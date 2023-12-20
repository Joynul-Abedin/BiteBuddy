import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:glassmorphism_widgets/glassmorphism_widgets.dart';

import '../../Controllers/Store/StoreController.dart';


class StoreSetupPage extends StatefulWidget {
  final StoreController controller;
  const StoreSetupPage({Key? key, required this.controller}) : super(key: key);

  @override
  StoreSetupPageState createState() => StoreSetupPageState();
}

class StoreSetupPageState extends State<StoreSetupPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    widget.controller.categoriesController.text = widget.controller.categories[0];
    widget.controller.menuController.text = widget.controller.menu[0];
  }

  @override
  void dispose() {
    super.dispose();
    widget.controller.nameController.dispose();
    widget.controller.streetController.dispose();
    widget.controller.cityController.dispose();
    widget.controller.stateController.dispose();
    widget.controller.zipCodeController.dispose();
    widget.controller.countryController.dispose();
    widget.controller.descriptionController.dispose();
    widget.controller.phoneController.dispose();
    widget.controller.emailController.dispose();
    widget.controller.websiteController.dispose();
    widget.controller.categoriesController.dispose();
    widget.controller.menuController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.05,
                  ),
                  const Text("Store Setup", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white)),
                  _buildImagePicker(),
                  _buildGlassInputField('Store Name', widget.controller.nameController, 'Please enter store name'),
                  _buildGlassInputField('Description', widget.controller.descriptionController, 'Please enter description'),
                  _buildGlassDropdownField('Categories', widget.controller.categories, widget.controller.categoriesController),
                  _buildGlassDropdownField('Menu', widget.controller.menu, widget.controller.menuController),
                  _buildGlassInputField('Street', widget.controller.streetController, 'Please enter street'),
                  _buildGlassInputField('City', widget.controller.cityController, 'Please enter city'),
                  _buildGlassInputField('State', widget.controller.stateController, 'Please enter state'),
                  _buildGlassInputField('Zip Code', widget.controller.zipCodeController, 'Please enter zip code'),
                  _buildGlassInputField('Country', widget.controller.countryController, 'Please enter country'),
                  _buildGlassInputField('Phone', widget.controller.phoneController, 'Please enter phone'),
                  _buildGlassInputField('Email', widget.controller.emailController, 'Please enter email'),
                  _buildGlassInputField('Website', widget.controller.websiteController, 'Please enter website'),
                  GlassButton(
                    border: 0,
                    blur: 10,
                    linearGradient: LinearGradient(
                      colors: [
                        Colors.blue.withOpacity(0.5),
                        Colors.blue.withOpacity(0.4),
                      ],
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Handle form submission
                      }
                    },
                    child: const GlassText("Submit", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold), opacity: 1.0,),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlassInputField(String label, TextEditingController controller, String validationMessage) {
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

  Widget _buildGlassDropdownField(String label, List<String> items, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: GlassContainer(
        borderRadius: BorderRadius.circular(10),
        blur: 10,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: DropdownButtonFormField<String>(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            decoration: InputDecoration(
              labelText: label,
              labelStyle: const TextStyle(color: Colors.white),
              border: InputBorder.none,
            ),
            dropdownColor: Colors.black, // Set the dropdown background color
            value: controller.text.isEmpty ? null : controller.text,
            onChanged: (String? newValue) {
              setState(() {
                controller.text = newValue!;
              });
            },
            items: items.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value, style: const TextStyle(color: Colors.white)),
              );
            }).toList(),
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _buildImagePicker() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GlassContainer(
        borderRadius: BorderRadius.circular(10),
        blur: 10,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Store Image',
                  style: TextStyle(fontSize: 18, color: Colors.white)),
              const SizedBox(height: 10),
              Center(
                child: GestureDetector(
                  onTap:() {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          backgroundColor: Colors.grey,
                          title: const Text('Select Image'),
                          content: SingleChildScrollView(
                            child: ListBody(
                              children: <Widget>[
                                GestureDetector(
                                  child: const Text('Gallery'),
                                  onTap: () {
                                    _selectImage(
                                        ImageSource.gallery);
                                    Navigator.of(context).pop();
                                  },
                                ),
                                const Padding(
                                  padding: EdgeInsets.all(8.0),
                                ),
                                GestureDetector(
                                  child: const Text('Camera'),
                                  onTap: () {
                                    _selectImage(
                                        ImageSource.camera);
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                  child: widget.controller.userImage == null
                      ? const Icon(Icons.add_a_photo, color: Colors.white, size: 50)
                      : Image.file(widget.controller.userImage!, fit: BoxFit.cover),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        widget.controller.userImage = File(pickedFile.path);
        debugPrint('Image path: ${pickedFile.path}');
        debugPrint('Image path: ${widget.controller.userImage?.path}');
      });
    }
  }

}
