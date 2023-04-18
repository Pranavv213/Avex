import 'dart:developer';
import 'package:flutter/services.dart';
import 'package:web3dart/web3dart.dart';
import 'dart:math' as math;
import 'constants.dart';
import 'package:flutter/material.dart';
import 'package:test_project/constants.dart';
import 'package:test_project/dummy_swap.dart';
import 'package:test_project/getTokens.dart';
import 'package:slide_to_confirm/slide_to_confirm.dart';
import 'package:test_project/deepak_services/swap.service.dart' as Swap;
import 'package:test_project/deepak_services/network.dart';

class SwapScreen extends StatefulWidget {
  const SwapScreen({super.key});

  @override
  State<SwapScreen> createState() => _SwapScreenState();
}

class _SwapScreenState extends State<SwapScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  double _value = 5.0;

  double _currentSliderValue = 20;
  void confirmed() {
    WalletSwap().swap(
        fromToken: Constants.tokenAddressList["MATIC"].toString(),
        toToken: Constants.tokenAddressList["SAND"].toString(),
        fromAmount: ((double.parse(_token1Controller.text) * math.pow(10, 18))
            .toInt()
            .toString()));
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  GlobalKey<FormState> _token1Key = GlobalKey<FormState>();
  GlobalKey<FormState> _token2Key = GlobalKey<FormState>();
  TextEditingController _token1Controller = TextEditingController();
  TextEditingController _token2Controller = TextEditingController();
  String selectedValue1 = "MATIC";
  String selectedValue2 = "SAND";
  var quote;
  String exchangePrice = '';
  String slippage = '0';
  var network = Network.polygonMatic;
  @override
  @override
  Widget build(BuildContext context) {
    var s = MediaQuery.of(context).size;
    var height = s.height;
    var width = s.width;

    return Scaffold(
      backgroundColor: const Color.fromRGBO(17, 16, 19, 1),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 30.0, right: 30.0, top: 30.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  'Swap',
                  style: Constants.h3poppinsStyle,
                ),
                SizedBox(
                  height: height * 0.01,
                ),
                Text(
                  'Ethereum Main Network',
                  style: Constants.h5poppinsStyle,
                ),
                SizedBox(
                  height: height * 0.04,
                ),
                Stack(alignment: Alignment.center, children: [
                  Column(
                    children: [
                      Container(
                        width: width,
                        height: height * 0.15,
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          border: Border.all(
                              width: 1,
                              color: const Color.fromRGBO(36, 41, 47, 1)),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(18)),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.currency_bitcoin,
                                          color: Colors.white,
                                        ),
                                        SizedBox(
                                          width: width * 0.05,
                                        ),
                                        DropdownButton(
                                            dropdownColor: const Color.fromRGBO(
                                                17, 16, 19, 1),
                                            menuMaxHeight:
                                                MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    5,
                                            underline: SizedBox(),
                                            items: Constants.tokens,
                                            value: selectedValue1,
                                            onChanged: (String? value) {
                                              setState(() {
                                                selectedValue1 = value!;
                                              });
                                              log(value.toString());
                                            }),
                                      ],
                                    ),
                                    SizedBox(
                                      height: height * 0.02,
                                    ),
                                    Text(
                                      'Balance : 0',
                                      style: Constants.h6poppinsStyle,
                                    )
                                  ],
                                ),
                                SizedBox(
                                  width: 70,
                                ),
                                Expanded(
                                  child: Form(
                                      child: TextFormField(
                                    style: Constants.h4poppinsStyle,
                                    onChanged: (value) async {
                                      var trimmedValue = value.trim();
                                      if (trimmedValue.isNotEmpty &&
                                          !trimmedValue.endsWith('.') &&
                                          !trimmedValue.contains(',') &&
                                          !trimmedValue.contains('-') &&
                                          trimmedValue != '0') {
                                        try {
                                          quote = await Swap.getQuote(
                                              "li.quest",
                                              network.chainId.toString(),
                                              Constants
                                                  .tokenAddressList["MATIC"]
                                                  .toString(),
                                              network.chainId.toString(),
                                              Constants.tokenAddressList["SAND"]
                                                  .toString(),
                                              (double.parse(_token1Controller
                                                          .text) *
                                                      math.pow(10, 18))
                                                  .toInt()
                                                  .toString(),
                                              Constants.address);
                                        } catch (e) {
                                          log(e.toString());
                                          // TODO
                                        }
                                        var toAmount =
                                            await quote?.estimate?.toAmount;
                                        toAmount = double.parse(toAmount) /
                                            math.pow(10, 18);
                                        // log(toAmount.toString());
                                        // exchangePrice = await WalletSwap()
                                        //     .qoute0x(
                                        //         buytoken: Constants
                                        //             .tokenAddressList[
                                        //                 selectedValue2]
                                        //             .toString(),
                                        //         selltoken: Constants
                                        //             .tokenAddressList[
                                        //                 selectedValue1]
                                        //             .toString(),
                                        //         amount: double.parse(
                                        //             _token1Controller.text));
                                        _token2Controller.text =
                                            toAmount.toString();
                                        setState(() {});
                                      } else if (trimmedValue.isEmpty) {
                                        _token2Controller.text = '';
                                        setState(() {});
                                      } else if (trimmedValue == '0') {
                                        _token2Controller.text = '0';
                                        setState(() {});
                                      }
                                    },
                                    key: _token1Key,
                                    controller: _token1Controller,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                        label: Text(
                                      "Value",
                                      style: Constants.h5poppinsStyle,
                                    )),
                                  )),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: height * 0.01,
                      ),
                      Container(
                        width: width,
                        height: height * 0.15,
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(36, 41, 47, 1),
                          border: Border.all(
                              width: 1,
                              color: const Color.fromRGBO(36, 41, 47, 1)),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(18)),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.currency_bitcoin,
                                          color: Colors.white,
                                        ),
                                        SizedBox(
                                          width: width * 0.05,
                                        ),
                                        DropdownButton(
                                            dropdownColor: const Color.fromRGBO(
                                                36, 41, 47, 1),
                                            underline: SizedBox(),
                                            items: Constants.tokens,
                                            value: selectedValue2,
                                            onChanged: (String? value) {
                                              setState(() {
                                                selectedValue2 = value!;
                                              });
                                              log(value.toString());
                                            }),
                                      ],
                                    ),
                                    SizedBox(
                                      height: height * 0.02,
                                    ),
                                    Text(
                                      'Balance : 0',
                                      style: Constants.h6poppinsStyle,
                                    )
                                  ],
                                ),
                                SizedBox(
                                  width: 70,
                                ),
                                Expanded(
                                  child: Form(
                                      child: TextFormField(
                                    style: Constants.h4poppinsStyle,
                                    onChanged: (value) async {
                                      () async {
                                        exchangePrice = await WalletSwap()
                                            .qoute0x(
                                                buytoken: Constants
                                                    .tokenAddressList[
                                                        selectedValue1]
                                                    .toString(),
                                                selltoken: Constants
                                                    .tokenAddressList[
                                                        selectedValue2]
                                                    .toString(),
                                                amount: double.parse(
                                                    _token2Controller.text));
                                        _token1Controller.text = exchangePrice;
                                        setState(() {});
                                      };
                                    },
                                    key: _token2Key,
                                    controller: _token2Controller,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                        label: Text(
                                      "Value",
                                      style: Constants.h5poppinsStyle,
                                    )),
                                  )),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Transform.rotate(
                    angle: 90 * math.pi / 180,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          var t = selectedValue1;
                          selectedValue1 = selectedValue2;
                          selectedValue2 = t;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(20),
                        backgroundColor: const Color.fromRGBO(
                            43, 147, 181, 1), // <-- Button color
                        // <-- Splash color
                      ),
                      child: const Icon(
                        Icons.compare_arrows,
                        color: Colors.black,
                        weight: 100.0,
                      ),
                    ),
                  ),
                ]),
                SizedBox(
                  height: height * 0.09,
                ),
                Container(
                  height: height * 0.05,
                  width: width,
                  child: TabBar(
                    labelPadding: EdgeInsets.zero,
                    indicatorPadding: EdgeInsets.zero,
                    padding: EdgeInsets.zero,
                    labelColor: Colors.white,
                    dividerColor: Colors.transparent,
                    indicatorColor: Color.fromRGBO(55, 203, 250, 1),
                    // indicatorWeight: 0.000001,
                    controller: _tabController,
                    tabs: [
                      Tab(text: 'SLIPPAGE'),
                      Tab(text: 'DETAILS'),
                    ],
                  ),
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                Container(
                  height: height * 0.2,
                  width: width,
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      Container(
                        height: height * 0.2,
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(21, 21, 24, 1),
                          border: Border.all(
                              width: 1,
                              color: const Color.fromRGBO(36, 41, 47, 1)),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(18)),
                        ),
                        child: SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            trackShape: GradientRectSliderTrackShape(),
                          ),
                          child: Slider(
                            activeColor: Color(0xFF161543),
                            value: _value,
                            min: 0,
                            max: 5,
                            onChanged: (double value) {
                              setState(() {
                                _value = value;
                              });
                            },
                            divisions: 100,
                            label: _value.toStringAsPrecision(2),
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(20.0),
                        height: height * 0.2,
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(21, 21, 24, 1),
                          border: Border.all(
                              width: 1,
                              color: const Color.fromRGBO(36, 41, 47, 1)),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(18)),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Rate',
                                  style: Constants.h6poppinsStyle,
                                ),
                                Text(
                                  '1 AVAX = 1.16 OKB',
                                  style: Constants.h6poppinsStyle,
                                )
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Slippage Tolerance',
                                  style: Constants.h6poppinsStyle,
                                ),
                                Text(
                                  '1.29%',
                                  style: Constants.h6poppinsStyle,
                                )
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Estimated Fees',
                                  style: Constants.h6poppinsStyle,
                                ),
                                Text(
                                  '0.076 ETH',
                                  style: Constants.h6poppinsStyle,
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: height * 0.08,
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 0.5),
                      borderRadius: BorderRadius.all(Radius.circular(69))),
                  child: ConfirmationSlider(
                    height: height * 0.07,
                    backgroundColorEnd: Colors.white,
                    backgroundColor: const Color.fromRGBO(17, 16, 19, 1),
                    foregroundColor: const Color.fromRGBO(40, 128, 158, 1), // ,
                    onConfirmation: () => confirmed(),
                    text: "Slide to pay",
                    textStyle: Constants.h5poppinsStyle,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // DropdownButton(
                    //     underline: SizedBox(),
                    //     hint: Text(
                    //         "Max Slippage = ${double.parse(slippage) * 100}%"),
                    //     items: Constants.slippage,
                    //     onChanged: (String? value) {
                    //       setState(() {
                    //         slippage = value!;
                    //       });
                    //       log(value.toString());
                    //     }),

                    //Actual Swap is done here by taking Symbols of both cryptocurrencies and using 0x Aggregator API

                    // ElevatedButton(
                    //     onPressed: () {
                    //       WalletSwap().swap(
                    //           token1: Constants.tokenAddressList[selectedValue1]
                    //               .toString(),
                    //           token2: Constants.tokenAddressList[selectedValue2]
                    //               .toString(),
                    //           amount: (double.parse(_token1Controller.text)));
                    //     },
                    //     child: Text("Swap")),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class GradientRectSliderTrackShape extends SliderTrackShape
    with BaseSliderTrackShape {
  /// Create a slider track that draws two rectangles with rounded outer edges.
  const GradientRectSliderTrackShape();

  @override
  void paint(
    PaintingContext context,
    Offset offset, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required TextDirection textDirection,
    required Offset thumbCenter,
    Offset? secondaryOffset,
    bool isDiscrete = false,
    bool isEnabled = false,
    double additionalActiveTrackHeight = 2,
  }) {
    assert(context != null);
    assert(offset != null);
    assert(parentBox != null);
    assert(sliderTheme != null);
    assert(sliderTheme.disabledActiveTrackColor != null);
    assert(sliderTheme.disabledInactiveTrackColor != null);
    assert(sliderTheme.activeTrackColor != null);
    assert(sliderTheme.inactiveTrackColor != null);
    assert(sliderTheme.thumbShape != null);
    assert(enableAnimation != null);
    assert(textDirection != null);
    assert(thumbCenter != null);
    // If the slider [SliderThemeData.trackHeight] is less than or equal to 0,
    // then it makes no difference whether the track is painted or not,
    // therefore the painting can be a no-op.
    if (sliderTheme.trackHeight == null || sliderTheme.trackHeight! <= 0) {
      return;
    }

    final Rect trackRect = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
      isEnabled: isEnabled,
      isDiscrete: isDiscrete,
    );
    LinearGradient gradient = LinearGradient(colors: <Color>[
      Color(0xFF37CBFA),
      Color(0xFF105D76),
      Color(0xFF102364),
      Color(0xFF161543)
    ]);

    // Assign the track segment paints, which are leading: active and
    // trailing: inactive.
    final ColorTween activeTrackColorTween = ColorTween(
        begin: sliderTheme.disabledActiveTrackColor,
        end: sliderTheme.activeTrackColor);
    final ColorTween inactiveTrackColorTween = ColorTween(
        begin: sliderTheme.disabledInactiveTrackColor,
        end: sliderTheme.inactiveTrackColor);
    final Paint activePaint = Paint()
      ..shader = gradient.createShader(trackRect)
      ..color = activeTrackColorTween.evaluate(enableAnimation)!;
    final Paint inactivePaint = Paint()
      ..color = inactiveTrackColorTween.evaluate(enableAnimation)!;
    final Paint leftTrackPaint;
    final Paint rightTrackPaint;
    switch (textDirection) {
      case TextDirection.ltr:
        leftTrackPaint = activePaint;
        rightTrackPaint = inactivePaint;
        break;
      case TextDirection.rtl:
        leftTrackPaint = inactivePaint;
        rightTrackPaint = activePaint;
        break;
    }

    final Radius trackRadius = Radius.circular(trackRect.height / 2);
    final Radius activeTrackRadius =
        Radius.circular((trackRect.height + additionalActiveTrackHeight) / 2);

    context.canvas.drawRRect(
      RRect.fromLTRBAndCorners(
        trackRect.left,
        (textDirection == TextDirection.ltr)
            ? trackRect.top - (additionalActiveTrackHeight / 2)
            : trackRect.top,
        thumbCenter.dx,
        (textDirection == TextDirection.ltr)
            ? trackRect.bottom + (additionalActiveTrackHeight / 2)
            : trackRect.bottom,
        topLeft: (textDirection == TextDirection.ltr)
            ? activeTrackRadius
            : trackRadius,
        bottomLeft: (textDirection == TextDirection.ltr)
            ? activeTrackRadius
            : trackRadius,
      ),
      leftTrackPaint,
    );
    context.canvas.drawRRect(
      RRect.fromLTRBAndCorners(
        thumbCenter.dx,
        (textDirection == TextDirection.rtl)
            ? trackRect.top - (additionalActiveTrackHeight / 2)
            : trackRect.top,
        trackRect.right,
        (textDirection == TextDirection.rtl)
            ? trackRect.bottom + (additionalActiveTrackHeight / 2)
            : trackRect.bottom,
        topRight: (textDirection == TextDirection.rtl)
            ? activeTrackRadius
            : trackRadius,
        bottomRight: (textDirection == TextDirection.rtl)
            ? activeTrackRadius
            : trackRadius,
      ),
      rightTrackPaint,
    );

    final bool showSecondaryTrack = (secondaryOffset != null) &&
        ((textDirection == TextDirection.ltr)
            ? (secondaryOffset.dx > thumbCenter.dx)
            : (secondaryOffset.dx < thumbCenter.dx));

    if (showSecondaryTrack) {
      final ColorTween secondaryTrackColorTween = ColorTween(
          begin: sliderTheme.disabledSecondaryActiveTrackColor,
          end: sliderTheme.secondaryActiveTrackColor);
      final Paint secondaryTrackPaint = Paint()
        ..color = secondaryTrackColorTween.evaluate(enableAnimation)!;
      if (textDirection == TextDirection.ltr) {
        context.canvas.drawRRect(
          RRect.fromLTRBAndCorners(
            thumbCenter.dx,
            trackRect.top,
            secondaryOffset.dx,
            trackRect.bottom,
            topRight: trackRadius,
            bottomRight: trackRadius,
          ),
          secondaryTrackPaint,
        );
      } else {
        context.canvas.drawRRect(
          RRect.fromLTRBAndCorners(
            secondaryOffset.dx,
            trackRect.top,
            thumbCenter.dx,
            trackRect.bottom,
            topLeft: trackRadius,
            bottomLeft: trackRadius,
          ),
          secondaryTrackPaint,
        );
      }
    }
  }
}
