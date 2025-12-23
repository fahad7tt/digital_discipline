// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'usage_log_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AppUsageModelAdapter extends TypeAdapter<AppUsageModel> {
  @override
  final int typeId = 1;

  @override
  AppUsageModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AppUsageModel(
      packageName: fields[0] as String,
      appName: fields[1] as String,
      minutesUsed: fields[2] as int,
    );
  }

  @override
  void write(BinaryWriter writer, AppUsageModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.packageName)
      ..writeByte(1)
      ..write(obj.appName)
      ..writeByte(2)
      ..write(obj.minutesUsed);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppUsageModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
