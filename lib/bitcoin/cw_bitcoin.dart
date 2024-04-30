part of 'bitcoin.dart';

class CWBitcoin extends Bitcoin {
  WalletCredentials createBitcoinRestoreWalletFromSeedCredentials({
    required String name,
    required String mnemonic,
    required String password,
    required DerivationType derivationType,
    required String derivationPath,
    String? passphrase,
  }) =>
      BitcoinRestoreWalletFromSeedCredentials(
        name: name,
        mnemonic: mnemonic,
        password: password,
        derivationType: derivationType,
        derivationPath: derivationPath,
        passphrase: passphrase,
      );

  @override
  WalletCredentials createBitcoinRestoreWalletFromWIFCredentials(
          {required String name,
          required String password,
          required String wif,
          WalletInfo? walletInfo}) =>
      BitcoinRestoreWalletFromWIFCredentials(
          name: name, password: password, wif: wif, walletInfo: walletInfo);

  @override
  WalletCredentials createBitcoinNewWalletCredentials(
          {required String name, WalletInfo? walletInfo, String? password}) =>
      BitcoinNewWalletCredentials(name: name, walletInfo: walletInfo, password: password);

  @override
  TransactionPriority getMediumTransactionPriority() => BitcoinTransactionPriority.medium;

  @override
  List<String> getWordList() => wordlist;

  @override
  Map<String, String> getWalletKeys(Object wallet) {
    final bitcoinWallet = wallet as ElectrumWallet;
    final keys = bitcoinWallet.keys;

    return <String, String>{
      'wif': keys.wif,
      'privateKey': keys.privateKey,
      'publicKey': keys.publicKey
    };
  }

  @override
  List<TransactionPriority> getTransactionPriorities() => BitcoinTransactionPriority.all;

  @override
  List<TransactionPriority> getLitecoinTransactionPriorities() => LitecoinTransactionPriority.all;

  @override
  TransactionPriority deserializeBitcoinTransactionPriority(int raw) =>
      BitcoinTransactionPriority.deserialize(raw: raw);

  @override
  TransactionPriority deserializeLitecoinTransactionPriority(int raw) =>
      LitecoinTransactionPriority.deserialize(raw: raw);

  @override
  int getFeeRate(Object wallet, TransactionPriority priority) {
    final bitcoinWallet = wallet as ElectrumWallet;
    return bitcoinWallet.feeRate(priority);
  }

  @override
  Future<void> generateNewAddress(Object wallet, String label) async {
    final bitcoinWallet = wallet as ElectrumWallet;
    await bitcoinWallet.walletAddresses.generateNewAddress(label: label);
    await wallet.save();
  }

  @override
  Future<void> updateAddress(Object wallet, String address, String label) async {
    final bitcoinWallet = wallet as ElectrumWallet;
    bitcoinWallet.walletAddresses.updateAddress(address, label);
    await wallet.save();
  }

  @override
  Object createBitcoinTransactionCredentials(List<Output> outputs,
      {required TransactionPriority priority, int? feeRate}) {
    final bitcoinFeeRate =
        priority == BitcoinTransactionPriority.custom && feeRate != null ? feeRate : null;
    return BitcoinTransactionCredentials(
        outputs
            .map((out) => OutputInfo(
                fiatAmount: out.fiatAmount,
                cryptoAmount: out.cryptoAmount,
                address: out.address,
                note: out.note,
                sendAll: out.sendAll,
                extractedAddress: out.extractedAddress,
                isParsedAddress: out.isParsedAddress,
                formattedCryptoAmount: out.formattedCryptoAmount,
                memo: out.memo))
            .toList(),
        priority: priority as BitcoinTransactionPriority,
        feeRate: bitcoinFeeRate);
  }

  @override
  Object createBitcoinTransactionCredentialsRaw(List<OutputInfo> outputs,
          {TransactionPriority? priority, required int feeRate}) =>
      BitcoinTransactionCredentials(outputs,
          priority: priority != null ? priority as BitcoinTransactionPriority : null,
          feeRate: feeRate);

