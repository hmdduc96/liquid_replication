// ignore_for_file: use_key_in_widget_constructors, invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member, avoid_print

import 'dart:async';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lazy_loading_list/lazy_loading_list.dart';
import 'package:liquid_replication/controller/configuration_controller.dart';
import 'package:liquid_replication/controller/markets_controller.dart';
import 'package:liquid_replication/model/coin.dart';
import 'package:liquid_replication/model/convert.dart';
import 'package:liquid_replication/styles.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MarketScreen extends StatelessWidget {
  //get controller
  final ConfigurationController appConfiguration = Get.find();

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        leading: CupertinoButton(
          padding: const EdgeInsets.all(0),
          onPressed: () {
            //change theme
            if (appConfiguration.isLightTheme.value) {
              //to dark
              appConfiguration.isLightTheme.value = false;
            } else {
              //to light
              appConfiguration.isLightTheme.value = true;
            }
          },
          child: Obx(() {
            return appConfiguration.isLightTheme.value == true
                ? Image.asset(Styles.sunIcon, height: 20)
                : Image.asset(Styles.moonIcon, height: 20);
          }),
        ),
        middle: const Text('Markets'),
        border: const Border(
            bottom: BorderSide(
                color: Colors.transparent)), //make border transparent
      ),
      child: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    //create search bar controller
    final _searchBarController = TextEditingController();
    //searching indicator
    ValueNotifier<bool> isSearching = ValueNotifier<bool>(false);

    return Column(
      children: [
        Padding(
          padding:
              const EdgeInsets.only(left: 30, right: 30, top: 10, bottom: 20),
          child: CupertinoSearchTextField(
            controller: _searchBarController,
            onSuffixTap: () {
              //clear
              _searchBarController.clear();
              //notify
              isSearching.value = false;
              isSearching.notifyListeners();
            },
            onSubmitted: (keyword) {
              if (_searchBarController.value.text.isNotEmpty) {
                isSearching.value = true;
                isSearching.notifyListeners();
              }
            },
            placeholder: 'Search',
          ),
        ),
        Expanded(
            child: Stack(
          children: [
            //normal
            CustomPageView(),
            //searching
            ValueListenableBuilder<bool>(
                valueListenable: isSearching,
                builder: (context, snapshot, child) {
                  return Visibility(
                    child: SearchingPage(
                        searchID: _searchBarController.value.text),
                    visible: isSearching.value,
                  );
                })
          ],
        ))
      ],
    );
  }
}

class SearchingPage extends StatelessWidget {
  const SearchingPage({required this.searchID});
  //search id
  final String searchID;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: CupertinoTheme.of(context).scaffoldBackgroundColor,
      child: CoinPageContent(
          pageConvertType: ConvertType.search,
          isForSearching: true,
          searchID: searchID),
    );
  }
}

class CustomPageView extends StatelessWidget {
  //create page controller that can be listen to
  final PageController pageController = PageController(initialPage: 0);
  //current page
  final ValueNotifier<int> currentPage = ValueNotifier<int>(0);
  //get getx controller
  final ConfigurationController appConfiguration = Get.find();

