import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../home_screen.dart';

class HomeTabs extends ConsumerWidget {
  const HomeTabs({required this.tabController, super.key});
  final TabController tabController;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        Align(
          child: Container(
            color: Colors.black,
            height: 50,
            child: TabBar(
              enableFeedback: false,
              isScrollable: true,
              splashFactory: NoSplash.splashFactory,
              automaticIndicatorColorAdjustment: true,
              indicatorSize: TabBarIndicatorSize.label,
              unselectedLabelStyle: TextStyle(color: Colors.black54),
              controller: tabController,
              indicatorColor: const Color(0xFF338BAA),
              tabs: tabsTexts
                  .map((e) => Tab(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Text(
                            e,
                            style: Theme.of(context).textTheme.subtitle2!.copyWith(
                                  color: Color(0xFFFEFEFF),
                                ),
                          ),
                        ),
                      ))
                  .toList(),
            ),
          ),
        ),
        Expanded(child: Container()),
        GestureDetector(
          child: const Icon(Icons.add),
        ),
        const SizedBox(width: 12,)
      ],

    );
  }
}
