import 'package:freezed_annotation/freezed_annotation.dart';

part 'wedding_model.freezed.dart';
part 'wedding_model.g.dart';

@freezed
abstract class Wedding with _$Wedding {
  const Wedding._();

  const factory Wedding({
    required String id,
    @JsonKey(name: '_id') String? serverId,
    required String userId,
    required String slug,
    
    required String groomName,
    required String brideName,
    String? groomPhoto,
    String? bridePhoto,
    String? couplePhoto,
    
    required DateTime weddingDate,
    String? weddingTime,
    Venue? venue,
    String? invitationMessage,
    String? additionalNotes,
    
    FamilyInfo? brideFamily,
    FamilyInfo? groomFamily,
    
    String? coupleStory,
    DateTime? engagementDate,
    @Default([]) List<TimelineEvent> timeline,
    
    @Default([]) List<GalleryPhoto> engagementPhotos,
    @Default([]) List<GalleryPhoto> galleryPhotos,
    
    @Default('traditional-kerala') String templateId,
    @Default('en') String language,
    ThemeConfig? theme,
    
    @Default(false) bool isPublished,
    @Default(true) bool isDraft,
    @Default(true) bool isRsvpEnabled,
    
    String? metaTitle,
    String? metaDescription,
    String? ogImage,
    @Default(0) int viewCount,
    
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _Wedding;

  factory Wedding.fromJson(Map<String, dynamic> json) => _$WeddingFromJson(json);
}

@freezed
abstract class Venue with _$Venue {
  const factory Venue({
    String? name,
    String? address,
    String? mapUrl,
    Coordinates? coordinates,
  }) = _Venue;

  factory Venue.fromJson(Map<String, dynamic> json) => _$VenueFromJson(json);
}

@freezed
abstract class Coordinates with _$Coordinates {
  const factory Coordinates({
    double? lat,
    double? lng,
  }) = _Coordinates;

  factory Coordinates.fromJson(Map<String, dynamic> json) => _$CoordinatesFromJson(json);
}

@freezed
abstract class FamilyInfo with _$FamilyInfo {
  const factory FamilyInfo({
    String? fatherName,
    String? motherName,
    String? address,
  }) = _FamilyInfo;

  factory FamilyInfo.fromJson(Map<String, dynamic> json) => _$FamilyInfoFromJson(json);
}

@freezed
abstract class TimelineEvent with _$TimelineEvent {
  const factory TimelineEvent({
    required String title,
    DateTime? date,
    String? description,
  }) = _TimelineEvent;

  factory TimelineEvent.fromJson(Map<String, dynamic> json) => _$TimelineEventFromJson(json);
}

@freezed
abstract class GalleryPhoto with _$GalleryPhoto {
  const factory GalleryPhoto({
    required String url,
    String? publicId,
    String? caption,
    @Default(0) int order,
  }) = _GalleryPhoto;

  factory GalleryPhoto.fromJson(Map<String, dynamic> json) => _$GalleryPhotoFromJson(json);
}

@freezed
abstract class ThemeConfig with _$ThemeConfig {
  const factory ThemeConfig({
    @Default('#D4A574') String primaryColor,
    @Default('Playfair Display') String fontFamily,
    String? coverImage,
  }) = _ThemeConfig;

  factory ThemeConfig.fromJson(Map<String, dynamic> json) => _$ThemeConfigFromJson(json);
}
