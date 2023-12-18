import 'package:flutter/material.dart';
import 'package:bite_buddy/Model/Store.dart';

class StoreSetupPage extends StatefulWidget {
  @override
  _StoreSetupPageState createState() => _StoreSetupPageState();
}

class _StoreSetupPageState extends State<StoreSetupPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _zipCodeController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _websiteController = TextEditingController();
  final TextEditingController _categoriesController = TextEditingController();
  final TextEditingController _menuController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Store Setup'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Store Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter store name';
                  }
                  return null;
                },
              ),
              // Add more TextFormFields for address, contact, etc.
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter street';
                  }
                  return null;
                },
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Address', style: Theme.of(context).textTheme.headline6?.copyWith(fontSize: 18.0)),
              ),
              Card(
                elevation: 1,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _streetController,
                        decoration: const InputDecoration(labelText: 'Street'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter street';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _streetController,
                        decoration: const InputDecoration(labelText: 'City'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter street';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _streetController,
                        decoration: const InputDecoration(labelText: 'State'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter street';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _streetController,
                        decoration: const InputDecoration(labelText: 'ZipCode'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter street';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _streetController,
                        decoration: const InputDecoration(labelText: 'Country'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter street';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Contact', style: Theme.of(context).textTheme.headline6?.copyWith(fontSize: 18.0)),
              ),
              Card(
                elevation: 1,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _streetController,
                        decoration: const InputDecoration(labelText: 'Phone'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Phone';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _streetController,
                        decoration: const InputDecoration(labelText: 'Email'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Email';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _streetController,
                        decoration: const InputDecoration(labelText: 'Website'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Website';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              // DropDown for Categories


              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // TODO: Handle store creation logic
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Processing Data')),
                    );
                  }
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
