import 'package:flutter/material.dart';
import '../services/auth_services.dart';

class SakhiChatbotScreen extends StatefulWidget {
  const SakhiChatbotScreen({Key? key}) : super(key: key);

  @override
  State<SakhiChatbotScreen> createState() => _SakhiChatbotScreenState();
}

class _SakhiChatbotScreenState extends State<SakhiChatbotScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [
    {
      "sender": "bot",
      "text":
          "Hi 🌸 I’m Sakhi...\nI’m here to listen, support and care for you 💖\nHow are you feeling today?",
    },
  ];

  void _sendMessage() async {
    if (_controller.text.trim().isEmpty) return;

    final userMessage = _controller.text;

    setState(() {
      _messages.add({"sender": "user", "text": userMessage});
    });

    _controller.clear();

    try {
      final reply = await ApiService.askSakhi(userMessage);

      setState(() {
        _messages.add({"sender": "bot", "text": reply});
      });
    } catch (e) {
      setState(() {
        _messages.add({
          "sender": "bot",
          "text": "Sorry 💔 I’m having trouble right now. Please try again.",
        });
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F5FC),
      appBar: AppBar(
        title: const Text("Sakhi 💬", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.purple,
      ),
      body: Column(
        children: [
          /// 🧠 Chat Messages
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                bool isUser = _messages[index]["sender"] == "user";

                return Align(
                  alignment: isUser
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    padding: const EdgeInsets.all(14),
                    constraints: BoxConstraints(maxWidth: size.width * 0.75),
                    decoration: BoxDecoration(
                      color: isUser ? Colors.purple : Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: Text(
                      _messages[index]["text"]!,
                      style: TextStyle(
                        color: isUser ? Colors.white : Colors.black87,
                        fontSize: 15,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          /// ✍️ Input Field
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 8),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: "Type your feelings here...",
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.purple),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
