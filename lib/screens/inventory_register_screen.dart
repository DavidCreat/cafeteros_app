import 'package:flutter/material.dart';
import '../app.dart';
import '../repositories/data_repository.dart';

class InventoryRegisterScreen extends StatefulWidget {
  const InventoryRegisterScreen({super.key});

  @override
  State<InventoryRegisterScreen> createState() => _InventoryRegisterScreenState();
}

class _InventoryRegisterScreenState extends State<InventoryRegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final DataRepository _repository = DataRepository();
  String? variedad;
  String? estado;
  String? cantidad;
  DateTime? fecha;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar Inventario'),
        backgroundColor: AppColors.liver,
        foregroundColor: Colors.white,
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
                  // Título descriptivo
                  const Text(
                    'Información del Inventario',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 24),
                  
                  // Variedad
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Variedad',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      prefixIcon: const Icon(Icons.grass, color: AppColors.coffee),
                    ),
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
                  const SizedBox(height: 20),
                  
                  // Estado
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Estado',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      prefixIcon: const Icon(Icons.inventory_2, color: AppColors.coffee),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'Pergamino seco', child: Text('Pergamino seco')),
                      DropdownMenuItem(value: 'Verde', child: Text('Verde')),
                      DropdownMenuItem(value: 'Tostado', child: Text('Tostado')),
                    ],
                    onChanged: (value) => setState(() => estado = value),
                    validator: (value) => value == null ? 'Selecciona un estado' : null,
                  ),
                  const SizedBox(height: 20),
                  
                  // Cantidad
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Cantidad (kg)',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      prefixIcon: const Icon(Icons.scale, color: AppColors.coffee),
                      suffixText: 'kg',
                    ),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    onChanged: (value) => cantidad = value,
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Ingresa la cantidad';
                      if (double.tryParse(value) == null) return 'Ingresa un número válido';
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  
                  // Fecha
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.calendar_today, color: AppColors.coffee),
                      title: Text(
                        fecha == null 
                          ? 'Selecciona la fecha' 
                          : 'Fecha: ${fecha!.day}/${fecha!.month}/${fecha!.year}',
                        style: TextStyle(color: fecha == null ? Colors.grey.shade600 : Colors.black),
                      ),
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2100),
                          builder: (context, child) {
                            return Theme(
                              data: Theme.of(context).copyWith(
                                colorScheme: const ColorScheme.light(
                                  primary: AppColors.liver,
                                  onPrimary: Colors.white,
                                  surface: Colors.white,
                                  onSurface: AppColors.bistre,
                                ),
                              ),
                              child: child!,
                            );
                          },
                        );
                        if (picked != null) {
                          setState(() => fecha = picked);
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 32),
                  
                  // Botón guardar
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.liver,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    icon: const Icon(Icons.save),
                    label: const Text('GUARDAR INVENTARIO', style: TextStyle(fontSize: 16)),
                    onPressed: () {
                      if (_formKey.currentState!.validate() && fecha != null) {
                        // First navigate back, then save the data
                        // This avoids using context after an async gap
                        Navigator.of(context).pop();
                        
                        // Now save the data without needing to use context afterward
                        _repository.addLote({
                          'variedad': variedad!,
                          'estado': estado!,
                          'cantidad': cantidad!,
                          'fecha': fecha!.toIso8601String(),
                        });
                      } else if (fecha == null) {
                        // Show error if date is not selected
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Por favor selecciona una fecha')),
                        );
                      }
                    },
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
