import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:scan/scan.dart';
import 'package:test_project/wallet_connect/qr_scan.dart';
import 'package:wallet_connect_v2_dart/wallet_connect_v2.dart';

class WalletConnectScreen extends StatefulWidget {
  const WalletConnectScreen({super.key});

  @override
  State<WalletConnectScreen> createState() => _WalletConnectScreenState();
}

Future<SignClient> wcClient = SignClient.createInstance(
  Core(
      memoryStore: true,
      projectId: "bc02014f72142f7eebda2a5f8ca5559e",
      relayUrl: 'wss://relay.walletconnect.com'),
  self: PairingMetadata(
    'Wallet (Responder)',
    'A wallet that can be requested to sign transactions',
    'https://walletconnect.com',
    ['https://avatars.githubusercontent.com/u/37784886'],
  ),
);

class _WalletConnectScreenState extends State<WalletConnectScreen>
    with WidgetsBindingObserver {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  dAppflow() async {
    var client = await wcClient;
    ConnectResponse resp = await client.connect(requiredNamespaces: {
      'eip155': RequiredNamespace(
        chains: ['eip155:1'], // Ethereum chain
        methods: ['eth_signTransaction'], // Requestable Methods
      ),
      'kadena': RequiredNamespace(
        chains: ['kadena:mainnet01'], // Kadena chain
        methods: ['kadena_quicksign_v1'], // Requestable Methods
      ),
    });
    log(resp.uri.toString());
    Uri? uri = resp.uri;
    final SessionData session = await resp.session.future;
    final sig = await client.request(
      topic: session.topic,
      chainId: 'eip155:1',
      request: SessionRequestParams(
        method: 'eth_signTransaction',
        params: 'json serializable parameters',
      ),
    );
  }

  walletFlow(value) async {
    var client = await wcClient;
    int id = 0;
    var getid = client.onSessionProposal.subscribe((args) async {
      var idAgrs = await args;
      log(idAgrs!.id.toString());
    });
    // client.onSessionProposal.subscribe((SessionProposal? args) async {
    //   // Handle UI updates using the args.params
    //   // Keep track of the args.id for the approval response
    //   id = await args!.id;
    // });

// Also setup the methods and chains that your wallet supports
    final handler = (dynamic params) async {
      return 'signed!';
    };
    client.registerRequestHandler(
      chainId: "eip155:1",
      method: 'kadena_sign',
      handler: handler,
    );

// Then, scan the QR code and parse the URI, and pair with the dApp
// On the first pairing, you will immediately receive a onSessionProposal request.
    Uri uri = Uri.parse(value);
    await client.pair(uri: uri);

// Present the UI to the user, and allow them to reject or approve the proposal
    final walletNamespaces = {
      'eip155': Namespace(
        accounts: ['eip155:1:abc'],
        methods: ['eth_signTransaction'],
      ),
      'kadena': Namespace(
        accounts: ['kadena:mainnet01:abc'],
        methods: ['kadena_sign_v1', 'kadena_quicksign_v1'],
      ),
    };
    await client.approve(
        id: id,
        namespaces:
            walletNamespaces // This will have the accounts requested in params
        );
// Or to reject...
// Error codes and reasons can be found here: https://docs.walletconnect.com/2.0/specs/clients/sign/error-codes
    await client.reject(
      id: id,
      reason: ErrorResponse(
        code: 4001,
        message: "User rejected request",
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            var client = await wcClient;
            // log(client.engine.);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => QRScanView()),
            ).then((value) async {
              walletFlow(value);
              if (value != null) {
                try {
                  var client = await wcClient;
                  log(value.toString());
                  await client.pair(uri: Uri.parse(value));
                } catch (e) {
                  // TODO
                  log(e.toString());
                }
              }
            });
          },
          child: Text("ScanQR"),
        ),
      ),
    );
  }
}
