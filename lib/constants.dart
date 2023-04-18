import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:test_project/onboarding1.dart';
import 'package:dart_bip32_bip44/dart_bip32_bip44.dart';
import 'package:test_project/wallet_creation.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:web3dart/web3dart.dart';
import 'dart:developer' as dev;
import 'package:google_fonts/google_fonts.dart';
import 'dart:math';
// import 'package:meilisearch/meilisearch.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Constants {
  static Credentials userCredentials = EthPrivateKey.fromHex('962f96661bfb95764c4c99539d7f8676376c13fca2fad94deb550e19aa8f8e68');
  static EthereumAddress ethereumAddress = userCredentials.address;
  static String address = userCredentials.address.hex;
  static String dummyAddress = '';
  static EthereumAddress dummyethereumAddress =
      EthereumAddress.fromHex(dummyAddress);
  static String seedPhrase = '';
  static List<DropdownMenuItem<String>> accountsList = [
    DropdownMenuItem(
      child: Text("0x7F3BD.....2287F"),
      value: "0x7F3BD1Fa0d241bEd9D7bb81294b78daBa182287F",
    ),
    DropdownMenuItem(
      child: Text("0x8Cf6b.....babaE"),
      value: "0x8Cf6b290F1b478bC0FEeF9E05DA498a0167babaE",
    )
  ];
  static List<DropdownMenuItem<String>> tokens = [
    DropdownMenuItem(
        child: Text(
          "ETH",
          style: h4poppinsStyle,
        ),
        value: "ETH"),
    DropdownMenuItem(child: Text("DAI", style: h4poppinsStyle), value: "DAI"),
    DropdownMenuItem(child: Text("UDSC", style: h4poppinsStyle), value: "USDC"),
    DropdownMenuItem(child: Text("LINK", style: h4poppinsStyle), value: "LINK"),
    DropdownMenuItem(child: Text("USDT", style: h4poppinsStyle), value: "USDT"),
    DropdownMenuItem(child: Text("UNI", style: h4poppinsStyle), value: "UNI"),
    DropdownMenuItem(child: Text("MATIC"), value: "MATIC"),
    DropdownMenuItem(child: Text("SAND"), value: "SAND"),
    // DropdownMenuItem(child: Text("USD Mapped Token"), value: "USDM"),
    // DropdownMenuItem(child: Text("WETH"), value: "WETH"),
    // DropdownMenuItem(child: Text("BUSD"), value: "BUSD"),
  ];
  static List<DropdownMenuItem<String>> slippage = [
    DropdownMenuItem(child: Text("1%"), value: "0.01"),
    DropdownMenuItem(child: Text("2%"), value: "0.02"),
    DropdownMenuItem(child: Text("3%"), value: "0.03"),
    DropdownMenuItem(child: Text("5%"), value: "0.05"),
  ];
  static Map<String, String> tokenAddressList = {
    "ETH": "0xeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee",
    "DAI": "0xdc31Ee1784292379Fbb2964b3B9C4124D8F89C60",
    "UNI": "0x1f9840a85d5af5bf1d1762f925bdaddc4201f984",
    "USDC": "0x07865c6e87b9f70255377e024ace6630c1eaa37f",
    "USDT": "0x56705db9f87c8a930ec87da0d458e00a657fccb0 ",
    "LINK": "0xe9c4393a23246293a8D31BF7ab68c17d4CF90A29",
    "MATIC": "0x0000000000000000000000000000000000000000",
    "SAND": "0xbbba073c31bf03b8acf7c28ef0738decf3695683"
  };
  static TextStyle h1poppinsStyle = GoogleFonts.poppins(
    textStyle: const TextStyle(
      fontSize: 43,
      color: Colors.white,
      fontWeight: FontWeight.w500,
    ),
  );
  static TextStyle h2poppinsStyle = GoogleFonts.poppins(
    textStyle: const TextStyle(
      fontSize: 38,
      color: Colors.white,
      fontWeight: FontWeight.w500,
    ),
  );
  static TextStyle h3poppinsStyle = GoogleFonts.poppins(
    textStyle: const TextStyle(
      fontSize: 22,
      color: Colors.white,
      fontWeight: FontWeight.w500,
    ),
  );
  static TextStyle h4poppinsStyle = GoogleFonts.poppins(
    textStyle: const TextStyle(
      fontSize: 18,
      color: Colors.white,
      fontWeight: FontWeight.w400,
    ),
  );
  static TextStyle h5poppinsStyle = GoogleFonts.poppins(
    textStyle: const TextStyle(
      fontSize: 14,
      color: Colors.white,
      fontWeight: FontWeight.w400,
    ),
  );

  static TextStyle h6poppinsStyle = GoogleFonts.poppins(
    textStyle: const TextStyle(
      fontSize: 10,
      color: Colors.white,
      fontWeight: FontWeight.w400,
    ),
  );
  static TextStyle h7poppinsStyle = GoogleFonts.poppins(
    textStyle: const TextStyle(
      fontSize: 8,
      color: Colors.white,
      fontWeight: FontWeight.w400,
    ),
  );
  static ButtonStyle roundCornerBlue = ElevatedButton.styleFrom(
    backgroundColor: const Color(0xFF2f89a6),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(37.0),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
  );
  static ButtonStyle roundCornerBlack = ElevatedButton.styleFrom(
    backgroundColor: const Color(0xFF222529),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(37.0),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
  );
  static ButtonStyle rectRoundCornerBlue = ElevatedButton.styleFrom(
    backgroundColor: const Color(0xFF2f89a6),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15.0),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
  );
  static ButtonStyle rectRoundCornerBlack = ElevatedButton.styleFrom(
    backgroundColor: const Color(0xFF222529),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15.0),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
  );
  // createWallet() {
  //   var rng = Random.secure();
  //   Credentials random = EthPrivateKey.createRandom(rng);
  //   dev.log(random.address.hex);
  // }
  String? pubaddr;
  String? privaddr;
  bool creatingWallet = false;

  //Abstract class implemetation
  WalletAddress walletAddress = WalletAddress();

  void createWallet() async {
    //generating seed phrase
    final mnemonic = walletAddress.generateMnemonic();
    dev.log(mnemonic.toString());

    Constants.seedPhrase = mnemonic;
    //creating new account with seed phrase
    createAccount(mnemonic, false);
  }

  //Creating an account. New account is created in 2 scenarios, 1. When user creates a new acount in existing wallet 2. When user imports a wallet
  void createAccount(String mnemonic, bool importing) async {
    String seed = bip39.mnemonicToSeedHex(mnemonic);
    //Chain of wallet is created using seed
    Chain chain = Chain.seed(seed);
    ExtendedKey key;
    importing
        ? {
            key = chain.forPath("m/44'/60'/0'/0/0"),
            accountsList.clear()
          } //If importing, only first account from the above chain is obtained
        : key = chain.forPath(
            "m/44'/60'/0'/0/${accountsList.length}"); //else if creating new account in existing wallet, new account is added to list of accounts
    Credentials credentials = EthPrivateKey.fromHex(
        key.privateKeyHex()); //Getting credentials from private key
  }

