import 'package:flutter/material.dart';
import 'package:telephony/telephony.dart';

class SmsListScreen extends StatefulWidget {
  const SmsListScreen({Key? key}) : super(key: key);

  @override
  State<SmsListScreen> createState() => _SmsListScreenState();
}

class _SmsListScreenState extends State<SmsListScreen> {
  final Telephony telephony = Telephony.instance;
  List<SmsMessage> smsList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchSms();
    listenForIncomingSms();
  }

  /// Fetch all SMS messages from the inbox
  Future<void> fetchSms() async {
    print("Requesting SMS permissions...");
    final bool? permissionsGranted = await telephony.requestSmsPermissions;

    if (permissionsGranted ?? false) {
      try {
        final messages = await telephony.getInboxSms(
          columns: [SmsColumn.ADDRESS, SmsColumn.BODY, SmsColumn.DATE],
          sortOrder: [OrderBy(SmsColumn.DATE, sort: Sort.DESC)],
        );
        print("Fetched ${messages?.length ?? 0} SMS messages.");
        setState(() {
          smsList = messages ?? [];
          isLoading = false;
        });
      } catch (e) {
        print("Error fetching SMS: $e");
        setState(() {
          isLoading = false;
        });
      }
    } else {
      print("SMS permissions denied.");
      setState(() {
        isLoading = false;
      });
      _showPermissionDeniedDialog();
    }
  }

  /// Listen for incoming SMS
  void listenForIncomingSms() {
    telephony.listenIncomingSms(
      onNewMessage: (SmsMessage message) {
        print("New SMS received from: ${message.address}");
        setState(() {
          smsList.insert(0, message);
        });
      },
      onBackgroundMessage: backgroundSmsHandler,
    );
  }

  /// Handle SMS in background
  static Future<void> backgroundSmsHandler(SmsMessage message) async {
    print("Background SMS received from: ${message.address}");
    // Perform background operations if needed
  }

  /// Show a dialog if permissions are denied
  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Permission Denied'),
        content: const Text('SMS permissions are required to fetch messages.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All SMS Messages'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : smsList.isEmpty
              ? const Center(child: Text('No SMS found.'))
              : ListView.builder(
                  itemCount: smsList.length,
                  itemBuilder: (context, index) {
                    final sms = smsList[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SmsDetailScreen(sms: sms),
                          ),
                        );
                      },
                      child: Container(
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
                              sms.address ?? 'Unknown',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              sms.body ?? 'No content',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 14),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              DateTime.fromMillisecondsSinceEpoch(sms.date ?? 0)
                                  .toString(),
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}

/// Detailed SMS Screen
class SmsDetailScreen extends StatelessWidget {
  final SmsMessage sms;

  const SmsDetailScreen({Key? key, required this.sms}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SMS Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'From: ${sms.address ?? "Unknown"}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Date: ${DateTime.fromMillisecondsSinceEpoch(sms.date ?? 0)}',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              sms.body ?? 'No content',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
