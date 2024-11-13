// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'show_doctors.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DoctorsAdapter extends TypeAdapter<Doctors> {
  @override
  final int typeId = 2;

  @override
  Doctors read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Doctors(
      id: fields[0] as int,
      firstName: fields[1] as String,
      lastName: fields[2] as String,
      phone: fields[3] as String?,
      specialization: fields[4] as String?,
      startWork: fields[5] as String?,
      finishWork: fields[6] as String?,
      photo: fields[7] as String?,
      email: fields[8] as String?,
      password: fields[9] as String?,
      birthday: fields[10] as String?,
      collageDegree: fields[11] as String?,
      createdAt: fields[12] as String?,
      updatedAt: fields[13] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Doctors obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.firstName)
      ..writeByte(2)
      ..write(obj.lastName)
      ..writeByte(3)
      ..write(obj.phone)
      ..writeByte(4)
      ..write(obj.specialization)
      ..writeByte(5)
      ..write(obj.startWork)
      ..writeByte(6)
      ..write(obj.finishWork)
      ..writeByte(7)
      ..write(obj.photo)
      ..writeByte(8)
      ..write(obj.email)
      ..writeByte(9)
      ..write(obj.password)
      ..writeByte(10)
      ..write(obj.birthday)
      ..writeByte(11)
      ..write(obj.collageDegree)
      ..writeByte(12)
      ..write(obj.createdAt)
      ..writeByte(13)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DoctorsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
