import 'package:cake_wallet/entities/receive_page_option.dart';
import 'package:cw_bitcoin/electrum_wallet_addresses.dart';
import 'package:cw_core/wallet_base.dart';
import 'package:cw_core/wallet_type.dart';
import 'package:mobx/mobx.dart';

part 'receive_option_view_model.g.dart';

class ReceiveOptionViewModel = ReceiveOptionViewModelBase with _$ReceiveOptionViewModel;

abstract class ReceiveOptionViewModelBase with Store {
  ReceiveOptionViewModelBase(this._wallet, this.initialPageOption)
      : selectedReceiveOption = initialPageOption ??
            (_wallet.type == WalletType.bitcoin
                ? BitcoinReceivePageOption.fromType(
                    (_wallet.walletAddresses as ElectrumWalletAddresses).addressPageType)
                : ReceivePageOption.mainnet),
        _options = [] {
    final walletType = _wallet.type;
    _options = walletType == WalletType.haven
        ? [ReceivePageOption.mainnet]
        : walletType == WalletType.bitcoin
            ? [
                ...BitcoinReceivePageOptions,
                ...ReceivePageOptions.where((element) => element != ReceivePageOption.mainnet)
              ]
            : ReceivePageOptions;
  }

  final WalletBase _wallet;

  final ReceivePageOption? initialPageOption;

  List<ReceivePageOption> _options;

  @observable
  ReceivePageOption selectedReceiveOption;

  List<ReceivePageOption> get options => _options;

  @action
  void selectReceiveOption(ReceivePageOption option) {
    selectedReceiveOption = option;
  }
}
