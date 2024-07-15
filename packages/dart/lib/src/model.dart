// This file is automatically generated, so please do not edit it.
// Generated by `flutter_rust_bridge`@ 2.0.0.

// ignore_for_file: invalid_use_of_internal_member, unused_import, unnecessary_import

import 'bindings.dart';
import 'frb_generated.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart';
import 'package:freezed_annotation/freezed_annotation.dart' hide protected;
part 'model.freezed.dart';

class BackupRequest {
  /// Path to the backup.
  ///
  /// If not set, it defaults to `backup.sql` for mainnet and `backup-testnet.sql` for testnet.
  /// The file will be saved in [ConnectRequest]'s `data_dir`.
  final String? backupPath;

  const BackupRequest({
    this.backupPath,
  });

  @override
  int get hashCode => backupPath.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BackupRequest && runtimeType == other.runtimeType && backupPath == other.backupPath;
}

/// Configuration for the Liquid SDK
class Config {
  final String liquidElectrumUrl;
  final String bitcoinElectrumUrl;

  /// The mempool.space API URL, has to be in the format: `https://mempool.space/api`
  final String mempoolspaceUrl;

  /// Directory in which all SDK files (DB, log, cache) are stored.
  ///
  /// Prefix can be a relative or absolute path to this directory.
  final String workingDir;
  final LiquidNetwork network;

  /// Send payment timeout. See [crate::sdk::LiquidSdk::send_payment]
  final BigInt paymentTimeoutSec;

  /// Zero-conf minimum accepted fee-rate in millisatoshis per vbyte
  final int zeroConfMinFeeRateMsat;

  /// Maximum amount in satoshi to accept zero-conf payments with
  /// Defaults to [crate::receive_swap::DEFAULT_ZERO_CONF_MAX_SAT]
  final BigInt? zeroConfMaxAmountSat;

  const Config({
    required this.liquidElectrumUrl,
    required this.bitcoinElectrumUrl,
    required this.mempoolspaceUrl,
    required this.workingDir,
    required this.network,
    required this.paymentTimeoutSec,
    required this.zeroConfMinFeeRateMsat,
    this.zeroConfMaxAmountSat,
  });

  @override
  int get hashCode =>
      liquidElectrumUrl.hashCode ^
      bitcoinElectrumUrl.hashCode ^
      mempoolspaceUrl.hashCode ^
      workingDir.hashCode ^
      network.hashCode ^
      paymentTimeoutSec.hashCode ^
      zeroConfMinFeeRateMsat.hashCode ^
      zeroConfMaxAmountSat.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Config &&
          runtimeType == other.runtimeType &&
          liquidElectrumUrl == other.liquidElectrumUrl &&
          bitcoinElectrumUrl == other.bitcoinElectrumUrl &&
          mempoolspaceUrl == other.mempoolspaceUrl &&
          workingDir == other.workingDir &&
          network == other.network &&
          paymentTimeoutSec == other.paymentTimeoutSec &&
          zeroConfMinFeeRateMsat == other.zeroConfMinFeeRateMsat &&
          zeroConfMaxAmountSat == other.zeroConfMaxAmountSat;
}

class ConnectRequest {
  final String mnemonic;
  final Config config;

  const ConnectRequest({
    required this.mnemonic,
    required this.config,
  });

  @override
  int get hashCode => mnemonic.hashCode ^ config.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ConnectRequest &&
          runtimeType == other.runtimeType &&
          mnemonic == other.mnemonic &&
          config == other.config;
}

class GetInfoResponse {
  /// Usable balance. This is the confirmed onchain balance minus `pending_send_sat`.
  final BigInt balanceSat;

  /// Amount that is being used for ongoing Send swaps
  final BigInt pendingSendSat;

  /// Incoming amount that is pending from ongoing Receive swaps
  final BigInt pendingReceiveSat;
  final String pubkey;

  const GetInfoResponse({
    required this.balanceSat,
    required this.pendingSendSat,
    required this.pendingReceiveSat,
    required this.pubkey,
  });

  @override
  int get hashCode =>
      balanceSat.hashCode ^ pendingSendSat.hashCode ^ pendingReceiveSat.hashCode ^ pubkey.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GetInfoResponse &&
          runtimeType == other.runtimeType &&
          balanceSat == other.balanceSat &&
          pendingSendSat == other.pendingSendSat &&
          pendingReceiveSat == other.pendingReceiveSat &&
          pubkey == other.pubkey;
}

class LightningPaymentLimitsResponse {
  /// Amount limits for a Send Payment to be valid
  final Limits send;

  /// Amount limits for a Receive Payment to be valid
  final Limits receive;

