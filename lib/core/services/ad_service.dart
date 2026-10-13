import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdService {
  AdService._();
  static final AdService instance = AdService._();

  // Production Ad Unit IDs provided by user
  static const String _prodInterstitialAdUnitId =
      'ca-app-pub-1429137343095963/4007911156';
  static const String _prodRewardedAdUnitId =
      'ca-app-pub-1429137343095963/9652874099';
  static const String _prodNativeAdUnitId =
      'ca-app-pub-1429137343095963/9867751654';
  static const String _prodLeaderboardBannerAdUnitId =
      'ca-app-pub-1429137343095963/6068852305';
  static const String _prodPodcastBannerAdUnitId =
      'ca-app-pub-1429137343095963/3170481360';

  // Google Test Ad Unit IDs (used in kDebugMode to prevent AdMob invalid traffic strikes)
  static const String _testInterstitialAdUnitIdAndroid =
      'ca-app-pub-3940256099942544/1033173712';
  static const String _testInterstitialAdUnitIdIOS =
      'ca-app-pub-3940256099942544/4411468910';

  static const String _testRewardedAdUnitIdAndroid =
      'ca-app-pub-3940256099942544/5224354917';
  static const String _testRewardedAdUnitIdIOS =
      'ca-app-pub-3940256099942544/1712485313';

  static const String _testNativeAdUnitIdAndroid =
      'ca-app-pub-3940256099942544/2247696110';
  static const String _testNativeAdUnitIdIOS =
      'ca-app-pub-3940256099942544/3986624511';

  static const String _testBannerAdUnitIdAndroid =
      'ca-app-pub-3940256099942544/6300978111';
  static const String _testBannerAdUnitIdIOS =
      'ca-app-pub-3940256099942544/2934735716';

  String get interstitialAdUnitId => kDebugMode
      ? (Platform.isAndroid
          ? _testInterstitialAdUnitIdAndroid
          : _testInterstitialAdUnitIdIOS)
      : _prodInterstitialAdUnitId;

  String get rewardedAdUnitId => kDebugMode
      ? (Platform.isAndroid
          ? _testRewardedAdUnitIdAndroid
          : _testRewardedAdUnitIdIOS)
      : _prodRewardedAdUnitId;

  String get nativeAdUnitId => kDebugMode
      ? (Platform.isAndroid
          ? _testNativeAdUnitIdAndroid
          : _testNativeAdUnitIdIOS)
      : _prodNativeAdUnitId;

  String get leaderboardBannerAdUnitId => kDebugMode
      ? (Platform.isAndroid
          ? _testBannerAdUnitIdAndroid
          : _testBannerAdUnitIdIOS)
      : _prodLeaderboardBannerAdUnitId;

  String get podcastBannerAdUnitId => kDebugMode
      ? (Platform.isAndroid
          ? _testBannerAdUnitIdAndroid
          : _testBannerAdUnitIdIOS)
      : _prodPodcastBannerAdUnitId;

  // Interstitial Ad Management
  InterstitialAd? _interstitialAd;
  bool _isInterstitialLoading = false;

  // Rewarded Ad Management
  RewardedAd? _rewardedAd;
  bool _isRewardedLoading = false;

  Future<void> initialize() async {
    try {
      await MobileAds.instance.initialize();
      debugPrint('[AdService] Google Mobile Ads initialized successfully.');
    } catch (e) {
      debugPrint('[AdService] Failed to initialize Mobile Ads: $e');
    }
  }

  // --- Interstitial Ads ---

  void loadInterstitialAd({VoidCallback? onLoaded}) {
    if (_isInterstitialLoading || _interstitialAd != null) return;

    _isInterstitialLoading = true;
    InterstitialAd.load(
      adUnitId: interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          debugPrint('[AdService] Interstitial ad loaded.');
          _interstitialAd = ad;
          _isInterstitialLoading = false;
          onLoaded?.call();
        },
        onAdFailedToLoad: (LoadAdError error) {
          debugPrint('[AdService] Interstitial ad failed to load: $error');
          _interstitialAd = null;
          _isInterstitialLoading = false;
        },
      ),
    );
  }

  void showInterstitialAd({VoidCallback? onComplete}) {
    if (_interstitialAd != null) {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdShowedFullScreenContent: (ad) =>
            debugPrint('[AdService] Interstitial shown.'),
        onAdDismissedFullScreenContent: (ad) {
          debugPrint('[AdService] Interstitial dismissed.');
          ad.dispose();
          _interstitialAd = null;
          onComplete?.call();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          debugPrint('[AdService] Interstitial failed to show: $error');
          ad.dispose();
          _interstitialAd = null;
          onComplete?.call();
        },
      );
      _interstitialAd!.show();
    } else {
      onComplete?.call();
    }
  }

  // --- Rewarded Ads ---

  void loadRewardedAd({VoidCallback? onLoaded}) {
    if (_isRewardedLoading || _rewardedAd != null) return;

    _isRewardedLoading = true;
    RewardedAd.load(
      adUnitId: rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) {
          debugPrint('[AdService] Rewarded ad loaded.');
          _rewardedAd = ad;
          _isRewardedLoading = false;
          onLoaded?.call();
        },
        onAdFailedToLoad: (LoadAdError error) {
          debugPrint('[AdService] Rewarded ad failed to load: $error');
          _rewardedAd = null;
          _isRewardedLoading = false;
        },
      ),
    );
  }

  void showRewardedAd({
    required void Function(RewardItem reward) onUserEarnedReward,
    VoidCallback? onDismissed,
  }) {
    if (_rewardedAd != null) {
      _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdShowedFullScreenContent: (ad) =>
            debugPrint('[AdService] Rewarded ad shown.'),
        onAdDismissedFullScreenContent: (ad) {
          debugPrint('[AdService] Rewarded ad dismissed.');
          ad.dispose();
          _rewardedAd = null;
          loadRewardedAd(); // Pre-load next
          onDismissed?.call();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          debugPrint('[AdService] Rewarded ad failed to show: $error');
          ad.dispose();
          _rewardedAd = null;
          onDismissed?.call();
        },
      );
      _rewardedAd!.show(
        onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
          onUserEarnedReward(reward);
        },
      );
    } else {
      debugPrint('[AdService] Rewarded ad not ready. Loading now...');
      loadRewardedAd();
      onDismissed?.call();
    }
  }

  bool get isRewardedAdReady => _rewardedAd != null;

  // --- Banner & Native Helpers ---

  BannerAd createBannerAd({
    required String adUnitId,
    required VoidCallback onLoaded,
    Function(LoadAdError)? onFailed,
  }) {
    final banner = BannerAd(
      adUnitId: adUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          debugPrint('[AdService] Banner ad loaded ($adUnitId).');
          onLoaded();
        },
        onAdFailedToLoad: (ad, error) {
          debugPrint('[AdService] Banner ad failed ($adUnitId): $error');
          ad.dispose();
          onFailed?.call(error);
        },
      ),
    );
    banner.load();
    return banner;
  }

  NativeAd createNativeAd({
    required VoidCallback onLoaded,
    Function(LoadAdError)? onFailed,
  }) {
    final native = NativeAd(
      adUnitId: nativeAdUnitId,
      request: const AdRequest(),
      nativeTemplateStyle: NativeTemplateStyle(
        templateType: TemplateType.small,
        mainBackgroundColor: const Color(0xFFF7F8FA),
        cornerRadius: 16.0,
      ),
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          debugPrint('[AdService] Native ad loaded.');
          onLoaded();
        },
        onAdFailedToLoad: (ad, error) {
          debugPrint('[AdService] Native ad failed: $error');
          ad.dispose();
          onFailed?.call(error);
        },
      ),
    );
    native.load();
    return native;
  }

  void dispose() {
    _interstitialAd?.dispose();
    _interstitialAd = null;
    _isInterstitialLoading = false;
    _rewardedAd?.dispose();
    _rewardedAd = null;
    _isRewardedLoading = false;
  }
}
