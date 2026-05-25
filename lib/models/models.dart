// ==========================================
// MODELS & ENUMS
// Author: [Bethlehem — Models]
// ==========================================

enum UserRole { student, secretary, admin, staff }
enum UrgentLevel { low, medium, high }
enum AppointmentStatus { pending, confirmed, rejected, cancelled }

class AppUser {
  final String id;
  final String name;
  final String email;
  final String password;
  final UserRole role;
  final String roleTitle;
  final String department;
  final String avatarInitials;

  AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.role,
    required this.roleTitle,
    required this.department,
    required this.avatarInitials,
  });
}

class Leader {
  final String id;
  final String name;
  final String position;
  final String department;
  final String office;
  final String badge;
  final List<String> availableSlots;

  Leader({
    required this.id,
    required this.name,
    required this.position,
    required this.department,
    required this.office,
    required this.badge,
    required this.availableSlots,
  });
}

class Appointment {
  final String id;
  final String requesterName;
  final String requesterId;
  final String leaderId;
  final String purpose;
  final DateTime dateTime;
  final UrgentLevel urgency;
  final int durationMinutes;
  AppointmentStatus status;
  String? reason;

  Appointment({
    required this.id,
    required this.requesterName,
    required this.requesterId,
    required this.leaderId,
    required this.purpose,
    required this.dateTime,
    required this.urgency,
    required this.durationMinutes,
    required this.status,
    this.reason,
  });
}

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime time;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.time,
  });
}
