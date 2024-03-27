import 'package:foap/components/place_picker/place_picker.dart';
import 'package:foap/controllers/profile_controller.dart';
import 'package:foap/helper/imports/common_import.dart';
import 'package:foap/model/post_ads_model.dart';
import 'package:foap/screens/home_feed/quick_links.dart';
import 'package:foap/screens/picked_video_editor.dart';
import 'package:foap/screens/profile/my_profile.dart';
import 'package:foap/screens/settings_menu/notifications.dart';
import 'package:foap/screens/settings_menu/settings.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_polls/flutter_polls.dart';

import '../../apiHandler/api_controller.dart';
import '../../components/post_card.dart';
import '../../controllers/add_post_controller.dart';
import '../../controllers/agora_live_controller.dart';
import '../../controllers/home_controller.dart';
import '../../model/call_model.dart';
import '../../model/post_model.dart';
import '../../segmentAndMenu/horizontal_menu.dart';
import '../../util/shared_prefs.dart';
import '../dashboard/explore.dart';
import '../post/select_media.dart';
import '../post/view_post_insight.dart';
import '../settings_menu/settings_controller.dart';
import '../story/choose_media_for_story.dart';
import '../story/story_updates_bar.dart';
import '../story/story_viewer.dart';
import 'map_screen.dart';

class HomeFeedScreen extends StatefulWidget {
  const HomeFeedScreen({Key? key}) : super(key: key);

  @override
  HomeFeedState createState() => HomeFeedState();
}

class HomeFeedState extends State<HomeFeedScreen> {
  final HomeController _homeController = Get.find();
  final AddPostController _addPostController = Get.find();
  final AgoraLiveController _agoraLiveController = Get.find();
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  bool isLocationApiCalled = false;
  final SettingsController _settingsController = Get.find();
  final ProfileController _profileController = Get.find();
  RxString latitude = "".obs;
  RxString longitude = "".obs;
  RxString name = "".obs;
  final _controller = ScrollController();

  String? selectedValue;
  int pollFrequencyIndex = 10;

  ///NATIVE ADS
  NativeAd? _nativeAd;
  bool _nativeAdIsLoaded = false;

