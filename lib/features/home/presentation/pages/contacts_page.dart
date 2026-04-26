import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';

class ContactsPage extends StatefulWidget {
  const ContactsPage({Key? key}) : super(key: key);

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  List<Contact> contacts = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchContacts();
  }

  Future<void> fetchContacts() async {
    // Request permissions
    final status = await Permission.contacts.request();

    if (status.isGranted) {
      try {
        // Fetch contacts
        Iterable<Contact> fetchedContacts = await ContactsService.getContacts();
        setState(() {
          contacts = fetchedContacts.toList();
          isLoading = false;
        });
      } catch (e) {
        print("Error fetching contacts: $e");
        setState(() {
          isLoading = false;
        });
      }
    } else {
      print("Contacts permission denied.");
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
            const Text('Contacts permission is required to fetch contacts.'),
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
        title: const Text("Contacts"),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : contacts.isEmpty
              ? const Center(child: Text("No contacts found."))
              : ListView.builder(
                  itemCount: contacts.length,
                  itemBuilder: (context, index) {
                    final contact = contacts[index];
                    return ListTile(
                      leading:
                          (contact.avatar != null && contact.avatar!.isNotEmpty)
                              ? CircleAvatar(
                                  backgroundImage: MemoryImage(contact.avatar!))
                              : CircleAvatar(
                                  child: Text(contact.initials()),
                                ),
                      title: Text(contact.displayName ?? "No Name"),
                      subtitle: contact.phones!.isNotEmpty
                          ? Text(contact.phones!.first.value ?? "No Phone")
                          : const Text("No Phone"),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ContactDetailsPage(contact: contact),
                          ),
                        );
                      },
                    );
                  },
                ),
    );
  }
}

class ContactDetailsPage extends StatelessWidget {
  final Contact contact;

  const ContactDetailsPage({Key? key, required this.contact}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Contact Details"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 40,
              child: (contact.avatar != null && contact.avatar!.isNotEmpty)
                  ? ClipOval(child: Image.memory(contact.avatar!))
                  : Text(
                      contact.initials(),
                      style: const TextStyle(fontSize: 24),
                    ),
            ),
            const SizedBox(height: 20),
            Text(
              "Name: ${contact.displayName ?? "No Name"}",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ...contact.phones!.map(
              (phone) => Text(
                "Phone: ${phone.value}",
                style: const TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 10),
            ...contact.emails!.map(
              (email) => Text(
                "Email: ${email.value}",
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
