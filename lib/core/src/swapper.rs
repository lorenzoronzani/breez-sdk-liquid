use std::str::FromStr;

use anyhow::Result;
use boltz_client::network::electrum::ElectrumConfig;
use boltz_client::network::Chain;
use boltz_client::swaps::boltzv2::{
    BoltzApiClientV2, CreateReverseRequest, CreateReverseResponse, CreateSubmarineRequest,
    CreateSubmarineResponse, ReversePair, SubmarinePair,
};

use boltz_client::error::Error;

use boltz_client::util::secrets::Preimage;
use boltz_client::{Amount, Bolt11Invoice, Keypair, LBtcSwapScriptV2, LBtcSwapTxV2};
use log::{debug, info};
use serde_json::Value;

use crate::error::PaymentError;
use crate::model::{Network, ReceiveSwap, SendSwap};

pub const BOLTZ_TESTNET_URL_V2: &str = "https://api.testnet.boltz.exchange/v2";
pub const BOLTZ_MAINNET_URL_V2: &str = "https://api.boltz.exchange/v2";

pub trait Swapper: Send + Sync {
    // Send swap
    fn create_send_swap(
        &self,
        req: CreateSubmarineRequest,
    ) -> Result<CreateSubmarineResponse, PaymentError>;
    fn get_submarine_pairs(&self) -> Result<Option<SubmarinePair>, PaymentError>;
    fn refund_send_swap_cooperative(
        &self,
        swap: &SendSwap,
        output_address: &String,
        broadcast_fees_sat: Amount,
        keypair: &Keypair,
    ) -> Result<String, PaymentError>;
    fn refund_send_swap_non_cooperative(
        &self,
        swap: &SendSwap,
        keypair: &Keypair,
        broadcast_fees_sat: Amount,
        output_address: &String,
    ) -> Result<String, PaymentError>;
    fn claim_send_swap_cooperative(
        &self,
        swap: &SendSwap,
        invoice: &str,
        keypair: &Keypair,
    ) -> Result<(), PaymentError>;

    // Receive swap
    fn create_receive_swap(
        &self,
        req: CreateReverseRequest,
    ) -> Result<CreateReverseResponse, PaymentError>;
    fn get_reverse_swap_pairs(&self) -> Result<Option<ReversePair>, PaymentError>;
    fn claim_receive_swap(
        &self,
        swap: &ReceiveSwap,
        keypair: &Keypair,
        claim_address: String,
    ) -> Result<String, PaymentError>;

    // chain broadcast
    fn broadcast_tx(&self, chain: Chain, tx_hex: &String) -> Result<Value, PaymentError>;
}

pub struct BoltzSwapper {
    client: BoltzApiClientV2,
    electrum_config: ElectrumConfig,
    network: Network,
}

impl BoltzSwapper {
    pub fn new(network: Network, electrum_config: ElectrumConfig) -> BoltzSwapper {
        BoltzSwapper {
            client: BoltzApiClientV2::new(BoltzSwapper::boltz_url_v2(&network)),
            electrum_config,
            network,
        }
    }

    fn boltz_url_v2(network: &Network) -> &'static str {
        match network {
            Network::LiquidTestnet => BOLTZ_TESTNET_URL_V2,
            Network::Liquid => BOLTZ_MAINNET_URL_V2,
        }
    }

    fn new_refund_tx(
        &self,
        swap: &SendSwap,
        keypair: &Keypair,
        output_address: &String,
    ) -> Result<LBtcSwapTxV2, PaymentError> {
        let create_response = swap
            .get_boltz_create_response()
            .map_err(|e| Error::Generic(e.to_string()))?;

        let swap_script = LBtcSwapScriptV2::submarine_from_swap_resp(
            &create_response,
            keypair.public_key().into(),
        )?;

        Ok(LBtcSwapTxV2::new_refund(
            swap_script.clone(),
            output_address,
            &self.electrum_config,
            Self::boltz_url_v2(&self.network).to_string(),
            swap.id.to_string(),
        )?)
    }

    fn validate_send_swap_preimage(
        &self,
        swap_id: &str,
        invoice: &str,
        preimage: &str,
    ) -> Result<(), PaymentError> {
        Self::verify_payment_hash(preimage, invoice)?;
        info!("Preimage is valid for Send Swap {swap_id}");
        Ok(())
    }

    fn verify_payment_hash(preimage: &str, invoice: &str) -> Result<(), PaymentError> {
        let preimage = Preimage::from_str(preimage)?;
        let preimage_hash = preimage.sha256.to_string();
        let invoice =
            Bolt11Invoice::from_str(invoice).map_err(|e| Error::Generic(e.to_string()))?;
        let invoice_payment_hash = invoice.payment_hash();

        (invoice_payment_hash.to_string() == preimage_hash)
            .then_some(())
            .ok_or(PaymentError::InvalidPreimage)
    }
}

impl Swapper for BoltzSwapper {
    fn create_send_swap(
        &self,
        req: CreateSubmarineRequest,
    ) -> Result<CreateSubmarineResponse, PaymentError> {
        Ok(self.client.post_swap_req(&req)?)
    }

    fn create_receive_swap(
        &self,
        req: CreateReverseRequest,
    ) -> Result<CreateReverseResponse, PaymentError> {
        Ok(self.client.post_reverse_req(req)?)
    }

