import 'package:flutter/material.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Prevent screenshot / screen recording
  await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: QuizPage(),
    );
  }
}

class QuizPage extends StatefulWidget {
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int? selectedAnswer;
  bool isSubmitting = false;
  bool next = false;
  final List<Map<String, dynamic>> questions = [
    {
      "question": "What is the boiling point of water at sea level?",
      "options": ["90°C", "100°C", "80°C", "120°C"],
      "answerIndex": 1,
    },
    {
      "question": "Which gas do humans exhale during respiration?",
      "options": ["Oxygen", "Carbon Dioxide", "Nitrogen", "Hydrogen"],
      "answerIndex": 1,
    },
    {
      "question": "Which planet is known as the Red Planet?",
      "options": ["Earth", "Mars", "Venus", "Jupiter"],
      "answerIndex": 1,
    },
    {
      "question": "Which part of the plant carries out photosynthesis?",
      "options": ["Root", "Stem", "Leaf", "Flower"],
      "answerIndex": 2,
    },
    {
      "question": "What is the chemical symbol for Gold?",
      "options": ["Ag", "Au", "Gd", "Go"],
      "answerIndex": 1,
    },
    {
      "question": "What is the closest star to Earth?",
      "options": ["Moon", "Sun", "Alpha Centauri", "Sirius"],
      "answerIndex": 1,
    },

    {
      "question": "What is the largest planet in our Solar System?",
      "options": ["Earth", "Saturn", "Jupiter", "Neptune"],
      "answerIndex": 2,
    },
    {
      "question": "What is H2O commonly known as?",
      "options": ["Oxygen", "Hydrogen", "Salt", "Water"],
      "answerIndex": 3,
    },
    {
      "question": "Which galaxy is Earth located in?",
      "options": ["Andromeda Galaxy", "Milky Way Galaxy", "Whirlpool Galaxy", "Sombrero Galaxy"],
      "answerIndex": 1,
    },
    {
      "question": "Which instrument is used to measure temperature?",
      "options": ["Barometer", "Thermometer", "Hygrometer", "Compass"],
      "answerIndex": 1,
    },
  ];
  //final List<String> question = ["What is boiling point of water at sea level", "Which gas do human exhausted during respiration?", "Which planet is known as Red Planet?"];
  int q_num = 0;
  int points = 0;
  @override
  Widget build(BuildContext context) {
    if (selectedAnswer != null && questions[q_num]["answerIndex"] == selectedAnswer) {
      points += 10;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showSuccessDialog(context);
      });
    }
    if(selectedAnswer != null && questions[q_num]["answerIndex"] != selectedAnswer){
      points -=10;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showFailureDialog(context);
      });
    }

    if(next != false && q_num != questions.length - 1){
      q_num++;
    }
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          "Quiz Challenge",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Progress indicator
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              child: Row(
                children: [
                  Text(
                    "Question ${q_num+1} of 10",

                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                   Text(
                    "${points} points",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.deepPurple,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // Progress bar
            Container(
              margin: EdgeInsets.only(bottom: 30),
              child: LinearProgressIndicator(
                value: 0.1*(q_num+1),
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple),
                minHeight: 6,
              ),
            ),

            // Question card
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(24),
              margin: EdgeInsets.only(bottom: 30),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 0,
                    blurRadius: 10,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.quiz,
                    color: Colors.deepPurple,
                    size: 32,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "${questions[q_num]["question"]}",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),

            // Options
            ...questions[q_num]["options"].asMap().entries.map((entry) {
              int idx = entry.key;
              String option = entry.value;
              bool isSelected = selectedAnswer == idx;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedAnswer = idx;
                    next = false;
                  });
                },
                child: Container(
                  margin: EdgeInsets.only(bottom: 12),
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.deepPurple.withOpacity(0.1) : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? Colors.deepPurple : Colors.grey[300]!,
                      width: isSelected ? 2 : 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.05),
                        spreadRadius: 0,
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected ? Colors.deepPurple : Colors.grey[400]!,
                            width: 2,
                          ),
                          color: isSelected ? Colors.deepPurple : Colors.transparent,
                        ),
                        child: isSelected
                            ? const Icon(
                          Icons.check,
                          size: 16,
                          color: Colors.white,
                        )
                            : null,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          option,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                            color: isSelected ? Colors.deepPurple : Colors.grey[700],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),

            const SizedBox(height: 30),

            // Submit button
            Container(
              width: double.infinity,
              height: 56,
              child: RaisedButton(
                onPressed: selectedAnswer != null && !isSubmitting
                    ? _submitAnswer
                    : null,
                color: Colors.deepPurple,
                textColor: Colors.white,
                disabledColor: Colors.grey[300],
                disabledTextColor: Colors.grey[600],
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: isSubmitting
                    ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                    SizedBox(width: 12),
                    Text(
                      "Submitting...",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                )
                    : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.send, size: 20),
                    SizedBox(width: 8),
                    Text(
                      "Submit Answer",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submitAnswer() async {
    if (selectedAnswer == null) return;

    setState(() {
      isSubmitting = true;
    });

    try {
      // Simulate network delay
      await Future.delayed(Duration(seconds: 1));

      // Save answer to database
      await saveAnswer(selectedAnswer!);

      // Show success popup
      _showSuccessDialog(context);
    } catch (e) {
      // Show error dialog
      _showErrorDialog(context);
    } finally {
      if (mounted) {
        setState(() {
          isSubmitting = false;
        });
      }
    }
  }

  void _showSuccessDialog(context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        content: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 40,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "Success!",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Your response has been successfully submitted.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              "Close",
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
              ),
            ),
          ),
          RaisedButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Reset for next question
              setState(() {
                selectedAnswer = null;
                next = true;
              });
            },
            color: Colors.deepPurple,
            textColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              "Next Question",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
  void _showFailureDialog(context) {
    showDialog(
      context: context,
      barrierDismissible: false, // user cannot dismiss by tapping outside
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        content: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.cancel,
                  color: Colors.red,
                  size: 40,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "Oops!",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "That’s the wrong answer. Try the next one!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              "Close",
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
              ),
            ),
          ),
          RaisedButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Reset for next question
              setState(() {
                selectedAnswer = null;
                next = true;
              });
            },
            color: Colors.red,
            textColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              "Next Question",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }


  void _showErrorDialog(context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: const [
            Icon(Icons.error_outline, color: Colors.red),
            SizedBox(width: 8),
            Text("Error"),
          ],
        ),
        content: const Text("Failed to submit your answer. Please try again."),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  Future<void> saveAnswer(int answer) async {
    try {
      final dbPath = await getDatabasesPath();
      final path = join(dbPath, 'quiz.db');

      final db = await openDatabase(
        path,
        version: 1,
        onCreate: (Database db, int version) async {
          await db.execute(
            'CREATE TABLE IF NOT EXISTS answers (id INTEGER PRIMARY KEY AUTOINCREMENT, answer INTEGER, timestamp DATETIME DEFAULT CURRENT_TIMESTAMP)',
          );
        },
      );

      await db.insert('answers', {
        'answer': answer,
        'timestamp': DateTime.now().toIso8601String(),
      });

      await db.close();
    } catch (e) {
      print('Error saving answer: $e');
      rethrow;
    }
  }
}