  const LightningPaymentLimitsResponse({
    required this.send,
    required this.receive,
  });

  @override
  int get hashCode => send.hashCode ^ receive.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LightningPaymentLimitsResponse &&
          runtimeType == other.runtimeType &&
          send == other.send &&
          receive == other.receive;
}

class Limits {
  final BigInt minSat;
  final BigInt maxSat;
  final BigInt maxZeroConfSat;

  const Limits({
    required this.minSat,
    required this.maxSat,
    required this.maxZeroConfSat,
  });

  @override
  int get hashCode => minSat.hashCode ^ maxSat.hashCode ^ maxZeroConfSat.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Limits &&
          runtimeType == other.runtimeType &&
          minSat == other.minSat &&
          maxSat == other.maxSat &&
          maxZeroConfSat == other.maxZeroConfSat;
}

/// Network chosen for this Liquid SDK instance. Note that it represents both the Liquid and the
/// Bitcoin network used.
enum LiquidNetwork {
  /// Mainnet Bitcoin and Liquid chains
  mainnet,

  /// Testnet Bitcoin and Liquid chains
  testnet,
  ;
}

/// Represents a list payments request.
class ListPaymentsRequest {
  final List<PaymentType>? filters;

  /// Epoch time, in seconds
  final PlatformInt64? fromTimestamp;

  /// Epoch time, in seconds
  final PlatformInt64? toTimestamp;
  final int? offset;
  final int? limit;

  const ListPaymentsRequest({
    this.filters,
    this.fromTimestamp,
    this.toTimestamp,
    this.offset,
    this.limit,
  });

  @override
  int get hashCode =>
      filters.hashCode ^ fromTimestamp.hashCode ^ toTimestamp.hashCode ^ offset.hashCode ^ limit.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ListPaymentsRequest &&
          runtimeType == other.runtimeType &&
          filters == other.filters &&
          fromTimestamp == other.fromTimestamp &&
          toTimestamp == other.toTimestamp &&
          offset == other.offset &&
          limit == other.limit;
}

@freezed
sealed class LnUrlPayResult with _$LnUrlPayResult {
  const LnUrlPayResult._();

  const factory LnUrlPayResult.endpointSuccess({
    required LnUrlPaySuccessData data,
  }) = LnUrlPayResult_EndpointSuccess;
  const factory LnUrlPayResult.endpointError({
    required LnUrlErrorData data,
  }) = LnUrlPayResult_EndpointError;
  const factory LnUrlPayResult.payError({
    required LnUrlPayErrorData data,
  }) = LnUrlPayResult_PayError;
}

class LnUrlPaySuccessData {
  final Payment payment;
  final SuccessActionProcessed? successAction;

  const LnUrlPaySuccessData({
    required this.payment,
    this.successAction,
  });

  @override
  int get hashCode => payment.hashCode ^ successAction.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LnUrlPaySuccessData &&
          runtimeType == other.runtimeType &&
          payment == other.payment &&
          successAction == other.successAction;
}

/// Internal SDK log entry used in the Uniffi and Dart bindings
class LogEntry {
  final String line;
  final String level;

  const LogEntry({
    required this.line,
    required this.level,
  });

  @override
  int get hashCode => line.hashCode ^ level.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LogEntry && runtimeType == other.runtimeType && line == other.line && level == other.level;
}

class OnchainPaymentLimitsResponse {
  /// Amount limits for a Send Onchain Payment to be valid
  final Limits send;

  /// Amount limits for a Receive Onchain Payment to be valid
  final Limits receive;

  const OnchainPaymentLimitsResponse({
    required this.send,
    required this.receive,
  });

  @override
  int get hashCode => send.hashCode ^ receive.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OnchainPaymentLimitsResponse &&
          runtimeType == other.runtimeType &&
          send == other.send &&
          receive == other.receive;
}

class PayOnchainRequest {
  final String address;
  final PreparePayOnchainResponse prepareRes;

  const PayOnchainRequest({
    required this.address,
    required this.prepareRes,
  });

  @override
  int get hashCode => address.hashCode ^ prepareRes.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PayOnchainRequest &&
          runtimeType == other.runtimeType &&
          address == other.address &&
          prepareRes == other.prepareRes;
}

/// Represents an SDK payment.
///
/// By default, this is an onchain tx. It may represent a swap, if swap metadata is available.
class Payment {
  final String? txId;

  /// The swap ID, if any swap is associated with this payment
  final String? swapId;