  @override
  List<String> getAddresses(Object wallet) {
    final bitcoinWallet = wallet as ElectrumWallet;
    return bitcoinWallet.walletAddresses.addressesByReceiveType
        .map((BitcoinAddressRecord addr) => addr.address)
        .toList();
  }

  @override
  @computed
  List<ElectrumSubAddress> getSubAddresses(Object wallet) {
    final electrumWallet = wallet as ElectrumWallet;
    return electrumWallet.walletAddresses.addressesByReceiveType
        .map((BitcoinAddressRecord addr) => ElectrumSubAddress(
            id: addr.index,
            name: addr.name,
            address: addr.address,
            txCount: addr.txCount,
            balance: addr.balance,
            isChange: addr.isHidden))
        .toList();
  }

  @override
  Future<int> estimateFakeSendAllTxAmount(Object wallet, TransactionPriority priority) async {
    try {
      final sk = ECPrivate.random();
      final electrumWallet = wallet as ElectrumWallet;

      if (wallet.type == WalletType.bitcoinCash) {
        final p2pkhAddr = sk.getPublic().toP2pkhAddress();
        final estimatedTx = await electrumWallet.estimateSendAllTx(
          [BitcoinOutput(address: p2pkhAddr, value: BigInt.zero)],
          getFeeRate(wallet, priority as BitcoinCashTransactionPriority),
        );

        return estimatedTx.amount;
      }

      final p2shAddr = sk.getPublic().toP2pkhInP2sh();
      final estimatedTx = await electrumWallet.estimateSendAllTx(
        [BitcoinOutput(address: p2shAddr, value: BigInt.zero)],
        getFeeRate(
          wallet,
          wallet.type == WalletType.litecoin
              ? priority as LitecoinTransactionPriority
              : priority as BitcoinTransactionPriority,
        ),
      );

      return estimatedTx.amount;
    } catch (_) {
      return 0;
    }
  }

  @override
  String getAddress(Object wallet) {
    final bitcoinWallet = wallet as ElectrumWallet;
    return bitcoinWallet.walletAddresses.address;
  }

  @override
  String formatterBitcoinAmountToString({required int amount}) =>
      bitcoinAmountToString(amount: amount);

  @override
  double formatterBitcoinAmountToDouble({required int amount}) =>
      bitcoinAmountToDouble(amount: amount);

  @override
  int formatterStringDoubleToBitcoinAmount(String amount) => stringDoubleToBitcoinAmount(amount);

  @override
  String bitcoinTransactionPriorityWithLabel(TransactionPriority priority, int rate,
          {int? customRate}) =>
      (priority as BitcoinTransactionPriority).labelWithRate(rate, customRate);

  @override
  List<BitcoinUnspent> getUnspents(Object wallet) {
    final bitcoinWallet = wallet as ElectrumWallet;
    return bitcoinWallet.unspentCoins;
  }

  Future<void> updateUnspents(Object wallet) async {
    final bitcoinWallet = wallet as ElectrumWallet;
    await bitcoinWallet.updateUnspent();
  }

  WalletService createBitcoinWalletService(
      Box<WalletInfo> walletInfoSource, Box<UnspentCoinsInfo> unspentCoinSource, bool isDirect) {
    return BitcoinWalletService(walletInfoSource, unspentCoinSource, isDirect);
  }

  WalletService createLitecoinWalletService(
      Box<WalletInfo> walletInfoSource, Box<UnspentCoinsInfo> unspentCoinSource, bool isDirect) {
    return LitecoinWalletService(walletInfoSource, unspentCoinSource, isDirect);
  }

  @override
  TransactionPriority getBitcoinTransactionPriorityMedium() => BitcoinTransactionPriority.medium;

  @override
  TransactionPriority getBitcoinTransactionPriorityCustom() => BitcoinTransactionPriority.custom;

