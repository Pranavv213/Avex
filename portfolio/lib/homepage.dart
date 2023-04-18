import 'dart:async';
import '/providers/balnace_provider.dart';
import '/widgets/top_profile.dart';
import '/utils/get_data.dart';
import '/tabs/history.dart';
import '/tabs/nfts.dart';
import '/providers/chain_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/tabs/portfolio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class MyDelegate extends SliverPersistentHeaderDelegate {
  MyDelegate(this.tabBar);

  final TabBar tabBar;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return tabBar;
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  double get minExtent => tabBar.preferredSize.height;
}

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage>
    with TickerProviderStateMixin {
  

  @override
  Widget build(BuildContext context) {
    ChainProvider chainProvider =ref.watch(chainNotifierProvider);
    // Provider.of<ChainProvider>(context, listen: false);

    BalanceProvider balanceProvider =ref.watch(balanceNotifierProvider);

    updateUsdPrice(
      balanceProvider: balanceProvider,
      address: chainProvider.address,
    );
    Timer.periodic(const Duration(seconds: 5), (timer) {
      updateUsdPrice(
        balanceProvider: balanceProvider,
        address: chainProvider.address,
      );
    });
    // ref.watch
    return Scaffold(
      backgroundColor: Colors.black,
      body: DefaultTabController(
        length: 3,
        child: NestedScrollView(
          physics: const NeverScrollableScrollPhysics(),
          headerSliverBuilder: (context, value) {
            return [
              const SliverAppBar(
                collapsedHeight: 88,
                expandedHeight: 88,
                backgroundColor: Colors.black,
                flexibleSpace: TopProfile(),
                pinned: true,
              ),
              SliverPersistentHeader(
                delegate: MyDelegate(
                  const TabBar(
                    physics: NeverScrollableScrollPhysics(),
                    labelPadding: EdgeInsets.symmetric(horizontal: 5),
                    dividerColor: Colors.black,
                    unselectedLabelColor: Colors.white,
                    indicatorColor: Color(0xff338BAA),
                    indicatorPadding:
                        EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    labelColor: Color(0xff338BAA),
                    tabs: [
                      Tab(
                        child: Text(
                          'Portfolio',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      Tab(
                        child: Text(
                          'NFTs',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      Tab(
                        child: Text(
                          'History',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                ),
                // floating: true,
                pinned: true,
              ),
            ];
          },
          body: const Padding(
            padding: EdgeInsets.only(left: 15, top: 10),
            child: TabBarView(
              physics: AlwaysScrollableScrollPhysics(),
              children: [
                Portfolio(),
                NFTs(),
                History(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
