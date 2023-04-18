import 'dart:convert';
import 'dart:developer';

import 'package:eth_sig_util/eth_sig_util.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_project/constants.dart';
import 'package:test_project/wallet_connect/qr_scan.dart';
import 'package:test_project/wallet_connect/update_session_view.dart';
import 'package:wallet_connect/wallet_connect.dart';
import 'package:flutter/material.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart' as http;
import 'package:wallet_connect/models/jsonrpc/json_rpc_request.dart';
import 'package:wallet_connect/models/ethereum/wc_ethereum_sign_message.dart';
import 'package:wallet_connect/models/ethereum/wc_ethereum_transaction.dart';
// import 'package:wallet_connect/models/ethereum/wc_ethereum_transaction.g.dart';
import 'package:wallet_connect/models/ethereum/wc_wallet_switch_network.dart';
// import 'package:wallet_connect/models/ethereum/wc_wallet_switch_network.g.dart';
import '../session_request_view.dart';
import 'package:wallet_connect/models/exception/exceptions.dart';
import 'package:wallet_connect/models/jsonrpc/json_rpc_error.dart';
import 'package:wallet_connect/models/jsonrpc/json_rpc_error_response.dart';
import 'package:wallet_connect/models/jsonrpc/json_rpc_response.dart';
import 'package:wallet_connect/models/message_type.dart';
import 'package:wallet_connect/models/session/wc_approve_session_response.dart';
import 'package:wallet_connect/models/session/wc_session.dart';
import 'package:wallet_connect/models/session/wc_session_request.dart';
import 'package:wallet_connect/models/session/wc_session_update.dart';
import 'package:wallet_connect/models/wc_encryption_payload.dart';
import 'package:wallet_connect/models/wc_method.dart';
import 'package:wallet_connect/models/wc_peer_meta.dart';
import 'package:wallet_connect/models/wc_socket_message.dart';
import 'package:wallet_connect/utils/constants.dart';
import 'package:wallet_connect/utils/hex.dart';

import 'input_field.dart';

class WalletConnectTestScreen extends StatefulWidget {
  const WalletConnectTestScreen({super.key});

  @override
  State<WalletConnectTestScreen> createState() =>
      _WallatConnectScreenTestState();
}

enum MenuItems {
  PREVIOUS_SESSION,
  UPDATE_SESSION,
  KILL_SESSION,
  SCAN_QR,
  PASTE_CODE,
  CLEAR_CACHE,
  GOTO_URL,
}

class _WallatConnectScreenTestState extends State<WalletConnectTestScreen> {
  String walletAddress = Constants.address;
  String privateKey = EthPrivateKey.fromHex(Constants.address).toString();
  static var httpClient = http.Client();
  late InAppWebViewController _webViewController;
  // static String rpc_url = "https://eth.llamarpc.com";
  WCSessionStore? _sessionStore;
  var _web3Client = Web3Client(rpc_url, httpClient);
  bool connected = false;
  late SharedPreferences _prefs;

  static String rpc_url =
      "https://goerli.infura.io/v3/a1a50b6285a944d98e643e6efe0bc6bf";
  late WCClient _wcClient;
  _initialize() async {
    _wcClient = WCClient(
      onConnect: () {
        log("Connected");
      },
      onDisconnect: (code, reason) {
        log("Disconnect code $code reason $reason");
        // Respond to disconnect callback
      },
      onFailure: (error) {
        log(error.toString());
        // Respond to connection failure callback
      },
      onEthSign: (id, message) {
        log("ID $id message $message");
        // Respond to personal_sign or eth_sign or eth_signTypedData request callback
      },
      onEthSendTransaction: (id, tx) {
        log("ID $id Transsaction ${tx.data}");
        // Respond to eth_sendTransaction request callback
      },
      onEthSignTransaction: (id, tx) {
        log("ID $id Transsaction ${tx.data}");
        // Respond to eth_signTransaction request callback
      },
    );
    // walletAddress = Constants.address;
  }

  _onSessionRequest(int id, WCPeerMeta peerMeta) {
    showDialog(
      context: context,
      builder: (_) => SessionRequestView(
        peerMeta: peerMeta,
        onApprove: (chainId) async {
          _wcClient.approveSession(
            accounts: [walletAddress],
            chainId: chainId,
          );
          _sessionStore = _wcClient.sessionStore;
          await _prefs.setString(
              'session', jsonEncode(_wcClient.sessionStore.toJson()));
          Navigator.pop(context);
        },
        onReject: () {
          _wcClient.rejectSession();
          Navigator.pop(context);
        },
      ),
    );
  }

