import 'package:athlorun/core/services/metrics_store.dart';
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

    expect(find.text('Mayur'), findsOneWidget);
    expect(find.text('4,200'), findsOneWidget);

    await tester.tap(find.text('Challenges'));
    await tester.pumpAndSettle();
    expect(find.text('Daily Challenges'), findsOneWidget);
    expect(find.text('0/4'), findsOneWidget);

    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();
    expect(find.text('Daily goals'), findsOneWidget);
    expect(find.text('10,000'), findsOneWidget);
  });
}
