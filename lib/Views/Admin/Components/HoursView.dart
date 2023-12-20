import 'package:flutter/material.dart';
import 'package:glassmorphism_widgets/glassmorphism_widgets.dart';

import '../../../Controllers/Store/StoreController.dart';

class HoursView extends StatefulWidget {
  final StoreController controller;

  const HoursView({Key? key, required this.controller}) : super(key: key);

  @override
  HoursViewState createState() => HoursViewState();
}

class HoursViewState extends State<HoursView> {
  final _daysOfWeek = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: _daysOfWeek.map((day) => _buildDayHours(day)).toList(),
    );
  }

  Widget _buildDayHours(String day) {
    TextEditingController openController = TextEditingController();
    TextEditingController closeController = TextEditingController();

    switch (day) {
      case 'Monday':
        openController = widget.controller.mondayOpenController;
        closeController = widget.controller.mondayCloseController;
        break;

      case 'Tuesday':
        openController = widget.controller.tuesdayOpenController;
        closeController = widget.controller.tuesdayCloseController;
        break;
      case 'Wednesday':
        openController = widget.controller.wednesdayOpenController;
        closeController = widget.controller.wednesdayCloseController;
        break;

      case 'Thursday':
        openController = widget.controller.thursdayOpenController;
        closeController = widget.controller.thursdayCloseController;
        break;

      case 'Friday':
        openController = widget.controller.fridayOpenController;
        closeController = widget.controller.fridayCloseController;
        break;

      case 'Saturday':
        openController = widget.controller.saturdayOpenController;
        closeController = widget.controller.saturdayCloseController;
        break;

      case 'Sunday':
        openController = widget.controller.sundayOpenController;
        closeController = widget.controller.sundayCloseController;
        break;
      default:
        openController = TextEditingController();
        closeController = TextEditingController();
        break;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: GlassContainer(
        borderRadius: BorderRadius.circular(10),
        blur: 10,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(day,
                  style: const TextStyle(fontSize: 18, color: Colors.white)),
              Row(
                children: [
                  Expanded(
                    child: _buildGlassInputField(
                      '$day Opening Time',
                      openController,
                      'Please enter opening time for $day',
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildGlassInputField(
                      '$day Closing Time',
                      closeController,
                      'Please enter closing time for $day',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGlassInputField(String label, TextEditingController controller,
      String validationMessage) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: GlassContainer(
        border: 0,
        blur: 10,
        linearGradient: LinearGradient(
          colors: [
            Colors.grey.withOpacity(0.2),
            Colors.grey.withOpacity(0.1),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            controller: controller,
            decoration: InputDecoration(
              labelText: label,
              labelStyle: const TextStyle(color: Colors.white),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: const BorderSide(color: Colors.grey),
              ),
            ),
            style: const TextStyle(color: Colors.white),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return validationMessage;
              }
              return null;
            },
          ),
        ),
      ),
    );
  }
}
