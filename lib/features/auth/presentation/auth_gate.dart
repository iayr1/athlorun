import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/services/auth_service.dart';
import '../../../core/services/cloud_sync.dart';
import '../../assessment/presentation/pages/assessment_page.dart';
import 'pages/onboarding_page.dart';
import 'pages/sign_in_page.dart';
import 'pages/splash_page.dart';
import 'pages/welcome_page.dart';

enum _Stage {
  splash,
  welcome,
  onboarding,
  signIn,
  loading,
  error,
  assessment,
  app
}

/// Decides what to show: onboarding, sign-in, the health assessment or the
/// main app, based on Firebase Auth state and the user's Firestore profile.
class AuthGate extends StatefulWidget {
  final WidgetBuilder appBuilder;

  const AuthGate({super.key, required this.appBuilder});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  static const _onboardedKey = 'athlorun_onboarded';

  StreamSubscription<User?>? _sub;
  _Stage _stage = _Stage.splash;
  User? _user;
  bool _onboarded = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final prefs = await SharedPreferences.getInstance();
    _onboarded = prefs.getBool(_onboardedKey) ?? false;
    _sub = AuthService.instance.authStateChanges().listen(_onUser);
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  Future<void> _onUser(User? user) async {
    _user = user;
    if (user == null) {
      await CloudSync.instance.stop();
      _go(_onboarded ? _Stage.signIn : _Stage.welcome);
      return;
    }
    await _loadProfile();
  }

  Future<void> _loadProfile() async {
    final user = _user;
    if (user == null) return;
    _go(_Stage.loading);
    try {
      final profile = await CloudSync.instance.start(user);
      if (_user?.uid != user.uid) return;
      _go(profile.assessmentCompleted ? _Stage.app : _Stage.assessment);
    } catch (e) {
      _error = 'We couldn’t load your profile. Check your connection.\n($e)';
      _go(_Stage.error);
    }
  }

  Future<void> _finishOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardedKey, true);
    _onboarded = true;
    _go(_Stage.signIn);
  }

  void _go(_Stage stage) {
    if (!mounted) return;
    // Close any auth sub-pages (sign up, forgot password) left on top.
    Navigator.of(context).popUntil((r) => r.isFirst);
    setState(() => _stage = stage);
  }

  @override
  Widget build(BuildContext context) {
    final child = switch (_stage) {
      _Stage.splash || _Stage.loading => const SplashPage(),
      _Stage.error => SplashPage(message: _error, onRetry: _loadProfile),
      _Stage.welcome => WelcomePage(
          onGetStarted: () => _go(_Stage.onboarding),
          onSignIn: _finishOnboarding,
        ),
      _Stage.onboarding => OnboardingPage(onDone: _finishOnboarding),
      _Stage.signIn => const SignInPage(),
      _Stage.assessment => AssessmentPage(
          initial: CloudSync.instance.profile?.assessment,
          onFinished: () => _go(_Stage.app),
        ),
      _Stage.app => widget.appBuilder(context),
    };
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: KeyedSubtree(key: ValueKey(_stage), child: child),
    );
  }
}
