import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:myapp/theme/my_colors.dart';

// Formatter para la fecha MM/AA que inserta '/' automáticamente
class ExpirationDateFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var text = newValue.text;

    // Eliminar todo lo que no sea número
    text = text.replaceAll(RegExp(r'[^0-9]'), '');

    final buffer = StringBuffer();

    for (int i = 0; i < text.length && i < 4; i++) {
      if (i == 2) buffer.write('/');
      buffer.write(text[i]);
    }

    final string = buffer.toString();

    return TextEditingValue(
      text: string,
      selection: TextSelection.collapsed(offset: string.length),
    );
  }
}

class StoreUnionScreen extends StatefulWidget {
  const StoreUnionScreen({Key? key}) : super(key: key);

  @override
  State<StoreUnionScreen> createState() => _StoreUnionScreenState();
}

class _StoreUnionScreenState extends State<StoreUnionScreen> {
  final List<String> ingredientes = [
    'Tomate',
    'Lechuga',
    'Cebolla',
    'Pepino',
    'Queso',
    'Pan',
  ];

  late Map<String, bool> ingredientesSeleccionados;
  late Map<String, double> cantidadesSeleccionadas;

  @override
  void initState() {
    super.initState();
    ingredientesSeleccionados = {for (var ing in ingredientes) ing: false};
    cantidadesSeleccionadas = {for (var ing in ingredientes) ing: 0.5};
  }

  void _buscarTiendas() {
    final seleccionados = ingredientesSeleccionados.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();

    final cantidades = seleccionados
        .map(
          (ingrediente) => {
            'ingrediente': ingrediente,
            'cantidad': cantidadesSeleccionadas[ingrediente] ?? 0.5,
          },
        )
        .toList();

    if (seleccionados.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NearbyStoresScreen(ingredientes: cantidades),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Seleccione al menos un ingrediente',)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Selecciona Ingredientes',
        ),
      ),
      body: ListView(
        children: ingredientes.map((ingrediente) {
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        ingrediente,
                        style: const TextStyle(fontSize: 16),
                      ),
                      Switch(
                        value: ingredientesSeleccionados[ingrediente]!,
                        activeColor: MyColors.primary,
                        onChanged: (bool value) {
                          setState(() {
                            ingredientesSeleccionados[ingrediente] = value;
                          });
                        },
                      ),
                    ],
                  ),
                  if (ingredientesSeleccionados[ingrediente]!)
                    Row(
                      children: [
                        const Text('Cantidad (kg):'),
                        Expanded(
                          child: Slider(
                            value: cantidadesSeleccionadas[ingrediente]!,
                            min: 0.5,
                            max: 10.0,
                            divisions: 19,
                            label: '${cantidadesSeleccionadas[ingrediente]!.toStringAsFixed(1)} kg',
                            activeColor: MyColors.primary,
                            onChanged: (double value) {
                              setState(() {
                                cantidadesSeleccionadas[ingrediente] = value;
                              });
                            },
                          ),
                        ),
                        Text(
                          '${cantidadesSeleccionadas[ingrediente]!.toStringAsFixed(1)} kg',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _buscarTiendas,
        tooltip: 'Buscar Tiendas',
        backgroundColor: Colors.green,
        child: const Icon(Icons.search),
      ),
    );
  }
}

class NearbyStoresScreen extends StatefulWidget {
  final List<Map<String, dynamic>> ingredientes;

  const NearbyStoresScreen({required this.ingredientes, Key? key})
      : super(key: key);

  @override
  State<NearbyStoresScreen> createState() => _NearbyStoresScreenState();
}

class _NearbyStoresScreenState extends State<NearbyStoresScreen> {
  final List<Map<String, dynamic>> tiendas = [
    {
      'nombre': 'Tienda Central',
      'ubicacion': 'Calle 123',
      'latlng': LatLng(20.985, -89.615),
      'ingredientes': {'Tomate': 1.50, 'Lechuga': 0.75, 'Cebolla': 0.80},
    },
    {
      'nombre': 'Supermercado Express',
      'ubicacion': 'Avenida 456',
      'latlng': LatLng(20.987, -89.617),
      'ingredientes': {'Pepino': 1.00, 'Queso': 2.50, 'Pan': 1.20},
    },
  ];

