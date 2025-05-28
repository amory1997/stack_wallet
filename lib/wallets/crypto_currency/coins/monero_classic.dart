import 'package:cs_monero/src/ffi_bindings/monero_wallet_bindings.dart'
    as xmr_wallet_ffi;

import '../../../models/node_model.dart';
import '../../../utilities/default_nodes.dart';
import '../../../utilities/enums/derive_path_type_enum.dart';
import '../crypto_currency.dart';
import '../intermediate/cryptonote_currency.dart';

class MoneroClassic extends CryptonoteCurrency {
  MoneroClassic(super.network) {
    _idMain = "monero_classic";
    _uriScheme = "monero-classic";
    switch (network) {
      case CryptoCurrencyNetwork.main:
        _id = _idMain;
        _name = "Monero Classic";
        _ticker = "XMC";
      default:
        throw Exception("Unsupported network: $network");
    }
  }

  late final String _id;
  @override
  String get identifier => _id;

  late final String _idMain;
  @override
  String get mainNetId => _idMain;

  late final String _name;
  @override
  String get prettyName => _name;

  late final String _uriScheme;
  @override
  String get uriScheme => _uriScheme;

  late final String _ticker;
  @override
  String get ticker => _ticker;

  @override
  int get minConfirms => 10;

  @override
  bool get torSupport => true;

  @override
  bool validateAddress(String address) {
    if (address.contains("111")) {
      return false;
    }
    switch (network) {
      case CryptoCurrencyNetwork.main:
        return xmr_wallet_ffi.validateAddress(address, 0);
      default:
        throw Exception("Unsupported network: $network");
    }
  }

  static const List<String> _xmcNodes = [
    "node1.monero-classic.org",
    "node2.monero-classic.org",
    "node3.monero-classic.org",
    "node1.xmc-seed.com",
    "node2.xmc-seed.com",
    "node3.xmc-seed.com",
    "node1.xmc-seed.org",
    "node2.xmc-seed.org",
    "node3.xmc-seed.org"
  ];

  @override
  NodeModel get defaultNode {
    switch (network) {
      case CryptoCurrencyNetwork.main:
        // Randomly select one of the available nodes
        final nodeHost = _xmcNodes[DateTime.now().microsecond % _xmcNodes.length];
        return NodeModel(
          host: "https://$nodeHost",
          port: 18081,
          name: DefaultNodes.defaultName,
          id: DefaultNodes.buildId(this),
          useSSL: true,
          enabled: true,
          coinName: identifier,
          isFailover: true,
          isDown: false,
          trusted: true,
          torEnabled: true,
          clearnetEnabled: true,
        );

      default:
        throw UnimplementedError();
    }
  }

  @override
  int get defaultSeedPhraseLength => 16;

  @override
  int get fractionDigits => 11;

  @override
  bool get hasBuySupport => false;

  @override
  bool get hasMnemonicPassphraseSupport => false;

  @override
  List<int> get possibleMnemonicLengths => [defaultSeedPhraseLength, 25];

  @override
  BigInt get satsPerCoin => BigInt.from(100000000000);

  @override
  int get targetBlockTimeSeconds => 120;

  @override
  DerivePathType get defaultDerivePathType => throw UnsupportedError(
        "$runtimeType does not use bitcoin style derivation paths",
      );

  @override
  Uri defaultBlockExplorer(String txid) {
    switch (network) {
      case CryptoCurrencyNetwork.main:
        return Uri.parse("https://explorer.monero-classic.org/tx/$txid");
      default:
        throw Exception(
          "Unsupported network for defaultBlockExplorer(): $network",
        );
    }
  }
} 