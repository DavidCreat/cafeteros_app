import 'package:flutter/material.dart';

class LotRegisterScreen extends StatefulWidget {
  const LotRegisterScreen({super.key});

  @override
  State<LotRegisterScreen> createState() => _LotRegisterScreenState();
}

class _LotRegisterScreenState extends State<LotRegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  String? variedad;
  String? estado;
  String? cantidad;
  DateTime? fecha;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar Lote'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: 'Variedad'),
                    items: const [
                      DropdownMenuItem(value: 'Castillo', child: Text('Castillo')),
                      DropdownMenuItem(value: 'Colombia', child: Text('Colombia')),
                      DropdownMenuItem(value: 'Tabi', child: Text('Tabi')),
                      DropdownMenuItem(value: 'Cenicafé 1', child: Text('Cenicafé 1')),
                      DropdownMenuItem(value: 'Typica', child: Text('Typica')),
                      DropdownMenuItem(value: 'Geisha', child: Text('Geisha')),
                    ],
                    onChanged: (value) => setState(() => variedad = value),
                    validator: (value) => value == null ? 'Selecciona una variedad' : null,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: 'Estado'),
                    items: const [
                      DropdownMenuItem(value: 'Pergamino seco', child: Text('Pergamino seco')),
                      DropdownMenuItem(value: 'Verde', child: Text('Verde')),
                      DropdownMenuItem(value: 'Tostado', child: Text('Tostado')),
                    ],
                    onChanged: (value) => setState(() => estado = value),
                    validator: (value) => value == null ? 'Selecciona un estado' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Cantidad (kg o bultos)'),
                    keyboardType: TextInputType.number,
                    onChanged: (value) => cantidad = value,
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Ingresa la cantidad';
                      if (double.tryParse(value) == null) return 'Ingresa un número válido';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(fecha == null ? 'Selecciona la fecha' : 'Fecha: ${fecha!.toLocal()}'.split(' ')[0]),
                    trailing: Icon(Icons.calendar_today, color: Colors.brown),
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) {
                        setState(() => fecha = picked);
                      }
                    },
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Lote registrado (prototipo)')),
                        );
                        Navigator.pop(context);
                      }
                    },
                    child: const Text('Guardar'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
