class SettingModel {
  String? siteName;
  String? email;
  String? phone;
  String? inAppPurchaseId;
  int? isUploadImage;
  int? isUploadVideo;
  int? uploadMaxFile;
  String? facebook;
  String? youtube;
  String? twitter;
  String? linkedin;
  String? pinterest;
  String? instagram;
  String? siteUrl;
  int watchVideoRewardCoins;
  String? latestVersion;
  String? maximumVideoDurationAllowed;
  String? freeLiveTvDurationToView;
  String? latestAppDownloadLink;
  String? disclaimerUrl;
  String? privacyPolicyUrl;
  String? termsOfServiceUrl;
  String? giphyApiKey;
  String? razorPayKey;
  String? agoraApiKey;
  // String? googleMapApiKey;
  String? interstitialAdUnitIdForAndroid;
  String? interstitialAdUnitIdForiOS;
  String? rewardInterstitlAdUnitIdForAndroid;
  String? rewardInterstitialAdUnitIdForiOS;
  String? bannerAdUnitIdForAndroid;
  String? bannerAdUnitIdForiOS;
  String? fbInterstitialAdUnitIdForAndroid;
  String? fbInterstitialAdUnitIdForiOS;
  String? fbRewardInterstitialAdUnitIdForAndroid;
  String? fbRewardInterstitialAdUnitIdForiOS;
  String? networkToUse;
  String? stripePublishableKey;

  int minWithdrawLimit;
  int minCoinsWithdrawLimit;
  double coinsValue;
  double serviceFee;

  String? pid;

  bool enableImagePost;
  bool enableVideoPost;
  bool enableStories;
  bool enableHighlights;
  bool enableChat;
  bool enableLocationSharingInChat;
  bool enablePhotoSharingInChat;
  bool enableContactSharingInChat;
  bool enableVideoSharingInChat;
  bool enableAudioSharingInChat;
  bool enableFileSharingInChat;
  bool enableGifSharingInChat;
  bool enableDrawingSharingInChat;
  bool enableClubSharingInChat;
  bool enableProfileSharingInChat;
  bool enableReplyInChat;
  bool enableForwardingInChat;
  bool enableStarMessage;
  bool enableAudioCalling;
  bool enableVideoCalling;
  bool enableLive;
  bool enableClubs;
  bool enableCompetitions;
  bool enableEvents;
  bool enableStrangerChat;
  bool enableProfileVerification;
  bool enableDarkLightModeSwitch;
  bool enableWatchTv;
  bool enablePodcasts;
  bool enableGift;
  bool enablePolls;

  // nee to add
  bool enableReel;
  bool enableDating;

  SettingModel({
    required this.email,
    required this.phone,
    required this.facebook,
    required this.youtube,
    required this.twitter,
    required this.linkedin,
    required this.pinterest,
    required this.instagram,
    required this.watchVideoRewardCoins,
    required this.latestVersion,
    required this.minWithdrawLimit,
    required this.minCoinsWithdrawLimit,
    required this.coinsValue,
    this.pid,
    required this.siteName,
    required this.inAppPurchaseId,
    required this.isUploadImage,
    required this.isUploadVideo,
    required this.uploadMaxFile,
    required this.siteUrl,
    required this.maximumVideoDurationAllowed,
    required this.freeLiveTvDurationToView,
    required this.latestAppDownloadLink,
    required this.disclaimerUrl,
    required this.privacyPolicyUrl,
    required this.termsOfServiceUrl,
    required this.giphyApiKey,
    required this.agoraApiKey,
    required this.razorPayKey,
    // required this.googleMapApiKey,
    required this.interstitialAdUnitIdForAndroid,
    required this.interstitialAdUnitIdForiOS,
    required this.rewardInterstitlAdUnitIdForAndroid,
    required this.rewardInterstitialAdUnitIdForiOS,
    required this.bannerAdUnitIdForAndroid,
    required this.bannerAdUnitIdForiOS,
    required this.fbInterstitialAdUnitIdForAndroid,
    required this.fbInterstitialAdUnitIdForiOS,
    required this.fbRewardInterstitialAdUnitIdForAndroid,
    required this.fbRewardInterstitialAdUnitIdForiOS,
    required this.networkToUse,
    required this.serviceFee,
    required this.stripePublishableKey,
    required this.enableImagePost,
    required this.enableVideoPost,
    required this.enableStories,
    required this.enableHighlights,
    required this.enableChat,
    required this.enableLocationSharingInChat,
    required this.enablePhotoSharingInChat,
    required this.enableContactSharingInChat,
    required this.enableVideoSharingInChat,
    required this.enableAudioSharingInChat,
    required this.enableFileSharingInChat,
    required this.enableGifSharingInChat,
    required this.enableDrawingSharingInChat,
    required this.enableClubSharingInChat,
    required this.enableProfileSharingInChat,
    required this.enableReplyInChat,
    required this.enableForwardingInChat,
    required this.enableStarMessage,
    required this.enableAudioCalling,
    required this.enableVideoCalling,
    required this.enableLive,
    required this.enableClubs,
    required this.enableCompetitions,
    required this.enableEvents,
    required this.enableStrangerChat,
    required this.enableProfileVerification,
    required this.enableDarkLightModeSwitch,
    required this.enableWatchTv,
    required this.enablePodcasts,
    required this.enableReel,
    required this.enableGift,
    required this.enablePolls,
    required this.enableDating,

  });


