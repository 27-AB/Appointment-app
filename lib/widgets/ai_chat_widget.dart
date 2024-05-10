// ==========================================
// AI CHAT WIDGET
// Author: [Birhane — AI Assistant]
// ==========================================

import 'package:flutter/material.dart';
import '../models/models.dart';

class AiChatWidget extends StatefulWidget {
  const AiChatWidget({Key? key}) : super(key: key);
  @override
  State<AiChatWidget> createState() => _AiChatWidgetState();
}

class _AiChatWidgetState extends State<AiChatWidget> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  final List<ChatMessage> _messages = [
    ChatMessage(
      text:
          "Hi! I'm the ASTU Appointment Assistant 👋\n\nI can help you with:\n• How to book an appointment\n• Who you can meet with\n• How the approval process works\n• Writing formal letters\n• General questions about the app\n\nWhat would you like to know?",
      isUser: false,
      time: DateTime.now(),
    ),
  ];
  bool _isTyping = false;

  String _generateReply(String input) {
    final q = input.toLowerCase().trim();

    if (_matches(q, ["hello", "hi", "hey", "good morning", "good afternoon", "selam", "salam"])) {
      return "Hello! 😊 How can I help you today? You can ask me about booking appointments, the officials you can meet, how approvals work, or anything else about the ASTU Appointment app.";
    }

    if (_matches(q, ["what is this app", "what does this app do", "what is astu appointment", "tell me about this app", "explain this app", "how does this app work", "what can i do", "purpose of this app"])) {
      return "ASTU Direct Appointment is a mobile app for Adama Science and Technology University (ASTU) in Ethiopia.\n\nIt lets students, staff, and secretaries book appointments directly with university leaders and officials — without waiting in long queues or going office-to-office.\n\nKey features:\n• Book appointments with deans, registrars, and other officials\n• Choose your preferred date, time, and meeting duration\n• Get notified when your request is approved or declined\n• Secretaries can manage and approve requests from a control desk\n• AI assistant (that's me!) to guide you\n\nIt replaces the old way of physically showing up and hoping someone is available.";
    }

    if (_matches(q, ["how to book", "how do i book", "book appointment", "schedule appointment", "make appointment", "request appointment", "how to schedule"])) {
      return "Booking an appointment is simple:\n\n1. Go to the Board tab (home screen)\n2. You'll see a list of ASTU officials\n3. Tap the 'Book' button next to the person you want to meet\n4. Fill in:\n   • Purpose of your visit\n   • Preferred date and time\n   • How long you need (15, 30, 45, 60, or 90 minutes)\n   • Priority level (Low, Medium, or High)\n5. Tap 'Submit Appointment Request'\n\nYour request will be reviewed and you'll get a notification when it's approved or declined.";
    }

    if (_matches(q, ["who can i meet", "which officials", "list of officials", "available officials", "who is available", "coordinators", "leaders", "dean", "registrar", "secretary", "vice president", "vp"])) {
      return "You can currently book appointments with these ASTU officials:\n\n1. Dr. Abraham Kebede\n   Dean, School of Electrical Eng. & Computing\n   Office: Block 504, Room 12\n   Available: Mornings & Afternoons\n\n2. W/ro Selamawit Alene\n   Secretary, School of Postgraduate Studies\n   Office: Block 102, Room 08\n   Available: Mon–Fri mornings & Mon–Wed afternoons\n\n3. Dr. Zelalem Mulatu\n   VP of Research & Tech Transfer\n   Office: Admin Building, 1st Floor\n   Available: Tues 10–12, Thurs 15–17\n\n4. Ato Kassa Demeke\n   Head Registrar, Office of Student Admissions\n   Office: Registrar House, Counter 2\n   Available: Full time (09:00–16:00)";
    }

    if (_matches(q, ["approval", "how long", "when approved", "status", "pending", "confirmed", "rejected", "declined", "how does approval work", "review process"])) {
      return "After you submit a booking request, here's what happens:\n\n1. Your request shows as PENDING\n2. The relevant secretary or admin reviews your request\n3. They either:\n   ✅ APPROVE it — you get a notification and your appointment is confirmed\n   ❌ DECLINE it — you get a notification with feedback explaining why\n\nYou can see the status of all your appointments on the Board tab. If declined, you can submit a new request with a different date or time.";
    }

    if (_matches(q, ["notification", "alert", "informed", "update", "notified"])) {
      return "You'll receive notifications whenever:\n• Your appointment request is received\n• Your request is approved ✅\n• Your request is declined ❌ (with a reason)\n\nYou can see all your notifications in the Alerts tab (the bell icon in the bottom navigation bar).";
    }

    if (_matches(q, ["duration", "how long meeting", "meeting time", "how many minutes", "time for meeting", "15 min", "30 min", "45 min", "60 min", "90 min"])) {
      return "When booking, you choose how long you need for your meeting. The available durations are:\n\n• 15 minutes — quick questions or document signing\n• 30 minutes — standard meeting (default)\n• 45 minutes — moderate discussions\n• 60 minutes — detailed consultations\n• 90 minutes — extended research or project meetings\n\nThe official or secretary may adjust the duration when approving, depending on availability.";
    }

    if (_matches(q, ["urgency", "priority", "urgent", "high priority", "low priority", "medium"])) {
      return "When booking an appointment, you set a priority level:\n\n🔴 HIGH — Critical or time-sensitive matters (e.g. deadline in a few days, exam re-evaluation)\n🟡 MEDIUM — Important but not urgent (e.g. thesis guidance, clearance signature)\n🟢 LOW — General inquiry or non-urgent discussion\n\nHigher priority requests are visible to secretaries and may be reviewed faster.";
    }

    if (_matches(q, ["register", "sign up", "create account", "new account", "how to register", "enrollment"])) {
      return "To create an account:\n\n1. On the Sign In screen, tap 'Create Account'\n2. Fill in your:\n   • Full name\n   • ASTU institutional email\n   • Department/College\n   • Role (Student, Staff, or Secretary)\n   • Password (at least 6 characters)\n3. Tap 'Create Account'\n\nYou'll be signed in automatically after registering. Next time, use your email and password to sign in.";
    }

    if (_matches(q, ["login", "sign in", "how to login", "log in", "password", "forgot password", "can't login"])) {
      return "To sign in:\n1. Enter your registered email address\n2. Enter your password\n3. Tap 'Sign In'\n\nMake sure you use the same email and password you used when you registered. If you don't have an account yet, tap 'Create Account' on the login screen.\n\nNote: This app currently stores accounts in memory, so if the app is fully closed and restarted, you'll need to register again. A backend database would persist accounts permanently.";
    }

    if (_matches(q, ["secretary", "admin", "control desk", "how to approve", "manage requests", "approve appointment"])) {
      return "Secretaries and admins have access to a special 'Control' tab in the bottom navigation.\n\nFrom there they can:\n• See all incoming appointment requests\n• View the requester's name, purpose, and requested duration\n• APPROVE a request with one tap\n• DECLINE a request and provide a written reason\n\nWhen an action is taken, the student automatically receives a notification.";
    }

    if (_matches(q, ["calendar", "planner", "schedule view", "upcoming", "my schedule"])) {
      return "The Planner tab (calendar icon) shows all your scheduled appointments.\n\nFor each appointment you can see:\n• The official's name\n• The purpose of your meeting\n• The date and time\n• The duration you requested\n\nIt also shows a simple monthly calendar view at the top.";
    }

    if (_matches(q, ["write a letter", "formal letter", "draft letter", "letter of", "application letter", "permission letter", "petition", "appeal letter", "write letter", "help me write"])) {
      return "Sure! I can help you draft a formal letter. Tell me:\n1. What type of letter? (e.g. permission request, grade appeal, thesis clearance, makeup exam)\n2. Who is it addressed to?\n3. What is the main reason or request?\n\nOnce you give me those details, I'll draft a proper formal letter for you.";
    }

    if (q.contains("to:") || q.contains("dear") || q.contains("subject:") ||
        (q.contains("letter") && q.length > 50)) {
      return _draftFormalLetter(input);
    }

    if (_matches(q, ["thesis", "research", "capstone", "project", "dissertation", "postgraduate", "graduate"])) {
      return "For thesis and research-related appointments, you can book with:\n\n• W/ro Selamawit Alene (Postgraduate Studies Secretary) — for thesis submission, clearance signatures, or administrative postgrad matters\n• Dr. Zelalem Mulatu (VP Research & Tech Transfer) — for research guidance, funding, or technology transfer discussions\n\nMake sure to clearly state your thesis title and the specific help you need in the Purpose field when booking.";
    }

    if (_matches(q, ["grade", "transcript", "registration", "admission", "student id", "clearance", "document", "certificate"])) {
      return "For grade reviews, transcripts, admissions, and student documents, contact:\n\nAto Kassa Demeke\nHead Registrar — Office of Student Admissions\nRegistrar House, Counter 2\nAvailable full time: 09:00–16:00\n\nYou can book an appointment through the app. In your Purpose field, mention the specific document or issue (e.g. 'Request for official transcript', 'Grade review for Course X').";
    }

    if (_matches(q, ["thank", "thanks", "thank you", "bye", "goodbye", "ok thanks", "got it"])) {
      return "You're welcome! 😊 Feel free to come back if you have more questions. Good luck with your appointments at ASTU!";
    }

    if (_matches(q, ["who are you", "what are you", "are you ai", "are you a bot", "chatbot", "ai assistant"])) {
      return "I'm the ASTU Appointment AI Assistant — a built-in chatbot designed to help you use this app.\n\nI work completely offline (no internet needed) and I'm programmed to answer questions about the ASTU Direct Appointment app, guide you through booking, help draft formal letters, and more.\n\nI'm not connected to a general AI like ChatGPT, but I know everything about this app!";
    }

    if (_matches(q, ["help", "what can you do", "guide me", "assist", "support"])) {
      return "Here's what I can help you with:\n\n📱 App features\n• How to book an appointment\n• How approval works\n• Understanding your appointment status\n• The calendar and notifications tabs\n\n👥 Officials\n• Who is available to meet\n• Their office locations and availability\n\n✉️ Letters\n• Drafting formal request letters\n• Permission letters, appeals, petitions\n\n🎓 Academic matters\n• Thesis and research appointments\n• Grade reviews and transcripts\n\nJust type your question and I'll answer!";
    }

    return "I'm not sure I fully understood that. Could you rephrase?\n\nHere are some things you can ask me:\n• \"How do I book an appointment?\"\n• \"Who can I meet with?\"\n• \"How does the approval process work?\"\n• \"Help me write a formal letter\"\n• \"What does this app do?\"\n\nOr type 'help' to see everything I can assist with.";
  }

  bool _matches(String query, List<String> keywords) {
    return keywords.any((k) => query.contains(k));
  }

  String _draftFormalLetter(String userInput) {
    final now = DateTime.now();
    final dateStr = "${now.day}/${now.month}/${now.year}";
    return """Here's a formal letter draft based on your request:

---

ADAMA SCIENCE AND TECHNOLOGY UNIVERSITY
Office of Academic Affairs
Adama, Ethiopia

Date: $dateStr

To: The Concerned Department Head / Official
Adama Science and Technology University

Subject: FORMAL REQUEST — [Add your specific subject here]

Dear Sir/Madam,

I am writing to formally bring to your attention the following matter and respectfully request your assistance:

$userInput

I kindly request that this matter be reviewed and the necessary action or approval be granted at your earliest convenience. I am available for any follow-up discussion and can be reached at my institutional email.

I appreciate your time and look forward to a favorable response.

Yours sincerely,

[Your Full Name]
[Student/Staff ID]
[Department]
[Institutional Email]
[Date: $dateStr]

---

✏️ Tip: Replace the bracketed parts with your actual details before submitting.""";
  }

  void _sendMessage(String text) {
    if (text.trim().isEmpty || _isTyping) return;
    _controller.clear();
    setState(() {
      _messages.add(
          ChatMessage(text: text.trim(), isUser: true, time: DateTime.now()));
      _isTyping = true;
    });
    _scrollToBottom();

    final reply = _generateReply(text);
    final delay = reply.length < 200 ? 600 : 1000;
    Future.delayed(Duration(milliseconds: delay), () {
      setState(() {
        _isTyping = false;
        _messages.add(
            ChatMessage(text: reply, isUser: false, time: DateTime.now()));
      });
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
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
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          color: const Color(0xFF0D2137),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: const Color(0xFFE8A020),
                    borderRadius: BorderRadius.circular(8)),
                child: const Icon(Icons.psychology,
                    color: Color(0xFF0D2137), size: 18),
              ),
              const SizedBox(width: 12),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("ASTU AI Assistant",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 14)),
                  Text("Always available · No internet needed",
                      style:
                          TextStyle(color: Colors.white60, fontSize: 11)),
                ],
              ),
            ],
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              "What does this app do?",
              "How do I book?",
              "Who can I meet?",
              "Write a formal letter",
              "How does approval work?",
            ]
                .map((s) => Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ActionChip(
                        label: Text(s,
                            style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600)),
                        backgroundColor: const Color(0x140D2137),
                        side: const BorderSide(color: Color(0x220D2137)),
                        onPressed: () => _sendMessage(s),
                      ),
                    ))
                .toList(),
          ),
        ),
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            itemCount: _messages.length + (_isTyping ? 1 : 0),
            itemBuilder: (context, idx) {
              if (idx == _messages.length && _isTyping) {
                return Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border:
                          Border.all(color: const Color(0x1A9E9E9E)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _dot(0),
                        const SizedBox(width: 4),
                        _dot(150),
                        const SizedBox(width: 4),
                        _dot(300),
                      ],
                    ),
                  ),
                );
              }

              final msg = _messages[idx];
              return Align(
                alignment: msg.isUser
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 10),
                  constraints: BoxConstraints(
                      maxWidth:
                          MediaQuery.of(context).size.width * 0.80),
                  decoration: BoxDecoration(
                    color: msg.isUser
                        ? const Color(0xFF0D2137)
                        : Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(16),
                      topRight: const Radius.circular(16),
                      bottomLeft:
                          Radius.circular(msg.isUser ? 16 : 4),
                      bottomRight:
                          Radius.circular(msg.isUser ? 4 : 16),
                    ),
                    border: msg.isUser
                        ? null
                        : Border.all(color: const Color(0x1A9E9E9E)),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 4,
                          offset: const Offset(0, 2))
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (!msg.isUser)
                        const Padding(
                          padding: EdgeInsets.only(bottom: 4),
                          child: Text("ASTU Assistant",
                              style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFFE8A020),
                                  letterSpacing: 0.5)),
                        ),
                      SelectableText(
                        msg.text,
                        style: TextStyle(
                          fontSize: 13,
                          color: msg.isUser
                              ? Colors.white
                              : const Color(0xFF1E293B),
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "${msg.time.hour.toString().padLeft(2, '0')}:${msg.time.minute.toString().padLeft(2, '0')}",
                        style: TextStyle(
                            fontSize: 10,
                            color: msg.isUser
                                ? Colors.white54
                                : Colors.grey),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 16),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: Color(0x1A9E9E9E))),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  maxLines: null,
                  style: const TextStyle(fontSize: 14),
                  decoration: InputDecoration(
                    hintText:
                        "Ask me anything about ASTU appointments...",
                    hintStyle: const TextStyle(
                        fontSize: 13, color: Colors.grey),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide:
                            const BorderSide(color: Color(0x1A9E9E9E))),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide:
                            const BorderSide(color: Color(0x1A9E9E9E))),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: const BorderSide(
                            color: Color(0xFF0D2137), width: 1.5)),
                    filled: true,
                    fillColor: const Color(0xFFF8FAFC),
                  ),
                  onSubmitted: (t) {
                    if (!_isTyping) _sendMessage(t);
                  },
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: _isTyping
                    ? null
                    : () => _sendMessage(_controller.text),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: _isTyping
                        ? Colors.grey
                        : const Color(0xFF0D2137),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.send_rounded,
                      color: Colors.white, size: 18),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _dot(int delayMs) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 600 + delayMs),
      builder: (context, val, _) {
        return Container(
          width: 7,
          height: 7,
          decoration: BoxDecoration(
            color: Color.lerp(
                Colors.grey.shade300, const Color(0xFF0D2137), val),
            shape: BoxShape.circle,
          ),
        );
      },
    );
  }
}