  _onSessionError(dynamic message) {
    setState(() {
      connected = false;
    });
    showDialog(
      context: context,
      builder: (_) {
        return SimpleDialog(
          title: Text("Error"),
          contentPadding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 16.0),
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text('Some Error Occured. $message'),
            ),
            Row(
              children: [
                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('CLOSE'),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  _onSessionClosed(int? code, String? reason) {
    _prefs.remove('session');
    setState(() {
      connected = false;
    });
    showDialog(
      context: context,
      builder: (_) {
        return SimpleDialog(
          title: Text("Session Ended"),
          contentPadding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 16.0),
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text('Some Error Occured. ERROR CODE: $code'),
            ),
            if (reason != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text('Failure Reason: $reason'),
              ),
            Row(
              children: [
                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('CLOSE'),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  _onSignTransaction(
    int id,
    WCEthereumTransaction ethereumTransaction,
  ) {
    _onTransaction(
      id: id,
      ethereumTransaction: ethereumTransaction,
      title: 'Sign Transaction',
      onConfirm: () async {
        final creds = EthPrivateKey.fromHex(privateKey);
        final tx = await _web3Client.signTransaction(
          creds,
          _wcEthTxToWeb3Tx(ethereumTransaction),
          chainId: _wcClient.chainId!,
        );
        _wcClient.approveRequest<String>(
          id: id,
          result: bytesToHex(tx),
        );
        Navigator.pop(context);
      },
      onReject: () {
        _wcClient.rejectRequest(id: id);
        Navigator.pop(context);
      },
    );
  }

  _onSendTransaction(
    int id,
    WCEthereumTransaction ethereumTransaction,
  ) {
    _onTransaction(
      id: id,
      ethereumTransaction: ethereumTransaction,
      title: 'Send Transaction',
      onConfirm: () async {
        final creds = EthPrivateKey.fromHex(privateKey);
        final txhash = await _web3Client.sendTransaction(
          creds,
          _wcEthTxToWeb3Tx(ethereumTransaction),
          chainId: _wcClient.chainId!,
        );
        debugPrint('txhash $txhash');
        _wcClient.approveRequest<String>(
          id: id,
          result: txhash,
        );
        Navigator.pop(context);
      },
      onReject: () {
        _wcClient.rejectRequest(id: id);
        Navigator.pop(context);
      },
    );
  }

  _onTransaction({
    required int id,
    required WCEthereumTransaction ethereumTransaction,
    required String title,
    required VoidCallback onConfirm,
    required VoidCallback onReject,
  }) async {
    BigInt gasPrice = BigInt.parse(ethereumTransaction.gasPrice ?? '0');
    if (gasPrice == BigInt.zero) {
      gasPrice = await _web3Client.estimateGas();
    }
    showDialog(
      context: context,
      builder: (_) {
        return SimpleDialog(
          title: Column(
            children: [
              if (_wcClient.remotePeerMeta!.icons.isNotEmpty)
                Container(
                  height: 100.0,
                  width: 100.0,
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Image.network(_wcClient.remotePeerMeta!.icons.first),
                ),
              Text(
                _wcClient.remotePeerMeta!.name,
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 20.0,
                ),
              ),
            ],
          ),
          contentPadding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 16.0),
          children: [
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Receipient',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    '${ethereumTransaction.to}',
                    style: TextStyle(fontSize: 16.0),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Transaction Fee',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                  // Expanded(
                  //   child: Text(
                  //     '${EthConversions.weiToEthUnTrimmed(gasPrice * BigInt.parse(ethereumTransaction.gas ?? '0'), 18)} MATIC',
                  //     style: TextStyle(fontSize: 16.0),
                  //   ),
                  // ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Transaction Amount',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                  // Expanded(
                  //   child: Text(
                  //     // '${EthConversions.weiToEthUnTrimmed(BigInt.parse(ethereumTransaction.value ?? '0'), 18)} MATIC',
                  //     style: TextStyle(fontSize: 16.0),
                  //   ),
                  // ),
                ],
              ),
            ),
            Theme(
              data:
                  Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: ExpansionTile(
                  tilePadding: EdgeInsets.zero,
                  title: Text(
                    'Data',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                  children: [
                    Text(
                      '${ethereumTransaction.data}',
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ],
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                    ),
                    onPressed: onConfirm,
                    child: Text('CONFIRM'),
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                    ),
                    onPressed: onReject,
                    child: Text('REJECT'),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  _onSign(
    int id,
    WCEthereumSignMessage ethereumSignMessage,
  ) {
    showDialog(
      context: context,
      builder: (_) {
        return SimpleDialog(
          title: Column(
            children: [
              if (_wcClient.remotePeerMeta!.icons.isNotEmpty)
                Container(
                  height: 100.0,
                  width: 100.0,
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Image.network(_wcClient.remotePeerMeta!.icons.first),
                ),
              Text(
                _wcClient.remotePeerMeta!.name,
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 20.0,
                ),
              ),
            ],
          ),
          contentPadding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 16.0),
          children: [
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                'Sign Message',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
              ),
            ),
            Theme(
              data:
                  Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: ExpansionTile(
                  tilePadding: EdgeInsets.zero,
                  title: Text(
                    'Message',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                  children: [
                    Text(
                      ethereumSignMessage.data!,
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ],
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                    ),
                    onPressed: () async {
                      String signedDataHex;
                      if (ethereumSignMessage.type ==
                          WCSignType.TYPED_MESSAGE) {
                        signedDataHex = EthSigUtil.signTypedData(
                          privateKey: privateKey,
                          jsonData: ethereumSignMessage.data!,
                          version: TypedDataVersion.V4,
                        );
                      } else {
                        final creds = EthPrivateKey.fromHex(privateKey);
                        final encodedMessage =
                            hexToBytes(ethereumSignMessage.data!);
                        final signedData =
                            await creds.signPersonalMessage(encodedMessage);
                        signedDataHex = bytesToHex(signedData, include0x: true);
                      }
                      debugPrint('SIGNED $signedDataHex');
                      _wcClient.approveRequest<String>(
                        id: id,
                        result: signedDataHex,
                      );
                      Navigator.pop(context);
                    },
                    child: Text('SIGN'),
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                    ),
                    onPressed: () {
                      _wcClient.rejectRequest(id: id);
                      Navigator.pop(context);
                    },
                    child: Text('REJECT'),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Transaction _wcEthTxToWeb3Tx(WCEthereumTransaction ethereumTransaction) {
    return Transaction(
      from: EthereumAddress.fromHex(ethereumTransaction.from),
      to: EthereumAddress.fromHex(ethereumTransaction.to!),
      maxGas: ethereumTransaction.gasLimit != null
          ? int.tryParse(ethereumTransaction.gasLimit!)
          : null,
      gasPrice: ethereumTransaction.gasPrice != null
          ? EtherAmount.inWei(BigInt.parse(ethereumTransaction.gasPrice!))
          : null,
      value: EtherAmount.inWei(BigInt.parse(ethereumTransaction.value ?? '0')),
      data: hexToBytes(ethereumTransaction.data!),
      nonce: ethereumTransaction.nonce != null
          ? int.tryParse(ethereumTransaction.nonce!)
          : null,
    );
  }

  _connectToPreviousSession() {
    final _sessionSaved = _prefs.getString('session');
    debugPrint('_sessionSaved $_sessionSaved');
    _sessionStore = _sessionSaved != null
        ? WCSessionStore.fromJson(jsonDecode(_sessionSaved))
        : null;
    if (_sessionStore != null) {
      debugPrint('_sessionStore $_sessionStore');
      _wcClient.connectFromSessionStore(_sessionStore!);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('No previous session found.'),
      ));
    }
  }

  onSwitchNetwork(int id, int chainId) async {
    await _wcClient.updateSession(chainId: chainId);
    _wcClient.approveRequest<Null>(id: id, result: null);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Changed network to $chainId.'),
    ));
  }

  _onConnect() {
    setState(() {
      connected = true;
    });
  }

  _qrScanHandler(String value) {
    if (value.contains('bridge') && value.contains('key')) {
      final session = WCSession.from(value);
      log('session $session');
      final peerMeta = WCPeerMeta(
        name: "Example Wallet",
        url: "https://example.wallet",
        description: "Example Wallet",
        icons: [
          "https://gblobscdn.gitbook.com/spaces%2F-LJJeCjcLrr53DcT1Ml7%2Favatar.png"
        ],
      );
      _wcClient.connectNewSession(session: session, peerMeta: peerMeta);
    }
  }

  @override
  void initState() {
    _initialize();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: Text(widget.title),
        actions: [
          PopupMenuButton<MenuItems>(
            onSelected: (item) {
              switch (item) {
                case MenuItems.PREVIOUS_SESSION:
                  _connectToPreviousSession();
                  break;
                case MenuItems.UPDATE_SESSION:
                  if (_wcClient.isConnected) {
                    showGeneralDialog(
                      context: context,
                      barrierDismissible: true,
                      barrierLabel: 'Update Session',
                      pageBuilder: (context, _, __) => UpdateSessionView(
                        client: _wcClient,
                        address: walletAddress,
                      ),
                    ).then((value) {
                      if (value != null && (value as List).isNotEmpty) {
                        _wcClient.updateSession(
                          chainId: value[0] as int,
                          accounts: [value[1] as String],
                        );
                      }
                    });
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Not connected.'),
                    ));
                  }
                  break;
                case MenuItems.KILL_SESSION:
                  _wcClient.killSession();
                  break;
                case MenuItems.SCAN_QR:
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => QRScanView()),
                  ).then((value) {
                    if (value != null) {
                      log(value.toString());
                      _qrScanHandler(value);
                    }
                  });
                  break;
                case MenuItems.PASTE_CODE:
                  showGeneralDialog(
                    context: context,
                    barrierDismissible: true,
                    barrierLabel: 'Paste Code',
                    pageBuilder: (context, _, __) => InputDialog(
                      title: 'Paste code to connect',
                      label: 'Enter Code',
                    ),
                  ).then((value) {
                    if (value != null && (value as String).isNotEmpty) {
                      _qrScanHandler(value);
                    }
                  });
                  break;
                case MenuItems.CLEAR_CACHE:
                  _webViewController.clearCache();
                  break;
                case MenuItems.GOTO_URL:
                  showGeneralDialog(
                    context: context,
                    barrierDismissible: true,
                    barrierLabel: 'Goto URL',
                    pageBuilder: (context, _, __) => InputDialog(
                      title: 'Enter URL to open',
                      label: 'Enter URL',
                    ),
                  ).then((value) {
                    if (value != null && (value as String).isNotEmpty) {
                      _webViewController.loadUrl(
                        urlRequest: URLRequest(url: Uri.parse(value)),
                      );
                    }
                  });
                  break;
              }
            },
            itemBuilder: (_) {
              return [
                PopupMenuItem(
                  value: MenuItems.PREVIOUS_SESSION,
                  child: Text('Connect Previous Session'),
                ),
                PopupMenuItem(
                  value: MenuItems.UPDATE_SESSION,
                  child: Text('Update Session'),
                ),
                PopupMenuItem(
                  value: MenuItems.KILL_SESSION,
                  child: Text('Kill Session'),
                ),
                PopupMenuItem(
                  value: MenuItems.SCAN_QR,
                  child: Text('Connect via QR'),
                ),
                PopupMenuItem(
                  value: MenuItems.PASTE_CODE,
                  child: Text('Connect via Code'),
                ),
                PopupMenuItem(
                  value: MenuItems.CLEAR_CACHE,
                  child: Text('Clear Cache'),
                ),
                PopupMenuItem(
                  value: MenuItems.GOTO_URL,
                  child: Text('Goto URL'),
                ),
              ];
            },
          ),
        ],
      ),
      body: InAppWebView(
        initialUrlRequest:
            URLRequest(url: Uri.parse('example.walletconnect.org')),
        initialOptions: InAppWebViewGroupOptions(
          crossPlatform: InAppWebViewOptions(
            useShouldOverrideUrlLoading: true,
          ),
        ),
        onWebViewCreated: (controller) {
          _webViewController = controller;
        },
        shouldOverrideUrlLoading: (controller, navAction) async {
          final url = navAction.request.url.toString();
          debugPrint('URL $url');
          if (url.contains('wc?uri=')) {
            final wcUri = Uri.parse(
                Uri.decodeFull(Uri.parse(url).queryParameters['uri']!));
            _qrScanHandler(wcUri.toString());
            return NavigationActionPolicy.CANCEL;
          } else if (url.startsWith('wc:')) {
            _qrScanHandler(url);
            return NavigationActionPolicy.CANCEL;
          } else {
            return NavigationActionPolicy.ALLOW;
          }
        },
      ),
    );
  }
}
