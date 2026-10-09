import 'package:athlorun/core/services/cloud_sync.dart';
import 'package:athlorun/core/services/metrics_store.dart';
import 'package:athlorun/features/assessment/presentation/pages/assessment_page.dart';
import 'package:athlorun/features/auth/presentation/pages/sign_up_page.dart';
import 'package:athlorun/features/challenges/presentation/widgets/sleep_logger.dart';
import 'package:athlorun/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await MetricsStore.instance.load();
    await MetricsStore.instance.clearAll();
  });

  group('MetricsStore', () {
    test('accumulates steps, distance and calories for today', () {
      final store = MetricsStore.instance;
      store.addSteps(1000);
      store.addSteps(500, running: true);

      expect(store.today.steps, 1500);
      expect(store.today.walkKm, closeTo(0.762, 0.001));
      expect(store.today.runKm, closeTo(0.55, 0.001));
      expect(store.today.calories, closeTo(60, 0.5));
    });

    test('does not double count distance during a GPS session', () {
      final store = MetricsStore.instance;
      store.gpsSessionActive = true;
      store.addSteps(1000);
      store.gpsSessionActive = false;

      expect(store.today.steps, 1000);
      expect(store.today.totalKm, 0);
    });

    test('saving a workout adds distance and appears in history', () async {
      final store = MetricsStore.instance;
      await store.addActivity(TrackedActivity(
        id: '1',
        kind: ActivityKind.run,
        startedAt: DateTime.now(),
        duration: const Duration(minutes: 30),
        distanceKm: 5,
        calories: 350,
        route: const [
          [0, 0],
          [0.01, 0.01],
        ],
      ));

      expect(store.activities, hasLength(1));
      expect(store.today.runKm, 5);
      expect(store.activities.first.paceMinPerKm, 6);

      // Persisted data survives a reload.
      await store.load();
      expect(store.activities.single.distanceKm, 5);
    });

    test('resetToday keeps sleep', () {
      final store = MetricsStore.instance;
      store.addSteps(200);
      store.setSleep(7.5);
      store.resetToday();

      expect(store.today.steps, 0);
      expect(store.today.sleepHours, 7.5);
    });
  });

  test('sleep duration wraps past midnight', () {
    expect(
      sleepHoursBetween(
        const TimeOfDay(hour: 23, minute: 0),
        const TimeOfDay(hour: 7, minute: 30),
      ),
      8.5,
    );
  });

  testWidgets('home shows today and navigates between tabs', (tester) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);

    MetricsStore.instance.addSteps(4200);
    await MetricsStore.instance.updateProfile(name: 'Mayur');

    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(useMaterial3: true),
        home: const AppShell(startSensors: false),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Hi, Mayur! 👋'), findsOneWidget);
    expect(find.textContaining('4,200', findRichText: true), findsWidgets);

    await tester.tap(find.text('Challenges'));
    await tester.pumpAndSettle();
    expect(find.text('Daily Challenges'), findsOneWidget);
    expect(find.text('0/4'), findsOneWidget);

    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();
    expect(find.text('Daily goals'), findsOneWidget);
    expect(find.text('10,000'), findsOneWidget);
  });

  testWidgets('sign up shows an error when passwords do not match',
      (tester) async {
    await tester.pumpWidget(const MaterialApp(home: SignUpPage()));

    final fields = find.byType(TextField);
    await tester.enterText(fields.at(0), 'Mayur');
    await tester.enterText(fields.at(1), 'mayur@example.com');
    await tester.enterText(fields.at(2), 'secret123');
    await tester.enterText(fields.at(3), 'secret124');
    await tester.ensureVisible(find.text('Sign Up'));
    await tester.tap(find.text('Sign Up'));
    await tester.pump();

    expect(find.text('ERROR: Password do not match!'), findsOneWidget);
  });

  testWidgets('health assessment saves answers and personalises goals',
      (tester) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);

    HealthAssessment? saved;
    var finished = false;
    await tester.pumpWidget(MaterialApp(
      home: AssessmentPage(
        onSave: (a) async => saved = a,
        onFinished: () => finished = true,
      ),
    ));

    Future<void> next() async {
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();
    }

    await tester.tap(find.text('I wanna lose weight'));
    await tester.pump();
    await next(); // goal
    await tester.tap(find.text('I Am Female'));
    await tester.pump();
    await next(); // gender
    await next(); // weight
    await next(); // age
    await next(); // blood type
    await next(); // fitness level
    await next(); // sleep
    await next(); // mood
    await tester.tap(find.text('Low Carb'));
    await tester.pump();
    await tester.tap(find.text('Finish'));
    await tester.pumpAndSettle();

    expect(finished, isTrue);
    expect(saved?.goal, 'I wanna lose weight');
    expect(saved?.gender, 'I Am Female');
    expect(saved?.eatingHabit, 'Low Carb');
    // Fitness level 3 -> 10,000 steps.
    expect(MetricsStore.instance.goals.steps, 10000);
  });
}