  @override
  TransactionPriority getLitecoinTransactionPriorityMedium() => LitecoinTransactionPriority.medium;

  @override
  TransactionPriority getBitcoinTransactionPrioritySlow() => BitcoinTransactionPriority.slow;

  @override
  TransactionPriority getLitecoinTransactionPrioritySlow() => LitecoinTransactionPriority.slow;

  @override
  Future<void> setAddressType(Object wallet, dynamic option) async {
    final bitcoinWallet = wallet as ElectrumWallet;
    await bitcoinWallet.walletAddresses.setAddressType(option as BitcoinAddressType);
  }

  @override
  ReceivePageOption getSelectedAddressType(Object wallet) {
    final bitcoinWallet = wallet as ElectrumWallet;
    return BitcoinReceivePageOption.fromType(bitcoinWallet.walletAddresses.addressPageType);
  }

  @override
  List<ReceivePageOption> getBitcoinReceivePageOptions() => BitcoinReceivePageOption.all;

  @override
  BitcoinAddressType getBitcoinAddressType(ReceivePageOption option) {
    switch (option) {
      case BitcoinReceivePageOption.p2pkh:
        return P2pkhAddressType.p2pkh;
      case BitcoinReceivePageOption.p2sh:
        return P2shAddressType.p2wpkhInP2sh;
      case BitcoinReceivePageOption.p2tr:
        return SegwitAddresType.p2tr;
      case BitcoinReceivePageOption.p2wsh:
        return SegwitAddresType.p2wsh;
      case BitcoinReceivePageOption.p2wpkh:
      default:
        return SegwitAddresType.p2wpkh;
    }
  }

  @override
  Future<List<DerivationType>> compareDerivationMethods(
      {required String mnemonic, required Node node}) async {
    if (await checkIfMnemonicIsElectrum2(mnemonic)) {
      return [DerivationType.electrum];
    }

    return [DerivationType.bip39, DerivationType.electrum];
  }

  int _countOccurrences(String str, String charToCount) {
    int count = 0;
    for (int i = 0; i < str.length; i++) {
      if (str[i] == charToCount) {
        count++;
      }
    }
    return count;
  }

