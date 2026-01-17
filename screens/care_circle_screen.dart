// import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';

// class CareCircleScreen extends StatefulWidget {
//   const CareCircleScreen({Key? key}) : super(key: key);

//   @override
//   State<CareCircleScreen> createState() => _CareCircleScreenState();
// }

// class _CareCircleScreenState extends State<CareCircleScreen> {
//   final _nameController = TextEditingController();
//   final _phoneController = TextEditingController();
//   final _relationController = TextEditingController();

//   bool isSaved = false;

//   Future<void> _sendEmergencySMS() async {
//     const phoneNumber = "112"; // You can change to saved number later
//     const message =
//         "🚨 Emergency! I need immediate help. Please contact me as soon as possible.";

//     final Uri smsUri = Uri(
//       scheme: 'sms',
//       path: phoneNumber,
//       queryParameters: {'body': message},
//     );

//     if (await canLaunchUrl(smsUri)) {
//       await launchUrl(smsUri);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Care Circle", style: TextStyle(color: Colors.white)),
//         centerTitle: false,
//         backgroundColor: const Color.fromARGB(255, 167, 108, 243),
//       ),
//       backgroundColor: const Color(0xFFF7F4FB),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(18),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             /// 🧡 Heading
//             const Text(
//               "Trusted Woman Contact",
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 6),
//             const Text(
//               "Add a woman you trust. She will be contacted in emergencies.",
//               style: TextStyle(color: Colors.grey),
//             ),

//             const SizedBox(height: 20),

//             /// 👩 Name
//             TextField(
//               controller: _nameController,
//               decoration: const InputDecoration(
//                 labelText: "Her Name",
//                 prefixIcon: Icon(Icons.person),
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 14),

//             /// 📞 Phone
//             TextField(
//               controller: _phoneController,
//               keyboardType: TextInputType.phone,
//               decoration: const InputDecoration(
//                 labelText: "Phone Number",
//                 prefixIcon: Icon(Icons.phone),
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 14),

//             /// 💞 Relationship
//             TextField(
//               controller: _relationController,
//               decoration: const InputDecoration(
//                 labelText: "Relationship with her",
//                 hintText: "Mother / Sister / Friend",
//                 prefixIcon: Icon(Icons.favorite),
//                 border: OutlineInputBorder(),
//               ),
//             ),

//             const SizedBox(height: 20),

//             /// 💾 Save Button
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton.icon(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color.fromARGB(255, 167, 108, 243),
//                   padding: const EdgeInsets.all(14),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(14),
//                   ),
//                 ),
//                 icon: const Icon(Icons.save, color: Colors.white),
//                 label: const Text(
//                   "Save Information",
//                   style: TextStyle(color: Colors.white),
//                 ),
//                 onPressed: () {
//                   if (_nameController.text.isNotEmpty &&
//                       _phoneController.text.isNotEmpty &&
//                       _relationController.text.isNotEmpty) {
//                     setState(() {
//                       isSaved = true;
//                     });
//                   }
//                 },
//               ),
//             ),

//             const SizedBox(height: 25),

//             /// 📋 Show Saved Info
//             if (isSaved)
//               Container(
//                 width: double.infinity,
//                 padding: const EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(16),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.grey.withOpacity(0.15),
//                       blurRadius: 8,
//                     ),
//                   ],
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text(
//                       "Saved Care Circle",
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 10),
//                     Text("👩 Name: ${_nameController.text}"),
//                     Text("📞 Phone: ${_phoneController.text}"),
//                     Text("💞 Relation: ${_relationController.text}"),
//                   ],
//                 ),
//               ),

//             const SizedBox(height: 30),

//             /// 🚨 Emergency SMS Button
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton.icon(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color.fromARGB(255, 253, 79, 66),
//                   padding: const EdgeInsets.all(16),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(16),
//                   ),
//                 ),
//                 icon: const Icon(Icons.sms, color: Colors.white),
//                 label: const Text(
//                   "Emergency SMS",
//                   style: TextStyle(fontSize: 16, color: Colors.white),
//                 ),
//                 onPressed: _sendEmergencySMS,
//               ),
//             ),

//             const SizedBox(height: 10),

//             const Text(
//               "⚠ This will open SMS app and send emergency message.",
//               style: TextStyle(color: Colors.grey, fontSize: 12),
//               textAlign: TextAlign.center,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/auth_services.dart';

class CareCircleScreen extends StatefulWidget {
  const CareCircleScreen({Key? key}) : super(key: key);

  @override
  State<CareCircleScreen> createState() => _CareCircleScreenState();
}

class _CareCircleScreenState extends State<CareCircleScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _relationController = TextEditingController();

  bool isSaved = false;

  /// 🚨 UPDATED: Use saved phone number
  Future<void> _sendEmergencySMS() async {
    if (!isSaved || _phoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please save Care Circle details first")),
      );
      return;
    }

    final phoneNumber = _phoneController.text;
    const message =
        "🚨 Emergency! I need immediate help. Please contact me as soon as possible.";

    final Uri smsUri = Uri(
      scheme: 'sms',
      path: phoneNumber,
      queryParameters: {'body': message},
    );

    if (await canLaunchUrl(smsUri)) {
      await launchUrl(smsUri);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Care Circle", style: TextStyle(color: Colors.white)),
        centerTitle: false,
        backgroundColor: const Color.fromARGB(255, 167, 108, 243),
      ),
      backgroundColor: const Color(0xFFF7F4FB),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Trusted Person Contact",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            const Text(
              "Add a person you trust. She/He will be contacted in emergencies.",
              style: TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: "Your Name",
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 14),

            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: "Contact Number",
                prefixIcon: Icon(Icons.phone),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 14),

            TextField(
              controller: _relationController,
              decoration: const InputDecoration(
                labelText: "Relationship with her",
                hintText: "Mother / Sister / Friend",
                prefixIcon: Icon(Icons.favorite),
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            /// 💾 Save Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 167, 108, 243),
                  padding: const EdgeInsets.all(14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                icon: const Icon(Icons.save, color: Colors.white),
                label: const Text(
                  "Save Information",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  if (_nameController.text.isEmpty ||
                      _phoneController.text.isEmpty ||
                      _relationController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Please fill all fields")),
                    );
                    return;
                  }

                  try {
                    await ApiService.saveCareCircle(
                      name: _nameController.text,
                      phone: _phoneController.text,
                      relation: _relationController.text,
                    );

                    setState(() {
                      isSaved = true;
                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Care Circle saved successfully 💜"),
                      ),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Failed to save Care Circle"),
                      ),
                    );
                  }
                },
              ),
            ),

            const SizedBox(height: 25),

            /// 📋 Show Saved Info
            if (isSaved)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.15),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Saved Care Circle",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text("👩 Name: ${_nameController.text}"),
                    Text("📞 Phone: ${_phoneController.text}"),
                    Text("💞 Relation: ${_relationController.text}"),
                  ],
                ),
              ),

            const SizedBox(height: 30),

            /// 🚨 Emergency SMS Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 253, 79, 66),
                  padding: const EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                icon: const Icon(Icons.sms, color: Colors.white),
                label: const Text(
                  "Emergency SMS",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
                onPressed: _sendEmergencySMS,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              "⚠ This will open SMS app and send emergency message.",
              style: TextStyle(color: Colors.grey, fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