  /// Composite timestamp that can be used for sorting or displaying the payment.
  ///
  /// If this payment has an associated swap, it is the swap creation time. Otherwise, the point
  /// in time when the underlying tx was included in a block. If there is no associated swap
  /// available and the underlying tx is not yet confirmed, the value is `now()`.
  final int timestamp;

  /// The payment amount, which corresponds to the onchain tx amount.
  ///
  /// In case of an outbound payment (Send), this is the payer amount. Otherwise it's the receiver amount.
  final BigInt amountSat;

  /// Represents the fees paid by this wallet for this payment.
  ///
  /// ### Swaps
  /// If there is an associated Send Swap, these fees represent the total fees paid by this wallet
  /// (the sender). It is the difference between the amount that was sent and the amount received.
  ///
  /// If there is an associated Receive Swap, these fees represent the total fees paid by this wallet
  /// (the receiver). It is also the difference between the amount that was sent and the amount received.
  ///
  /// ### Pure onchain txs
  /// If no swap is associated with this payment:
  /// - for Send payments, this is the onchain tx fee
  /// - for Receive payments, this is zero
  final BigInt feesSat;

  /// In case of a Send swap, this is the preimage of the paid invoice (proof of payment).
  final String? preimage;

  /// Represents the invoice associated with a payment
  /// In the case of a Send payment, this is the invoice paid by the swapper
  /// In the case of a Receive payment, this is the invoice paid by the user
  final String? bolt11;

  /// For a Send swap which was refunded, this is the refund tx id
  final String? refundTxId;

  /// For a Send swap which was refunded, this is the refund amount
  final BigInt? refundTxAmountSat;
  final PaymentType paymentType;

  /// Composite status representing the overall status of the payment.
  ///
  /// If the tx has no associated swap, this reflects the onchain tx status (confirmed or not).
  ///
  /// If the tx has an associated swap, this is determined by the swap status (pending or complete).
  final PaymentState status;

  const Payment({
    this.txId,
    this.swapId,
    required this.timestamp,
    required this.amountSat,
    required this.feesSat,
    this.preimage,
    this.bolt11,
    this.refundTxId,
    this.refundTxAmountSat,
    required this.paymentType,
    required this.status,
  });

  @override
  int get hashCode =>
      txId.hashCode ^
      swapId.hashCode ^
      timestamp.hashCode ^
      amountSat.hashCode ^
      feesSat.hashCode ^
      preimage.hashCode ^
      bolt11.hashCode ^
      refundTxId.hashCode ^
      refundTxAmountSat.hashCode ^
      paymentType.hashCode ^
      status.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Payment &&
          runtimeType == other.runtimeType &&
          txId == other.txId &&
          swapId == other.swapId &&
          timestamp == other.timestamp &&
          amountSat == other.amountSat &&
          feesSat == other.feesSat &&
          preimage == other.preimage &&
          bolt11 == other.bolt11 &&
          refundTxId == other.refundTxId &&
          refundTxAmountSat == other.refundTxAmountSat &&
          paymentType == other.paymentType &&
          status == other.status;
}

enum PaymentState {
  created,

  /// ## Receive Swaps
  ///
  /// Covers the cases when
  /// - the lockup tx is seen in the mempool or
  /// - our claim tx is broadcast
  ///
  /// When the claim tx is broadcast, `claim_tx_id` is set in the swap.
  ///
  /// ## Send Swaps
  ///
  /// This is the status when our lockup tx was broadcast
  ///
  /// ## Chain Swaps
  ///
  /// This is the status when the user lockup tx was broadcast
  ///
  /// ## No swap data available
  ///
  /// If no associated swap is found, this indicates the underlying tx is not confirmed yet.
  pending,

  /// ## Receive Swaps
  ///
  /// Covers the case when the claim tx is confirmed.
  ///
  /// ## Send and Chain Swaps
  ///
  /// This is the status when the claim tx is broadcast and we see it in the mempool.
  ///
  /// ## No swap data available
  ///
  /// If no associated swap is found, this indicates the underlying tx is confirmed.
  complete,

  /// ## Receive Swaps
  ///
  /// This is the status when the swap failed for any reason and the Receive could not complete.
  ///
  /// ## Send and Chain Swaps
  ///
  /// This is the status when a swap refund was initiated and the refund tx is confirmed.
  failed,

  /// ## Send and Outgoing Chain Swaps
  ///
  /// This covers the case when the swap state is still Created and the swap fails to reach the
  /// Pending state in time. The TimedOut state indicates the lockup tx should never be broadcast.
  timedOut,

  /// ## Incoming Chain Swaps
  ///
  /// This covers the case when the swap failed for any reason and there is a user lockup tx.
  /// The swap in this case has to be manually refunded with a provided Bitcoin address
  refundable,

