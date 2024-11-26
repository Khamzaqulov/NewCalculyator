import 'package:flutter/material.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({Key? key}) : super(key: key);

  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _output = '';

  void _buttonPressed(String value) {
    setState(() {
      if (value == 'C') {
        _output = ''; 
      } else if (value == '=') {
        try {
          _output = _calculateOutput(_output);
        } catch (e) {
          _output = 'Error'; 
        }
      } else {
        _output += value; 
      }
    });
  }

  
  String _calculateOutput(String input) {
    try {
      
      input = input.replaceAll('x', '*').replaceAll('%', '/100');

      List<String> tokens = _tokenize(input);
      double result = _evaluateExpression(tokens);

      return result.toString();
    } catch (_) {
      return 'Error'; 
    }
  }

  List<String> _tokenize(String input) {
    List<String> tokens = [];
    String number = '';
    for (int i = 0; i < input.length; i++) {
      String char = input[i];
      if ('0123456789.'.contains(char)) {
        number += char; 
      } else if ('+-*/'.contains(char)) {
        if (number.isNotEmpty) {
          tokens.add(number);
          number = '';
        }
        tokens.add(char); 
      }
    }
    if (number.isNotEmpty) {
      tokens.add(number); 
    }
    return tokens;
  }


  double _evaluateExpression(List<String> tokens) {

    for (int i = 0; i < tokens.length; i++) {
      if (tokens[i] == '*' || tokens[i] == '/') {
        double left = double.parse(tokens[i - 1]);
        double right = double.parse(tokens[i + 1]);
        double result;
        if (tokens[i] == '*') {
          result = left * right;
        } else {
          result = left / right;
        }
        tokens[i - 1] = result.toString();
        tokens.removeAt(i);
        tokens.removeAt(i); 
        i--;
      }
    }

    double result = double.parse(tokens[0]);
    for (int i = 1; i < tokens.length; i += 2) {
      String operator = tokens[i];
      double value = double.parse(tokens[i + 1]);
      if (operator == '+') {
        result += value;
      } else if (operator == '-') {
        result -= value;
      }
    }
    return result;
  }
  Widget _buildButton(String text,
      {Color color = const Color.fromARGB(255, 234, 229, 229)}) {
    return Container(
      margin: const EdgeInsets.all(4),
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.zero, 
          ),
          textStyle: const TextStyle(fontSize: 20),
        ),
        onPressed: () => _buttonPressed(text),
        child: Text(
          text,
          style: const TextStyle(color: Colors.black),
        ),
      ),
    );
  }

@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculator'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              alignment: Alignment.centerRight,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue, width: 2),
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              height: 100,
              width: double.infinity,
              child: Text(
                _output,
                style: const TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          // Calculator buttons grid
          Expanded(
            flex: 3,
            child: GridView.count(
              crossAxisCount: 4,
              childAspectRatio: 1,
              padding: const EdgeInsets.all(70),
              crossAxisSpacing: 8,
              mainAxisSpacing: 30,
              children: [
                _buildButton('7', color: Colors.blue.shade100),
                _buildButton('8', color: Colors.blue.shade100),
                _buildButton('9', color: Colors.blue.shade100),
                _buildButton('C', color: Colors.blue.shade100),
                _buildButton('4', color: Colors.blue.shade100),
                _buildButton('5', color: Colors.blue.shade100),
                _buildButton('6', color: Colors.blue.shade100),
                _buildButton('+', color: Colors.blue.shade100),
                _buildButton('1', color: Colors.blue.shade100),
                _buildButton('2', color: Colors.blue.shade100),
                _buildButton('3', color: Colors.blue.shade100),
                _buildButton('-', color: Colors.blue.shade100),
                _buildButton('0', color: Colors.blue.shade100),
                _buildButton('x', color: Colors.blue.shade100),
                _buildButton('%', color: Colors.blue.shade100),
                _buildButton('=', color: Colors.blue.shade100),
              ],
            ),
          ),
        ],
      ),
    );
  }
}