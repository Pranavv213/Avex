import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TokenTile extends ConsumerWidget {
  const TokenTile({required this.index,super.key});
  final int index;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      title: Text('ListTile${index}'),
      isThreeLine: true,
      subtitle: Text('Secondary text\nTertiary text'),
      leading: Padding(
        padding: const EdgeInsets.all(4.0),
        child: SizedBox.square(
          dimension: 40,
          child: ClipOval(
              child: CachedNetworkImage(
            imageUrl:
                "https://cloudfront-us-east-1.images.arcpublishing.com/coindesk/ZJZZK5B2ZNF25LYQHMUTBTOMLU.png",
          )),
        ),
      ),
      trailing: Text('Metadata'),
    );
  }
}
