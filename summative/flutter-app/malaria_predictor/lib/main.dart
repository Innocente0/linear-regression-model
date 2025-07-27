import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(const MalariaPredictApp());

class MalariaPredictApp extends StatelessWidget {
  const MalariaPredictApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Malaria Prediction',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: const PredictionForm(),
    );
  }
}

class PredictionForm extends StatefulWidget {
  const PredictionForm({Key? key}) : super(key: key);

  @override
  _PredictionFormState createState() => _PredictionFormState();
}

class _PredictionFormState extends State<PredictionForm> {
  final _formKey = GlobalKey<FormState>();
  final _yearController = TextEditingController();
  final _deathsController = TextEditingController();
  String _result = '';

  // Replace with your actual endpoint
  static const String apiUrl = 'https://rwanda-malaria-api.onrender.com/predict';

  Future<void> _predict() async {
    if (!_formKey.currentState!.validate()) return;

    final int year = int.parse(_yearController.text);
    final double deaths = double.parse(_deathsController.text);

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'year': year,
          'deaths_median': deaths,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _result = "Predicted cases: ${data['predicted_cases']}";
        });
      } else {
        setState(() {
          _result = "Error ${response.statusCode}: ${response.body}";
        });
      }
    } catch (e) {
      setState(() {
        _result = 'Request failed: $e';
      });
    }
  }

  @override
  void dispose() {
    _yearController.dispose();
    _deathsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Malaria Case Predictor')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _yearController,
                decoration: const InputDecoration(labelText: 'Year'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Enter a year';
                  final y = int.tryParse(value);
                  if (y == null) return 'Year must be an integer';
                  if (y < 2000 || y > 2030) return 'Year must be 2000–2030';
                  return null;
                },
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _deathsController,
                decoration: const InputDecoration(labelText: 'Median Deaths'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Enter deaths';
                  final d = double.tryParse(value);
                  if (d == null) return 'Deaths must be a number';
                  if (d < 0) return 'Deaths cannot be negative';
                  return null;
                },
              ),

              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: _predict,
                child: const Text('Predict'),
              ),

              const SizedBox(height: 24),

              Text(
                _result,
                style: const TextStyle(fontSize: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
