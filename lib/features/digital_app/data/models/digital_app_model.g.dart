// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'digital_app_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DigitalAppModelAdapter extends TypeAdapter<DigitalAppModel> {
  @override
  final int typeId = 0;

  @override
  DigitalAppModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DigitalAppModel(
      id: fields[0] as String,
      name: fields[1] as String,
      dailyLimitMinutes: fields[2] as int,
      createdAt: fields[3] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, DigitalAppModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.dailyLimitMinutes)
      ..writeByte(3)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DigitalAppModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
