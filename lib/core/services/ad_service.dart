import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdService {
  AdService._();
  static final AdService instance = AdService._();

  // Production Ad Unit ID provided by user
  static const String _prodInterstitialAdUnitId =
      'ca-app-pub-1429137343095963/4007911156';

  // Google Test Interstitial Ad Unit ID for debug/testing to avoid policy violations
  static const String _testInterstitialAdUnitIdAndroid =
      'ca-app-pub-3940256099942544/1033173712';
  static const String _testInterstitialAdUnitIdIOS =
      'ca-app-pub-3940256099942544/4411468910';

  String get interstitialAdUnitId {
    // In debug mode, optionally use Google's official test ad unit ID to prevent policy violations
    if (kDebugMode) {
      return Platform.isAndroid
          ? _testInterstitialAdUnitIdAndroid
          : _testInterstitialAdUnitIdIOS;
    }
    return _prodInterstitialAdUnitId;
  }

  InterstitialAd? _interstitialAd;
  bool _isAdLoading = false;

  Future<void> initialize() async {
    try {
      await MobileAds.instance.initialize();
      debugPrint('[AdService] Google Mobile Ads initialized successfully.');
    } catch (e) {
      debugPrint('[AdService] Failed to initialize Mobile Ads: $e');
    }
  }

  /// Loads an interstitial ad in the background.
  void loadInterstitialAd({VoidCallback? onLoaded}) {
    if (_isAdLoading || _interstitialAd != null) return;

    _isAdLoading = true;
    InterstitialAd.load(
      adUnitId: interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          debugPrint('[AdService] Interstitial ad loaded.');
          _interstitialAd = ad;
          _isAdLoading = false;
          _setAdCallbacks(ad);
          onLoaded?.call();
        },
        onAdFailedToLoad: (LoadAdError error) {
          debugPrint('[AdService] Interstitial ad failed to load: $error');
          _interstitialAd = null;
          _isAdLoading = false;
        },
      ),
    );
  }

  void _setAdCallbacks(InterstitialAd ad) {
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) {
        debugPrint('[AdService] Interstitial ad shown full screen.');
      },
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        debugPrint('[AdService] Interstitial ad dismissed.');
        ad.dispose();
        _interstitialAd = null;
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        debugPrint('[AdService] Interstitial ad failed to show: $error');
        ad.dispose();
        _interstitialAd = null;
      },
    );
  }

  /// Shows the loaded interstitial ad. If no ad is loaded, executes [onComplete] directly.
  void showInterstitialAd({VoidCallback? onComplete}) {
    if (_interstitialAd != null) {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdShowedFullScreenContent: (InterstitialAd ad) {
          debugPrint('[AdService] Interstitial ad showed full screen.');
        },
        onAdDismissedFullScreenContent: (InterstitialAd ad) {
          debugPrint('[AdService] Interstitial ad dismissed.');
          ad.dispose();
          _interstitialAd = null;
          onComplete?.call();
        },
        onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
          debugPrint('[AdService] Interstitial ad failed to show: $error');
          ad.dispose();
          _interstitialAd = null;
          onComplete?.call();
        },
      );
      _interstitialAd!.show();
    } else {
      debugPrint('[AdService] No interstitial ad ready to show.');
      onComplete?.call();
    }
  }

  void dispose() {
    _interstitialAd?.dispose();
    _interstitialAd = null;
    _isAdLoading = false;
  }
}
