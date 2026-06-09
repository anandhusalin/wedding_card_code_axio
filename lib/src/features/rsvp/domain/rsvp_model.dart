import 'package:freezed_annotation/freezed_annotation.dart';

part 'rsvp_model.freezed.dart';
part 'rsvp_model.g.dart';

@freezed
abstract class Rsvp with _$Rsvp {
  const Rsvp._();

  const factory Rsvp({
    required String id,
    @JsonKey(name: '_id') String? serverId,
    required String weddingId,
    required String guestName,
    String? phone,
    @Default(1) int numberOfGuests,
    required String status,
    String? message,
    DateTime? createdAt,
  }) = _Rsvp;

  factory Rsvp.fromJson(Map<String, dynamic> json) => _$RsvpFromJson(json);
}

@freezed
abstract class RsvpStats with _$RsvpStats {
  const factory RsvpStats({
    @Default(0) int total,
    @Default(0) int attending,
    @Default(0) int notAttending,
    @Default(0) int maybe,
  }) = _RsvpStats;

  factory RsvpStats.fromJson(Map<String, dynamic> json) => _$RsvpStatsFromJson(json);
}
