import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:test_project/home.dart';
import 'package:test_project/presentation/main/home/widgets/home_tabs.dart';
import 'package:test_project/presentation/main/home/widgets/symbol_button.dart';
import 'package:test_project/send.dart';
import 'package:test_project/swap.dart';
import '../../../constants.dart';
import '../../../request.dart';
import '../../../swap.dart';
import 'widgets/account_card.dart';
import 'widgets/sliver_app_bar_delegate.dart';
import 'widgets/token_tile.dart';

List<String> tabsTexts = ["Tokens", "NFTs"];

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  double _sendReceivePagePosition = 0;
  List<DropdownMenuItem<String>> networks = [
    DropdownMenuItem(child: Text("Ethereum Mainnet"), value: "ETH"),
    DropdownMenuItem(child: Text("Goerli Testnet"), value: "GOERLI"),
  ];
  String selectedValue2 = "ETH";
  @override
  void initState() {
    super.initState();
    _tabController = TabController(initialIndex: 0, length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverPersistentHeader(
                delegate: SliverAppBarDelegate(
                  minHeight: 185,
                  maxHeight: 90,
                  child: const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: AccountCard(),
                  ),
                ),
              ),
              SliverPersistentHeader(
                delegate: SliverAppBarDelegate(
                  minHeight: 100,
                  maxHeight: 70,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: SizedBox(
                      height: 100,
                      child: PageView(
                        physics: const BouncingScrollPhysics(),
                        onPageChanged: (value) => setState(() {
                          _sendReceivePagePosition = value.toDouble();
                        }),
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SymbolButton(
                                  title: "Add Funds",
                                  icon: Icon(Icons.credit_card)),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => SendScreen(),
                                      ));
                                },
                                child: SymbolButton(
                                    title: "Send",
                                    icon: Icon(Icons.credit_card)),
                              ),
                              GestureDetector(
                                onTap: () {
                                  _bottomSheet(context);
                                },
                                child: SymbolButton(
                                    title: "Receive",
                                    icon: Icon(Icons.credit_card)),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => SwapScreen(),
                                      ));
                                },
                                child: SymbolButton(
                                    title: "Swap",
                                    icon: Icon(Icons.credit_card)),
                              ),
                              SymbolButton(
                                  title: "Swap", icon: Icon(Icons.swap_horiz)),
                              SizedBox(
                                width: 50,
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SliverPersistentHeader(
                delegate: SliverAppBarDelegate(
                  minHeight: 37,
                  maxHeight: 37,
                  child: Column(
                    children: [
                      DotsIndicator(
                        dotsCount: 2,
                        position: _sendReceivePagePosition,
                        decorator: DotsDecorator(
                          size: const Size.square(9.0),
                          activeSize: const Size(18.0, 5.0),
                          activeColor: Color(0xFF37CBFA),
                          activeShape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                        ),
                      ),
                      const Divider(),
                    ],
                  ),
                ),
              ),
              SliverPersistentHeader(
                pinned: true,
                delegate: SliverAppBarDelegate(
                    minHeight: 50,
                    maxHeight: 50,
                    child: HomeTabs(
                      tabController: _tabController,
                    )),
              ),
            ];
          },
          body: TabBarView(
            controller: _tabController,
            children: [
              ListView.builder(
                  key: const PageStorageKey('myListView1'),
                  itemBuilder: (context, idx) {
                    return TokenTile(
                      index: idx,
                    );
                  }),
              ListView.builder(
                  key: const PageStorageKey('myListView2'),
                  itemBuilder: (context, index) {
                    return TokenTile(
                      index: index,
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }

  Future<dynamic> _bottomSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) => Container(
            // height: 200,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "Recieve",
                  style: TextStyle(fontSize: 25),
                ),
                DropdownButtonHideUnderline(
                    child: DropdownButton(
                        value: selectedValue2,
                        items: networks,
                        onChanged: (String? value) {
                          setState(() {
                            selectedValue2 = value.toString();
                          });
                          log(value.toString());
                        })),
                QrImage(
                  data: Constants.address,
                  size: 150,
                  backgroundColor: Colors.white,
                  // foregroundColor: Colors.pinkAccent,
                  errorStateBuilder: (cxt, err) {
                    return const Center(
                      child: Text(
                        "Uh oh! Something went wrong...",
                        textAlign: TextAlign.center,
                      ),
                    );
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(Constants.address),
                    IconButton(
                      onPressed: () {
                        Clipboard.setData(
                                ClipboardData(text: Constants.address))
                            .then((_) {
                          Fluttertoast.showToast(msg: "Copied to Clipboard");
                        });
                      },
                      icon: Icon(Icons.copy),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RequestScreen()));
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(Icons.request_quote),
                          Text("Request payment")
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [Icon(Icons.share), Text("Share Address")],
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
