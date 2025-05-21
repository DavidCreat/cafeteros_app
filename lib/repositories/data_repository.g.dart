// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_repository.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LoteModelAdapter extends TypeAdapter<LoteModel> {
  @override
  final int typeId = 0;

  @override
  LoteModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LoteModel(
      id: fields[0] as String,
      fechaRegistro: fields[1] as DateTime,
      variedad: fields[2] as String,
      estado: fields[3] as String,
      cantidad: fields[4] as double,
    );
  }

  @override
  void write(BinaryWriter writer, LoteModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.fechaRegistro)
      ..writeByte(2)
      ..write(obj.variedad)
      ..writeByte(3)
      ..write(obj.estado)
      ..writeByte(4)
      ..write(obj.cantidad);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LoteModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
