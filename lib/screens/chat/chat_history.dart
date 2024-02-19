import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:foap/helper/imports/chat_imports.dart';
import 'package:foap/helper/imports/common_import.dart';
import 'package:foap/screens/chat/random_chat/choose_profile_category.dart';
import 'package:foap/screens/chat/search_bar_without_margin.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../components/search_bar.dart';
import '../calling/call_history.dart';
import '../settings_menu/settings_controller.dart';

class ChatHistory extends StatefulWidget {
  const ChatHistory({Key? key}) : super(key: key);

  @override
  State<ChatHistory> createState() => _ChatHistoryState();
}

class _ChatHistoryState extends State<ChatHistory> {
  final ChatHistoryController _chatController = Get.find();
  final ChatDetailController _chatDetailController = Get.find();
  final SettingsController settingsController = Get.find();
  bool showSearchBar = false;
  BannerAd? _bannerAd;
  bool _bannerReady = false;

  @override
  void initState() {
    super.initState();
    _chatController.getChatRooms();
    _bannerAd = BannerAd(
      adUnitId:
          settingsController.setting.value!.interstitialAdUnitIdForAndroid!,
      // adUnitId: 'ca-app-pub-3940256099942544/6300978111',
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (_) {
          print('working');
          setState(() {
            _bannerReady = true;
          });
        },
        onAdFailedToLoad: (ad, err) {
          print('error $err');
          setState(() {
            _bannerReady = false;
          });
          ad.dispose();
        },
      ),
    );
    _bannerAd?.load();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _bannerAd?.dispose();
    super.dispose();
  }

  Widget bannerAd() {
    return _bannerReady
        ? SizedBox(
            width: MediaQuery.of(context).size.width,
            height: _bannerAd!.size.height.toDouble(),
            child: AdWidget(ad: _bannerAd!),
          )
        : Container();
  }

  //addon comment changes on app top bar design and add new class SearchBarWithoutMargin

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColorConstants.backgroundColor,
      body: KeyboardDismissOnTap(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            // (_settingsController.setting.value!.enableAudioCalling ||
            //         _settingsController.setting.value!.enableVideoCalling)
            //     ? titleNavigationBarWithIcon(
            //         context: context,
            //         title: LocalizationString.chats,
            //         icon: ThemeIcon.mobile,
            //         icon1: ThemeIcon.search,
            //     isLeading: true,
            //         completion: () {
            //           Get.to(() => const CallHistory());
            //         },
            //     leading: (){
            //           setState(() {
            //             showSearchBar = !showSearchBar;
            //           });
            //     })
            //     : titleNavigationBar(
            //         context: context,
            //         title: LocalizationString.chats,
            //       ),
            divider(context: context).tP8,
            // showSearchBar ?
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(width: 10),
                Container(
                  height: 30,
                  width: 30,
                  color: AppColorConstants.themeColor,
                  child: ThemeIconWidget(
                    ThemeIcon.plus,
                    color: AppColorConstants.whiteClr,
                  ),
                ).circular.ripple(() {
                  selectUsers();
                }),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(left: 10, right: 10),
                    height: 45,
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColorConstants.grayscale300,
                        ),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5))),
                    child: SearchBarWithoutMargin(
                      showSearchIcon: true,
                      hintText: LocalizationString.searchUserGroup,
                      iconColor: AppColorConstants.themeColor,
                      onSearchChanged: (value) {
                        _chatController.searchTextChanged(value);
                      },
                      onSearchStarted: () {
                        //controller.startSearch();
                      },
                      onSearchCompleted: (searchTerm) {},
                    ),
                  ),
                ),
                settingsController.setting.value!.enableAudioCalling
                    ? Container(
                        height: 30,
                        width: 30,
                        color: AppColorConstants.themeColor,
                        child: ThemeIconWidget(
                          ThemeIcon.mobile,
                          color: AppColorConstants.whiteClr,
                        ),
                      ).circular.ripple(() {
                        Get.to(() => const CallHistory());
                      })
                    : const SizedBox(),
                const SizedBox(width: 10),
              ],
            ),
            const SizedBox(height: 15),
            // : const SizedBox.shrink(),
            divider(context: context).tP8,

            // Modified code for createGroup and strangerChat sections in a single row
            Container(
              padding: const EdgeInsets.only(left: 11),
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // createGroup section
                  Container(
                    color: AppColorConstants.themeColor.withOpacity(0.2),
                    child: ThemeIconWidget(
                      ThemeIcon.group,
                      size: 15,
                      color: AppColorConstants.themeColor,
                    ).p8,
                  ).circular,
                  const SizedBox(
                    width: 1,
                  ),
                  Heading6Text(
                    LocalizationString.createGroup,
                    weight: TextWeight.semiBold,
                  ).ripple(() {
                    Get.back();
                    Get.to(() => const SelectUserForGroupChat());
                  }).hP16,

                  // Add some spacing between the sections
                  const SizedBox(
                    width: 5,
                  ),

                  // strangerChat section
                  Container(
                    color: AppColorConstants.themeColor.withOpacity(0.2),
                    child: ThemeIconWidget(
                      ThemeIcon.randomChat,
                      size: 15,
                      color: AppColorConstants.themeColor,
                    ).p8,
                  ).circular,
                  const SizedBox(
                    width: 2,
                  ),
                  Heading6Text(
                    LocalizationString.strangerChat,
                    weight: TextWeight.semiBold,
                  ).ripple(() {
                    Get.to(() => const ChooseProfileCategory(
                          isCalling: false,
                        ));
                  }).hP16,
                ],
              ),
            ),

            divider(context: context).tP8,

            // SearchBar code...

            Expanded(child: chatListView().hP16),
          ],
        ),
      ),
    );
  }

  Widget chatListView() {
    return GetBuilder<ChatHistoryController>(
        init: _chatController,
        builder: (ctx) {
          return _chatController.searchedRooms.isNotEmpty
              ? ListView.separated(
                  padding: const EdgeInsets.only(top: 10, bottom: 50),
                  itemCount: _chatController.searchedRooms.length,
                  itemBuilder: (ctx, index) {
                    return Dismissible(
                      key: UniqueKey(),
                      onDismissed: (direction) {
                        _chatController
                            .deleteRoom(_chatController.searchedRooms[index]);
                      },
                      background: Container(
                        color: AppColorConstants.red,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Heading6Text(
                              LocalizationString.delete,
                              weight: TextWeight.bold,
                              color: AppColorConstants.grayscale700,
                            )
                          ],
                        ).hP25,
                      ),
                      child: ChatHistoryTile(
                              model:
                                  //_chatController.allRooms[index]
                                  _chatController.searchedRooms[index])
                          .ripple(() {
                        ChatRoomModel model =
                            _chatController.searchedRooms[index];
                        _chatController.clearUnreadCount(chatRoom: model);

                        Get.to(() => ChatDetail(chatRoom: model))!
                            .then((value) {
                          _chatController.getChatRooms();
                        });
                      }),
                    );
                  },
                  separatorBuilder: (ctx, index) {
                    return const SizedBox(
                      height: 20,
                    );
                  })
              : _chatController.isLoading == true
                  ? Container()
                  : emptyData(
                      title: LocalizationString.noChatFound,
                      subTitle: LocalizationString.followSomeUserToChat,
                    );
        });
  }

  void selectUsers() {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      isScrollControlled: true,
      builder: (context) => FractionallySizedBox(
        heightFactor: 0.95,
        child: SelectUserForChat(
          userSelected: (user) {
            _chatDetailController.getChatRoomWithUser(
                userId: user.id,
                callback: (room) {
                  EasyLoading.dismiss();

                  Get.close(1);
                  print('this is opponent id ${user.id}');
                  Get.to(() => ChatDetail(
                            // opponent: usersList[index - 1].toChatRoomMember,
                            chatRoom: room,
                          ))!
                      .then((value) {
                    _chatController.getChatRooms();
                  });
                });
          },
        ),
      ),
    );
  }
}
