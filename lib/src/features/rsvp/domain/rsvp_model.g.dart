// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rsvp_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Rsvp _$RsvpFromJson(Map<String, dynamic> json) => _Rsvp(
  id: json['id'] as String,
  serverId: json['_id'] as String?,
  weddingId: json['weddingId'] as String,
  guestName: json['guestName'] as String,
  phone: json['phone'] as String?,
  numberOfGuests: (json['numberOfGuests'] as num?)?.toInt() ?? 1,
  status: json['status'] as String,
  message: json['message'] as String?,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$RsvpToJson(_Rsvp instance) => <String, dynamic>{
  'id': instance.id,
  '_id': instance.serverId,
  'weddingId': instance.weddingId,
  'guestName': instance.guestName,
  'phone': instance.phone,
  'numberOfGuests': instance.numberOfGuests,
  'status': instance.status,
  'message': instance.message,
  'createdAt': instance.createdAt?.toIso8601String(),
};

_RsvpStats _$RsvpStatsFromJson(Map<String, dynamic> json) => _RsvpStats(
  total: (json['total'] as num?)?.toInt() ?? 0,
  attending: (json['attending'] as num?)?.toInt() ?? 0,
  notAttending: (json['notAttending'] as num?)?.toInt() ?? 0,
  maybe: (json['maybe'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$RsvpStatsToJson(_RsvpStats instance) =>
    <String, dynamic>{
      'total': instance.total,
      'attending': instance.attending,
      'notAttending': instance.notAttending,
      'maybe': instance.maybe,
    };
