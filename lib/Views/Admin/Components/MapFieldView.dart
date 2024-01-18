import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapField extends StatefulWidget {
  const MapField({super.key});

  @override
  MapFieldState createState() => MapFieldState();
}

class MapFieldState extends State<MapField> {
  LatLng? _selectedLocation;
  late GoogleMapController _mapController;

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  void _handleTap(LatLng location) {
    setState(() {
      _selectedLocation = location;
    });
    _mapController.animateCamera(CameraUpdate.newLatLng(location));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 200, // Set the height for the map widget
          child: GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: const CameraPosition(
              target: LatLng(0, 0), // Replace with a default location
              zoom: 14.0,
            ),
            onTap: _handleTap,
            markers: _selectedLocation != null
                ? {
                    Marker(
                      markerId: const MarkerId('selected_location'),
                      position: _selectedLocation!,
                    )
                  }
                : {},
          ),
        ),
        if (_selectedLocation != null)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
                'Selected Location: ${_selectedLocation!.latitude}, ${_selectedLocation!.longitude}'),
          ),
        ElevatedButton(
          onPressed: () {
            // Logic to submit or use the selected location
          },
          child: const Text('Confirm Location'),
        ),
      ],
    );
  }
}
