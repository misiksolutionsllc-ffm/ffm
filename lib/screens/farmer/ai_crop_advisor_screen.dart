import 'package:flutter/material.dart';
import '../../services/ai_service.dart';
import '../../utils/constants.dart';

class AICropAdvisorScreen extends StatefulWidget {
  const AICropAdvisorScreen({super.key});

  @override
  State<AICropAdvisorScreen> createState() => _AICropAdvisorScreenState();
}

class _AICropAdvisorScreenState extends State<AICropAdvisorScreen> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  final List<_ChatMessage> _messages = [
    _ChatMessage(
      isUser: false,
      text: 'Hello! I\'m your AI Crop & Business Advisor. I can help with:\n\n'
          '- Crop planning & planting schedules\n'
          '- Pricing strategies & market trends\n'
          '- Organic certification guidance\n'
          '- Pest & disease management\n'
          '- Demand forecasting\n\n'
          'What would you like to know?',
    ),
  ];

  final _quickQuestions = [
    'What should I plant this season?',
    'How should I price my products?',
    'How do I get organic certification?',
    'Help with pest management',
    'Tell me about tomato growing',
  ];

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;
    setState(() {
      _messages.add(_ChatMessage(isUser: true, text: text.trim()));
    });
    _controller.clear();

    Future.delayed(const Duration(milliseconds: 500), () {
      final response = AIService.getCropAdvice(text);
      setState(() {
        _messages.add(_ChatMessage(isUser: false, text: response));
      });
      _scrollToBottom();
    });
    _scrollToBottom();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.smart_toy, color: Colors.white),
            SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('AI Crop Advisor',
                    style: TextStyle(fontSize: 16)),
                Text('Powered by AI',
                    style: TextStyle(fontSize: 11, color: Colors.white70)),
              ],
            ),
          ],
        ),
        backgroundColor: Colors.purple.shade700,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                return _buildMessageBubble(msg);
              },
            ),
          ),
          // Quick questions
          if (_messages.length <= 2)
            SizedBox(
              height: 44,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: _quickQuestions.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ActionChip(
                      label: Text(_quickQuestions[index],
                          style: const TextStyle(fontSize: 12)),
                      backgroundColor: Colors.purple.shade50,
                      side: BorderSide(color: Colors.purple.shade200),
                      onPressed: () => _sendMessage(_quickQuestions[index]),
                    ),
                  );
                },
              ),
            ),
          // Input bar
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: 'Ask about crops, pricing, pests...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                      ),
                      onSubmitted: _sendMessage,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.purple.shade700,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.send, color: Colors.white, size: 20),
                      onPressed: () => _sendMessage(_controller.text),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(_ChatMessage msg) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment:
            msg.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!msg.isUser) ...[
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.purple.shade700, Colors.blue.shade600],
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.auto_awesome,
                  color: Colors.white, size: 16),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: msg.isUser
                    ? Colors.purple.shade700
                    : Colors.grey.shade100,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(msg.isUser ? 16 : 4),
                  bottomRight: Radius.circular(msg.isUser ? 4 : 16),
                ),
              ),
              child: Text(
                msg.text,
                style: TextStyle(
                  color: msg.isUser ? Colors.white : AppColors.textPrimary,
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
            ),
          ),
          if (msg.isUser) const SizedBox(width: 40),
        ],
      ),
    );
  }
}

class _ChatMessage {
  final bool isUser;
  final String text;

  _ChatMessage({required this.isUser, required this.text});
}