//Importin an existing wallet using seed phrase
  void importWallet(String importSeed) async {
    String seed = bip39.mnemonicToSeedHex(importSeed);
    //Validating seed phrase
    if (bip39.validateMnemonic(seed)) {
      dev.log("true");
    } else {
      dev.log("false");
    }
    //Chain of wallet is created using seed
    Chain chain = Chain.seed(seed); //web3dart
    ExtendedKey key = chain.forPath("m/44'/60'/0'/0/0");
    //Getting credentials from private key
    Credentials credentials = EthPrivateKey.fromHex(key.privateKeyHex());
  }

  Future<double> getPrice({required String token}) async {
    double x = 0;
    var url =
        "https://data.messari.io/api/v1/assets/$token/metrics/market-data";
    var response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      var decodedData = jsonDecode(response.body);
      var price = decodedData["data"]["market_data"]["price_usd"];
      x = price;
    }

    return x;
  }

  // static var client = MeiliSearchClient(
  //     "https://ms-decb20c2b075-2348.sgp.meilisearch.io/",
  //     "0a0d19ca9a2a29d97528913d6741313e446a455aaf863b82b451c62a0b834075");
  // var index = client.index("tokens");
  simluate(
      {String toAddress = '',
      String fromAddress = '',
      double value = 0.0}) async {
    //Use the below code to
    // contract.function(name).encodeCall(params)
    Map<String, dynamic> simulateParams = {
      "chain": "ethereum-mainnet",
      "params": [
        {
          "from": "0xa9527687EfA8AdABfEfD90a98Ac5a320DC747166",
          "to": "0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48",
          "value": "0x0",
          "data":
              "0xa9059cbb000000000000000000000000fc43f5f9dd45258b3aff31bdbe6561d97e8b71de00000000000000000000000000000000000000000000000000000000000f4240"
        }
      ]
    };
    var simulateUri = Uri(
      scheme: 'https',
      host: '2701-2401-4900-1cc8-df15-2aaa-a7e8-5f08-6ce6.in.ngrok.io',
      path: "/simulate/assetChange",
    );

    http.Response response = await http.post(simulateUri,
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(simulateParams));
    var data;
    if (response.statusCode == 200) {
      data = jsonDecode(response.body);
      dev.log(data.toString());
    } else {
      data = jsonDecode(response.body);
      dev.log(data['error']['message']);
    }
  }

  Future<DeployedContract> loadContract(
      {String contractAddress = '', String contractFileName = ''}) async {
    // String contractAddress = contractAddress;
    String contractName = contractFileName;
    String abi = await rootBundle.loadString("contracts/$contractName.json");

    final contract = DeployedContract(ContractAbi.fromJson(abi, "TestnetERC20"),
        EthereumAddress.fromHex(contractAddress));
    return contract;
  }
}
// var result;
// if (value.isNotEmpty) {
//   result = await Constants()
//       .index
//       .search(value, filter: ['symbol = $value']);
//   log(result.hits.toString());
// }

// var address = await credentials.address;
//     accountsList.add(address.hex.toString());
//     dev.log(accountsList.length.toString());
//     dev.log(accountsList.toString());

//web3dart
// var address = await credentials.address;
// dev.log(address.hex); //web3dart
// // toggleCreateState();
