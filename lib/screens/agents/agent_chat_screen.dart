import 'package:flutter/material.dart';
import '../../models/agent_persona.dart';
import '../../utils/constants.dart';

class AgentChatScreen extends StatefulWidget {
  final AgentPersona agent;

  const AgentChatScreen({super.key, required this.agent});

  @override
  State<AgentChatScreen> createState() => _AgentChatScreenState();
}

class _AgentChatScreenState extends State<AgentChatScreen>
    with SingleTickerProviderStateMixin {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  final List<_Message> _messages = [];
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    // Welcome message
    _messages.add(_Message(
      text: widget.agent.responses['default'] ?? 'How can I help you today?',
      isUser: false,
    ));
  }

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;
    final trimmed = text.trim();
    _controller.clear();

    setState(() {
      _messages.add(_Message(text: trimmed, isUser: true));
      _isTyping = true;
    });
    _scrollToBottom();

    // Simulate AI thinking time
    Future.delayed(const Duration(milliseconds: 800), () {
      final response = _getResponse(trimmed);
      setState(() {
        _isTyping = false;
        _messages.add(_Message(text: response, isUser: false));
      });
      _scrollToBottom();
    });
  }

  String _getResponse(String input) {
    final q = input.toLowerCase();
    final responses = widget.agent.responses;

    for (final key in responses.keys) {
      if (key == 'default') continue;
      if (q.contains(key) ||
          key.split('-').any((k) => q.contains(k)) ||
          _fuzzyMatch(q, key)) {
        return responses[key]!;
      }
    }

    // Keyword matching for more flexibility
    if (widget.agent.id == 'growth-hacker') {
      if (q.contains('grow') || q.contains('acquire') || q.contains('1000')) {
        return responses['customer']!;
      }
      if (q.contains('refer')) return responses['referral']!;
      if (q.contains('social') ||
          q.contains('instagram') ||
          q.contains('tiktok')) {
        return responses['social']!;
      }
    } else if (widget.agent.id == 'supply-chain') {
      if (q.contains('waste') || q.contains('fresh') || q.contains('expir')) {
        return responses['waste']!;
      }
      if (q.contains('route') ||
          q.contains('delivery') ||
          q.contains('optim')) {
        return responses['route']!;
      }
    } else if (widget.agent.id == 'support') {
      if (q.contains('damage') || q.contains('broken') || q.contains('bad')) {
        return responses['damaged']!;
      }
      if (q.contains('cancel') || q.contains('refund')) {
        return responses['cancel']!;
      }
      if (q.contains('wrong') || q.contains('incorrect') || q.contains('mix')) {
        return responses['wrong']!;
      }
    } else if (widget.agent.id == 'nutrition') {
      if (q.contains('meal') ||
          q.contains('plan') ||
          q.contains('week') ||
          q.contains('recipe')) {
        return responses['meal']!;
      }
      if (q.contains('health') || q.contains('best') || q.contains('top')) {
        return responses['healthy']!;
      }
    } else if (widget.agent.id == 'pricing') {
      if (q.contains('price') ||
          q.contains('cost') ||
          q.contains('charge') ||
          q.contains('raise')) {
        return responses['pricing']!;
      }
      if (q.contains('bundle') ||
          q.contains('package') ||
          q.contains('combo')) {
        return responses['bundle']!;
      }
    } else if (widget.agent.id == 'sustainability') {
      if (q.contains('packag') || q.contains('plastic') || q.contains('wrap')) {
        return responses['packaging']!;
      }
      if (q.contains('regenerat') ||
          q.contains('soil') ||
          q.contains('sustain')) {
        return responses['regenerative']!;
      }
    }

    return responses['default']!;
  }

  bool _fuzzyMatch(String query, String key) {
    final words = key.split(RegExp(r'[-_\s]'));
    return words.any((w) => query.contains(w) && w.length > 3);
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
        title: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    widget.agent.color,
                    widget.agent.color.withOpacity(0.7),
                  ],
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(widget.agent.emoji,
                    style: const TextStyle(fontSize: 18)),
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.agent.name,
                    style: const TextStyle(fontSize: 16)),
                Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: AppColors.success,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${widget.agent.role} — Online',
                      style:
                          const TextStyle(fontSize: 11, color: Colors.white70),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        backgroundColor: widget.agent.color.withOpacity(0.9),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _showAgentInfo(context),
          ),
        ],
      ),
      body: Column(
        children: [
          // Messages
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length + (_isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (_isTyping && index == _messages.length) {
                  return _buildTypingIndicator();
                }
                return _buildBubble(_messages[index]);
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
                itemCount: widget.agent.sampleQuestions.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ActionChip(
                      label: Text(widget.agent.sampleQuestions[index],
                          style: const TextStyle(fontSize: 11)),
                      backgroundColor:
                          widget.agent.color.withOpacity(0.08),
                      side: BorderSide(
                          color: widget.agent.color.withOpacity(0.3)),
                      onPressed: () =>
                          _sendMessage(widget.agent.sampleQuestions[index]),
                    ),
                  );
                },
              ),
            ),

          // Input
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
                        hintText:
                            'Ask ${widget.agent.name} anything...',
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
                      color: widget.agent.color,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.send,
                          color: Colors.white, size: 20),
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

  Widget _buildBubble(_Message msg) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment:
            msg.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!msg.isUser) ...[
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    widget.agent.color,
                    widget.agent.color.withOpacity(0.7),
                  ],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(widget.agent.emoji,
                    style: const TextStyle(fontSize: 14)),
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: msg.isUser
                    ? widget.agent.color
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
                  height: 1.45,
                ),
              ),
            ),
          ),
          if (msg.isUser) const SizedBox(width: 40),
        ],
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  widget.agent.color,
                  widget.agent.color.withOpacity(0.7),
                ],
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(widget.agent.emoji,
                  style: const TextStyle(fontSize: 14)),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
                bottomLeft: Radius.circular(4),
                bottomRight: Radius.circular(16),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _TypingDot(delay: 0, color: widget.agent.color),
                const SizedBox(width: 4),
                _TypingDot(delay: 150, color: widget.agent.color),
                const SizedBox(width: 4),
                _TypingDot(delay: 300, color: widget.agent.color),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showAgentInfo(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        widget.agent.color,
                        widget.agent.color.withOpacity(0.7),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Center(
                    child: Text(widget.agent.emoji,
                        style: const TextStyle(fontSize: 26)),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.agent.name,
                          style: AppTextStyles.heading2),
                      Text(widget.agent.role,
                          style: TextStyle(
                              color: widget.agent.color,
                              fontWeight: FontWeight.w600)),
                      Text(widget.agent.division,
                          style: AppTextStyles.caption),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(widget.agent.description, style: AppTextStyles.body),
            const SizedBox(height: 16),
            const Text('Specialties',
                style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: widget.agent.specialties
                  .map((s) => Chip(
                        label: Text(s, style: const TextStyle(fontSize: 12)),
                        backgroundColor:
                            widget.agent.color.withOpacity(0.08),
                        side: BorderSide(
                            color: widget.agent.color.withOpacity(0.2)),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _Message {
  final String text;
  final bool isUser;

  _Message({required this.text, required this.isUser});
}

class _TypingDot extends StatefulWidget {
  final int delay;
  final Color color;

  const _TypingDot({required this.delay, required this.color});

  @override
  State<_TypingDot> createState() => _TypingDotState();
}

class _TypingDotState extends State<_TypingDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _animation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) _controller.repeat(reverse: true);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (_, __) => Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(
          color: widget.color.withOpacity(_animation.value),
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
