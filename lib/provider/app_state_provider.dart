// ==========================================
// STATE MANAGER (Provider)
// Author: [Fiteh— State/Backend]
// ==========================================

import 'package:flutter/material.dart';
import '../models/models.dart';

class AppStateProvider with ChangeNotifier {
  AppUser? _currentUser;
  final Map<String, AppUser> _registeredUsers = {};

  final List<Leader> leaders = [
    Leader(
      id: "l1",
      name: "Dr. Abraham Kebede",
      position: "Dean, School of Electrical Eng. & Computing",
      department: "Electrical Engineering",
      office: "Block 504, Room 12",
      badge: "SOEEC DEAN",
      availableSlots: ["Mornings (09:00 - 11:30)", "Afternoons (14:30 - 16:30)"],
    ),
    Leader(
      id: "l2",
      name: "W/ro Selamawit Alene",
      position: "Office Secretary, School of Postgraduate Studies",
      department: "Postgraduate Studies",
      office: "Block 102, Room 08",
      badge: "POSTGRAD SEC",
      availableSlots: ["Mon-Fri (08:30 - 12:00)", "Mon-Wed (14:00 - 17:00)"],
    ),
    Leader(
      id: "l3",
      name: "Dr. Zelalem Mulatu",
      position: "Vice President of Research & Tech Transfer",
      department: "Research & Tech Transfer",
      office: "ASTU Admin Building, 1st Floor",
      badge: "RESEARCH VP",
      availableSlots: ["Tuesdays (10:00 - 12:00)", "Thursdays (15:00 - 17:00)"],
    ),
    Leader(
      id: "l4",
      name: "Ato Kassa Demeke",
      position: "Head Registrar, Office of Student Admissions",
      department: "Admissions",
      office: "Registrar House, Counter 2",
      badge: "REGISTRAR HEAD",
      availableSlots: ["Full Time (09:00 - 16:00)"],
    ),
  ];

  final List<Appointment> _appointments = [];
  final List<Map<String, dynamic>> _notifications = [];

  AppUser? get currentUser => _currentUser;
  List<Appointment> get appointments => List.unmodifiable(_appointments);
  List<Map<String, dynamic>> get notifications => List.unmodifiable(_notifications);

  String? register({
    required String name,
    required String email,
    required String password,
    required UserRole role,
    required String department,
  }) {
    final normalizedEmail = email.trim().toLowerCase();
    if (name.trim().isEmpty) return "Full name is required.";
    if (normalizedEmail.isEmpty || !normalizedEmail.contains('@')) {
      return "Please enter a valid institutional email.";
    }
    if (password.length < 6) return "Password must be at least 6 characters.";
    if (_registeredUsers.containsKey(normalizedEmail)) {
      return "An account with this email already exists.";
    }
    final initials = name
        .trim()
        .split(' ')
        .map((w) => w.isNotEmpty ? w[0] : '')
        .join()
        .toUpperCase();
    final user = AppUser(
      id: "u_${DateTime.now().millisecondsSinceEpoch}",
      name: name.trim(),
      email: normalizedEmail,
      password: password,
      role: role,
      roleTitle: role == UserRole.student
          ? "ASTU Student"
          : role == UserRole.secretary
              ? "Department Secretary"
              : role == UserRole.staff
                  ? "Faculty Staff"
                  : "Administrator",
      department: department.trim().isEmpty ? "General" : department.trim(),
      avatarInitials: initials.isEmpty ? "U" : initials,
    );
    _registeredUsers[normalizedEmail] = user;
    _currentUser = user;
    notifyListeners();
    return null;
  }

  String? login({required String email, required String password}) {
    final normalizedEmail = email.trim().toLowerCase();
    if (normalizedEmail.isEmpty) return "Please enter your email.";
    if (password.isEmpty) return "Please enter your password.";
    final user = _registeredUsers[normalizedEmail];
    if (user == null) return "No account found with this email. Please register first.";
    if (user.password != password) return "Incorrect password. Please try again.";
    _currentUser = user;
    notifyListeners();
    return null;
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }

  void addAppointment(Appointment appt) {
    _appointments.insert(0, appt);
    _notifications.insert(0, {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'title': "New Booking Request Submitted",
      'message': "Your request with ${_getLeaderName(appt.leaderId)} is pending review.",
      'time': "Just now",
      'isRead': false,
    });
    notifyListeners();
  }

  void updateStatus(String apptId, AppointmentStatus status,
      {String? rejectionNote}) {
    final index = _appointments.indexWhere((a) => a.id == apptId);
    if (index != -1) {
      _appointments[index].status = status;
      if (rejectionNote != null) _appointments[index].reason = rejectionNote;
      _notifications.insert(0, {
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'title': status == AppointmentStatus.confirmed
            ? "Appointment Confirmed ✓"
            : "Appointment Declined",
        'message': status == AppointmentStatus.confirmed
            ? "Your slot has been approved."
            : "Feedback: ${rejectionNote ?? 'Request declined.'}",
        'time': "Just now",
        'isRead': false,
      });
      notifyListeners();
    }
  }

  String _getLeaderName(String id) {
    return leaders.firstWhere((e) => e.id == id, orElse: () => leaders[0]).name;
  }

  Leader? getLeaderById(String id) {
    try {
      return leaders.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }
}