  /// ## Send and Chain Swaps
  ///
  /// This is the status when a refund was initiated and our refund tx was broadcast
  ///
  /// When the refund tx is broadcast, `refund_tx_id` is set in the swap.
  refundPending,
  ;
}

enum PaymentType {
  receive,
  send,
  ;
}

class PreparePayOnchainRequest {
  final BigInt receiverAmountSat;
  final int? satPerVbyte;

  const PreparePayOnchainRequest({
    required this.receiverAmountSat,
    this.satPerVbyte,
  });

  @override
  int get hashCode => receiverAmountSat.hashCode ^ satPerVbyte.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PreparePayOnchainRequest &&
          runtimeType == other.runtimeType &&
          receiverAmountSat == other.receiverAmountSat &&
          satPerVbyte == other.satPerVbyte;
}

class PreparePayOnchainResponse {
  final BigInt receiverAmountSat;
  final BigInt claimFeesSat;
  final BigInt totalFeesSat;

  const PreparePayOnchainResponse({
    required this.receiverAmountSat,
    required this.claimFeesSat,
    required this.totalFeesSat,
  });

  @override
  int get hashCode => receiverAmountSat.hashCode ^ claimFeesSat.hashCode ^ totalFeesSat.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PreparePayOnchainResponse &&
          runtimeType == other.runtimeType &&
          receiverAmountSat == other.receiverAmountSat &&
          claimFeesSat == other.claimFeesSat &&
          totalFeesSat == other.totalFeesSat;
}

class PrepareReceiveOnchainRequest {
  final BigInt payerAmountSat;

  const PrepareReceiveOnchainRequest({
    required this.payerAmountSat,
  });

  @override
  int get hashCode => payerAmountSat.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PrepareReceiveOnchainRequest &&
          runtimeType == other.runtimeType &&
          payerAmountSat == other.payerAmountSat;
}

class PrepareReceiveOnchainResponse {
  final BigInt payerAmountSat;
  final BigInt feesSat;

  const PrepareReceiveOnchainResponse({
    required this.payerAmountSat,
    required this.feesSat,
  });

  @override
  int get hashCode => payerAmountSat.hashCode ^ feesSat.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PrepareReceiveOnchainResponse &&
          runtimeType == other.runtimeType &&
          payerAmountSat == other.payerAmountSat &&
          feesSat == other.feesSat;
}

class PrepareReceiveRequest {
  final BigInt payerAmountSat;

  const PrepareReceiveRequest({
    required this.payerAmountSat,
  });

  @override
  int get hashCode => payerAmountSat.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PrepareReceiveRequest &&
          runtimeType == other.runtimeType &&
          payerAmountSat == other.payerAmountSat;
}

class PrepareReceiveResponse {
  final BigInt payerAmountSat;
  final BigInt feesSat;

  const PrepareReceiveResponse({
    required this.payerAmountSat,
    required this.feesSat,
  });

  @override
  int get hashCode => payerAmountSat.hashCode ^ feesSat.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PrepareReceiveResponse &&
          runtimeType == other.runtimeType &&
          payerAmountSat == other.payerAmountSat &&
          feesSat == other.feesSat;
}

class PrepareRefundRequest {
  final String swapAddress;
  final String refundAddress;
  final int satPerVbyte;

  const PrepareRefundRequest({
    required this.swapAddress,
    required this.refundAddress,
    required this.satPerVbyte,
  });

  @override
  int get hashCode => swapAddress.hashCode ^ refundAddress.hashCode ^ satPerVbyte.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PrepareRefundRequest &&
          runtimeType == other.runtimeType &&
          swapAddress == other.swapAddress &&
          refundAddress == other.refundAddress &&
          satPerVbyte == other.satPerVbyte;
}

class PrepareRefundResponse {
  final int txVsize;
  final BigInt txFeeSat;
  final String? refundTxId;

  const PrepareRefundResponse({
    required this.txVsize,
    required this.txFeeSat,
    this.refundTxId,
  });

  @override
  int get hashCode => txVsize.hashCode ^ txFeeSat.hashCode ^ refundTxId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PrepareRefundResponse &&
          runtimeType == other.runtimeType &&
          txVsize == other.txVsize &&
          txFeeSat == other.txFeeSat &&
          refundTxId == other.refundTxId;
}

class PrepareSendRequest {
  final String invoice;

  const PrepareSendRequest({
    required this.invoice,
  });

  @override
  int get hashCode => invoice.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PrepareSendRequest && runtimeType == other.runtimeType && invoice == other.invoice;
}

