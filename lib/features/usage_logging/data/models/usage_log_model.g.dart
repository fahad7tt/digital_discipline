// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'usage_log_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UsageLogModelAdapter extends TypeAdapter<UsageLogModel> {
  @override
  final int typeId = 1;

  @override
  UsageLogModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UsageLogModel(
      id: fields[0] as String,
      focusAppId: fields[1] as String,
      durationMinutes: fields[2] as int,
      triggerType: fields[3] as String,
      loggedAt: fields[4] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, UsageLogModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.focusAppId)
      ..writeByte(2)
      ..write(obj.durationMinutes)
      ..writeByte(3)
      ..write(obj.triggerType)
      ..writeByte(4)
      ..write(obj.loggedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UsageLogModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
