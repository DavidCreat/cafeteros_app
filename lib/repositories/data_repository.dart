import 'package:hive_flutter/hive_flutter.dart';

part 'data_repository.g.dart';

@HiveType(typeId: 0)
class LoteModel extends HiveObject {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final DateTime fechaRegistro;
  
  @HiveField(2)
  final String variedad;
  
  @HiveField(3)
  final String estado;
  
  @HiveField(4)
  final double cantidad;

  LoteModel({
    required this.id,
    required this.fechaRegistro,
    required this.variedad,
    required this.estado,
    required this.cantidad,
  });
  
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fechaRegistro': fechaRegistro,
      'variedad': variedad,
      'estado': estado,
      'cantidad': cantidad,
    };
  }
}

class DataRepository {
  static final DataRepository _instance = DataRepository._internal();
  
  factory DataRepository() {
    return _instance;
  }
  
  DataRepository._internal();
  
  Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(LoteModelAdapter());
    await Hive.openBox<LoteModel>('lotes');
  }

  Box<LoteModel> get lotesBox => Hive.box<LoteModel>('lotes');

  Future<void> addLote(Map<String, dynamic> loteData) async {
    final lote = LoteModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      fechaRegistro: DateTime.now(),
      variedad: loteData['variedad'],
      estado: loteData['estado'],
      cantidad: double.parse(loteData['cantidad']),
    );
    await lotesBox.add(lote);
  }
  
  List<Map<String, dynamic>> getLotes() {
    final lotes = lotesBox.values.toList();
    if (lotes.isEmpty) {
      return [];
    }
    
    return lotes.map((lote) => {
      'id': lote.id,
      'fechaRegistro': lote.fechaRegistro,
      'variedad': lote.variedad,
      'estado': lote.estado,
      'cantidad': lote.cantidad.toString(),
    }).toList();
  }
  
  // Get total inventory weight
  double getTotalInventario() {
    final lotes = lotesBox.values.toList();
    if (lotes.isEmpty) {
      return 0;
    }
    
    return lotes.fold(0, (sum, lote) => sum + lote.cantidad);
  }
  
  // Get count of lots
  int getLotesCount() {
    return lotesBox.length;
  }
  
  // Clear all data (for testing)
  Future<void> clearAll() async {
    await lotesBox.clear();
  }
}

// The adapter is automatically generated in data_repository.g.dart