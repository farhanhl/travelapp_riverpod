import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:travel/features/domain/entities/trip.dart';
import 'package:travel/features/presentasion/providers/trip_provider.dart';

class AddTripScreen extends ConsumerWidget {
  final _formkey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _dateController = TextEditingController();

  AddTripScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Form(
      key: _formkey,
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Text(
              "Got new idea for your new trip? 🏝️",
              maxLines: 2,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          TextFormField(
            controller: _titleController,
            decoration: const InputDecoration(labelText: "Title"),
          ),
          TextFormField(
            controller: _descriptionController,
            decoration: const InputDecoration(labelText: "Description"),
          ),
          TextFormField(
            controller: _locationController,
            decoration: const InputDecoration(labelText: "Location"),
          ),
          TextFormField(
            controller: _dateController,
            decoration: const InputDecoration(labelText: "Date"),
            onTap: () => _selectDate(context),
          ),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: ElevatedButton(
              onPressed: () => _submitForm(_formkey, ref, context),
              child: const Text("Submit"),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != DateTime.now()) {
      _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
    }
  }

  Future<void> _submitForm(
    GlobalKey<FormState> key,
    WidgetRef ref,
    BuildContext context,
  ) async {
    try {
      if (key.currentState!.validate()) {
        final newTrip = Trip(
          title: _titleController.text,
          description: _descriptionController.text,
          date: DateTime.parse(_dateController.text),
          location: _locationController.text,
        );

        ref.read(tripListNotifierProvider.notifier).addNewTrip(newTrip);
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Lottie.asset(
                    'assets/lotties/success.json',
                    width: 200,
                    height: 200,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Good Idea!',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Back'),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Lottie.asset(
                  'assets/lotties/error.json',
                  width: 200,
                  height: 200,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Something Went Wrong!',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Back'),
                ),
              ],
            ),
          );
        },
      );
    }
  }
}