    fn claim_send_swap_cooperative(
        &self,
        swap: &SendSwap,
        invoice: &str,
        keypair: &Keypair,
    ) -> Result<(), PaymentError> {
        let swap_id = &swap.id;
        debug!("Claim is pending for swap-in {swap_id}. Initiating cooperative claim");
        let refund_tx = self.new_refund_tx(swap, keypair, &"".into())?;

        let claim_tx_response = self.client.get_claim_tx_details(&swap_id.to_string())?;
        debug!("Received claim tx details: {:?}", &claim_tx_response);

        self.validate_send_swap_preimage(swap_id, invoice, &claim_tx_response.preimage)?;

        let (partial_sig, pub_nonce) =
            refund_tx.submarine_partial_sig(keypair, &claim_tx_response)?;

        self.client
            .post_claim_tx_details(&swap_id.to_string(), pub_nonce, partial_sig)?;
        debug!("Successfully sent claim details for swap-in {swap_id}");
        Ok(())
    }

    fn get_submarine_pairs(&self) -> Result<Option<SubmarinePair>, PaymentError> {
        Ok(self.client.get_submarine_pairs()?.get_lbtc_to_btc_pair())
    }

    fn get_reverse_swap_pairs(&self) -> Result<Option<ReversePair>, PaymentError> {
        Ok(self.client.get_reverse_pairs()?.get_btc_to_lbtc_pair())
    }

    fn broadcast_tx(&self, chain: Chain, tx_hex: &String) -> Result<Value, PaymentError> {
        Ok(self.client.broadcast_tx(chain, tx_hex)?)
    }

    fn refund_send_swap_cooperative(
        &self,
        swap: &SendSwap,
        output_address: &String,
        broadcast_fees_sat: Amount,
        keypair: &Keypair,
    ) -> Result<String, PaymentError> {
        info!("Initiating cooperative refund for Send Swap {}", &swap.id);
        let create_response = swap
            .get_boltz_create_response()
            .map_err(|e| Error::Generic(e.to_string()))?;

        let swap_script = LBtcSwapScriptV2::submarine_from_swap_resp(
            &create_response,
            keypair.public_key().into(),
        )?;
        let refund_tx = self.new_refund_tx(swap, keypair, output_address)?;

        let cooperative = Some((&self.client, &swap.id));
        let tx = refund_tx.sign_refund(
            &swap
                .get_refund_keypair()
                .map_err(|e| Error::Generic(e.to_string()))?,
            broadcast_fees_sat,
            cooperative,
        )?;
        let is_lowball = match self.network {
            Network::Liquid => None,
            Network::LiquidTestnet => {
                Some((&self.client, boltz_client::network::Chain::LiquidTestnet))
            }
        };
        let refund_tx_id = refund_tx.broadcast(&tx, &self.electrum_config, is_lowball)?;
        info!(
            "Successfully broadcast cooperative refund for Send Swap {}",
            &swap.id
        );
        Ok(refund_tx_id.clone())
    }

    fn refund_send_swap_non_cooperative(
        &self,
        swap: &SendSwap,
        keypair: &Keypair,
        broadcast_fees_sat: Amount,
        output_address: &String,
    ) -> Result<String, PaymentError> {
        let refund_tx = self.new_refund_tx(swap, keypair, output_address)?;
        let tx = refund_tx.sign_refund(
            &swap
                .get_refund_keypair()
                .map_err(|e| Error::Generic(e.to_string()))?,
            broadcast_fees_sat,
            None,
        )?;
        let is_lowball = match self.network {
            Network::Liquid => None,
            Network::LiquidTestnet => {
                Some((&self.client, boltz_client::network::Chain::LiquidTestnet))
            }
        };
        let refund_tx_id = refund_tx.broadcast(&tx, &self.electrum_config, is_lowball)?;
        info!(
            "Successfully broadcast non-cooperative refund for swap-in {}",
            swap.id
        );
        Ok(refund_tx_id)
    }

    fn claim_receive_swap(
        &self,
        swap: &ReceiveSwap,
        keypair: &Keypair,
        claim_address: String,
    ) -> Result<String, PaymentError> {
        let create_response = swap
            .get_boltz_create_response()
            .map_err(|e| Error::Generic(e.to_string()))?;
        let swap_script = LBtcSwapScriptV2::reverse_from_swap_resp(
            &create_response,
            keypair.public_key().into(),
        )?;
        let swap_id = &swap.id;
        let claim_tx_wrapper = LBtcSwapTxV2::new_claim(
            swap_script,
            claim_address,
            &self.electrum_config,
            BoltzSwapper::boltz_url_v2(&self.network).into(),
            swap.id.clone(),
        )?;

        let cooperative = Some((&self.client, swap.id.clone()));
        let claim_tx = claim_tx_wrapper.sign_claim(
            keypair,
            &Preimage::from_str(&swap.preimage)?,
            Amount::from_sat(swap.claim_fees_sat),
            // Enable cooperative claim (Some) or not (None)
            cooperative,
            // None
        )?;

        let claim_tx_id = claim_tx_wrapper.broadcast(
            &claim_tx,
            &self.electrum_config,
            Some((&self.client, self.network.into())),
        )?;
        info!("Successfully broadcast claim tx {claim_tx_id} for Receive Swap {swap_id}");
        debug!("Claim Tx {:?}", claim_tx);
        Ok(claim_tx_id)
    }
}
