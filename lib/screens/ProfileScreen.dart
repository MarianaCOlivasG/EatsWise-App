import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:myapp/global/environments.dart';
import 'package:myapp/providers/auth_provider.dart';
import 'package:myapp/screens/LoginScreen.dart'; // Asegúrate de tener esta importación
import 'package:myapp/theme/my_colors.dart';

class ProfileScreen extends StatefulWidget {
  final String userId;

  const ProfileScreen({Key? key, required this.userId}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isLoading = true;
  bool _isSavingLocation = false;
  bool _isEditingName = false;
  Map<String, dynamic>? _profileData;
  LatLng? _currentLocation;
  LatLng? _selectedLocation;
  TextEditingController _nameController = TextEditingController();
  late String _profileName;

  @override
  void initState() {
    super.initState();
    _requestPermissionAndFetchProfile();
  }

  Future<void> _requestPermissionAndFetchProfile() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.always && permission != LocationPermission.whileInUse) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Permiso de ubicación denegado')),
        );
        return;
      }
    }

    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final userId = authProvider.user.uid;
      final userName = authProvider.user.profile?.name ?? 'Usuario';

      _profileName = userName;
      _nameController.text = _profileName;

      final response = await http.get(
        Uri.parse('${Environments.apiUrl}/user/$userId/profile'),
      );

      if (response.statusCode == 200) {
        setState(() {
          _profileData = jsonDecode(response.body);
          _isLoading = false;
          if (_profileData!['location'] != null) {
            _currentLocation = LatLng(
              _profileData!['location']['latitude'],
              _profileData!['location']['longitude'],
            );
            _selectedLocation = _currentLocation;
          }
        });
      } else {
        throw Exception('Error al cargar perfil');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Future<void> _getLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
        _selectedLocation = _currentLocation;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al obtener ubicación: $e')));
    }
  }

  Future<void> _saveLocation() async {
    if (_selectedLocation == null) return;

    setState(() {
      _isSavingLocation = true;
    });

    final data = {
      'latitude': _selectedLocation!.latitude,
      'longitude': _selectedLocation!.longitude,
    };

    try {
      final response = await http.put(
        Uri.parse('${Environments.apiUrl}/user/${widget.userId}/location'),
        body: jsonEncode(data),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Ubicación guardada con éxito')));
      } else {
        throw Exception('Error al guardar la ubicación');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      setState(() {
        _isSavingLocation = false;
      });
    }
  }

  Future<void> _updateProfileName() async {
    final newName = _nameController.text;
    if (newName == _profileName) return;

    setState(() {
      _isLoading = true;
    });

    final data = {'name': newName};

    try {
      final response = await http.put(
        Uri.parse('${Environments.apiUrl}/user/${widget.userId}/profile'),
        body: jsonEncode(data),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        setState(() {
          _profileName = newName;
          _isEditingName = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Perfil actualizado')));
      } else {
        throw Exception('Error al actualizar el perfil');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onMapTapped(LatLng location) {
    setState(() {
      _selectedLocation = location;
    });
  }

  void _logout() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    authProvider.logout();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final userName = authProvider.user.profile?.name ?? 'Usuario';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
        actions: [
          IconButton(
            onPressed: _logout,
            icon: const Icon(Icons.logout),
            tooltip: 'Cerrar sesión',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('¡Hola, $userName!', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 20),
                  if (_isEditingName)
                    Column(
                      children: [
                        TextField(
                          controller: _nameController,
                          decoration: const InputDecoration(labelText: 'Nombre'),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: _updateProfileName,
                          child: const Text('Actualizar nombre'),
                        ),
                      ],
                    )
                  else
                    /*ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _isEditingName = true;
                        });
                      },
                      child: const Text('Editar nombre', style: TextStyle(color: MyColors.primary)),
                    ),*/
                  const SizedBox(height: 20),
                  Text('Ubicación actual:', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 10),
                  _selectedLocation != null
                      ? SizedBox(
                          height: 250,
                          child: FlutterMap(
                            options: MapOptions(
                              initialCenter: _selectedLocation!,
                              initialZoom: 15,
                              onTap: (_, location) => _onMapTapped(location),
                            ),
                            children: [
                              TileLayer(
                                urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                                subdomains: const ['a', 'b', 'c'],
                              ),
                              MarkerLayer(
                                markers: [
                                  Marker(
                                    point: _selectedLocation!,
                                    width: 80,
                                    height: 80,
                                    child: const Icon(Icons.location_on, size: 40, color: Colors.red),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      : const Text('Ubicación no disponible'),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _getLocation,
                    child: const Text('Obtener ubicación actual', style: TextStyle(color: MyColors.primary)),
                  ),
                  const SizedBox(height: 10),
                  _isSavingLocation
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: _saveLocation,
                          child: const Text('Guardar ubicación', style: TextStyle(color: MyColors.primary)),
                        ),
                ],
              ),
            ),
    );
  }
}
