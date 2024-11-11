class PreferencesKey {
  static const currentWalletType = 'current_wallet_type';
  static const currentWalletName = 'current_wallet_name';
  static const currentNodeIdKey = 'current_node_id';
  static const currentBitcoinElectrumSererIdKey = 'current_node_id_btc';
  static const currentLitecoinElectrumSererIdKey = 'current_node_id_ltc';
  static const currentHavenNodeIdKey = 'current_node_id_xhv';
  static const currentZanoNodeIdKey = 'current_node_id_zano';
  static const currentEthereumNodeIdKey = 'current_node_id_eth';
  static const currentPolygonNodeIdKey = 'current_node_id_matic';
  static const currentNanoNodeIdKey = 'current_node_id_nano';
  static const currentNanoPowNodeIdKey = 'current_node_id_nano_pow';
  static const currentBananoNodeIdKey = 'current_node_id_banano';
  static const currentBananoPowNodeIdKey = 'current_node_id_banano_pow';
  static const currentFiatCurrencyKey = 'current_fiat_currency';
  static const currentCakePayCountry = 'current_cake_pay_country';
  static const currentBitcoinCashNodeIdKey = 'current_node_id_bch';
  static const currentSolanaNodeIdKey = 'current_node_id_sol';
  static const currentTronNodeIdKey = 'current_node_id_trx';
  static const currentWowneroNodeIdKey = 'current_node_id_wow';
  static const currentTransactionPriorityKeyLegacy = 'current_fee_priority';
  static const currentBalanceDisplayModeKey = 'current_balance_display_mode';
  static const shouldSaveRecipientAddressKey = 'save_recipient_address';
  static const isAppSecureKey = 'is_app_secure';
  static const disableTradeOption = 'disable_buy';
  static const disableBulletinKey = 'disable_bulletin';
  static const walletListOrder = 'wallet_list_order';
  static const contactListOrder = 'contact_list_order';
  static const walletListAscending = 'wallet_list_ascending';
  static const contactListAscending = 'contact_list_ascending';
  static const currentFiatApiModeKey = 'current_fiat_api_mode';
  static const failedTotpTokenTrials = 'failed_token_trials';
  static const disableExchangeKey = 'disable_exchange';
  static const exchangeStatusKey = 'exchange_status';
  static const currentTheme = 'current_theme';
  static const displayActionListModeKey = 'display_list_mode';
  static const currentPinLength = 'current_pin_length';
  static const currentLanguageCode = 'language_code';
  static const currentSeedPhraseLength = 'current_seed_phrase_length';
  static const currentDefaultSettingsMigrationVersion =
      'current_default_settings_migration_version';
  static const moneroTransactionPriority = 'current_fee_priority_monero';
  static const bitcoinTransactionPriority = 'current_fee_priority_bitcoin';
  static const havenTransactionPriority = 'current_fee_priority_haven';
  static const litecoinTransactionPriority = 'current_fee_priority_litecoin';
  static const ethereumTransactionPriority = 'current_fee_priority_ethereum';
  static const polygonTransactionPriority = 'current_fee_priority_polygon';
  static const bitcoinCashTransactionPriority = 'current_fee_priority_bitcoin_cash';
  static const zanoTransactionPriority = 'current_fee_priority_zano';
  static const wowneroTransactionPriority = 'current_fee_priority_wownero';
  static const customBitcoinFeeRate = 'custom_electrum_fee_rate';
  static const silentPaymentsCardDisplay = 'silentPaymentsCardDisplay';
  static const silentPaymentsAlwaysScan = 'silentPaymentsAlwaysScan';
  static const mwebCardDisplay = 'mwebCardDisplay';
  static const mwebEnabled = 'mwebEnabled';
  static const hasEnabledMwebBefore = 'hasEnabledMwebBefore';
  static const mwebAlwaysScan = 'mwebAlwaysScan';
  static const mwebNodeUri = 'mwebNodeUri';
  static const shouldShowReceiveWarning = 'should_show_receive_warning';
  static const shouldShowYatPopup = 'should_show_yat_popup';
  static const shouldShowRepWarning = 'should_show_rep_warning';
  static const moneroWalletPasswordUpdateV1Base = 'monero_wallet_update_v1';
  static const syncModeKey = 'sync_mode';
  static const syncAllKey = 'sync_all';
  static const lastPopupDate = 'last_popup_date';
  static const lastAppReviewDate = 'last_app_review_date';
  static const sortBalanceBy = 'sort_balance_by';
  static const pinNativeTokenAtTop = 'pin_native_token_at_top';
  static const useEtherscan = 'use_etherscan';
  static const usePolygonScan = 'use_polygonscan';
  static const useTronGrid = 'use_trongrid';
  static const useMempoolFeeAPI = 'use_mempool_fee_api';
  static const defaultNanoRep = 'default_nano_representative';
  static const defaultBananoRep = 'default_banano_representative';
  static const lookupsTwitter = 'looks_up_twitter';
  static const lookupsMastodon = 'looks_up_mastodon';
  static const lookupsYatService = 'looks_up_yat';
  static const lookupsUnstoppableDomains = 'looks_up_unstoppable_domain';
  static const lookupsOpenAlias = 'looks_up_open_alias';
  static const lookupsENS = 'looks_up_ens';
  static const showCameraConsent = 'show_camera_consent';

  static String moneroWalletUpdateV1Key(String name) =>
      '${PreferencesKey.moneroWalletPasswordUpdateV1Base}_${name}';

  static const exchangeProvidersSelection = 'exchange-providers-selection';
  static const autoGenerateSubaddressStatusKey = 'auto_generate_subaddress_status';
  static const moneroSeedType = 'monero_seed_type';
  static const bitcoinSeedType = 'bitcoin_seed_type';
  static const nanoSeedType = 'nano_seed_type';
  static const clearnetDonationLink = 'clearnet_donation_link';
  static const onionDonationLink = 'onion_donation_link';
  static const donationLinkWalletName = 'donation_link_wallet_name';
  static const lastSeenAppVersion = 'last_seen_app_version';
  static const shouldShowMarketPlaceInDashboard = 'should_show_marketplace_in_dashboard';
  static const isNewInstall = 'is_new_install';
  static const serviceStatusShaKey = 'service_status_sha_key';
  static const walletConnectPairingTopicsList = 'wallet_connect_pairing_topics_list';
  static String walletConnectPairingTopicsListForWallet(String publicKey) =>
      '${PreferencesKey.walletConnectPairingTopicsList}_${publicKey}';
}
