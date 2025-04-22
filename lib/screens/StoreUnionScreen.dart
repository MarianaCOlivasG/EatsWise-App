import 'package:flutter/material.dart';

class StoreUnionScreen extends StatefulWidget {
  const StoreUnionScreen({Key? key}) : super(key: key);

  @override
  _StoreUnionScreenState createState() => _StoreUnionScreenState();
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
        .map((ingrediente) => {
              'ingrediente': ingrediente,
              'cantidad': cantidadesSeleccionadas[ingrediente] ?? 0.5,
            })
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
        const SnackBar(content: Text('Seleccione al menos un ingrediente')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Selecciona Ingredientes y Cantidades'),
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
                            divisions: 19, // Incrementos de 0.5 kg
                            label:
                                '${cantidadesSeleccionadas[ingrediente]!.toStringAsFixed(1)} kg',
                            onChanged: (double value) {
                              setState(() {
                                cantidadesSeleccionadas[ingrediente] = value;
                              });
                            },
                          ),
                        ),
                        Text(
                          '${cantidadesSeleccionadas[ingrediente]!.toStringAsFixed(1)} kg',
                          style: const TextStyle(fontWeight: FontWeight.bold),
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
        child: const Icon(Icons.search),
      ),
    );
  }
}

class NearbyStoresScreen extends StatelessWidget {
  final List<Map<String, dynamic>> ingredientes;

  // Lista de tiendas con precios por kilogramo
  final List<Map<String, dynamic>> tiendas = [
    {
      'nombre': 'Tienda Central',
      'ubicacion': 'Calle 123',
      'ingredientes': {
        'Tomate': 1.50,
        'Lechuga': 0.75,
        'Cebolla': 0.80,
      },
    },
    {
      'nombre': 'Supermercado Express',
      'ubicacion': 'Avenida 456',
      'ingredientes': {
        'Pepino': 1.00,
        'Queso': 2.50,
        'Pan': 1.20,
      },
    },
  ];

  NearbyStoresScreen({required this.ingredientes, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tiendasFiltradas = tiendas.where((tienda) {
      final ingTienda = tienda['ingredientes'] as Map<String, double>;
      return ingredientes.any((ing) =>
          ingTienda.keys.contains(ing['ingrediente']) &&
          ing['cantidad'] > 0); // Validar que la cantidad sea mayor que 0
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tiendas Cercanas'),
      ),
      body: ListView.builder(
        itemCount: tiendasFiltradas.length,
        itemBuilder: (context, index) {
          final tienda = tiendasFiltradas[index];
          final ingTienda = tienda['ingredientes'] as Map<String, double>;

          final ingredientesDisponibles = ingredientes
              .where((ing) => ingTienda.containsKey(ing['ingrediente']))
              .map((ing) => {
                    'nombre': ing['ingrediente'],
                    'cantidad': ing['cantidad'],
                    'precio': ingTienda[ing['ingrediente']],
                  })
              .toList();

          return Card(
            margin: const EdgeInsets.all(8),
            child: ListTile(
              title: Text(tienda['nombre']),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Ubicación: ${tienda['ubicacion']}'),
                  ...ingredientesDisponibles.map((ing) => Text(
                      '${ing['nombre']} x${ing['cantidad']} kg: \$${((ing['precio'] as double) * (ing['cantidad'] as double)).toStringAsFixed(2)}')),
                ],
              ),
              trailing: ElevatedButton(
                onPressed: () async {
                  await _confirmarCompra(context);
                },
                child: const Text('Comprar'),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _confirmarCompra(BuildContext context) async {
    // Paso 1: Seleccionar ubicación
    final opcionEntrega = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Ubicación de Entrega"),
          content: const Text(
              "¿Los ingredientes serán entregados a la ubicación actual o a otra?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, "actual"),
              child: const Text("Actual"),
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

    String selectedLocation = "";
    if (opcionEntrega == "otra") {
      // Solicitar ubicación ingresada por el usuario
      final inputLocation = await showDialog<String>(
        context: context,
        builder: (context) {
          final locationController = TextEditingController();
          return AlertDialog(
            title: const Text("Introduzca la Ubicación"),
            content: TextField(
              controller: locationController,
              decoration:
                  const InputDecoration(hintText: "Ubicación"),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, null),
                child: const Text("Cancelar"),
              ),
              TextButton(
                onPressed: () => Navigator.pop(
                    context, locationController.text),
                child: const Text("Aceptar"),
              ),
            ],
          );
        },
      );

      if (inputLocation == null || inputLocation.trim().isEmpty) {
        return;
      }
      selectedLocation = inputLocation;
    } else {
      selectedLocation = "Ubicación actual del dispositivo";
    }

    // Paso 2: Solicitar datos de tarjeta
    final cardProvided = await showDialog<bool>(
      context: context,
      builder: (context) {
        final cardNumberController = TextEditingController();
        final cardNameController = TextEditingController();
        final cardCVVController = TextEditingController();
        final cardExpiryController = TextEditingController();

        return AlertDialog(
          title: const Text("Datos de Tarjeta"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: cardNumberController,
                decoration: const InputDecoration(
                    hintText: "Número de tarjeta"),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: cardNameController,
                decoration: const InputDecoration(
                    hintText: "Nombre del titular"),
              ),
              TextField(
                controller: cardCVVController,
                decoration: const InputDecoration(
                    hintText: "CVV (Código de seguridad)"),
                keyboardType: TextInputType.number,
                maxLength: 3,
              ),
              TextField(
                controller: cardExpiryController,
                decoration: const InputDecoration(
                    hintText: "Fecha de vencimiento (MM/AA)"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("Cancelar"),
            ),
            TextButton(
              onPressed: () {
                // Validamos que ningún campo esté vacío
                if (cardNumberController.text.isEmpty ||
                    cardNameController.text.isEmpty ||
                    cardCVVController.text.isEmpty ||
                    cardExpiryController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Por favor, complete todos los campos')),
                  );
                  return;
                }

                // Validación exitosa, cerramos el diálogo
                Navigator.pop(context, true);
              },
              child: const Text("Aceptar"),
            ),
          ],
        );
      },
    );

    if (cardProvided != true) return;

    // Confirmación final
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('Compra realizada exitosamente!')),
    );
  }
}