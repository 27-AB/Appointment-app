// ==========================================
// HOME SCREEN & ALL TABS
// Author: [Mahder — Home & Calendar]
// ==========================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../providers/app_state_provider.dart';
import 'booking_screen.dart';
import '../widgets/ai_chat_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentTab = 0;

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppStateProvider>(context);
    final user = appState.currentUser;
    final bool isSecretary =
        user?.role == UserRole.secretary || user?.role == UserRole.admin;

    final List<Widget> tabScreens = [
      _buildHomeTab(user, appState),
      _buildAlertsTab(appState.notifications),
      _buildCalendarTab(appState),
      if (isSecretary) _buildControlDeskTab(appState),
      const AiChatWidget(),
    ];

    final List<BottomNavigationBarItem> navItems = [
      const BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: "Board"),
      const BottomNavigationBarItem(
          icon: Icon(Icons.notifications_none_outlined),
          activeIcon: Icon(Icons.notifications),
          label: "Alerts"),
      const BottomNavigationBarItem(
          icon: Icon(Icons.calendar_month_outlined),
          activeIcon: Icon(Icons.calendar_month),
          label: "Planner"),
      if (isSecretary)
        const BottomNavigationBarItem(
            icon: Icon(Icons.admin_panel_settings_outlined),
            activeIcon: Icon(Icons.admin_panel_settings),
            label: "Control"),
      const BottomNavigationBarItem(
          icon: Icon(Icons.psychology_outlined),
          activeIcon: Icon(Icons.psychology),
          label: "AI Chat"),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("ASTU DIRECT APPOINTMENT",
            style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 13,
                letterSpacing: 0.8)),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded, size: 18),
            tooltip: "Sign Out",
            onPressed: () => showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                title: const Text("Sign Out"),
                content: const Text("Are you sure you want to sign out?"),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text("Cancel")),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0D2137)),
                    onPressed: () {
                      Navigator.pop(ctx);
                      appState.logout();
                    },
                    child: const Text("Sign Out",
                        style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex:
            _currentTab >= navItems.length ? 0 : _currentTab,
        selectedItemColor: const Color(0xFFE8A020),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle:
            const TextStyle(fontWeight: FontWeight.w900, fontSize: 9),
        unselectedLabelStyle:
            const TextStyle(fontWeight: FontWeight.bold, fontSize: 9),
        onTap: (index) => setState(() => _currentTab = index),
        items: navItems,
      ),
      body: tabScreens[
          _currentTab >= tabScreens.length ? 0 : _currentTab],
    );
  }

  // ---- HOME TAB ----
  Widget _buildHomeTab(AppUser? user, AppStateProvider provider) {
    final appointments = provider.appointments;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0D2137), Color(0xFF1B3B5F)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE8A020), width: 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text("Welcome, ${user?.name ?? 'User'}",
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              fontSize: 17)),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                          color: const Color(0xFFE8A020),
                          borderRadius: BorderRadius.circular(6)),
                      child: Text(
                          user?.role
                                  .toString()
                                  .split('.')
                                  .last
                                  .toUpperCase() ??
                              "STUDENT",
                          style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF0D2137))),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(user?.department ?? '',
                    style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                const Text(
                    "Book appointments with ASTU leaders directly. Manage your academic schedule efficiently.",
                    style: TextStyle(
                        color: Colors.white70, fontSize: 12, height: 1.4)),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("ASTU Campus Coordinators",
                  style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 15,
                      color: Color(0xFF0D2137))),
              Text("${provider.leaders.length} Active",
                  style: const TextStyle(
                      fontSize: 12,
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 10),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: provider.leaders.length,
            separatorBuilder: (c, i) => const SizedBox(height: 10),
            itemBuilder: (context, idx) {
              final leader = provider.leaders[idx];
              return Card(
                elevation: 0.5,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(color: Color(0x269E9E9E))),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: const Color(0x140D2137),
                        child: Text(
                            leader.name.split(" ").last.substring(0, 1),
                            style: const TextStyle(
                                color: Color(0xFF0D2137),
                                fontWeight: FontWeight.w900,
                                fontSize: 15)),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(leader.name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 14,
                                    color: Color(0xFF0D2137))),
                            const SizedBox(height: 2),
                            Text(leader.position,
                                style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600)),
                            const SizedBox(height: 4),
                            Text("Office: ${leader.office}",
                                style: const TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFFE8A020),
                                    fontWeight: FontWeight.w900)),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0D2137),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 10),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => BookingWizard(
                                    preSelectedLeader: leader))),
                        child: const Text("Book",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w900)),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 24),
          const Text("Your Appointments",
              style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 15,
                  color: Color(0xFF0D2137))),
          const SizedBox(height: 10),
          if (appointments.isEmpty)
            Container(
              padding: const EdgeInsets.all(24),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12)),
              child: const Text(
                  "No appointments yet. Book your first slot above!",
                  style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold)),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: appointments.length,
              itemBuilder: (context, index) {
                final apt = appointments[index];
                final leader =
                    provider.getLeaderById(apt.leaderId) ??
                        provider.leaders[0];
                Color badgeColor = Colors.orange;
                Color badgeBg = const Color(0x1FFF9800);
                if (apt.status == AppointmentStatus.confirmed) {
                  badgeColor = Colors.green;
                  badgeBg = const Color(0x1F4CAF50);
                }
                if (apt.status == AppointmentStatus.rejected) {
                  badgeColor = Colors.red;
                  badgeBg = const Color(0x1FF44336);
                }
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                          children: [
                            Text(leader.name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 13,
                                    color: Color(0xFF0D2137))),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                  color: badgeBg,
                                  borderRadius: BorderRadius.circular(4)),
                              child: Text(
                                  apt.status
                                      .toString()
                                      .split('.')
                                      .last
                                      .toUpperCase(),
                                  style: TextStyle(
                                      color: badgeColor,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w900)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text("Purpose: ${apt.purpose}",
                            style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF475569),
                                fontWeight: FontWeight.w600)),
                        if (apt.reason != null &&
                            apt.reason!.isNotEmpty) ...[
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.all(8),
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: const Color(0x0DF44336),
                                borderRadius: BorderRadius.circular(6)),
                            child: Text("Feedback: ${apt.reason}",
                                style: const TextStyle(
                                    fontSize: 11,
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ],
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${apt.dateTime.year}-${apt.dateTime.month.toString().padLeft(2, '0')}-${apt.dateTime.day.toString().padLeft(2, '0')}  "
                              "${apt.dateTime.hour.toString().padLeft(2, '0')}:${apt.dateTime.minute.toString().padLeft(2, '0')}",
                              style: const TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                                "${apt.durationMinutes} min · ${apt.urgency.toString().split('.').last.toUpperCase()}",
                                style: TextStyle(
                                    fontSize: 11,
                                    color: apt.urgency == UrgentLevel.high
                                        ? Colors.red
                                        : Colors.grey,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  // ---- ALERTS TAB ----
  Widget _buildAlertsTab(List<Map<String, dynamic>> notifications) {
    if (notifications.isEmpty) {
      return const Center(
          child: Text("No notifications yet.",
              style: TextStyle(fontSize: 14, color: Colors.grey)));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(14),
      itemCount: notifications.length,
      itemBuilder: (context, idx) {
        final item = notifications[idx];
        return Card(
          elevation: 0.5,
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: const CircleAvatar(
              backgroundColor: Color(0xFFF1F5F9),
              child: Icon(Icons.circle_notifications_outlined,
                  color: Color(0xFF0D2137)),
            ),
            title: Text(item['title'] ?? '',
                style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 13,
                    color: Color(0xFF0D2137))),
            subtitle: Text(item['message'] ?? '',
                style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    height: 1.3)),
            trailing: Text(item['time'] ?? '',
                style: const TextStyle(
                    fontSize: 11,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold)),
          ),
        );
      },
    );
  }

  // ---- CALENDAR TAB ----
  Widget _buildCalendarTab(AppStateProvider provider) {
    final appointments = provider.appointments;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Appointment Calendar",
              style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                  color: Color(0xFF0D2137))),
          const SizedBox(height: 4),
          const Text("Your upcoming scheduled appointments.",
              style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text("May 2026",
                          style: TextStyle(
                              fontWeight: FontWeight.w900, fontSize: 15)),
                      Icon(Icons.calendar_month, color: Color(0xFF0D2137)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: ["M", "T", "W", "T", "F", "S", "S"]
                        .map((d) => Text(d,
                            style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w900)))
                        .toList(),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: List.generate(
                        7,
                        (idx) => CircleAvatar(
                              backgroundColor: idx == 4
                                  ? const Color(0xFFE8A020)
                                  : Colors.transparent,
                              radius: 12,
                              child: Text("${idx + 22}",
                                  style: TextStyle(
                                      fontSize: 11,
                                      color: idx == 4
                                          ? const Color(0xFF0D2137)
                                          : Colors.black,
                                      fontWeight: FontWeight.bold)),
                            )),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text("Scheduled appointments:",
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF0D2137))),
          const SizedBox(height: 8),
          Expanded(
            child: appointments.isEmpty
                ? const Center(
                    child: Text("No appointments scheduled yet.",
                        style:
                            TextStyle(fontSize: 13, color: Colors.grey)))
                : ListView.builder(
                    itemCount: appointments.length,
                    itemBuilder: (context, index) {
                      final apt = appointments[index];
                      final leader =
                          provider.getLeaderById(apt.leaderId) ??
                              provider.leaders[0];
                      final timeStr =
                          "${apt.dateTime.hour.toString().padLeft(2, '0')}:${apt.dateTime.minute.toString().padLeft(2, '0')}";
                      final dateStr =
                          "${apt.dateTime.year}-${apt.dateTime.month.toString().padLeft(2, '0')}-${apt.dateTime.day.toString().padLeft(2, '0')}";
                      final durationLabel = "${apt.durationMinutes} MIN";
                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color: const Color(0x1A9E9E9E)),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(leader.name,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w900,
                                          fontSize: 13,
                                          color: Color(0xFF0D2137))),
                                  const SizedBox(height: 3),
                                  Text(apt.purpose,
                                      style: const TextStyle(
                                          fontSize: 11, color: Colors.grey),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis),
                                  const SizedBox(height: 3),
                                  Text("$dateStr at $timeStr",
                                      style: const TextStyle(
                                          fontSize: 11,
                                          color: Colors.blueGrey,
                                          fontWeight: FontWeight.w600)),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Tooltip(
                              message: "Duration requested by the student",
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 5),
                                decoration: BoxDecoration(
                                    color: const Color(0xFF0D2137),
                                    borderRadius:
                                        BorderRadius.circular(6)),
                                child: Text(durationLabel,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // ---- CONTROL DESK TAB ----
  Widget _buildControlDeskTab(AppStateProvider provider) {
    final allAppts = provider.appointments.toList();
    final pendingCount =
        allAppts.where((e) => e.status == AppointmentStatus.pending).length;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                  colors: [Color(0xFFE8A020), Colors.amber]),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("ADMIN SECRETARY CONTROL DESK",
                    style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 15,
                        color: Color(0xFF0D2137))),
                const SizedBox(height: 4),
                Text(
                    "Department: ${provider.currentUser?.department ?? ''}",
                    style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0D2137))),
                Text("Pending requests: $pendingCount",
                    style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0D2137))),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Text("All Appointment Requests",
              style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 14,
                  color: Color(0xFF0D2137))),
          const SizedBox(height: 8),
          Expanded(
            child: allAppts.isEmpty
                ? const Center(
                    child: Text("No requests yet.",
                        style:
                            TextStyle(fontSize: 13, color: Colors.grey)))
                : ListView.builder(
                    itemCount: allAppts.length,
                    itemBuilder: (context, idx) {
                      final apt = allAppts[idx];
                      final leader =
                          provider.getLeaderById(apt.leaderId) ??
                              provider.leaders[0];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("From: ${apt.requesterName}",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w900,
                                          fontSize: 13)),
                                  Text(
                                    apt.status
                                        .toString()
                                        .split('.')
                                        .last
                                        .toUpperCase(),
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w900,
                                      color: apt.status ==
                                              AppointmentStatus.confirmed
                                          ? Colors.green
                                          : apt.status ==
                                                  AppointmentStatus.rejected
                                              ? Colors.red
                                              : Colors.orange,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text("To: ${leader.name}",
                                  style: const TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF0D2137),
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(height: 6),
                              Text("Purpose: ${apt.purpose}",
                                  style: const TextStyle(
                                      fontSize: 12, color: Colors.grey)),
                              Text(
                                  "Duration requested: ${apt.durationMinutes} minutes",
                                  style: const TextStyle(
                                      fontSize: 11,
                                      color: Colors.blueGrey,
                                      fontWeight: FontWeight.w600)),
                              if (apt.status ==
                                  AppointmentStatus.pending) ...[
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    Expanded(
                                      child: OutlinedButton(
                                        style: OutlinedButton.styleFrom(
                                            foregroundColor: Colors.red,
                                            side: const BorderSide(
                                                color: Colors.red)),
                                        onPressed: () =>
                                            _showRejectionDialog(
                                                context, provider, apt.id),
                                        child: const Text("Decline",
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight:
                                                    FontWeight.bold)),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.green),
                                        onPressed: () =>
                                            provider.updateStatus(apt.id,
                                                AppointmentStatus.confirmed),
                                        child: const Text("Approve",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                                fontWeight:
                                                    FontWeight.bold)),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void _showRejectionDialog(
      BuildContext context, AppStateProvider provider, String id) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Decline Reason"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
              hintText: "e.g. Fully booked, attending senate meeting"),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              provider.updateStatus(id, AppointmentStatus.rejected,
                  rejectionNote: controller.text);
              Navigator.pop(ctx);
            },
            child: const Text("Confirm Decline"),
          ),
        ],
      ),
    );
  }
}