  @override
  Future<List<DerivationInfo>> getDerivationsFromMnemonic({
    required String mnemonic,
    required Node node,
    String? passphrase,
  }) async {
    List<DerivationInfo> list = [];

    List<DerivationType> types = await compareDerivationMethods(mnemonic: mnemonic, node: node);
    if (types.length == 1 && types.first == DerivationType.electrum) {
      return [
        DerivationInfo(
          derivationType: DerivationType.electrum,
          derivationPath: "m/0'/0",
          description: "Electrum",
          scriptType: "p2wpkh",
        )
      ];
    }

    final electrumClient = ElectrumClient();
    await electrumClient.connectToUri(node.uri);

    late BasedUtxoNetwork network;
    btc.NetworkType networkType;
    switch (node.type) {
      case WalletType.litecoin:
        network = LitecoinNetwork.mainnet;
        networkType = litecoinNetwork;
        break;
      case WalletType.bitcoin:
      default:
        network = BitcoinNetwork.mainnet;
        networkType = btc.bitcoin;
        break;
    }

    for (DerivationType dType in electrum_derivations.keys) {
      late Uint8List seedBytes;
      if (dType == DerivationType.electrum) {
        seedBytes = await mnemonicToSeedBytes(mnemonic);
      } else if (dType == DerivationType.bip39) {
        seedBytes = bip39.mnemonicToSeed(mnemonic, passphrase: passphrase ?? '');
      }

      for (DerivationInfo dInfo in electrum_derivations[dType]!) {
        try {
          DerivationInfo dInfoCopy = DerivationInfo(
            derivationType: dInfo.derivationType,
            derivationPath: dInfo.derivationPath,
            description: dInfo.description,
            scriptType: dInfo.scriptType,
          );

          String derivationPath = dInfoCopy.derivationPath!;
          int derivationDepth = _countOccurrences(derivationPath, "/");

          // the correct derivation depth is dependant on the derivation type:
          // the derivation paths defined in electrum_derivations are at the ROOT level, i.e.:
          // electrum's format doesn't specify subaddresses, just subaccounts:

          // for BIP44
          if (derivationDepth == 3) {
            // we add "/0/0" so that we generate account 0, index 0 and correctly get balance
            derivationPath += "/0/0";
            // we don't support sub-ACCOUNTS in bitcoin like we do monero, and so the path dInfoCopy
            // expects should be ACCOUNT 0, index unspecified:
            dInfoCopy.derivationPath = dInfoCopy.derivationPath! + "/0";
          }

          // var hd = bip32.BIP32.fromSeed(seedBytes).derivePath(derivationPath);
          final hd = btc.HDWallet.fromSeed(
            seedBytes,
            network: networkType,
          ).derivePath(derivationPath);

          String? address;
          switch (dInfoCopy.scriptType) {
            case "p2wpkh":
              address = generateP2WPKHAddress(hd: hd, network: network);
              break;
            case "p2pkh":
              address = generateP2PKHAddress(hd: hd, network: network);
              break;
            case "p2wpkh-p2sh":
              address = generateP2SHAddress(hd: hd, network: network);
              break;
            default:
              continue;
          }

          final sh = scriptHash(address, network: network);
          final history = await electrumClient.getHistory(sh);

          final balance = await electrumClient.getBalance(sh);
          dInfoCopy.balance = balance.entries.first.value.toString();
          dInfoCopy.address = address;
          dInfoCopy.transactionsCount = history.length;

          list.add(dInfoCopy);
        } catch (e) {
          print(e);
        }
      }
    }

    // sort the list such that derivations with the most transactions are first:
    list.sort((a, b) => b.transactionsCount.compareTo(a.transactionsCount));
    return list;
  }

  @override
  bool hasTaprootInput(PendingTransaction pendingTransaction) {
    return (pendingTransaction as PendingBitcoinTransaction).hasTaprootInputs;
  }

  @override
  Future<PendingBitcoinTransaction> replaceByFee(
      Object wallet, String transactionHash, String fee) async {
    final bitcoinWallet = wallet as ElectrumWallet;
    return await bitcoinWallet.replaceByFee(transactionHash, int.parse(fee));
  }

  @override
  Future<bool> canReplaceByFee(Object wallet, String transactionHash) async {
    final bitcoinWallet = wallet as ElectrumWallet;
    return bitcoinWallet.canReplaceByFee(transactionHash);
  }

  @override
  Future<bool> isChangeSufficientForFee(Object wallet, String txId, String newFee) async {
    final bitcoinWallet = wallet as ElectrumWallet;
    return bitcoinWallet.isChangeSufficientForFee(txId, int.parse(newFee));
  }

  @override
  int getFeeAmountForPriority(
      Object wallet, TransactionPriority priority, int inputsCount, int outputsCount,
      {int? size}) {
    final bitcoinWallet = wallet as ElectrumWallet;
    return bitcoinWallet.feeAmountForPriority(
        priority as BitcoinTransactionPriority, inputsCount, outputsCount);
  }

  @override
  int getEstimatedFeeWithFeeRate(Object wallet, int feeRate, int? amount,
      {int? outputsCount, int? size}) {
    final bitcoinWallet = wallet as ElectrumWallet;
    return bitcoinWallet.calculateEstimatedFeeWithFeeRate(
      feeRate,
      amount,
      outputsCount: outputsCount,
      size: size,
    );
  }

  @override
  int getMaxCustomFeeRate(Object wallet) {
    final bitcoinWallet = wallet as ElectrumWallet;
    return (bitcoinWallet.feeRate(BitcoinTransactionPriority.fast) * 1.1).round();
  }
}