  @override
  Widget build(BuildContext context) {
    //build
    return Column(
      children: [
        SizedBox(
          height: 50,
          //create ListView To expand multiples tabs in future
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: appConfiguration.convertTabs.length,
              itemBuilder: (BuildContext context, index) {
                //set config at index tab (icon, convertType)
                final currentTabConfig = appConfiguration.convertTabs[index];
                return Column(
                  children: [
                    SizedBox(
                      height: 15,
                      child: CupertinoButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          pageController.jumpToPage(index); //jump to page
                          currentPage.value = index; //assign current page
                          currentPage.notifyListeners(); //notify
                        },
                        child: currentTabConfig.presenter,
                      ),
                    ),
                    ValueListenableBuilder<int>(
                        valueListenable: currentPage,
                        builder: (context, snapshot, child) {
                          if (currentPage.value == index) {
                            //show underline if tab selected
                            return SizedBox(
                              height: 15,
                              child: DelayedDisplay(
                                slidingBeginOffset: const Offset(0.0, 0.0),
                                delay: const Duration(microseconds: 500),
                                child: CupertinoButton(
                                  padding: EdgeInsets.zero,
                                  onPressed: () {},
                                  child: const Text('__'),
                                ),
                              ),
                            );
                          } else {
                            //return nothing
                            return const SizedBox();
                          }
                        }),
                  ],
                );
              }),
        ),
        Expanded(
          child: PageView(
            onPageChanged: (index) {
              currentPage.value = index; //assign current page
              currentPage.notifyListeners(); //notify
            },
            scrollDirection: Axis.horizontal,
            controller: pageController,
            children: const <Widget>[
              CoinPageContent(
                  pageConvertType: ConvertType.favorite, isForSearching: false),
              CoinPageContent(
                  pageConvertType: ConvertType.usd, isForSearching: false),
            ],
          ),
        )
      ],
    );
  }
}

class CoinPageContent extends StatefulWidget {
  const CoinPageContent(
      {required this.pageConvertType,
      required this.isForSearching,
      this.searchID});

  final ConvertType pageConvertType; //identify page for logic
  final bool isForSearching; //change page behavior and fetching data
  final String? searchID;

  @override
  _CoinPageContent createState() => _CoinPageContent();
}