class PrepareSendResponse {
  final String invoice;
  final BigInt feesSat;

  const PrepareSendResponse({
    required this.invoice,
    required this.feesSat,
  });

  @override
  int get hashCode => invoice.hashCode ^ feesSat.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PrepareSendResponse &&
          runtimeType == other.runtimeType &&
          invoice == other.invoice &&
          feesSat == other.feesSat;
}

class ReceiveOnchainResponse {
  final String address;
  final String bip21;

  const ReceiveOnchainResponse({
    required this.address,
    required this.bip21,
  });

  @override
  int get hashCode => address.hashCode ^ bip21.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReceiveOnchainResponse &&
          runtimeType == other.runtimeType &&
          address == other.address &&
          bip21 == other.bip21;
}

class ReceivePaymentResponse {
  final String id;
  final String invoice;

  const ReceivePaymentResponse({
    required this.id,
    required this.invoice,
  });

  @override
  int get hashCode => id.hashCode ^ invoice.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReceivePaymentResponse &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          invoice == other.invoice;
}

class RecommendedFees {
  final BigInt fastestFee;
  final BigInt halfHourFee;
  final BigInt hourFee;
  final BigInt economyFee;
  final BigInt minimumFee;

  const RecommendedFees({
    required this.fastestFee,
    required this.halfHourFee,
    required this.hourFee,
    required this.economyFee,
    required this.minimumFee,
  });

  @override
  int get hashCode =>
      fastestFee.hashCode ^
      halfHourFee.hashCode ^
      hourFee.hashCode ^
      economyFee.hashCode ^
      minimumFee.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecommendedFees &&
          runtimeType == other.runtimeType &&
          fastestFee == other.fastestFee &&
          halfHourFee == other.halfHourFee &&
          hourFee == other.hourFee &&
          economyFee == other.economyFee &&
          minimumFee == other.minimumFee;
}

class RefundRequest {
  final String swapAddress;
  final String refundAddress;
  final int satPerVbyte;

  const RefundRequest({
    required this.swapAddress,
    required this.refundAddress,
    required this.satPerVbyte,
  });

  @override
  int get hashCode => swapAddress.hashCode ^ refundAddress.hashCode ^ satPerVbyte.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RefundRequest &&
          runtimeType == other.runtimeType &&
          swapAddress == other.swapAddress &&
          refundAddress == other.refundAddress &&
          satPerVbyte == other.satPerVbyte;
}

class RefundResponse {
  final String refundTxId;

  const RefundResponse({
    required this.refundTxId,
  });

  @override
  int get hashCode => refundTxId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RefundResponse && runtimeType == other.runtimeType && refundTxId == other.refundTxId;
}

class RefundableSwap {
  final String swapAddress;
  final int timestamp;
  final BigInt amountSat;

  const RefundableSwap({
    required this.swapAddress,
    required this.timestamp,
    required this.amountSat,
  });

  @override
  int get hashCode => swapAddress.hashCode ^ timestamp.hashCode ^ amountSat.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RefundableSwap &&
          runtimeType == other.runtimeType &&
          swapAddress == other.swapAddress &&
          timestamp == other.timestamp &&
          amountSat == other.amountSat;
}

class RestoreRequest {
  final String? backupPath;

  const RestoreRequest({
    this.backupPath,
  });

  @override
  int get hashCode => backupPath.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RestoreRequest && runtimeType == other.runtimeType && backupPath == other.backupPath;
}

@freezed
sealed class SdkEvent with _$SdkEvent {
  const SdkEvent._();

  const factory SdkEvent.paymentFailed({
    required Payment details,
  }) = SdkEvent_PaymentFailed;
  const factory SdkEvent.paymentPending({
    required Payment details,
  }) = SdkEvent_PaymentPending;
  const factory SdkEvent.paymentRefunded({
    required Payment details,
  }) = SdkEvent_PaymentRefunded;
  const factory SdkEvent.paymentRefundPending({
    required Payment details,
  }) = SdkEvent_PaymentRefundPending;
  const factory SdkEvent.paymentSucceeded({
    required Payment details,
  }) = SdkEvent_PaymentSucceeded;
  const factory SdkEvent.paymentWaitingConfirmation({
    required Payment details,
  }) = SdkEvent_PaymentWaitingConfirmation;
  const factory SdkEvent.synced() = SdkEvent_Synced;
}

class SendPaymentResponse {
  final Payment payment;

  const SendPaymentResponse({
    required this.payment,
  });

  @override
  int get hashCode => payment.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SendPaymentResponse && runtimeType == other.runtimeType && payment == other.payment;
}
