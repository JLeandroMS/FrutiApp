import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'models/access_record.dart';
import 'services/access_log_service.dart';

import 'package:file_selector/file_selector.dart';
import 'package:web/web.dart' as web;

final logService = AccessLogService();

void main() {
  runApp(const FrutiApp());
}

class FrutiApp extends StatelessWidget {
  const FrutiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FrutiApp Web',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
        ),
        useMaterial3: true,
      ),
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final _usuarioController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _recordarme = false;
  bool _ocultarContrasena = true;

  void _ingresar() {
    final usuario = _usuarioController.text.trim();
    final password = _passwordController.text;

    final formularioValido = _formKey.currentState!.validate();

    final exitoso = formularioValido;

    logService.add(
      AccessRecord(
        usuario: usuario,
        fechaHora: DateTime.now(),
        exitoso: exitoso,
      ),
    );

    if (formularioValido) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const HomePage(),
        ),
      );
    }
  }

  void _abrirBitacora() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const BitacoraPage(),
      ),
    );
  }

  @override
  void dispose() {
    _usuarioController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FrutiApp'),
        actions: [
          IconButton(
            tooltip: 'Bitácora',
            onPressed: _abrirBitacora,
            icon: const Icon(Icons.history),
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: 450,
            margin: const EdgeInsets.all(20),
            child: Card(
              elevation: 6,
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.local_grocery_store,
                        size: 70,
                        color: Colors.blue,
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'FrutiApp',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 25),
                      TextFormField(
                        controller: _usuarioController,
                        decoration: const InputDecoration(
                          labelText: 'Correo electrónico',
                          prefixIcon: Icon(Icons.email),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Ingrese el correo';
                          }

                          if (!value.contains('@') || !value.contains('.')) {
                            return 'Correo no válido';
                          }

                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _ocultarContrasena,
                        decoration: InputDecoration(
                          labelText: 'Contraseña',
                          prefixIcon: const Icon(Icons.lock),
                          border: const OutlineInputBorder(),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _ocultarContrasena = !_ocultarContrasena;
                              });
                            },
                            icon: Icon(
                              _ocultarContrasena
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.length < 6) {
                            return 'La contraseña debe tener al menos 6 caracteres';
                          }

                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Checkbox(
                            value: _recordarme,
                            onChanged: (value) {
                              setState(() {
                                _recordarme = value ?? false;
                              });
                            },
                          ),
                          const Text('Recordarme'),
                        ],
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _ingresar,
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 14,
                            ),
                            child: Text('Ingresar'),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: _abrirBitacora,
                          icon: const Icon(Icons.history),
                          label: const Text(
                            'Ver bitácora',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class BitacoraPage extends StatefulWidget {
  const BitacoraPage({super.key});

  @override
  State<BitacoraPage> createState() => _BitacoraPageState();
}

class _BitacoraPageState extends State<BitacoraPage> {
  Future<void> importarBitacora() async {
    const typeGroup = XTypeGroup(
      label: 'JSON',
      extensions: ['json'],
      mimeTypes: ['application/json'],
    );

    final XFile? file = await openFile(
      acceptedTypeGroups: [typeGroup],
    );

    if (file == null) return;

    try {
      final contenido = await file.readAsString();

      logService.importJson(contenido);

      setState(() {});

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Bitácora importada correctamente'),
        ),
      );
    } on FormatException catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('JSON inválido: ${e.message}'),
        ),
      );
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No se pudo leer el archivo'),
        ),
      );
    }
  }

  void descargarJson(String contenido) {
    final base64 = base64Encode(
      utf8.encode(contenido),
    );

    web.HTMLAnchorElement()
      ..href = 'data:application/json;base64,$base64'
      ..setAttribute(
        'download',
        'bitacora_accesos.json',
      )
      ..click();
  }

  void exportarBitacora() {
    descargarJson(
      logService.exportJson(),
    );
  }

  void limpiarBitacora() {
    setState(() {
      logService.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Bitácora limpiada'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final registros = logService.records;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bitácora de accesos'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                ElevatedButton.icon(
                  onPressed: exportarBitacora,
                  icon: const Icon(Icons.download),
                  label: const Text('Exportar JSON'),
                ),
                OutlinedButton.icon(
                  onPressed: importarBitacora,
                  icon: const Icon(Icons.upload_file),
                  label: const Text('Importar JSON'),
                ),
                OutlinedButton.icon(
                  onPressed: limpiarBitacora,
                  icon: const Icon(Icons.delete),
                  label: const Text('Limpiar'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              'Total de registros: ${registros.length}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),
            Expanded(
              child: registros.isEmpty
                  ? const Center(
                      child: Text(
                        'No hay registros en la bitácora',
                      ),
                    )
                  : ListView.builder(
                      itemCount: registros.length,
                      itemBuilder: (context, index) {
                        final r = registros[index];

                        return Card(
                          child: ListTile(
                            leading: Icon(
                              r.exitoso ? Icons.check_circle : Icons.cancel,
                              color: r.exitoso ? Colors.green : Colors.red,
                            ),
                            title: Text(
                              r.usuario.isEmpty ? '(sin usuario)' : r.usuario,
                            ),
                            subtitle: Text(
                              r.fechaHora.toString(),
                            ),
                            trailing: Text(
                              r.exitoso ? 'OK' : 'FALLÓ',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<dynamic>> productos;

  @override
  void initState() {
    super.initState();

    productos = cargarProductos();
  }

  Future<List<dynamic>> cargarProductos() async {
    final response = await http.get(
      Uri.parse(
        'https://jsonplaceholder.typicode.com/posts',
      ),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    throw Exception(
      'No se pudo cargar la información',
    );
  }

  void _recargar() {
    setState(() {
      productos = cargarProductos();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FrutiApp - Catálogo'),
        backgroundColor: Colors.green.shade100,
        actions: [
          IconButton(
            tooltip: 'Recargar',
            onPressed: _recargar,
            icon: const Icon(Icons.refresh),
          ),
          IconButton(
            tooltip: 'Cerrar sesión',
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: FutureBuilder<List<dynamic>>(
        future: productos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 15),
                  Text(
                    'Cargando productos...',
                  ),
                ],
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'No se pudo cargar la información.',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 15),
                  ElevatedButton(
                    onPressed: _recargar,
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          }

          final lista = snapshot.data ?? [];

          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Catálogo de productos',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  '${lista.length} productos obtenidos desde JSONPlaceholder',
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    itemCount: lista.length,
                    itemBuilder: (context, index) {
                      final producto = lista[index];

                      final int id = producto['id'];

                      final String nombre = producto['title'];

                      final int precio = id * 100;

                      return Card(
                        margin: const EdgeInsets.only(
                          bottom: 10,
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            child: Text(
                              id.toString(),
                            ),
                          ),
                          title: Text(
                            nombre,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            'Identificador: $id',
                          ),
                          trailing: Text(
                            '₡$precio',
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