  checkPermission() async {
    if (await Permission.location.status.isGranted) {
    } else {
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            content: AppSettingsDialog(
              openAppSettings: () async {
                debugPrint("Open App Settings pressed!");
                //openAppSettings();
                openAppSettings();
              },
              cancelDialog: () {
                // debugPrint("Cancel pressed!");
                Get.back();
                // context.read<PermissionCubit>().hideOpenAppSettingsDialog();
              },
            ),
          );
        },
      );
    }

    if (await Permission.locationWhenInUse.serviceStatus.isEnabled) {
      // Use location.
      getCurrentLoc(context);
    } else {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            content: AppSettingsDialog(
              openAppSettings: () async {
                debugPrint("Open App Settings pressed!");
                //openAppSettings();
                Geolocator.openLocationSettings();
              },
              cancelDialog: () {
                // debugPrint("Cancel pressed!");
                Get.back();
                // context.read<PermissionCubit>().hideOpenAppSettingsDialog();
              },
            ),
          );
        },
      );
    }
  }

  bool isFirstTym = true;

  @override
  void initState() {
    super.initState();

    _nativeAd = NativeAd(
      adUnitId:
          _settingsController.setting.value!.interstitialAdUnitIdForAndroid!,
      // 'ca-app-pub-3940256099942544/1044960115',
      //'ca-app-pub-3940256099942544/6300978111',
      request: AdRequest(),
      listener: NativeAdListener(
        onAdLoaded: (Ad ad) {
          print('$NativeAd loaded.');
          setState(() {
            _nativeAdIsLoaded = true;
          });
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          print('$NativeAd failedToLoad: $error');
          ad.dispose();
        },
        onAdOpened: (Ad ad) => print('$NativeAd onAdOpened.'),
        onAdClosed: (Ad ad) => print('$NativeAd onAdClosed.'),
      ),
      nativeTemplateStyle: NativeTemplateStyle(
        templateType: TemplateType.medium,
        mainBackgroundColor: Colors.white12,
        callToActionTextStyle: NativeTemplateTextStyle(
          size: 16.0,
        ),
        primaryTextStyle: NativeTemplateTextStyle(
          textColor: Colors.black38,
          backgroundColor: Colors.white70,
        ),
      ),
    );
    _nativeAd!.load();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadData(isRecent: true);

      _homeController.loadQuickLinksAccordingToSettings();
    });

    _controller.addListener(() {
      if (_controller.position.atEdge) {
        bool isTop = _controller.position.pixels == 0;
        if (isTop) {
          print("HEREEE API CALLLED");
        } else {
          loadData(isRecent: false);
          print("HEREEE API CALLLED2");
        }
      }
    });
    // loadData(isRecent: false);
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   // Create the ad objects and load ads.
  //   _nativeAd = NativeAd(
  //     adUnitId: 'ca-app-pub-3940256099942544/6300978111',
  //     request: AdRequest(),
  //     listener: NativeAdListener(
  //       onAdLoaded: (Ad ad) {
  //         print('$NativeAd loaded.');
  //         setState(() {
  //           _nativeAdIsLoaded = true;
  //         });
  //       },
  //       onAdFailedToLoad: (Ad ad, LoadAdError error) {
  //         print('$NativeAd failedToLoad: $error');
  //         ad.dispose();
  //       },
  //       onAdOpened: (Ad ad) => print('$NativeAd onAdOpened.'),
  //       onAdClosed: (Ad ad) => print('$NativeAd onAdClosed.'),
  //     ),
  //     nativeTemplateStyle: NativeTemplateStyle(
  //       templateType: TemplateType.medium,
  //       mainBackgroundColor: Colors.white12,
  //       callToActionTextStyle: NativeTemplateTextStyle(
  //         size: 16.0,
  //       ),
  //       primaryTextStyle: NativeTemplateTextStyle(
  //         textColor: Colors.black38,
  //         backgroundColor: Colors.white70,
  //       ),
  //     ),
  //   );
  //   _nativeAd!.load();
  // }

  loadMore({required bool? isRecent}) {
    loadPosts(isRecent);
  }

  refreshData() async {
    _homeController.posts.refresh();
    _homeController.clear();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadData(isRecent: true);

      // _homeController.loadQuickLinksAccordingToSettings();
    });
    // loadData(isRecent: true);
    // loadMore(isRecent: true);
    // _homeController.removePostFromList(model);
  }

  loadPosts(bool? isRecent) {
    print("IS RECENT $isRecent");
    _homeController.getPosts(
        isRecent: isRecent,
        callback: () {
          _refreshController.refreshCompleted();
        });
    if (isFirstTym) {
      isFirstTym = false;
      checkPermission();
    } else {}
  }

  void loadData({required bool? isRecent}) {
    loadPosts(isRecent);
    _homeController.getStories();
    _profileController.getMyProfile();
  }

  @override
  void didUpdateWidget(covariant HomeFeedScreen oldWidget) {
    loadData(isRecent: false);
    final initFuture = MobileAds.instance.initialize();
    // final adState = AdState(initFuture);
    // adState.initialisation.then((status) {
    setState(() {
      _nativeAd = NativeAd(
        adUnitId: 'ca-app-pub-3234665702879990/7100969049',
        request: AdRequest(),
        listener: NativeAdListener(
          onAdLoaded: (Ad ad) {
            print('$NativeAd loaded.');
            setState(() {
              _nativeAdIsLoaded = true;
            });
          },
          onAdFailedToLoad: (Ad ad, LoadAdError error) {
            print('$NativeAd failedToLoad: $error');
            ad.dispose();
          },
          onAdOpened: (Ad ad) => print('$NativeAd onAdOpened.'),
          onAdClosed: (Ad ad) => print('$NativeAd onAdClosed.'),
        ),
        nativeTemplateStyle: NativeTemplateStyle(
          templateType: TemplateType.medium,
          mainBackgroundColor: Colors.white12,
          callToActionTextStyle: NativeTemplateTextStyle(
            size: 16.0,
          ),
          primaryTextStyle: NativeTemplateTextStyle(
            textColor: Colors.black38,
            backgroundColor: Colors.white70,
          ),
        ),
      );
      _nativeAd!.load();
      // });
    });
    super.didUpdateWidget(oldWidget);
  }

  int calculateTimeDifference(DateTime earlier, DateTime later) {
    Duration difference = later.difference(earlier);

    // Convert the duration to minutes
    return difference.inMinutes;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
        backgroundColor: AppColorConstants.backgroundColor,
        bottomNavigationBar: !_homeController.isLoading.value
            ? SizedBox()
            : Container(
                height: 60,
                child: Column(
                  children: [
                    Container(

                        // width: 25,
                        child: Center(
                            child: Image.asset(
                      "assets/images/Animation - 1708686222625.gif",
                      height: 30,
                    ))),
                    Text("Loading more posts")
                  ],
                ),
              ),
        floatingActionButton: Container(
          height: 50,
          width: 50,
          color: AppColorConstants.themeColor.withOpacity(0.7),
          child: ThemeIconWidget(
            ThemeIcon.edit,
            color: AppColorConstants.whiteClr,
            size: 25,
          ),
        ).circular.ripple(() async {
          print("floatingActionButton pressed");
          // Navigator.push(context, MaterialPageRoute(builder: (context)=> VideoFilterScreen()));
          // print(DateTime.now().toString() + "CURRENT TIME");
          // String? previousTime = await SharedPrefs().getUploadTime();

          // if (previousTime == null || previousTime.trim().isEmpty) {
          //   await SharedPrefs().setUploadTime(DateTime.now().toString());
          Future.delayed(
            Duration.zero,
            () => showGeneralDialog(
                context: context,
                pageBuilder: (context, animation, secondaryAnimation) =>
                    const SelectMedia(
                      isClips: false,
                    )),
          );
          // } else {
          //   // Define the two times as strings
          //   String earlierTimeString = previousTime;

          //   // Parse the strings into DateTime objects
          //   DateTime earlierTime = DateTime.parse(earlierTimeString);
          //   DateTime laterTime = DateTime.now();

          //   // Calculate the difference
          //   int differenceInMinutes =
          //       calculateTimeDifference(earlierTime, laterTime);
          //   print("${differenceInMinutes} DIFFERENCE TIME");
          //   if (differenceInMinutes > 60) {
          //     await SharedPrefs().setUploadTime(DateTime.now().toString());
          //     Future.delayed(
          //       Duration.zero,
          //       () => showGeneralDialog(
          //           context: context,
          //           pageBuilder: (context, animation, secondaryAnimation) =>
          //               const SelectMedia(
          //                 isClips: false,
          //               )),
          //     );
          //   } else {
          //     Get.snackbar("Alert",
          //         "Please try to upload media after ${60 - differenceInMinutes} minutes.",
          //         snackPosition: SnackPosition.BOTTOM,
          //         colorText: AppColorConstants.whiteClr,
          //         backgroundColor: AppColorConstants.themeColor.darken(),
          //         icon: Icon(Icons.error, color: AppColorConstants.iconColor));
          //   }
          // }
        }),
        // appBar: AppBar(
        //   backgroundColor: AppColorConstants.backgroundColor,
        //   leading: Container(
        //       // height: 60,
        //       // width: 60,
        //       child: Image.asset('assets/applogo.png')),
        //   title: Padding(
        //     padding: const EdgeInsets.only(right: 10.0),
        //     child: Heading4Text(
        //       AppConfigConstants.appName,
        //       weight: TextWeight.bold,
        //       color: AppColorConstants.themeColor,
        //     ),
        //   ),
        //     actions: [
        //        ThemeIconWidget(
        //         ThemeIcon.search,
        //         color: AppColorConstants.themeColor,
        //         size: 25,
        //       ).ripple(() {
        //         Get.to(() => const Explore());
        //       }),
        //
        //       Padding(
        //         padding: const EdgeInsets.only(left: 8.0, right: 8),
        //         child:  ThemeIconWidget(
        //           ThemeIcon.notification,
        //           color: AppColorConstants.themeColor,
        //           size: 25,
        //         ).ripple(() {
        //      //   Get.to(() => const Explore());
        //         }),
        //       ),
        //        ThemeIconWidget(
        //         ThemeIcon.name,
        //         color: AppColorConstants.themeColor,
        //         size: 25,
        //       ).ripple(() {
        //         Get.to(() =>  const MyProfile(
        //               showBack: true,
        //         ),);
        //       }),
        //       const SizedBox(width: 8,),
        //       Obx(() => Container(
        //         color: AppColorConstants.backgroundColor,
        //         height: 25,
        //         width: 25,
        //         child: ThemeIconWidget(
        //           _homeController.openQuickLinks.value == true
        //               ? ThemeIcon.close
        //               : ThemeIcon.menuIcon,
        //           color: AppColorConstants.themeColor,
        //           size: 25,
        //         ),
        //       ).ripple(() {
        //         // Get.to(() => const Settings());
        //
        //         _homeController.quickLinkSwitchToggle();
        //       })),
        //       const SizedBox(width: 7,)
        //     ],
        // ),
        body: SafeArea(
          top: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (_settingsController.appearanceChanged!.value) Container(),
              Container(
                decoration: BoxDecoration(
                  color: AppColorConstants.backgroundColor,
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: Colors.black54,
                        blurRadius: 15.0,
                        offset: Offset(0.0, 0.75))
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(
                      'assets/applogo.jpeg',
                      height: 80,
                      width: 150,
                    ),
                    Row(
                      children: [
                        ThemeIconWidget(
                          ThemeIcon.search,
                          color: AppColorConstants.themeColor,
                          size: 25,
                        ).ripple(() {
                          // Get.to(() =>  MainScreen());

                          Get.to(() => const Explore());
                        }),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 8),
                          child: Stack(
                            children: <Widget>[
                              ThemeIconWidget(
                                ThemeIcon.notification,
                                color: AppColorConstants.themeColor,
                                size: 25,
                              ).ripple(() {
                                Get.to(() => const NotificationsScreen());
                              }),
                              Visibility(
                                visible: _profileController
                                        .user.value!.notifications
                                        .toString() !=
                                    "0",
                                child: Positioned(
                                  right: 0,
                                  child: Container(
                                    padding: EdgeInsets.all(1),
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    constraints: BoxConstraints(
                                      minWidth: 12,
                                      minHeight: 12,
                                    ),
                                    child: Text(
                                      _profileController
                                          .user.value!.notifications
                                          .toString(),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 8,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        // Padding(
                        //   padding: const EdgeInsets.only(left: 8.0, right: 8),
                        //   child: ThemeIconWidget(
                        //     ThemeIcon.notification,
                        //     color: AppColorConstants.themeColor,
                        //     size: 25,
                        //   ).ripple(() {
                        //     Get.to(() => const NotificationsScreen());
                        //     //   Get.to(() => const Explore());
                        //   }),
                        // ),
                        ThemeIconWidget(
                          ThemeIcon.name,
                          color: AppColorConstants.themeColor,
                          size: 25,
                        ).ripple(() {
                          Get.to(
                            () => const MyProfile(
                              showBack: true,
                            ),
                          );
                        }),
                        const SizedBox(
                          width: 8,
                        ),
                        Obx(() => Container(
                              color: AppColorConstants.backgroundColor,
                              height: 25,
                              width: 25,
                              child: ThemeIconWidget(
                                _homeController.openQuickLinks.value == true
                                    ? ThemeIcon.close
                                    : ThemeIcon.menuIcon,
                                color: AppColorConstants.themeColor,
                                size: 25,
                              ),
                            ).ripple(() {
                              // Get.to(() => const Settings());

                              _homeController.quickLinkSwitchToggle();
                            })),
                        const SizedBox(
                          width: 7,
                        )
                      ],
                    )
                  ],
                ),
              ),
              menuView(),

              // Row(
              //   // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //
              //
              //     const Spacer(),
              //     // const ThemeIconWidget(
              //     //   ThemeIcon.map,
              //     //   // color: ColorConstants.themeColor,
              //     //   size: 25,
              //     // ).ripple(() {
              //     //   Get.to(() => MapsUsersScreen());
              //     // }),
              //     // const SizedBox(
              //     //   width: 20,
              //     // ),
              //     const ThemeIconWidget(
              //       ThemeIcon.search,
              //       size: 25,
              //     ).ripple(() {
              //       Get.to(() => const Explore());
              //     }),
              //
              //     const ThemeIconWidget(
              //       ThemeIcon.notification,
              //       size: 25,
              //     ).ripple(() {
              //       Get.to(() => const Explore());
              //     }),
              //     const ThemeIconWidget(
              //       ThemeIcon.name,
              //       size: 25,
              //     ).ripple(() {
              //       Get.to(() => const Explore());
              //     }),
              //     const SizedBox(
              //       width: 20,
              //     ),
              //     Obx(() => Container(
              //           color: AppColorConstants.backgroundColor,
              //           height: 25,
              //           width: 25,
              //           child: ThemeIconWidget(
              //             _homeController.openQuickLinks.value == true
              //                 ? ThemeIcon.close
              //                 : ThemeIcon.menuIcon,
              //             // color: ColorConstants.themeColor,
              //             size: 25,
              //           ),
              //         ).ripple(() {
              //           _homeController.quickLinkSwitchToggle();
              //         })),
              //   ],
              // ).hp(20),
              // const SizedBox(
              //   height: 10,
              // ),
              Expanded(
                child: postsView(),
              ),
            ],
          ),
        )));
  }

  @override
  void dispose() {
    super.dispose();
    // _ad!.dispose();
    _nativeAd?.dispose();
    _homeController.clear();
    _homeController.closeQuickLinks();
  }

  Widget menuView() {
    return Obx(() => AnimatedContainer(
          height: _homeController.openQuickLinks.value == true ? 100 : 0,
          width: Get.width,
          color: AppColorConstants.themeColor,
          duration: const Duration(milliseconds: 500),
          child: QuickLinkWidget(callback: () {
            _homeController.closeQuickLinks();
          }),
        ));
  }

  Widget postingView() {
    return Obx(() => _addPostController.isPosting.value
        ? Container(
            height: 55,
            color: AppColorConstants.cardColor,
            child: Row(
              children: [
                Image.memory(
                  _addPostController.postingMedia.first.thumbnail!,
                  fit: BoxFit.cover,
                  width: 40,
                  height: 40,
                ).round(5),
                const SizedBox(
                  width: 10,
                ),
                Heading5Text(
                  _addPostController.isErrorInPosting.value
                      ? LocalizationString.postFailed
                      : LocalizationString.posting,
                ),
                const Spacer(),
                _addPostController.isErrorInPosting.value
                    ? Row(
                        children: [
                          Heading5Text(
                            LocalizationString.discard,
                            weight: TextWeight.medium,
                          ).ripple(() {
                            _addPostController.discardFailedPost();
                          }),
                          const SizedBox(
                            width: 20,
                          ),
                          Heading5Text(
                            LocalizationString.retry,
                            weight: TextWeight.medium,
                          ).ripple(() {
                            _addPostController.retryPublish(context);
                          }),
                        ],
                      )
                    : Container()
              ],
            ).hP8,
          ).backgroundCard(radius: 10).bp(20)
        : Container());
  }

  Widget storiesView() {
    return SizedBox(
      height: 110,
      child: GetBuilder<HomeController>(
          init: _homeController,
          builder: (ctx) {
            return StoryUpdatesBar(
              stories: _homeController.stories,
              liveUsers: _homeController.liveUsers,
              addStoryCallback: () {
                // Get.to(() => const TextStoryMaker());
                Get.to(() => const ChooseMediaForStory());
              },
              viewStoryCallback: (story) {
                try {
                  Get.to(() => StoryViewer(
                        story: story,
                        storyDeleted: () {
                          _homeController.getStories();
                        },
                      ));
                } catch (stacktrace) {
                  story.image.toString();
                  print(stacktrace.toString() + "STORY VIEW ERROR");
                }
              },
              joinLiveUserCallback: (user) {
                Live live = Live(
                    channelName: user.liveCallDetail!.channelName,
                    isHosting: false,
                    host: user,
                    token: user.liveCallDetail!.token,
                    liveId: user.liveCallDetail!.id);
                _agoraLiveController.joinAsAudience(
                  live: live,
                );
              },
              user: _profileController.user.value!,
            ).vP16;
          }),
    );
  }

  Future<void> getCurrentLoc(BuildContext context) async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        return Future.error('Location Not Available');
      }
    }
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    latitude.value = position.latitude.toString();
    longitude.value = position.longitude.toString();
    List<Placemark> placemark = await placemarkFromCoordinates(
        double.parse(latitude.value), double.parse(longitude.value),
        localeIdentifier: "en");
    if (isLocationApiCalled) {
    } else {
      ApiController()
          .updateUserLocation(
              latitude.value, longitude.value, placemark.first.country ?? "")
          .then((response) {
        isLocationApiCalled = true;
        //AppUtil.showToast(message: response.message, isSuccess: false);
      });
    }

    // var stateName =
    //     stateAbbreviationMapFunction(placemark[0].administrativeArea!);
  }

  postsView() {
    return Obx(() {
      return ListView.separated(
              controller: _controller,
              padding: const EdgeInsets.only(bottom: 100),
              itemCount: _homeController.posts.length + 3,
              itemBuilder: (context, index) {
                if (index == 0) {
                  try {
                    print(_homeController.stories.length.toString() +
                        "HOME STORIES LENGTH");
                    print(_homeController.stories.first.image.toString() +
                        "HOME STORIES LENGTH");
                    if (_homeController.stories.first.image == null) {
                      _homeController.isRefreshingStories.value = false;
                    }
                  } catch (stacktrace) {
                    print(stacktrace.toString());
                  }

                  return Obx(() =>
                      _homeController.isRefreshingStories.value == true
                          ? const StoryAndHighlightsShimmer()
                          : storiesView());
                }
                // else if (index == 1) {
                //   return const QuickLinkWidget();
                // }
                else if (index == 1) {
                  return postingView().hP16;
                } else if (index == 2) {
                  return Obx(() => Column(
                        children: [
                          HorizontalMenuBar(
                              padding:
                                  const EdgeInsets.only(left: 16, right: 16),
                              onSegmentChange: (segment) {
                                _homeController.categoryIndexChanged(
                                    index: segment,
                                    callback: () {
                                      _refreshController.refreshCompleted();
                                    });
                              },
                              selectedIndex:
                                  _homeController.categoryIndex.value,
                              menus: [
                                LocalizationString.all,
                                LocalizationString.following,
                                // LocalizationString.trending,
                                LocalizationString.recent,
                                LocalizationString.your,
                              ]),
                          _homeController.isRefreshingPosts.value == true
                              ? SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.9,
                                  child: const HomeScreenShimmer())
                              : _homeController.posts.isEmpty
                                  ? SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.5,
                                      child: emptyPost(
                                          title: LocalizationString.noPostFound,
                                          subTitle: LocalizationString
                                              .followFriendsToSeeUpdates),
                                    )
                                  : Container()
                        ],
                      ));
                } else {
                  // final combinedList = combineLists(_homeController.posts, _homeController.adsItem);
                  PostModel model = _homeController.posts[index - 3];
                  return PostCard(
                    model: model,
                    isScene: false,
                    isClub: false,
                    isHome: true,
                    textTapHandler: (text) {
                      _homeController.postTextTapHandler(
                          post: model, text: text);
                    },
                    viewInsightHandler: () {
                      Get.to(() => ViewPostInsights(post: model));
                    },
                    // mediaTapHandler: (post) {
                    //   // Get.to(()=> PostMediaFullScreen(post: post));
                    // },
                    removePostHandler: () {
                      _homeController.removePostFromList(model);
                    },
                    blockUserHandler: () {
                      _homeController.removeUsersAllPostFromList(model);
                    },
                    followButtonHandler: () async {
                      setState(() {});
                    },
                  );
                }
              },
              separatorBuilder: (context, index) {
                if ((index + 1) % 6 == 0 &&
                    index != _homeController.posts.length - 1) {
                  return _nativeAd != null && _nativeAdIsLoaded
                      ? Container(
                          height: 300,
                          width: MediaQuery.of(context).size.width,
                          child: AdWidget(ad: _nativeAd!))
                      : const SizedBox.shrink();
                } else {
                  return const SizedBox.shrink(); // No separator
                }
              })
          .addPullToRefresh(
              refreshController: _refreshController,
              enablePullUp: false,
              onRefresh: refreshData,
              onLoading: () {});
    });
  }
}

class AppSettingsDialog extends StatelessWidget {
  final Function openAppSettings;
  final Function cancelDialog;
  const AppSettingsDialog({
    Key? key,
    required this.openAppSettings,
    required this.cancelDialog,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 10),
        const Text("You need to open settings to grant Location Permission"),
        const SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // TextButton(
            //   onPressed: () {
            //     openAppSettings();
            //   },
            //   child: const Text("Open Settings"),
            // ),
            TextButton(
              onPressed: () {
                cancelDialog();
              },
              child: const Text(
                "Cancel",
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
