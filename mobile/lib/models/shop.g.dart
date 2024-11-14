// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shop.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ShopAdapter extends TypeAdapter<Shop> {
  @override
  final int typeId = 0;

  @override
  Shop read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Shop(
      id: fields[0] as int,
      name: fields[1] as String,
      ville: fields[2] as String,
      adresse: fields[3] as String,
      layout: (fields[4] as List)
          .map((dynamic e) => (e as List).cast<ShopCell>())
          .toList(),
    );
  }

  @override
  void write(BinaryWriter writer, Shop obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.ville)
      ..writeByte(3)
      ..write(obj.adresse)
      ..writeByte(4)
      ..write(obj.layout);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShopAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ShopCellAdapter extends TypeAdapter<ShopCell> {
  @override
  final int typeId = 1;

  @override
  ShopCell read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ShopCell(
      name: fields[0] as String,
      size: fields[1] as int,
      type: fields[2] as String,
      isBeacon: fields[3] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, ShopCell obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.size)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.isBeacon);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShopCellAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
