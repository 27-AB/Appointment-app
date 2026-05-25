// ==========================================
// REGISTER SCREEN
// Author: [Llidiya— Auth Screens]
// ==========================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../providers/app_state_provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _deptController = TextEditingController();
  UserRole _selectedRole = UserRole.student;
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  String? _error;
  bool _isLoading = false;

  void _handleRegister() {
    setState(() => _error = null);
    if (_passwordController.text != _confirmPasswordController.text) {
      setState(() => _error = "Passwords do not match.");
      return;
    }
    setState(() => _isLoading = true);
    Future.delayed(const Duration(milliseconds: 400), () {
      final error =
          Provider.of<AppStateProvider>(context, listen: false).register(
        name: _nameController.text,
        email: _emailController.text,
        password: _passwordController.text,
        role: _selectedRole,
        department: _deptController.text,
      );
      if (error != null) {
        setState(() {
          _isLoading = false;
          _error = error;
        });
      } else {
        Navigator.pop(context);
      }
    });
  }

  Widget _label(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Text(text,
            style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 13,
                color: Color(0xFF334155))),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create Account")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Create your ASTU Account",
                style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 20,
                    color: Color(0xFF0D2137))),
            const SizedBox(height: 4),
            const Text(
                "Fill in your details. You'll use your email and password to sign in.",
                style: TextStyle(
                    color: Colors.grey, fontSize: 13, height: 1.4)),
            const SizedBox(height: 24),
            if (_error != null) ...[
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0x12F44336),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0x44F44336)),
                ),
                child: Row(children: [
                  const Icon(Icons.error_outline,
                      color: Colors.red, size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                      child: Text(_error!,
                          style: const TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                              fontWeight: FontWeight.w600))),
                ]),
              ),
              const SizedBox(height: 16),
            ],
            _label("Full Name *"),
            TextField(
                controller: _nameController,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                    hintText: "e.g. Birhane Tamirat",
                    prefixIcon: Icon(Icons.person_outline))),
            const SizedBox(height: 14),
            _label("Institutional Email *"),
            TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                    hintText: "your.name@astu.edu.et",
                    prefixIcon: Icon(Icons.email_outlined))),
            const SizedBox(height: 14),
            _label("Department / College"),
            TextField(
                controller: _deptController,
                decoration: const InputDecoration(
                    hintText: "e.g. Electrical Engineering",
                    prefixIcon: Icon(Icons.apartment_outlined))),
            const SizedBox(height: 14),
            _label("Role"),
            DropdownButtonFormField<UserRole>(
              value: _selectedRole,
              decoration:
                  const InputDecoration(prefixIcon: Icon(Icons.badge_outlined)),
              items: const [
                DropdownMenuItem(
                    value: UserRole.student, child: Text("Student")),
                DropdownMenuItem(
                    value: UserRole.staff, child: Text("Faculty / Staff")),
                DropdownMenuItem(
                    value: UserRole.secretary,
                    child: Text("Department Secretary")),
              ],
              onChanged: (val) {
                if (val != null) setState(() => _selectedRole = val);
              },
            ),
            const SizedBox(height: 14),
            _label("Password *"),
            TextField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              decoration: InputDecoration(
                hintText: "At least 6 characters",
                prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: IconButton(
                  icon: Icon(_obscurePassword
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined),
                  onPressed: () =>
                      setState(() => _obscurePassword = !_obscurePassword),
                ),
              ),
            ),
            const SizedBox(height: 14),
            _label("Confirm Password *"),
            TextField(
              controller: _confirmPasswordController,
              obscureText: _obscureConfirm,
              decoration: InputDecoration(
                hintText: "Re-enter password",
                prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: IconButton(
                  icon: Icon(_obscureConfirm
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined),
                  onPressed: () =>
                      setState(() => _obscureConfirm = !_obscureConfirm),
                ),
              ),
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0D2137),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: _isLoading ? null : _handleRegister,
                child: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2))
                    : const Text("Create Account",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15)),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account? ",
                      style: TextStyle(color: Colors.grey, fontSize: 13)),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Text("Sign In",
                        style: TextStyle(
                            color: Color(0xFF1B3B5F),
                            fontWeight: FontWeight.bold,
                            fontSize: 13)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