  factory SettingModel.fromJson(Map<String, dynamic> json) => SettingModel(
    email: json["email"],
    phone: json["phone"],
    facebook: json["facebook"],
    youtube: json["youtube"],
    twitter: json["twitter"],
    linkedin: json["linkedin"],
    pinterest: json["pinterest"],
    instagram: json["instagram"],
    latestVersion: json["release_version"],
    watchVideoRewardCoins: json["each_view_coin"] ?? 0,
    minWithdrawLimit: json["min_widhdraw_price"] ?? 0,
    minCoinsWithdrawLimit: json["min_coin_redeem"] ?? 0,
    coinsValue: double.parse(json["per_coin_value"].toString()),
    pid: json["user_p_id"],

    siteName: json["site_name"],
    inAppPurchaseId: json["in_app_purchase_id"],
    isUploadImage: json["is_upload_image"],
    isUploadVideo: json["is_upload_video"],
    uploadMaxFile: json["upload_max_file"],
    siteUrl: json["site_url"],
    maximumVideoDurationAllowed: json["maximum_video_duration_allowed"],
    freeLiveTvDurationToView: json["free_live_tv_duration_to_view"],
    latestAppDownloadLink: json["latest_app_download_link"],
    disclaimerUrl: json["disclaimer_url"],
    privacyPolicyUrl: json["privacy_policy_url"],
    termsOfServiceUrl: json["terms_of_service_url"],
    giphyApiKey: json["giphy_api_key"],
    agoraApiKey: json["agora_api_key"],
    razorPayKey: json["razorpay_api_key"],
    // googleMapApiKey: json["google_map_api_key"],
    interstitialAdUnitIdForAndroid:
    json["interstitial_ad_unit_id_for_android"],
    interstitialAdUnitIdForiOS: json["interstitial_ad_unit_id_for_IOS"],
    rewardInterstitlAdUnitIdForAndroid:
    json["reward_Interstitl_ad_unit_id_for_android"],
    rewardInterstitialAdUnitIdForiOS:
    json["reward_interstitial_ad_unit_id_for_IOS"],
    bannerAdUnitIdForAndroid: json["banner_ad_unit_id_for_android"],
    bannerAdUnitIdForiOS: json["banner_ad_unit_id_for_IOS"],
    fbInterstitialAdUnitIdForAndroid:
    json["fb_interstitial_ad_unit_id_for_android"],
    fbInterstitialAdUnitIdForiOS:
    json["fb_interstitial_ad_unit_id_for_IOS"],
    fbRewardInterstitialAdUnitIdForAndroid:
    json["fb_reward_interstitial_ad_unit_id_for_android"],
    fbRewardInterstitialAdUnitIdForiOS:
    json["fb_reward_interstitial_ad_unit_id_for_IOS"],
    networkToUse: json["network_to_use"],
    serviceFee: json["serviceFee"] ?? 5,
    stripePublishableKey: json["stripe_publishable_key"],
    enableChat: json["is_chat"] == 1,
    enableAudioCalling: json["is_audio_calling"] == 1,
    enableAudioSharingInChat: json["is_audio_share"] == 1,
    enableClubs: json["is_clubs"] == 1,
    enableClubSharingInChat: json["is_club_share"] == 1,
    enableCompetitions: json["is_competitions"] == 1,
    enableDarkLightModeSwitch: json["is_light_mode_switching"] == 1,
    enableDrawingSharingInChat: json["is_drawing_share"] == 1,
    enableEvents: json["is_events"] == 1,
    enableStrangerChat: json["is_staranger_chat"] == 1,
    enableFileSharingInChat: json["is_files_share"] == 1,
    enableForwardingInChat: json["is_forward"] == 1,
    enableGifSharingInChat: json["is_gift_share"] == 1,
    enableHighlights: json["is_story_highlights"] == 1,
    enableImagePost: json["is_photo_post"] == 1,
    enableVideoPost: json["is_video_post"] == 1,
    enableLive: json["is_live"] == 1,
    enableLocationSharingInChat: json["is_location_sharing"] == 1,
    enablePhotoSharingInChat: json["is_photo_share"] == 1,
    enableContactSharingInChat: json["is_contact_sharing"] == 1,

    enablePodcasts: json["is_podcasts"] == 1,
    enableProfileSharingInChat: json["is_user_profile_share"] == 1,
    enableProfileVerification: json["is_profile_verification"] == 1,
    enableReplyInChat: json["is_reply"] == 1,
    enableStarMessage: json["is_star_message"] == 1,
    enableStories: json["is_stories"] == 1,
    enableVideoCalling: json["is_video_calling"] == 1,
    enableVideoSharingInChat: json["is_video_share"] == 1,
    enableWatchTv: json["is_watch_tv"] == 1,
    enableReel: json["is_reel"] == 1,
    enableGift: json["is_gift_sending"] == 1,
    enablePolls: json["is_polls"] == 1,
    enableDating: json["is_dating"] == 1,

  );

}
