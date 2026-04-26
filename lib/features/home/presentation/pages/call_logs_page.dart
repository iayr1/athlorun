import 'package:flutter/material.dart';
import 'package:call_log/call_log.dart';
import 'package:permission_handler/permission_handler.dart';

class CallLogsPage extends StatefulWidget {
  const CallLogsPage({Key? key}) : super(key: key);

  @override
  State<CallLogsPage> createState() => _CallLogsPageState();
}

class _CallLogsPageState extends State<CallLogsPage> {
  List<CallLogEntry> callLogs = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCallLogs();
  }

  Future<void> fetchCallLogs() async {
    // Request permissions
    final status = await Permission.phone.request();
    if (status.isGranted) {
      try {
        // Fetch call logs
        Iterable<CallLogEntry> entries = await CallLog.get();
        setState(() {
          callLogs = entries.toList();
          isLoading = false;
        });
      } catch (e) {
        print("Error fetching call logs: $e");
        setState(() {
          isLoading = false;
        });
      }
    } else {
      print("Call log permissions denied.");
      setState(() {
        isLoading = false;
      });
      _showPermissionDeniedDialog();
    }
  }

  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Permission Denied'),
        content:
            const Text('Call log permissions are required to fetch call logs.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  String formatCallType(CallType? callType) {
    switch (callType) {
      case CallType.incoming:
        return "Incoming";
      case CallType.outgoing:
        return "Outgoing";
      case CallType.missed:
        return "Missed";
      case CallType.rejected:
        return "Rejected";
      default:
        return "Unknown";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Call Logs"),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : callLogs.isEmpty
              ? const Center(child: Text("No call logs found."))
              : ListView.builder(
                  itemCount: callLogs.length,
                  itemBuilder: (context, index) {
                    final log = callLogs[index];
                    return Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            log.name ?? log.number ?? "Unknown",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            "Type: ${formatCallType(log.callType)}",
                            style: const TextStyle(fontSize: 14),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            "Date: ${DateTime.fromMillisecondsSinceEpoch(log.timestamp ?? 0)}",
                            style: const TextStyle(
                                fontSize: 12, color: Colors.grey),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            "Duration: ${log.duration} seconds",
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}