class _CoinPageContent extends State<CoinPageContent>
    with AutomaticKeepAliveClientMixin {
  //Keep everything ALIVE!!!
  @override
  bool get wantKeepAlive => true;

  //get controller
  final ConfigurationController appConfiguration = Get.find();
  //create market controller - Instantiate configuration - getx
  late MarketsController controller =
      MarketsController(apiKey: appConfiguration.apiKey);

  @override
  Widget build(BuildContext context) {
    controller = MarketsController(apiKey: appConfiguration.apiKey);

    super.build(context);

    return FutureBuilder<List<CoinModel>?>(
        future: controller.getListCoinData(
            convertType: widget.pageConvertType,
            config: appConfiguration,
            isForSearching: widget.isForSearching,
            searchID: widget.searchID),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            //show data
            final coinDataList = controller.coinData.value;
            return ListView.builder(
                itemCount: coinDataList.length,
                padding: const EdgeInsets.only(
                    left: 15, right: 15, bottom: 10, top: 5),
                itemBuilder: (BuildContext context, index) {
                  final coin = coinDataList[index];
                  return LazyLoadingList(
                      initialSizeOfItems: 10,
                      hasMore: true,
                      index: index,
                      loadMore: () {},
                      child: _buildCoinRow(context, coin));
                });
          } else if (snapshot.hasData && snapshot.data == null) {
            //show no data
            return const Center(
              child: Text('Chưa có thông tin', style: TextStyle(fontSize: 20)),
            );
          }
          //show loading indicator
          return const Center(
              child: SizedBox(
                  height: 35,
                  width: 35,
                  child: LoadingIndicator(
                    indicatorType: Indicator.ballScale,
                    colors: [Styles.myLightGrey],
                  )));
        });
  }

  //Use this widget to build a coin row
  Widget _buildCoinRow(BuildContext context, CoinModel coin) {
    //current currency convert
    final Map<String, dynamic> currencyConverter =
        tabConvertCurrency[widget.pageConvertType]!;
    //set real time coin for UI to listen and rebuild
    ValueNotifier<CoinModel> realTimeCoin = ValueNotifier<CoinModel>(coin);
    //set refresh data for this coin after 60s
    Timer.periodic(const Duration(seconds: 60), (_) async {
      //fetch dat
      final result = await controller.getSingleCoinData(
          config: appConfiguration, coinID: coin.id);
      if (result != null) {
        //assign data after finishing
        print('refresh completed with ${result.id}');
        realTimeCoin.value = result;
        realTimeCoin.notifyListeners();
      }
    });

    return ValueListenableBuilder<CoinModel>(
        valueListenable: realTimeCoin,
        builder: (context, snapshot, child) {
          return Column(
            children: [
              Row(
                children: [
                  Column(
                    children: [
                      SizedBox(
                        height: 35,
                        width: 35,
                        child: SvgPicture.network(realTimeCoin.value.logo_url,
                            placeholderBuilder: (context) {
                          return const Center(
                              child: SizedBox(
                                  height: 15,
                                  width: 15,
                                  child: LoadingIndicator(
                                    indicatorType: Indicator.ballScale,
                                    colors: [Styles.myLightGrey],
                                  )));
                        }),
                      ),
                      const SizedBox(height: 10),
                      Builder(builder: (context) {
                        if (widget.pageConvertType == ConvertType.favorite) {
                          return const Icon(Icons.star_rounded,
                              size: 20, color: Styles.myYellow);
                        }
                        return const SizedBox();
                      })
                    ],
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${coin.name} / ${currencyConverter['currency']}',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 17)),
                        const SizedBox(height: 10),
                        Text('${currencyConverter['symbol']} ${coin.price}',
                            style: const TextStyle(fontSize: 15)),
                      ],
                    ),
                  ),
                  Builder(builder: (context) {
                    if (coin.day1 != null) {
                      return Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                _priceChangedButton(
                                  context: context,
                                  priceChange: coin.day1!['price_change'],
                                  pctChange: coin.day1!['price_change_pct'],
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  'Vol ${coin.day1!['volume']}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 13),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }
                    return const SizedBox();
                  })
                ],
              ),
              const SizedBox(height: 10),
              const Divider(height: 1),
              const SizedBox(height: 10),
            ],
          );
        });
  }

  Widget _priceChangedButton({
    required BuildContext context,
    required String priceChange,
    required String pctChange,
  }) {
    //create a switch to change between price & pct
    ValueNotifier<bool> isPCT = ValueNotifier<bool>(true);

    return Builder(builder: (context) {
      if (priceChange.startsWith('-')) {
        //nagative builder
        return Obx(() {
          Color boxColor = Styles.myDarkOrange;
          if (appConfiguration.isLightTheme.value) {
            //change color by theme
            boxColor = Styles.myLightOrange;
          }

          return Container(
              height: 35,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: boxColor,
              ),
              child: CupertinoButton(
                  padding: EdgeInsets.zero,
                  child: ValueListenableBuilder<bool>(
                      valueListenable: isPCT,
                      builder: (context, snap, child) {
                        //define showing price or pct
                        if (isPCT.value == true) {
                          return Text('$pctChange%',
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  color: Styles.myOrange,
                                  fontWeight: FontWeight.bold));
                        } else {
                          return Text(priceChange,
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  color: Styles.myOrange,
                                  fontWeight: FontWeight.bold));
                        }
                      }),
                  onPressed: () {
                    //change view type
                    if (isPCT.value) {
                      isPCT.value = false;
                    } else {
                      isPCT.value = true;
                    }
                  }));
        });
      } else {
        //positive builder
        return Obx(() {
          Color boxColor = Styles.myDarkGreen;
          if (appConfiguration.isLightTheme.value) {
            //change color by theme
            boxColor = Styles.myLightGreen;
          }
          return Container(
              height: 35,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), color: boxColor),
              child: CupertinoButton(
                  padding: EdgeInsets.zero,
                  child: ValueListenableBuilder<bool>(
                      valueListenable: isPCT,
                      builder: (context, snap, child) {
                        //define showing price or pct
                        if (isPCT.value == true) {
                          return Text('$pctChange%',
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  color: Styles.myGreen,
                                  fontWeight: FontWeight.bold));
                        } else {
                          return Text(priceChange,
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  color: Styles.myGreen,
                                  fontWeight: FontWeight.bold));
                        }
                      }),
                  onPressed: () {
                    //change view type
                    if (isPCT.value) {
                      isPCT.value = false;
                    } else {
                      isPCT.value = true;
                    }
                  }));
        });
      }
    });
  }
}
