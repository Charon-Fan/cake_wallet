import 'package:cw_core/transaction_info.dart';
import 'package:cw_core/monero_amount_format.dart';
import 'package:cw_zano/api/model/history.dart';
import 'package:cw_zano/api/structs/transaction_info_row.dart';
import 'package:cw_core/parseBoolFromString.dart';
import 'package:cw_core/transaction_direction.dart';
import 'package:cw_core/format_amount.dart';
import 'package:cw_zano/api/transaction_history.dart';

class ZanoTransactionInfo extends TransactionInfo {
  ZanoTransactionInfo(
      this.id,
      this.height,
      this.direction,
      this.date,
      this.isPending,
      this.amount,
      this.accountIndex,
      this.addressIndex,
      this.fee,
      this.confirmations);

  ZanoTransactionInfo.fromHistory(History history) 
    : id = history.txHash, 
    height = history.height, 
    direction = history.subtransfers.first.isIncome ? TransactionDirection.incoming :
      TransactionDirection.outgoing,
    date = DateTime.fromMillisecondsSinceEpoch(history.timestamp * 1000),
    isPending = false,
    amount = history.subtransfers.first.amount,
    accountIndex = 0,
    addressIndex = 0,
    fee = history.fee,
    confirmations = 1, 
    assetType = 'ZANO',     // TODO: FIXIT:
    recipientAddress = history.remoteAddresses.isNotEmpty ? history.remoteAddresses.first : '';

  /*ZanoTransactionInfo.fromMap(Map<String, Object> map)
      : id = (map['hash'] ?? '') as String,
        height = (map['height'] ?? 0) as int,
        direction =
            parseTransactionDirectionFromNumber(map['direction'] as String) ??
                TransactionDirection.incoming,
        date = DateTime.fromMillisecondsSinceEpoch(
            int.parse(map['timestamp'] as String? ?? '0') * 1000),
        isPending = parseBoolFromString(map['isPending'] as String),
        amount = map['amount'] as int,
        accountIndex = int.parse(map['accountIndex'] as String),
        addressIndex = map['addressIndex'] as int,
        confirmations = map['confirmations'] as int,
        key = getTxKey((map['hash'] ?? '') as String),
        fee = map['fee'] as int? ?? 0;*/

  /*ZanoTransactionInfo.fromRow(TransactionInfoRow row)
      : id = row.getHash(),
        height = row.blockHeight,
        direction = parseTransactionDirectionFromInt(row.direction) ??
            TransactionDirection.incoming,
        date = DateTime.fromMillisecondsSinceEpoch(row.getDatetime() * 1000),
        isPending = row.isPending != 0,
        amount = row.getAmount(),
        accountIndex = row.subaddrAccount,
        addressIndex = row.subaddrIndex,
        confirmations = row.confirmations,
        key = null, //getTxKey(row.getHash()),
        fee = row.fee,
        assetType = row.getAssetType();*/

  final String id;
  final int height;
  final TransactionDirection direction;
  final DateTime date;
  final int accountIndex;
  final bool isPending;
  final int amount;
  final int fee;
  final int addressIndex;
  final int confirmations;
  late String recipientAddress;
  late String assetType;
  String? _fiatAmount;
  String? key;

  @override
  String amountFormatted() =>
      '${formatAmount(moneroAmountToString(amount: amount))} $assetType';

  @override
  String fiatAmount() => _fiatAmount ?? '';

  @override
  void changeFiatAmount(String amount) => _fiatAmount = formatAmount(amount);

  @override
  String feeFormatted() =>
      '${formatAmount(moneroAmountToString(amount: fee))} $assetType';
}
