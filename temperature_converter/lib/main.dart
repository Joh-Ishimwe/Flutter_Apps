import 'package:flutter/material.dart';

// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart'; // Import for formatting date

void main() => runApp(const TemperatureConverterApp());

class TemperatureConverterApp extends StatelessWidget {
  const TemperatureConverterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Temperature Converter',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const TemperatureConverterScreen(),
    );
  }
}

class TemperatureConverterScreen extends StatefulWidget {
  const TemperatureConverterScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TemperatureConverterScreenState createState() =>
      _TemperatureConverterScreenState();
}

class _TemperatureConverterScreenState
    extends State<TemperatureConverterScreen> {
  String _selectedConversion = 'F to C'; // Ensure one conversion is always selected
  final TextEditingController _inputController = TextEditingController();
  double? _convertedValue;
  final List<Map<String, String>> _history = []; // Updated to store map with date and conversion

  // Conversion functions
  double _fahrenheitToCelsius(double fahrenheit) =>
      (fahrenheit - 32) * 5 / 9;

  double _celsiusToFahrenheit(double celsius) =>
      (celsius * 9 / 5) + 32;

  // Show error if input is not a valid number
  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _convert() {
    String inputText = _inputController.text;

    // Validate if the input is a valid number
    double? inputTemperature = double.tryParse(inputText);

    if (inputTemperature == null) {
      // If input is not a number, show error message
      _showError('Please enter a valid number.');
      return; // Do not proceed with conversion
    }

    double result;
    String conversion;

    if (_selectedConversion == 'F to C') {
      result = _fahrenheitToCelsius(inputTemperature);
      conversion = 'F to C: ${inputTemperature.toStringAsFixed(1)} => ${result.toStringAsFixed(2)}';
    } else {
      result = _celsiusToFahrenheit(inputTemperature);
      conversion = 'C to F: ${inputTemperature.toStringAsFixed(1)} => ${result.toStringAsFixed(2)}';
    }

    String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.now()); // Get current date

    setState(() {
      _convertedValue = result;
      // Store both conversion and date
      _history.insert(0, {'date': formattedDate, 'conversion': conversion});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
              child: Text(
                'Temperature Converter',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            // Degrees input and type selection in a row 
            Row(
              children: [
                // Degrees input field
                Expanded(
                  child: TextField(
                    controller: _inputController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Degrees',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 16),

                // Conversion type dropdown 
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedConversion,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedConversion = newValue!;
                      });
                    },
                    items: const [
                      DropdownMenuItem(
                        value: 'F to C',
                        child: Text('Fahrenheit to Celsius'),
                      ),
                      DropdownMenuItem(
                        value: 'C to F',
                        child: Text('Celsius to Fahrenheit'),
                      ),
                    ],
                    decoration: const InputDecoration(
                      labelText: 'Type',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Convert button 
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50.0), 
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _convert,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue, 
                  ),
                  child: const Text('Convert'),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Display converted value
            if (_convertedValue != null)
              Center(
                child: Text(
                  'Converted: ${_convertedValue!.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 24),
                ),
              ),
              
            const SizedBox(height: 20),

            // Conversion history with date and delete icon
            const Text('History of conversions:'),
            Expanded(
              child: ListView.builder(
                itemCount: _history.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('${_history[index]['date']} - ${_history[index]['conversion']}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        setState(() {
                          _history.removeAt(index);
                        });
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