  @override
  Widget build(BuildContext context) {
    final tiendasFiltradas = tiendas.where((tienda) {
      final ingTienda = tienda['ingredientes'] as Map<String, double>;
      return widget.ingredientes.any(
        (ing) =>
            ingTienda.keys.contains(ing['ingrediente']) &&
            ing['cantidad'] > 0,
      );
    }).toList();

    LatLng mapaCentro =
        tiendasFiltradas.isNotEmpty ? tiendasFiltradas[0]['latlng'] : LatLng(20.985, -89.615);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tiendas Cercanas'),
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          SizedBox(
            height: 250,
            child: FlutterMap(
              options: MapOptions(initialCenter: mapaCentro, initialZoom: 15.0),
              children: [
                TileLayer(
                  urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: const ['a', 'b', 'c'],
                ),
                MarkerLayer(
                  markers: [
                    ...tiendasFiltradas.map((tienda) {
                      return Marker(
                        point: tienda['latlng'],
                        child: const Icon(
                          Icons.store,
                          color: Colors.red,
                          size: 30,
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Tiendas Disponibles:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: tiendasFiltradas.length,
              itemBuilder: (context, index) {
                final tienda = tiendasFiltradas[index];
                final ingTienda = tienda['ingredientes'] as Map<String, double>;

                final ingredientesDisponibles = widget.ingredientes
                    .where((ing) => ingTienda.containsKey(ing['ingrediente']))
                    .map(
                      (ing) => {
                        'nombre': ing['ingrediente'],
                        'cantidad': ing['cantidad'],
                        'precio': ingTienda[ing['ingrediente']],
                      },
                    )
                    .toList();

                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    title: Text(tienda['nombre']),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Ubicación: ${tienda['ubicacion']}'),
                        ...ingredientesDisponibles.map(
                          (ing) => Text(
                            '${ing['nombre']} x${ing['cantidad']} kg: \$${((ing['precio'] as double) * (ing['cantidad'] as double)).toStringAsFixed(2)}',
                          ),
                        ),
                      ],
                    ),
                    trailing: ElevatedButton(
                      onPressed: () => _confirmarCompra(context, tienda['nombre']),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                      child: const Text('Comprar'),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmarCompra(
    BuildContext context,
    String nombreTienda,
  ) async {
    final opcionEntrega = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Ubicación de Entrega"),
          content: const Text(
            "¿Los ingredientes serán entregados a la ubicación de la tienda o a otra ubicación?",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, "tienda"),
              child: const Text("Ubicación Actual"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, "otra"),
              child: const Text("Otra"),
            ),
          ],
        );
      },
    );

    if (opcionEntrega == null) return;

    if (opcionEntrega == "otra") {
      final inputLocation = await showDialog<String>(
        context: context,
        builder: (context) {
          final controller = TextEditingController();
          return AlertDialog(
            title: const Text("Ingresar Ubicación"),
            content: TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: "Dirección o ubicación",
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancelar"),
              ),
              TextButton(
                onPressed: () {
                  if (controller.text.trim().isNotEmpty) {
                    Navigator.pop(context, controller.text.trim());
                  }
                },
                child: const Text("Aceptar"),
              ),
            ],
          );
        },
      );

      if (inputLocation != null && inputLocation.isNotEmpty) {
        _mostrarFormularioPago(context, nombreTienda, inputLocation);
      }
    } else {
      // Ubicación actual de la tienda
      _mostrarFormularioPago(context, nombreTienda, "Ubicación de la tienda");
    }
  }

  void _mostrarFormularioPago(
    BuildContext context,
    String tienda,
    String ubicacion,
  ) {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController();
    final cardNumberController = TextEditingController();
    final expirationDateController = TextEditingController();
    final cvvController = TextEditingController();

    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Comprar en $tienda'),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Entrega en: $ubicacion'),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Nombre completo',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Ingrese su nombre completo';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: cardNumberController,
                    keyboardType: TextInputType.number,
                    maxLength: 16,
                    decoration: const InputDecoration(
                      labelText: 'Número de tarjeta',
                      border: OutlineInputBorder(),
                      counterText: '',
                    ),
                    validator: (value) {
                      if (value == null || value.length != 16) {
                        return 'Ingrese un número de tarjeta válido de 16 dígitos';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: expirationDateController,
                    keyboardType: TextInputType.number,
                    maxLength: 5,
                    decoration: const InputDecoration(
                      labelText: 'Fecha de expiración (MM/AA)',
                      border: OutlineInputBorder(),
                      counterText: '',
                    ),
                    inputFormatters: [ExpirationDateFormatter()],
                    validator: (value) {
                      if (value == null || value.length != 5) {
                        return 'Ingrese fecha en formato MM/AA';
                      }
                      final parts = value.split('/');
                      final month = int.tryParse(parts[0]);
                      final year = int.tryParse(parts[1]);
                      if (month == null || year == null || month < 1 || month > 12) {
                        return 'Fecha inválida';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: cvvController,
                    keyboardType: TextInputType.number,
                    maxLength: 3,
                    decoration: const InputDecoration(
                      labelText: 'CVV',
                      border: OutlineInputBorder(),
                      counterText: '',
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.length != 3) {
                        return 'Ingrese un CVV válido de 3 dígitos';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  // Aquí enviar los datos de pago
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Compra realizada con éxito')),
                  );
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: const Text('Confirmar compra'),
            ),
          ],
        );
      },
    );
  }
}
