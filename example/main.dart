import 'package:flutter/material.dart';
import 'package:bingo/bingo.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bingo.setup();

  // Mapping the User factory for Bingo's deep casting logic
  Bingo.register<User>((json) => User.fromJson(json));

  runApp(const BingoExampleApp());
}

class BingoExampleApp extends StatelessWidget {
  const BingoExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0D1117),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.cyanAccent,
          brightness: Brightness.dark,
        ),
      ),
      home: const BingoDashboard(),
    );
  }
}

class BingoDashboard extends StatefulWidget {
  const BingoDashboard({super.key});

  @override
  State<BingoDashboard> createState() => _BingoDashboardState();
}

class _BingoDashboardState extends State<BingoDashboard> {
  final List<String> _logs = ["👾 Bingo Console Active"];

  // Controllers for User Object Input
  final _uIdCtrl = TextEditingController();
  final _uNameCtrl = TextEditingController();
  final _uEmailCtrl = TextEditingController();
  final _uKeyCtrl = TextEditingController();

  // Controllers for Retrieval & Deletion
  final _queryCtrl = TextEditingController();
  final _deleteCtrl = TextEditingController();

  dynamic _queryResult;
  String _resultType = "None";

  void _log(String msg) =>
      setState(() => _logs.insert(0, "[${DateTime.now().second}s] $msg"));

  void _fetchData() {
    final key = _queryCtrl.text.trim();
    if (key.isEmpty) {
      setState(() {
        _queryResult = null;
        _resultType = "None";
      });
      return;
    }

    // Attempting to call as User first, fallback to dynamic
    dynamic result;
    try {
      result = Bingo.call<User>(key);
    } catch (_) {
      result = Bingo.call<dynamic>(key);
    }

    setState(() {
      _queryResult = result;
      _resultType = result?.runtimeType.toString() ?? "Null";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "B I N G O",
          style: TextStyle(letterSpacing: 4, fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        centerTitle: true,
        foregroundColor: Colors.cyanAccent,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // 1. USER GENERATOR (Now the main entry point)
            _sectionHeader("USER GENERATOR"),
            _glassContainer(
              child: Column(
                children: [
                  TextField(
                    controller: _uKeyCtrl,
                    decoration: const InputDecoration(
                      labelText: "Storage Key (Unique)",
                      prefixIcon: Icon(Icons.key, size: 18),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _uIdCtrl,
                          decoration: const InputDecoration(
                            labelText: "User ID",
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: _uNameCtrl,
                          decoration: const InputDecoration(labelText: "Name"),
                        ),
                      ),
                    ],
                  ),
                  TextField(
                    controller: _uEmailCtrl,
                    decoration: const InputDecoration(
                      labelText: "Email Address",
                    ),
                  ),
                  const SizedBox(height: 20),
                  _neonButton(
                    text: "GENERATE & MARK USER",
                    onTap: () {
                      if (_uKeyCtrl.text.isEmpty) {
                        _log("⚠️ Error: Storage Key is required.");
                        return;
                      }
                      final user = User(
                        id: _uIdCtrl.text,
                        name: _uNameCtrl.text,
                        email: _uEmailCtrl.text,
                      );
                      Bingo.mark(_uKeyCtrl.text, user);
                      _log(
                        "👤 User '${user.name}' marked at key '${_uKeyCtrl.text}'",
                      );
                      _uKeyCtrl.clear();
                      _uIdCtrl.clear();
                      _uNameCtrl.clear();
                      _uEmailCtrl.clear();
                      setState(() {});
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),

            // 2. RETRIEVAL MODULE
            _sectionHeader("USER DATA RETRIEVAL"),
            _glassContainer(
              child: Column(
                children: [
                  TextField(
                    controller: _queryCtrl,
                    onChanged: (_) => _fetchData(),
                    decoration: const InputDecoration(
                      labelText: "Enter Key to Fetch",
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "TYPE: $_resultType",
                          style: const TextStyle(
                            color: Colors.cyanAccent,
                            fontSize: 10,
                          ),
                        ),
                        const Divider(color: Colors.white10),
                        Text(
                          _queryResult?.toString() ?? "No record found",
                          style: TextStyle(
                            fontSize: 13,
                            color: _queryResult == null
                                ? Colors.grey
                                : Colors.white,
                            fontFamily: 'monospace',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),

            // 3. DESTRUCTION MODULE (Delete & Clear)
            _sectionHeader("DESTRUCTION MODULE"),
            _glassContainer(
              child: Column(
                children: [
                  TextField(
                    controller: _deleteCtrl,
                    decoration: const InputDecoration(
                      labelText: "Key to Erase",
                      prefixIcon: Icon(
                        Icons.delete_outline,
                        color: Colors.redAccent,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Expanded(
                        child: _neonButton(
                          text: "ERASE KEY",
                          color: Colors.redAccent,
                          onTap: () {
                            if (_deleteCtrl.text.isNotEmpty) {
                              Bingo.erase(_deleteCtrl.text);
                              _log("🗑️ Erased key: ${_deleteCtrl.text}");
                              _deleteCtrl.clear();
                              _fetchData(); // Update retrieval if current key was deleted
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _neonButton(
                          text: "CLEAR ALL",
                          color: Colors.orangeAccent,
                          onTap: () {
                            Bingo.clear();
                            _log("☢️ DATABASE WIPED");
                            _fetchData();
                            setState(() {});
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),

            // 4. LOGS
            _sectionHeader("SYSTEM LOGS"),
            Container(
              height: 120,
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.white10),
              ),
              child: ListView.builder(
                itemCount: _logs.length,
                itemBuilder: (context, i) => Text(
                  _logs[i],
                  style: const TextStyle(
                    color: Colors.greenAccent,
                    fontFamily: 'monospace',
                    fontSize: 11,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- REUSABLE UI BUILDERS ---

  Widget _sectionHeader(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8, left: 4),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
            letterSpacing: 1.5,
          ),
        ),
      ),
    );
  }

  Widget _glassContainer({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.cyanAccent.withAlpha(40)),
        borderRadius: BorderRadius.circular(15),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.cyan.withAlpha(15), Colors.transparent],
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: child,
    );
  }

  Widget _neonButton({
    required String text,
    required VoidCallback onTap,
    Color color = Colors.cyanAccent,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: const EdgeInsets.all(12),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(color: color.withAlpha(80)),
          borderRadius: BorderRadius.circular(999),
          gradient: LinearGradient(
            colors: [color.withAlpha(60), Colors.transparent],
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ),
    );
  }
}

class User {
  final String id, name, email;
  User({required this.id, required this.name, required this.email});

  factory User.fromJson(Map<String, dynamic> json) =>
      User(id: json['id'], name: json['name'], email: json['email']);
  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'email': email};

  @override
  String toString() => "User(ID: $id, Name: $name, Email: $email)";
}
