// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reflection_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ReflectionModelAdapter extends TypeAdapter<ReflectionModel> {
  @override
  final int typeId = 2;

  @override
  ReflectionModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ReflectionModel(
      id: fields[0] as String,
      date: fields[1] as DateTime,
      mood: fields[2] as String,
      note: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ReflectionModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.mood)
      ..writeByte(3)
      ..write(obj.note);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReflectionModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
