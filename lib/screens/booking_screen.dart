// ==========================================
// BOOKING WIZARD SCREEN
// Author: [Birhane — Booking Flow]
// ==========================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../providers/app_state_provider.dart';

class BookingWizard extends StatefulWidget {
  final Leader? preSelectedLeader;
  const BookingWizard({Key? key, this.preSelectedLeader}) : super(key: key);
  @override
  State<BookingWizard> createState() => _BookingWizardState();
}

class _BookingWizardState extends State<BookingWizard> {
  final _purposeController = TextEditingController();
  UrgentLevel _urgency = UrgentLevel.low;
  Leader? _chosenLeader;
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  TimeOfDay _selectedTime = const TimeOfDay(hour: 10, minute: 0);
  int _durationMinutes = 30;

  final List<int> _durationOptions = [15, 30, 45, 60, 90];

  @override
  void initState() {
    super.initState();
    _chosenLeader = widget.preSelectedLeader;
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppStateProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text("Book Appointment")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Schedule an Appointment",
                style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 18,
                    color: Color(0xFF0D2137))),
            const SizedBox(height: 4),
            const Text(
                "Fill in the details below. Your request will be reviewed by the office.",
                style: TextStyle(fontSize: 13, color: Colors.grey)),
            const SizedBox(height: 20),

            // Leader selector
            if (widget.preSelectedLeader == null) ...[
              const Text("Select Official",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 6),
              DropdownButtonFormField<Leader>(
                value: _chosenLeader ?? provider.leaders[0],
                items: provider.leaders
                    .map((e) => DropdownMenuItem(
                        value: e,
                        child: Text(e.name,
                            style: const TextStyle(fontSize: 13))))
                    .toList(),
                onChanged: (val) =>
                    setState(() => _chosenLeader = val),
              ),
              const SizedBox(height: 16),
            ] else ...[
              Card(
                color: const Color(0xFF0D2137),
                child: ListTile(
                  title: Text(_chosenLeader?.name ?? '',
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14)),
                  subtitle: Text(_chosenLeader?.position ?? '',
                      style: const TextStyle(
                          color: Colors.white70, fontSize: 12)),
                  trailing:
                      const Icon(Icons.verified, color: Color(0xFFE8A020)),
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Purpose
            const Text("Purpose of Appointment",
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(height: 6),
            TextField(
              controller: _purposeController,
              maxLines: 4,
              style: const TextStyle(fontSize: 14),
              decoration: const InputDecoration(
                  hintText:
                      "Briefly explain why you are requesting this appointment..."),
            ),
            const SizedBox(height: 16),

            // Date & Time
            const Text("Date & Time",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Color(0xFF0D2137))),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: _selectedDate,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now()
                            .add(const Duration(days: 90)),
                      );
                      if (picked != null)
                        setState(() => _selectedDate = picked);
                    },
                    icon: const Icon(Icons.calendar_month, size: 18),
                    label: Text(
                      "${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      final picked = await showTimePicker(
                          context: context, initialTime: _selectedTime);
                      if (picked != null)
                        setState(() => _selectedTime = picked);
                    },
                    icon: const Icon(Icons.access_time, size: 18),
                    label: Text(_selectedTime.format(context),
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 13)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Duration selector
            const Text("How long do you need?",
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(height: 4),
            const Text(
              "Select the estimated duration of your meeting. The office may adjust this when approving.",
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 10),
            Row(
              children: _durationOptions.map((mins) {
                final isSelected = _durationMinutes == mins;
                return Expanded(
                  child: GestureDetector(
                    onTap: () =>
                        setState(() => _durationMinutes = mins),
                    child: Container(
                      margin:
                          const EdgeInsets.symmetric(horizontal: 3),
                      padding:
                          const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFFE8A020)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFFE8A020)
                              : const Color(0x1A9E9E9E),
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        "${mins}m",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: isSelected
                              ? const Color(0xFF0D2137)
                              : Colors.black87,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),

            // Urgency
            const Text("Priority Level",
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(height: 8),
            Row(
              children: UrgentLevel.values.map((v) {
                final isSelected = _urgency == v;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _urgency = v),
                    child: Container(
                      margin:
                          const EdgeInsets.symmetric(horizontal: 4),
                      padding:
                          const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF0D2137)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                            color: isSelected
                                ? const Color(0xFF0D2137)
                                : const Color(0x1A9E9E9E)),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        v.toString().split('.').last.toUpperCase(),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: isSelected
                              ? Colors.white
                              : Colors.black87,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0D2137),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  if (_purposeController.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text(
                                "Please enter the purpose of your appointment")));
                    return;
                  }
                  final user = provider.currentUser;
                  final scheduledDateTime = DateTime(
                    _selectedDate.year,
                    _selectedDate.month,
                    _selectedDate.day,
                    _selectedTime.hour,
                    _selectedTime.minute,
                  );
                  final apt = Appointment(
                    id: "a_${DateTime.now().millisecondsSinceEpoch}",
                    requesterName: user?.name ?? "Guest",
                    requesterId: user?.id ?? "g1",
                    leaderId:
                        _chosenLeader?.id ?? provider.leaders[0].id,
                    purpose: _purposeController.text.trim(),
                    dateTime: scheduledDateTime,
                    urgency: _urgency,
                    durationMinutes: _durationMinutes,
                    status: AppointmentStatus.pending,
                  );
                  provider.addAppointment(apt);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text(
                        "Appointment request submitted successfully!"),
                    backgroundColor: Colors.green,
                  ));
                  Navigator.pop(context);
                },
                child: const Text("Submit Appointment Request",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
