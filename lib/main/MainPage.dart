import 'package:flutter/material.dart';
import 'package:universis/auth/auth.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String? _token;
  String _status = "Logging in...";

  @override
  void initState() {
    super.initState();
    _loginAndGetToken();
  }

  Future<void> _loginAndGetToken() async {
    try {
      final token = await AuthClient().login("2342", "wolckcho54!");
      setState(() {
        _token = token;
      });
    } catch (e) {
      setState(() {
        _status = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Universis Auth")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              _status,
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16),
            if (_token != null && _token != "invalid")
              SelectableText(
                "Token:\n$_token",
                style: const TextStyle(fontSize: 14),
              ),
          ],
        ),
      ),
    );
  }
}
