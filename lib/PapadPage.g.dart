// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'PapadPage.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Playlistdata _$PlaylistdataFromJson(Map<String, dynamic> json) {
  return Playlistdata(
    id: json['id'] as int,
    name: json['name'] as String,
    description: json['description'] as String,
    audiolink: json['upload'] as String,
  );
}

Map<String, dynamic> _$PlaylistdataToJson(Playlistdata instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'upload': instance.audiolink,
      'description': instance.description,
    };
