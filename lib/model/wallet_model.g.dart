// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WalletModelAdapter extends TypeAdapter<WalletModel> {
  @override
  final int typeId = 2;

  @override
  WalletModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WalletModel(
      cashIncome: fields[0] as double,
      cashExpense: fields[1] as double,
      accIncome: fields[2] as double,
      accExpense: fields[3] as double,
    );
  }

  @override
  void write(BinaryWriter writer, WalletModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.cashIncome)
      ..writeByte(1)
      ..write(obj.cashExpense)
      ..writeByte(2)
      ..write(obj.accIncome)
      ..writeByte(3)
      ..write(obj.accExpense);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WalletModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
