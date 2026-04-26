// import 'package:flutter/material.dart';
// import 'package:health/health.dart';
//
// class FetchAllHealthDataPage extends StatefulWidget {
//   @override
//   _FetchAllHealthDataPageState createState() => _FetchAllHealthDataPageState();
// }
//
// class _FetchAllHealthDataPageState extends State<FetchAllHealthDataPage> {
//   final Health _health = Health();
//   List<HealthDataPoint> _healthData = [];
//   bool _isLoading = false;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Fetch All Health Data'),
//         backgroundColor: Colors.teal,
//       ),
//       body: _isLoading
//           ? Center(child: CircularProgressIndicator())
//           : _healthData.isEmpty
//           ? Center(
//         child: Text(
//           'No Health Data Available',
//           style: TextStyle(fontSize: 18, color: Colors.grey),
//         ),
//       )
//           : ListView(
//         children: _buildHealthDataSections(),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _fetchAllHealthData,
//         child: Icon(Icons.sync),
//         backgroundColor: Colors.teal,
//       ),
//     );
//   }
//
//   List<Widget> _buildHealthDataSections() {
//     final dataByType = _groupDataByType();
//
//     return dataByType.entries.map((entry) {
//       final type = entry.key;
//       final points = entry.value;
//
//       return ExpansionTile(
//         title: Text(type, style: TextStyle(fontWeight: FontWeight.bold)),
//         children: points.map((point) {
//           return Card(
//             margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 12.0),
//             child: ListTile(
//               title: Text('${point.value} ${point.unit.toString().split('.').last}'),
//               subtitle: Text(
//                   'Date: ${point.dateFrom}\nSource: ${point.sourceName} (${point.sourcePlatform})'),
//             ),
//           );
//         }).toList(),
//       );
//     }).toList();
//   }
//
//   Map<String, List<HealthDataPoint>> _groupDataByType() {
//     final Map<String, List<HealthDataPoint>> dataByType = {};
//
//     for (var point in _healthData) {
//       final type = point.type.toString().split('.').last;
//       if (!dataByType.containsKey(type)) {
//         dataByType[type] = [];
//       }
//       dataByType[type]?.add(point);
//     }
//
//     return dataByType;
//   }
//
//   Future<void> _fetchAllHealthData() async {
//     setState(() {
//       _isLoading = true;
//     });
//
//     try {
//       // Define all supported health data types
//       List<HealthDataType> dataTypes = [
//         // Activity and Exercise
//         HealthDataType.ACTIVE_ENERGY_BURNED,
//         HealthDataType.STEPS,
//         HealthDataType.DISTANCE_WALKING_RUNNING,
//         HealthDataType.FLIGHTS_CLIMBED,
//         HealthDataType.EXERCISE_TIME,
//         HealthDataType.WORKOUT,
//         HealthDataType.HIGH_HEART_RATE_EVENT,
//         HealthDataType.LOW_HEART_RATE_EVENT,
//         HealthDataType.IRREGULAR_HEART_RATE_EVENT,
//         // Heart and Circulatory
//         HealthDataType.HEART_RATE,
//         HealthDataType.RESTING_HEART_RATE,
//         HealthDataType.HEART_RATE_VARIABILITY_SDNN,
//
//         HealthDataType.BLOOD_PRESSURE_SYSTOLIC,
//         HealthDataType.BLOOD_PRESSURE_DIASTOLIC,
//         // Nutrition and Body Metrics
//         HealthDataType.BODY_MASS_INDEX,
//         HealthDataType.BODY_FAT_PERCENTAGE,
//
//         HealthDataType.WEIGHT,
//         HealthDataType.HEIGHT,
//         HealthDataType.WAIST_CIRCUMFERENCE,
//         HealthDataType.BASAL_ENERGY_BURNED,
//         // Blood and Oxygen
//         HealthDataType.BLOOD_GLUCOSE,
//         HealthDataType.BLOOD_OXYGEN,
//         HealthDataType.ELECTRODERMAL_ACTIVITY,
//         HealthDataType.PERIPHERAL_PERFUSION_INDEX,
//         // Temperature and Respiration
//         HealthDataType.BODY_TEMPERATURE,
//         HealthDataType.RESPIRATORY_RATE,
//         // Sleep and Mindfulness
//         HealthDataType.SLEEP_ASLEEP,
//         HealthDataType.SLEEP_DEEP,
//         HealthDataType.SLEEP_LIGHT,
//         HealthDataType.SLEEP_REM,
//         HealthDataType.SLEEP_AWAKE,
//         HealthDataType.MINDFULNESS,
//         // Specialized Data
//         HealthDataType.AUDIOGRAM,
//         HealthDataType.ELECTROCARDIOGRAM,
//         HealthDataType.comSULIN_DELIVERY,
//       ];
//
//       // Request permissions
//       bool permissionsGranted = await _health.requestAuthorization(dataTypes);
//
//       if (permissionsGranted) {
//         // Fetch data
//         final now = DateTime.now();
//         final yesterday = now.subtract(Duration(days: 1));
//
//         List<HealthDataPoint> fetchedData =
//         await _health.getHealthDataFromTypes(yesterday, now, dataTypes);
//
//         setState(() {
//           _healthData = _health.removeDuplicates(fetchedData);
//         });
//       } else {
//         _showMessage('Permissions not granted.');
//       }
//     } catch (error) {
//       _showMessage('Error fetching data: $error');
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }
//
//   void _showMessage(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text(message)),
//     );
//   }
// }
