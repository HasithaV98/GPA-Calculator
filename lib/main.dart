import 'package:flutter/material.dart';
//import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //await Firebase.initializeApp();
  runApp(GPAApp());
}

class GPAApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GPA Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: CalculatePage(),
    );
  }
}

class CalculatePage extends StatefulWidget {
  @override
  CalculatePageState createState() => CalculatePageState();
}

class CalculatePageState extends State<CalculatePage> {
  List<TextEditingController> gradeControllers = [];
  List<TextEditingController> creditControllers = [];
  TextEditingController nameController = TextEditingController();
  int subjectCount = 5;
  String name = '';
  double gpa = 0.0;

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < subjectCount; i++) {
      gradeControllers.add(TextEditingController());
      creditControllers.add(TextEditingController());
    }
    displayGPA();
  }

  @override
  void dispose() {
    for (var controller in gradeControllers) {
      controller.dispose();
    }
    for (var controller in creditControllers) {
      controller.dispose();
    }
    nameController.dispose();
    super.dispose();
  }

  double calculateGPA() {
    double totalGradePoints = 0;
    int totalCredits = 0;

    for (int i = 0; i < subjectCount; i++) {
      double grade = double.tryParse(gradeControllers[i].text) ?? 0;
      int credit = int.tryParse(creditControllers[i].text) ?? 0;

      totalGradePoints += grade * credit;
      totalCredits += credit;
    }

    if (totalCredits == 0) {
      return 0;
    }

    return totalGradePoints / totalCredits;
  }

  void displayGPA() {
    setState(() {
      name = nameController.text;
      gpa = calculateGPA();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('GPA Calculator'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text(
              'Enter Student Name:',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            SizedBox.square(),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Student Name',
                border: OutlineInputBorder(),
              ),
              onChanged: (_) => displayGPA(),
            ),
            SizedBox(height: 16.0),
            Text(
              'Enter Subject, Course GP, Course Credits',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                itemCount: subjectCount,
                itemBuilder: (BuildContext context, int index) {
                  return Row(
                    children: [
                      SizedBox(
                        width: 16.0,
                        height: 10.0,
                      ),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            labelText: 'Subject',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.text,
                          onChanged: (_) => displayGPA(),
                        ),
                      ),
                      SizedBox(width: 20.0),
                      Expanded(
                        child: TextField(
                          controller: gradeControllers[index],
                          decoration: InputDecoration(
                            labelText: 'Course GP',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          onChanged: (_) => displayGPA(),
                        ),
                      ),
                      SizedBox(width: 20.0),
                      Expanded(
                        child: TextField(
                          controller: creditControllers[index],
                          decoration: InputDecoration(
                            labelText: 'Course Credit',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          onChanged: (_) => displayGPA(),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            SizedBox(height: 10.0),
            SizedBox(height: 10.0),
            Text(
              'Student Name:$name ',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'GPA: $gpa',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
