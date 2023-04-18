import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

makeTranslucentDialog(BuildContext context) {
  showGeneralDialog(
    barrierDismissible: true,
    barrierLabel: '',
    barrierColor: Colors.black38,
    transitionDuration: Duration(milliseconds: 200),
    pageBuilder: (ctx, anim1, anim2) => AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      contentPadding: EdgeInsets.zero,
      content: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (int i = 0; i < 4; i++)
              InkWell(
                child: ListTile(
                  leading: SizedBox.square(
                    dimension: 40,
                    child: ClipOval(
                        child: CachedNetworkImage(
                      imageUrl:
                          "https://cloudfront-us-east-1.images.arcpublishing.com/coindesk/ZJZZK5B2ZNF25LYQHMUTBTOMLU.png",
                    )),
                  ),
                  title: Text("Title"),
                ),
              )
          ],
        ),
      ),
      elevation: 2,
    ),
    transitionBuilder: (ctx, anim1, anim2, child) => BackdropFilter(
      filter:
          ImageFilter.blur(sigmaX: 4 * anim1.value, sigmaY: 4 * anim1.value),
      child: FadeTransition(
        child: child,
        opacity: anim1,
      ),
    ),
    context: context,
  );
}
