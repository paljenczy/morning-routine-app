// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'completion_record.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CompletionRecordAdapter extends TypeAdapter<CompletionRecord> {
  @override
  final int typeId = 2;

  @override
  CompletionRecord read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CompletionRecord(
      childId: fields[0] as String,
      activityId: fields[1] as String,
      dateKey: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, CompletionRecord obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.childId)
      ..writeByte(1)
      ..write(obj.activityId)
      ..writeByte(2)
      ..write(obj.dateKey);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CompletionRecordAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
