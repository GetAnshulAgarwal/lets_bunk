import 'package:flutter/material.dart';

class AttendanceHomePage extends StatefulWidget {
  const AttendanceHomePage({super.key});

  @override
  _AttendanceHomePageState createState() => _AttendanceHomePageState();
}

class _AttendanceHomePageState extends State<AttendanceHomePage> {
  final TextEditingController _attendedController = TextEditingController();
  final TextEditingController _totalController = TextEditingController();
  String _result = "";
  int _selectedPercentageIndex = 1; // Default is 75%
  final List<int> _percentages = [70, 75, 80, 85, 90];

  void _calculateAttendance() {
    final String totalText = _totalController.text;
    final String attendedText = _attendedController.text;

    // Validate input values
    if (totalText.isEmpty || attendedText.isEmpty) {
      setState(() {
        _result =
            "🚨 Oops! Please enter both total classes and classes attended. 📉";
      });
      return;
    }

    final int attended = int.tryParse(attendedText) ?? 0;
    final int total = int.tryParse(totalText) ?? 0;

    if (total <= 0) {
      setState(() {
        _result = "🚨 Total classes must be greater than zero. 🛑";
      });
      return;
    }

    if (attended < 0) {
      setState(() {
        _result = "🚨 Classes attended cannot be negative. ❌";
      });
      return;
    }

    if (attended > total) {
      setState(() {
        _result = "🚨 Classes attended cannot exceed total classes. 📊";
      });
      return;
    }

    final int selectedPercentage = _percentages[_selectedPercentageIndex];
    final double currentAttendancePercentage = (attended / total) * 100;

    // Calculate the minimum classes that need to be attended to meet the selected percentage
    (total * selectedPercentage / 100).ceil();

    // Calculate how many more classes are needed to meet the selected percentage
    int futureTotalClasses = total;
    int futureAttendedClasses = attended;

    // Case 1: If current attendance is less than required percentage
    int classesToAttend = 0;
    if (currentAttendancePercentage < selectedPercentage) {
      while ((futureAttendedClasses / futureTotalClasses) * 100 <
          selectedPercentage) {
        futureTotalClasses++;
        futureAttendedClasses++;
        classesToAttend++;
      }
    }

    // Reset future classes to original values for the next calculation
    futureTotalClasses = total;
    futureAttendedClasses = attended;

    // Case 2: If current attendance is equal to or more than required percentage
    int skippableClasses = 0;
    while ((futureAttendedClasses / futureTotalClasses) * 100 >=
        selectedPercentage) {
      futureTotalClasses++;
      skippableClasses++;
    }
    skippableClasses--; // The last iteration exceeds the skippable limit

    setState(() {
      _result =
          "📚 Hi Fellow Scholar 👋\n\nYour Current Percentage: ${currentAttendancePercentage.toStringAsFixed(2)}%.\n\n";

      if (currentAttendancePercentage < selectedPercentage) {
        _result +=
            "😓 Oops! You need to attend $classesToAttend more class(es) to reach $selectedPercentage%.\n";
      } else {
        _result += "🎉 Congratulations! You've reached $selectedPercentage%.\n";
      }

      if (skippableClasses > 0) {
        _result +=
            "😎 You can skip $skippableClasses more class(es) without dropping below $selectedPercentage%.\n\nEnjoy!";
      } else {
        _result +=
            "🚨 Oops! You cannot skip any more classes without dropping below $selectedPercentage% attendance.\n\nKeep attending!";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      body: SingleChildScrollView(
        // Add this
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SizedBox(height: 50), // Adjust top margin as needed
              const Text(
                "Let's Bunk 🎒",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                  shadows: [
                    Shadow(
                      blurRadius: 10.0,
                      color: Colors.black38,
                      offset: Offset(2.0, 2.0),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _totalController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Total Classes Conducted',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  filled: true,
                  fillColor: Colors.lightBlue[100],
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _attendedController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Classes Attended',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  filled: true,
                  fillColor: Colors.lightBlue[100],
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Required Percentage",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.deepPurple,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              ToggleButtons(
                isSelected: List.generate(_percentages.length,
                    (index) => index == _selectedPercentageIndex),
                borderRadius: BorderRadius.circular(20),
                selectedColor: Colors.white,
                fillColor: Colors.purpleAccent,
                children: _percentages
                    .map((percentage) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text('$percentage%',
                              style: const TextStyle(fontSize: 16)),
                        ))
                    .toList(),
                onPressed: (int index) {
                  setState(() {
                    _selectedPercentageIndex = index;
                  });
                },
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _calculateAttendance,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple[300],
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text(
                  'Calculate 📊',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
              const SizedBox(
                  height: 20), // Add some space before result container
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.lightBlue[200]!, Colors.purple[200]!],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      offset: Offset(0, 4),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: Text(
                  _result,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    height: 1.5,
                    fontFamily: 'Comic Sans MS',
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              const SizedBox(height: 20), // Add some space at the bottom
            ],
          ),
        ),
      ),
    );
  }
}
