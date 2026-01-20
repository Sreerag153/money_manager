// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'eventmodel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EventModelAdapter extends TypeAdapter<EventModel> {
  @override
  final int typeId = 6;

  @override
  EventModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return EventModel(
      name: fields[0] as String,
      members: fields[1] as int,
      totalAmount: fields[2] as double,
      status: fields[3] as String,
      category: fields[4] as String?,
      splitAmount: fields[5] as double?,
      attachmentPath: fields[6] as String?,
      paymentType: fields[7] as String,
      expenceAdd: fields[8] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, EventModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.members)
      ..writeByte(2)
      ..write(obj.totalAmount)
      ..writeByte(3)
      ..write(obj.status)
      ..writeByte(4)
      ..write(obj.category)
      ..writeByte(5)
      ..write(obj.splitAmount)
      ..writeByte(6)
      ..write(obj.attachmentPath)
      ..writeByte(7)
      ..write(obj.paymentType)
      ..writeByte(8)
      ..write(obj.expenceAdd);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EventModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
