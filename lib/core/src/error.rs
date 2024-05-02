use anyhow::Error;

#[macro_export]
macro_rules! ensure_sdk {
    ($cond:expr, $err:expr) => {
        if !$cond {
            return Err($err);
        }
    };
}

// TODO Unify error enum
#[derive(Debug, thiserror::Error)]
pub enum LsSdkError {
    #[error("Error: {err}")]
    Generic { err: String },
}

impl From<anyhow::Error> for LsSdkError {
    fn from(e: Error) -> Self {
        LsSdkError::Generic { err: e.to_string() }
    }
}

#[derive(thiserror::Error, Debug)]
pub enum PaymentError {
    #[error("Invoice amount is out of range")]
    AmountOutOfRange,

    #[error("The specified funds have already been claimed")]
    AlreadyClaimed,

    #[error("Generic error: {err}")]
    Generic { err: String },

    #[error("The specified invoice is not valid")]
    InvalidInvoice,

    #[error("The generated preimage is not valid")]
    InvalidPreimage,

    #[error("Lwk error: {err}")]
    LwkError { err: String },

    #[error("Boltz did not return any pairs from the request")]
    PairsNotFound,

    #[error("Could not store the swap details locally")]
    PersistError,

    #[error("Could not sign/send the transaction: {err}")]
    SendError { err: String },

    #[error("Could not sign the transaction: {err}")]
    SignerError { err: String },
}

impl From<boltz_client::error::Error> for PaymentError {
    fn from(err: boltz_client::error::Error) -> Self {
        match err {
            boltz_client::error::Error::Protocol(msg) => {
                if msg == "Could not find utxos for script" {
                    return PaymentError::AlreadyClaimed;
                }

                PaymentError::Generic { err: msg }
            }
            _ => PaymentError::Generic {
                err: format!("{err:?}"),
            },
        }
    }
}

#[allow(clippy::match_single_binding)]
impl From<lwk_wollet::Error> for PaymentError {
    fn from(err: lwk_wollet::Error) -> Self {
        match err {
            _ => PaymentError::LwkError {
                err: format!("{err:?}"),
            },
        }
    }
}

#[allow(clippy::match_single_binding)]
impl From<lwk_signer::SignerError> for PaymentError {
    fn from(err: lwk_signer::SignerError) -> Self {
        match err {
            _ => PaymentError::SignerError {
                err: format!("{err:?}"),
            },
        }
    }
}

impl From<anyhow::Error> for PaymentError {
    fn from(err: anyhow::Error) -> Self {
        Self::Generic {
            err: err.to_string(),
        }
    }
}

impl From<LsSdkError> for PaymentError {
    fn from(err: LsSdkError) -> Self {
        Self::Generic {
            err: err.to_string(),
        }
    }
}