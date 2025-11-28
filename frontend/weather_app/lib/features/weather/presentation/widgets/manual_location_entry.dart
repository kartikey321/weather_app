import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Manual location entry widget for when permission is denied
class ManualLocationEntry extends StatefulWidget {
  final void Function({double? latitude, double? longitude, String? city})
  onLocationEntered;

  const ManualLocationEntry({super.key, required this.onLocationEntered});

  @override
  State<ManualLocationEntry> createState() => _ManualLocationEntryState();
}

class _ManualLocationEntryState extends State<ManualLocationEntry> {
  final _formKey = GlobalKey<FormState>();
  final _latitudeController = TextEditingController();
  final _longitudeController = TextEditingController();
  final _cityController = TextEditingController();

  @override
  void dispose() {
    _latitudeController.dispose();
    _longitudeController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  void _submitLocation() {
    final city = _cityController.text.trim();
    if (city.isNotEmpty) {
      widget.onLocationEntered(city: city);
      return;
    }

    if (_formKey.currentState!.validate()) {
      final latitude = double.parse(_latitudeController.text);
      final longitude = double.parse(_longitudeController.text);
      widget.onLocationEntered(latitude: latitude, longitude: longitude);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Icon
            const Icon(Icons.location_off, size: 64, color: Colors.orange),
            const SizedBox(height: 16),

            // Title
            Text(
              'Enter Location',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),

            // Description
            Text(
              'Location permission is required to show weather data. Please enter coordinates manually.',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            Text(
              'Prefer city names? Enter it below or use coordinates.',
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),

            // City field
            TextFormField(
              controller: _cityController,
              decoration: const InputDecoration(
                labelText: 'City (optional)',
                hintText: 'e.g., Berlin',
                prefixIcon: Icon(Icons.location_city),
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.done,
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  _cityController.clear();
                },
                child: const Text('Clear city'),
              ),
            ),
            const Divider(),
            const SizedBox(height: 12),

            // Latitude field
            TextFormField(
              controller: _latitudeController,
              decoration: const InputDecoration(
                labelText: 'Latitude',
                hintText: 'e.g., 37.7749',
                prefixIcon: Icon(Icons.location_on),
                border: OutlineInputBorder(),
              ),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
                signed: true,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^-?\d*\.?\d*')),
              ],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter latitude';
                }
                final latitude = double.tryParse(value);
                if (latitude == null) {
                  return 'Invalid latitude';
                }
                if (latitude < -90 || latitude > 90) {
                  return 'Latitude must be between -90 and 90';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Longitude field
            TextFormField(
              controller: _longitudeController,
              decoration: const InputDecoration(
                labelText: 'Longitude',
                hintText: 'e.g., -122.4194',
                prefixIcon: Icon(Icons.location_on),
                border: OutlineInputBorder(),
              ),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
                signed: true,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^-?\d*\.?\d*')),
              ],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter longitude';
                }
                final longitude = double.tryParse(value);
                if (longitude == null) {
                  return 'Invalid longitude';
                }
                if (longitude < -180 || longitude > 180) {
                  return 'Longitude must be between -180 and 180';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),

            // Submit button
            ElevatedButton.icon(
              onPressed: _submitLocation,
              icon: const Icon(Icons.check),
              label: const Text('Get Weather'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
              ),
            ),

            const SizedBox(height: 12),

            // Common locations (quick access)
            const Divider(),
            const SizedBox(height: 12),
            Text(
              'Quick Locations',
              style: Theme.of(context).textTheme.labelLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 8,
              children: [
                _QuickLocationChip(
                  label: 'New York',
                  onTap: () => widget.onLocationEntered(city: 'New York'),
                ),
                _QuickLocationChip(
                  label: 'London',
                  onTap: () => widget.onLocationEntered(city: 'London'),
                ),
                _QuickLocationChip(
                  label: 'Tokyo',
                  onTap: () => widget.onLocationEntered(city: 'Tokyo'),
                ),
                _QuickLocationChip(
                  label: 'Sydney',
                  onTap: () => widget.onLocationEntered(city: 'Sydney'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Quick location chip widget
class _QuickLocationChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _QuickLocationChip({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      label: Text(label),
      onPressed: onTap,
      avatar: const Icon(Icons.public, size: 16),
    );
  }
}
