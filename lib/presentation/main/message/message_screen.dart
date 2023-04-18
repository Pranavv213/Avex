import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:test_project/main.dart';

class MessageScreen extends ConsumerWidget {
  MessageScreen({
    Key? key,
  }) : super(key: key);

  late StreamChatClient client;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    client = ref.read(clientProvider);

    return MaterialApp(
      builder: (context, child) => StreamChat(
        client: client,
        child: child,
      ),
      home: ChannelListPage(
        client: client,
      ),
    );
  }
}

class ChannelListPage extends StatefulWidget {
  const ChannelListPage({
    Key? key,
    required this.client,
  }) : super(key: key);

  final StreamChatClient client;

  @override
  State<ChannelListPage> createState() => _ChannelListPageState();
}

class _ChannelListPageState extends State<ChannelListPage> {
  late final _controller = StreamChannelListController(
    client: widget.client,
    filter: Filter.in_(
      'members',
      [StreamChat.of(context).currentUser!.id],
    ),
    sort: const [SortOption('last_message_at')],
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SlidableAutoCloseBehavior(
          child: RefreshIndicator(
            onRefresh: _controller.refresh,
            child: StreamChannelListView(
              controller: _controller,
              onChannelTap: (channel) => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => StreamChannel(
                    channel: channel,
                    child: const ChannelPage(),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
}

class ChannelPage extends StatelessWidget {
  const ChannelPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: const StreamChannelHeader(),
        body: Column(
          children: const <Widget>[
            Expanded(
              child: StreamMessageListView(),
            ),
            StreamMessageInput(),
          ],
        ),
      );
}
