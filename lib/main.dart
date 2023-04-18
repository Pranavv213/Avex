import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:test_project/firebase_options.dart';
import 'app.dart';
import 'dynamic_link_handler.dart';

// import 'package:graphql_flutter/graphql_flutter.dart';
const apiKey = "b67pax5b2wdq";
const userToken =
    "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoidHV0b3JpYWwtZmx1dHRlciJ9.S-MJpoSwDiqyXpUURgO5wVqJ4vKlIVFLSEyrFYCOE1c";

late Provider<StreamChatClient> clientProvider;
late Provider<Channel> channelProvider;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final PendingDynamicLinkData? initialLink =
      await FirebaseDynamicLinks.instance.getInitialLink();
  //StreamChatClient
  final client = StreamChatClient(apiKey, logLevel: Level.INFO);
  clientProvider = Provider((ref) => client);
  // Current user
  await client.connectUser(User(id: "tutorial-flutter"), userToken);

  // Get channel
  final channel = client.channel("messaging", id: "flutterdevs");
  channelProvider = Provider((ref) => channel);
  await channel.watch();
  runApp(const ProviderScope(child: App()));
}
