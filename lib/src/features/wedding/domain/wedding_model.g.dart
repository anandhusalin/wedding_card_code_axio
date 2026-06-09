// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wedding_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Wedding _$WeddingFromJson(Map<String, dynamic> json) => _Wedding(
  id: json['id'] as String,
  serverId: json['_id'] as String?,
  userId: json['userId'] as String,
  slug: json['slug'] as String,
  groomName: json['groomName'] as String,
  brideName: json['brideName'] as String,
  groomPhoto: json['groomPhoto'] as String?,
  bridePhoto: json['bridePhoto'] as String?,
  couplePhoto: json['couplePhoto'] as String?,
  weddingDate: DateTime.parse(json['weddingDate'] as String),
  weddingTime: json['weddingTime'] as String?,
  venue: json['venue'] == null
      ? null
      : Venue.fromJson(json['venue'] as Map<String, dynamic>),
  invitationMessage: json['invitationMessage'] as String?,
  additionalNotes: json['additionalNotes'] as String?,
  brideFamily: json['brideFamily'] == null
      ? null
      : FamilyInfo.fromJson(json['brideFamily'] as Map<String, dynamic>),
  groomFamily: json['groomFamily'] == null
      ? null
      : FamilyInfo.fromJson(json['groomFamily'] as Map<String, dynamic>),
  coupleStory: json['coupleStory'] as String?,
  engagementDate: json['engagementDate'] == null
      ? null
      : DateTime.parse(json['engagementDate'] as String),
  timeline:
      (json['timeline'] as List<dynamic>?)
          ?.map((e) => TimelineEvent.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  engagementPhotos:
      (json['engagementPhotos'] as List<dynamic>?)
          ?.map((e) => GalleryPhoto.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  galleryPhotos:
      (json['galleryPhotos'] as List<dynamic>?)
          ?.map((e) => GalleryPhoto.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  templateId: json['templateId'] as String? ?? 'traditional-kerala',
  language: json['language'] as String? ?? 'en',
  theme: json['theme'] == null
      ? null
      : ThemeConfig.fromJson(json['theme'] as Map<String, dynamic>),
  isPublished: json['isPublished'] as bool? ?? false,
  isDraft: json['isDraft'] as bool? ?? true,
  isRsvpEnabled: json['isRsvpEnabled'] as bool? ?? true,
  metaTitle: json['metaTitle'] as String?,
  metaDescription: json['metaDescription'] as String?,
  ogImage: json['ogImage'] as String?,
  viewCount: (json['viewCount'] as num?)?.toInt() ?? 0,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$WeddingToJson(_Wedding instance) => <String, dynamic>{
  'id': instance.id,
  '_id': instance.serverId,
  'userId': instance.userId,
  'slug': instance.slug,
  'groomName': instance.groomName,
  'brideName': instance.brideName,
  'groomPhoto': instance.groomPhoto,
  'bridePhoto': instance.bridePhoto,
  'couplePhoto': instance.couplePhoto,
  'weddingDate': instance.weddingDate.toIso8601String(),
  'weddingTime': instance.weddingTime,
  'venue': instance.venue,
  'invitationMessage': instance.invitationMessage,
  'additionalNotes': instance.additionalNotes,
  'brideFamily': instance.brideFamily,
  'groomFamily': instance.groomFamily,
  'coupleStory': instance.coupleStory,
  'engagementDate': instance.engagementDate?.toIso8601String(),
  'timeline': instance.timeline,
  'engagementPhotos': instance.engagementPhotos,
  'galleryPhotos': instance.galleryPhotos,
  'templateId': instance.templateId,
  'language': instance.language,
  'theme': instance.theme,
  'isPublished': instance.isPublished,
  'isDraft': instance.isDraft,
  'isRsvpEnabled': instance.isRsvpEnabled,
  'metaTitle': instance.metaTitle,
  'metaDescription': instance.metaDescription,
  'ogImage': instance.ogImage,
  'viewCount': instance.viewCount,
  'createdAt': instance.createdAt?.toIso8601String(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
};

_Venue _$VenueFromJson(Map<String, dynamic> json) => _Venue(
  name: json['name'] as String?,
  address: json['address'] as String?,
  mapUrl: json['mapUrl'] as String?,
  coordinates: json['coordinates'] == null
      ? null
      : Coordinates.fromJson(json['coordinates'] as Map<String, dynamic>),
);

Map<String, dynamic> _$VenueToJson(_Venue instance) => <String, dynamic>{
  'name': instance.name,
  'address': instance.address,
  'mapUrl': instance.mapUrl,
  'coordinates': instance.coordinates,
};

_Coordinates _$CoordinatesFromJson(Map<String, dynamic> json) => _Coordinates(
  lat: (json['lat'] as num?)?.toDouble(),
  lng: (json['lng'] as num?)?.toDouble(),
);

Map<String, dynamic> _$CoordinatesToJson(_Coordinates instance) =>
    <String, dynamic>{'lat': instance.lat, 'lng': instance.lng};

_FamilyInfo _$FamilyInfoFromJson(Map<String, dynamic> json) => _FamilyInfo(
  fatherName: json['fatherName'] as String?,
  motherName: json['motherName'] as String?,
  address: json['address'] as String?,
);

Map<String, dynamic> _$FamilyInfoToJson(_FamilyInfo instance) =>
    <String, dynamic>{
      'fatherName': instance.fatherName,
      'motherName': instance.motherName,
      'address': instance.address,
    };

_TimelineEvent _$TimelineEventFromJson(Map<String, dynamic> json) =>
    _TimelineEvent(
      title: json['title'] as String,
      date: json['date'] == null
          ? null
          : DateTime.parse(json['date'] as String),
      description: json['description'] as String?,
    );

Map<String, dynamic> _$TimelineEventToJson(_TimelineEvent instance) =>
    <String, dynamic>{
      'title': instance.title,
      'date': instance.date?.toIso8601String(),
      'description': instance.description,
    };

_GalleryPhoto _$GalleryPhotoFromJson(Map<String, dynamic> json) =>
    _GalleryPhoto(
      url: json['url'] as String,
      publicId: json['publicId'] as String?,
      caption: json['caption'] as String?,
      order: (json['order'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$GalleryPhotoToJson(_GalleryPhoto instance) =>
    <String, dynamic>{
      'url': instance.url,
      'publicId': instance.publicId,
      'caption': instance.caption,
      'order': instance.order,
    };

_ThemeConfig _$ThemeConfigFromJson(Map<String, dynamic> json) => _ThemeConfig(
  primaryColor: json['primaryColor'] as String? ?? '#D4A574',
  fontFamily: json['fontFamily'] as String? ?? 'Playfair Display',
  coverImage: json['coverImage'] as String?,
);

Map<String, dynamic> _$ThemeConfigToJson(_ThemeConfig instance) =>
    <String, dynamic>{
      'primaryColor': instance.primaryColor,
      'fontFamily': instance.fontFamily,
      'coverImage': instance.coverImage,
    };
