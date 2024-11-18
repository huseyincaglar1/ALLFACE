import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LabeledLocationButton extends StatefulWidget {
  final TextEditingController controller;
  const LabeledLocationButton({
    super.key,
    required this.controller,
  });

  @override
  _LabeledLocationButtonState createState() => _LabeledLocationButtonState();
}

class _LabeledLocationButtonState extends State<LabeledLocationButton> {
  String? _currentAddress;

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Konum özelliği aktif değil. Lütfen servisi aktifleştirin.')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Konum izni reddedildi')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Konum izni kalıcı olarak reddedildi, izin gönderilemiyor.')));
      return false;
    }
    return true;
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();

    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      _getAddressFromLatLng(position);
    }).catchError((e) {
      debugPrint(e);
    });
  }

  Future<void> _getAddressFromLatLng(Position position) async {
    await placemarkFromCoordinates(position.latitude, position.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      setState(() {
        _currentAddress =
            '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}';
        widget.controller.text = _currentAddress!;
      });
    }).catchError((e) {
      debugPrint(e);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // MyTextfield(
        //     hintText: "Konumunuz", obscureText: false, controller: widget.controller),
        ElevatedButton(
          style: ButtonStyle(
            backgroundColor:
                WidgetStatePropertyAll(Theme.of(context).colorScheme.primary),
          ),
          onPressed: _getCurrentPosition,
          child:  Text(
            "Konum bilgisine izin ver",
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface, // Rengi tema moduna göre ayarla
                ),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          _currentAddress ?? "Konuma izin verilmedi.",
          style: const TextStyle(fontSize: 10),
        ),
      ],
    );
  }
}
