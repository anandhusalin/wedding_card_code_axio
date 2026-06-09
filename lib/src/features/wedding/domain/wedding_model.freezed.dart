// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'wedding_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Wedding {

 String get id;@JsonKey(name: '_id') String? get serverId; String get userId; String get slug; String get groomName; String get brideName; String? get groomPhoto; String? get bridePhoto; String? get couplePhoto; DateTime get weddingDate; String? get weddingTime; Venue? get venue; String? get invitationMessage; String? get additionalNotes; FamilyInfo? get brideFamily; FamilyInfo? get groomFamily; String? get coupleStory; DateTime? get engagementDate; List<TimelineEvent> get timeline; List<GalleryPhoto> get engagementPhotos; List<GalleryPhoto> get galleryPhotos; String get templateId; String get language; ThemeConfig? get theme; bool get isPublished; bool get isDraft; bool get isRsvpEnabled; String? get metaTitle; String? get metaDescription; String? get ogImage; int get viewCount; DateTime? get createdAt; DateTime? get updatedAt;
/// Create a copy of Wedding
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WeddingCopyWith<Wedding> get copyWith => _$WeddingCopyWithImpl<Wedding>(this as Wedding, _$identity);

  /// Serializes this Wedding to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Wedding&&(identical(other.id, id) || other.id == id)&&(identical(other.serverId, serverId) || other.serverId == serverId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.groomName, groomName) || other.groomName == groomName)&&(identical(other.brideName, brideName) || other.brideName == brideName)&&(identical(other.groomPhoto, groomPhoto) || other.groomPhoto == groomPhoto)&&(identical(other.bridePhoto, bridePhoto) || other.bridePhoto == bridePhoto)&&(identical(other.couplePhoto, couplePhoto) || other.couplePhoto == couplePhoto)&&(identical(other.weddingDate, weddingDate) || other.weddingDate == weddingDate)&&(identical(other.weddingTime, weddingTime) || other.weddingTime == weddingTime)&&(identical(other.venue, venue) || other.venue == venue)&&(identical(other.invitationMessage, invitationMessage) || other.invitationMessage == invitationMessage)&&(identical(other.additionalNotes, additionalNotes) || other.additionalNotes == additionalNotes)&&(identical(other.brideFamily, brideFamily) || other.brideFamily == brideFamily)&&(identical(other.groomFamily, groomFamily) || other.groomFamily == groomFamily)&&(identical(other.coupleStory, coupleStory) || other.coupleStory == coupleStory)&&(identical(other.engagementDate, engagementDate) || other.engagementDate == engagementDate)&&const DeepCollectionEquality().equals(other.timeline, timeline)&&const DeepCollectionEquality().equals(other.engagementPhotos, engagementPhotos)&&const DeepCollectionEquality().equals(other.galleryPhotos, galleryPhotos)&&(identical(other.templateId, templateId) || other.templateId == templateId)&&(identical(other.language, language) || other.language == language)&&(identical(other.theme, theme) || other.theme == theme)&&(identical(other.isPublished, isPublished) || other.isPublished == isPublished)&&(identical(other.isDraft, isDraft) || other.isDraft == isDraft)&&(identical(other.isRsvpEnabled, isRsvpEnabled) || other.isRsvpEnabled == isRsvpEnabled)&&(identical(other.metaTitle, metaTitle) || other.metaTitle == metaTitle)&&(identical(other.metaDescription, metaDescription) || other.metaDescription == metaDescription)&&(identical(other.ogImage, ogImage) || other.ogImage == ogImage)&&(identical(other.viewCount, viewCount) || other.viewCount == viewCount)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,serverId,userId,slug,groomName,brideName,groomPhoto,bridePhoto,couplePhoto,weddingDate,weddingTime,venue,invitationMessage,additionalNotes,brideFamily,groomFamily,coupleStory,engagementDate,const DeepCollectionEquality().hash(timeline),const DeepCollectionEquality().hash(engagementPhotos),const DeepCollectionEquality().hash(galleryPhotos),templateId,language,theme,isPublished,isDraft,isRsvpEnabled,metaTitle,metaDescription,ogImage,viewCount,createdAt,updatedAt]);

@override
String toString() {
  return 'Wedding(id: $id, serverId: $serverId, userId: $userId, slug: $slug, groomName: $groomName, brideName: $brideName, groomPhoto: $groomPhoto, bridePhoto: $bridePhoto, couplePhoto: $couplePhoto, weddingDate: $weddingDate, weddingTime: $weddingTime, venue: $venue, invitationMessage: $invitationMessage, additionalNotes: $additionalNotes, brideFamily: $brideFamily, groomFamily: $groomFamily, coupleStory: $coupleStory, engagementDate: $engagementDate, timeline: $timeline, engagementPhotos: $engagementPhotos, galleryPhotos: $galleryPhotos, templateId: $templateId, language: $language, theme: $theme, isPublished: $isPublished, isDraft: $isDraft, isRsvpEnabled: $isRsvpEnabled, metaTitle: $metaTitle, metaDescription: $metaDescription, ogImage: $ogImage, viewCount: $viewCount, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $WeddingCopyWith<$Res>  {
  factory $WeddingCopyWith(Wedding value, $Res Function(Wedding) _then) = _$WeddingCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: '_id') String? serverId, String userId, String slug, String groomName, String brideName, String? groomPhoto, String? bridePhoto, String? couplePhoto, DateTime weddingDate, String? weddingTime, Venue? venue, String? invitationMessage, String? additionalNotes, FamilyInfo? brideFamily, FamilyInfo? groomFamily, String? coupleStory, DateTime? engagementDate, List<TimelineEvent> timeline, List<GalleryPhoto> engagementPhotos, List<GalleryPhoto> galleryPhotos, String templateId, String language, ThemeConfig? theme, bool isPublished, bool isDraft, bool isRsvpEnabled, String? metaTitle, String? metaDescription, String? ogImage, int viewCount, DateTime? createdAt, DateTime? updatedAt
});


$VenueCopyWith<$Res>? get venue;$FamilyInfoCopyWith<$Res>? get brideFamily;$FamilyInfoCopyWith<$Res>? get groomFamily;$ThemeConfigCopyWith<$Res>? get theme;

}
/// @nodoc
class _$WeddingCopyWithImpl<$Res>
    implements $WeddingCopyWith<$Res> {
  _$WeddingCopyWithImpl(this._self, this._then);

  final Wedding _self;
  final $Res Function(Wedding) _then;

/// Create a copy of Wedding
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? serverId = freezed,Object? userId = null,Object? slug = null,Object? groomName = null,Object? brideName = null,Object? groomPhoto = freezed,Object? bridePhoto = freezed,Object? couplePhoto = freezed,Object? weddingDate = null,Object? weddingTime = freezed,Object? venue = freezed,Object? invitationMessage = freezed,Object? additionalNotes = freezed,Object? brideFamily = freezed,Object? groomFamily = freezed,Object? coupleStory = freezed,Object? engagementDate = freezed,Object? timeline = null,Object? engagementPhotos = null,Object? galleryPhotos = null,Object? templateId = null,Object? language = null,Object? theme = freezed,Object? isPublished = null,Object? isDraft = null,Object? isRsvpEnabled = null,Object? metaTitle = freezed,Object? metaDescription = freezed,Object? ogImage = freezed,Object? viewCount = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,serverId: freezed == serverId ? _self.serverId : serverId // ignore: cast_nullable_to_non_nullable
as String?,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,groomName: null == groomName ? _self.groomName : groomName // ignore: cast_nullable_to_non_nullable
as String,brideName: null == brideName ? _self.brideName : brideName // ignore: cast_nullable_to_non_nullable
as String,groomPhoto: freezed == groomPhoto ? _self.groomPhoto : groomPhoto // ignore: cast_nullable_to_non_nullable
as String?,bridePhoto: freezed == bridePhoto ? _self.bridePhoto : bridePhoto // ignore: cast_nullable_to_non_nullable
as String?,couplePhoto: freezed == couplePhoto ? _self.couplePhoto : couplePhoto // ignore: cast_nullable_to_non_nullable
as String?,weddingDate: null == weddingDate ? _self.weddingDate : weddingDate // ignore: cast_nullable_to_non_nullable
as DateTime,weddingTime: freezed == weddingTime ? _self.weddingTime : weddingTime // ignore: cast_nullable_to_non_nullable
as String?,venue: freezed == venue ? _self.venue : venue // ignore: cast_nullable_to_non_nullable
as Venue?,invitationMessage: freezed == invitationMessage ? _self.invitationMessage : invitationMessage // ignore: cast_nullable_to_non_nullable
as String?,additionalNotes: freezed == additionalNotes ? _self.additionalNotes : additionalNotes // ignore: cast_nullable_to_non_nullable
as String?,brideFamily: freezed == brideFamily ? _self.brideFamily : brideFamily // ignore: cast_nullable_to_non_nullable
as FamilyInfo?,groomFamily: freezed == groomFamily ? _self.groomFamily : groomFamily // ignore: cast_nullable_to_non_nullable
as FamilyInfo?,coupleStory: freezed == coupleStory ? _self.coupleStory : coupleStory // ignore: cast_nullable_to_non_nullable
as String?,engagementDate: freezed == engagementDate ? _self.engagementDate : engagementDate // ignore: cast_nullable_to_non_nullable
as DateTime?,timeline: null == timeline ? _self.timeline : timeline // ignore: cast_nullable_to_non_nullable
as List<TimelineEvent>,engagementPhotos: null == engagementPhotos ? _self.engagementPhotos : engagementPhotos // ignore: cast_nullable_to_non_nullable
as List<GalleryPhoto>,galleryPhotos: null == galleryPhotos ? _self.galleryPhotos : galleryPhotos // ignore: cast_nullable_to_non_nullable
as List<GalleryPhoto>,templateId: null == templateId ? _self.templateId : templateId // ignore: cast_nullable_to_non_nullable
as String,language: null == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as String,theme: freezed == theme ? _self.theme : theme // ignore: cast_nullable_to_non_nullable
as ThemeConfig?,isPublished: null == isPublished ? _self.isPublished : isPublished // ignore: cast_nullable_to_non_nullable
as bool,isDraft: null == isDraft ? _self.isDraft : isDraft // ignore: cast_nullable_to_non_nullable
as bool,isRsvpEnabled: null == isRsvpEnabled ? _self.isRsvpEnabled : isRsvpEnabled // ignore: cast_nullable_to_non_nullable
as bool,metaTitle: freezed == metaTitle ? _self.metaTitle : metaTitle // ignore: cast_nullable_to_non_nullable
as String?,metaDescription: freezed == metaDescription ? _self.metaDescription : metaDescription // ignore: cast_nullable_to_non_nullable
as String?,ogImage: freezed == ogImage ? _self.ogImage : ogImage // ignore: cast_nullable_to_non_nullable
as String?,viewCount: null == viewCount ? _self.viewCount : viewCount // ignore: cast_nullable_to_non_nullable
as int,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}
/// Create a copy of Wedding
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$VenueCopyWith<$Res>? get venue {
    if (_self.venue == null) {
    return null;
  }

  return $VenueCopyWith<$Res>(_self.venue!, (value) {
    return _then(_self.copyWith(venue: value));
  });
}/// Create a copy of Wedding
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FamilyInfoCopyWith<$Res>? get brideFamily {
    if (_self.brideFamily == null) {
    return null;
  }

  return $FamilyInfoCopyWith<$Res>(_self.brideFamily!, (value) {
    return _then(_self.copyWith(brideFamily: value));
  });
}/// Create a copy of Wedding
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FamilyInfoCopyWith<$Res>? get groomFamily {
    if (_self.groomFamily == null) {
    return null;
  }

  return $FamilyInfoCopyWith<$Res>(_self.groomFamily!, (value) {
    return _then(_self.copyWith(groomFamily: value));
  });
}/// Create a copy of Wedding
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ThemeConfigCopyWith<$Res>? get theme {
    if (_self.theme == null) {
    return null;
  }

  return $ThemeConfigCopyWith<$Res>(_self.theme!, (value) {
    return _then(_self.copyWith(theme: value));
  });
}
}


/// Adds pattern-matching-related methods to [Wedding].
extension WeddingPatterns on Wedding {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Wedding value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Wedding() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Wedding value)  $default,){
final _that = this;
switch (_that) {
case _Wedding():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Wedding value)?  $default,){
final _that = this;
switch (_that) {
case _Wedding() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: '_id')  String? serverId,  String userId,  String slug,  String groomName,  String brideName,  String? groomPhoto,  String? bridePhoto,  String? couplePhoto,  DateTime weddingDate,  String? weddingTime,  Venue? venue,  String? invitationMessage,  String? additionalNotes,  FamilyInfo? brideFamily,  FamilyInfo? groomFamily,  String? coupleStory,  DateTime? engagementDate,  List<TimelineEvent> timeline,  List<GalleryPhoto> engagementPhotos,  List<GalleryPhoto> galleryPhotos,  String templateId,  String language,  ThemeConfig? theme,  bool isPublished,  bool isDraft,  bool isRsvpEnabled,  String? metaTitle,  String? metaDescription,  String? ogImage,  int viewCount,  DateTime? createdAt,  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Wedding() when $default != null:
return $default(_that.id,_that.serverId,_that.userId,_that.slug,_that.groomName,_that.brideName,_that.groomPhoto,_that.bridePhoto,_that.couplePhoto,_that.weddingDate,_that.weddingTime,_that.venue,_that.invitationMessage,_that.additionalNotes,_that.brideFamily,_that.groomFamily,_that.coupleStory,_that.engagementDate,_that.timeline,_that.engagementPhotos,_that.galleryPhotos,_that.templateId,_that.language,_that.theme,_that.isPublished,_that.isDraft,_that.isRsvpEnabled,_that.metaTitle,_that.metaDescription,_that.ogImage,_that.viewCount,_that.createdAt,_that.updatedAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: '_id')  String? serverId,  String userId,  String slug,  String groomName,  String brideName,  String? groomPhoto,  String? bridePhoto,  String? couplePhoto,  DateTime weddingDate,  String? weddingTime,  Venue? venue,  String? invitationMessage,  String? additionalNotes,  FamilyInfo? brideFamily,  FamilyInfo? groomFamily,  String? coupleStory,  DateTime? engagementDate,  List<TimelineEvent> timeline,  List<GalleryPhoto> engagementPhotos,  List<GalleryPhoto> galleryPhotos,  String templateId,  String language,  ThemeConfig? theme,  bool isPublished,  bool isDraft,  bool isRsvpEnabled,  String? metaTitle,  String? metaDescription,  String? ogImage,  int viewCount,  DateTime? createdAt,  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _Wedding():
return $default(_that.id,_that.serverId,_that.userId,_that.slug,_that.groomName,_that.brideName,_that.groomPhoto,_that.bridePhoto,_that.couplePhoto,_that.weddingDate,_that.weddingTime,_that.venue,_that.invitationMessage,_that.additionalNotes,_that.brideFamily,_that.groomFamily,_that.coupleStory,_that.engagementDate,_that.timeline,_that.engagementPhotos,_that.galleryPhotos,_that.templateId,_that.language,_that.theme,_that.isPublished,_that.isDraft,_that.isRsvpEnabled,_that.metaTitle,_that.metaDescription,_that.ogImage,_that.viewCount,_that.createdAt,_that.updatedAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: '_id')  String? serverId,  String userId,  String slug,  String groomName,  String brideName,  String? groomPhoto,  String? bridePhoto,  String? couplePhoto,  DateTime weddingDate,  String? weddingTime,  Venue? venue,  String? invitationMessage,  String? additionalNotes,  FamilyInfo? brideFamily,  FamilyInfo? groomFamily,  String? coupleStory,  DateTime? engagementDate,  List<TimelineEvent> timeline,  List<GalleryPhoto> engagementPhotos,  List<GalleryPhoto> galleryPhotos,  String templateId,  String language,  ThemeConfig? theme,  bool isPublished,  bool isDraft,  bool isRsvpEnabled,  String? metaTitle,  String? metaDescription,  String? ogImage,  int viewCount,  DateTime? createdAt,  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _Wedding() when $default != null:
return $default(_that.id,_that.serverId,_that.userId,_that.slug,_that.groomName,_that.brideName,_that.groomPhoto,_that.bridePhoto,_that.couplePhoto,_that.weddingDate,_that.weddingTime,_that.venue,_that.invitationMessage,_that.additionalNotes,_that.brideFamily,_that.groomFamily,_that.coupleStory,_that.engagementDate,_that.timeline,_that.engagementPhotos,_that.galleryPhotos,_that.templateId,_that.language,_that.theme,_that.isPublished,_that.isDraft,_that.isRsvpEnabled,_that.metaTitle,_that.metaDescription,_that.ogImage,_that.viewCount,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Wedding extends Wedding {
  const _Wedding({required this.id, @JsonKey(name: '_id') this.serverId, required this.userId, required this.slug, required this.groomName, required this.brideName, this.groomPhoto, this.bridePhoto, this.couplePhoto, required this.weddingDate, this.weddingTime, this.venue, this.invitationMessage, this.additionalNotes, this.brideFamily, this.groomFamily, this.coupleStory, this.engagementDate, final  List<TimelineEvent> timeline = const [], final  List<GalleryPhoto> engagementPhotos = const [], final  List<GalleryPhoto> galleryPhotos = const [], this.templateId = 'traditional-kerala', this.language = 'en', this.theme, this.isPublished = false, this.isDraft = true, this.isRsvpEnabled = true, this.metaTitle, this.metaDescription, this.ogImage, this.viewCount = 0, this.createdAt, this.updatedAt}): _timeline = timeline,_engagementPhotos = engagementPhotos,_galleryPhotos = galleryPhotos,super._();
  factory _Wedding.fromJson(Map<String, dynamic> json) => _$WeddingFromJson(json);

@override final  String id;
@override@JsonKey(name: '_id') final  String? serverId;
@override final  String userId;
@override final  String slug;
@override final  String groomName;
@override final  String brideName;
@override final  String? groomPhoto;
@override final  String? bridePhoto;
@override final  String? couplePhoto;
@override final  DateTime weddingDate;
@override final  String? weddingTime;
@override final  Venue? venue;
@override final  String? invitationMessage;
@override final  String? additionalNotes;
@override final  FamilyInfo? brideFamily;
@override final  FamilyInfo? groomFamily;
@override final  String? coupleStory;
@override final  DateTime? engagementDate;
 final  List<TimelineEvent> _timeline;
@override@JsonKey() List<TimelineEvent> get timeline {
  if (_timeline is EqualUnmodifiableListView) return _timeline;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_timeline);
}

 final  List<GalleryPhoto> _engagementPhotos;
@override@JsonKey() List<GalleryPhoto> get engagementPhotos {
  if (_engagementPhotos is EqualUnmodifiableListView) return _engagementPhotos;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_engagementPhotos);
}

 final  List<GalleryPhoto> _galleryPhotos;
@override@JsonKey() List<GalleryPhoto> get galleryPhotos {
  if (_galleryPhotos is EqualUnmodifiableListView) return _galleryPhotos;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_galleryPhotos);
}

@override@JsonKey() final  String templateId;
@override@JsonKey() final  String language;
@override final  ThemeConfig? theme;
@override@JsonKey() final  bool isPublished;
@override@JsonKey() final  bool isDraft;
@override@JsonKey() final  bool isRsvpEnabled;
@override final  String? metaTitle;
@override final  String? metaDescription;
@override final  String? ogImage;
@override@JsonKey() final  int viewCount;
@override final  DateTime? createdAt;
@override final  DateTime? updatedAt;

/// Create a copy of Wedding
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WeddingCopyWith<_Wedding> get copyWith => __$WeddingCopyWithImpl<_Wedding>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WeddingToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Wedding&&(identical(other.id, id) || other.id == id)&&(identical(other.serverId, serverId) || other.serverId == serverId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.groomName, groomName) || other.groomName == groomName)&&(identical(other.brideName, brideName) || other.brideName == brideName)&&(identical(other.groomPhoto, groomPhoto) || other.groomPhoto == groomPhoto)&&(identical(other.bridePhoto, bridePhoto) || other.bridePhoto == bridePhoto)&&(identical(other.couplePhoto, couplePhoto) || other.couplePhoto == couplePhoto)&&(identical(other.weddingDate, weddingDate) || other.weddingDate == weddingDate)&&(identical(other.weddingTime, weddingTime) || other.weddingTime == weddingTime)&&(identical(other.venue, venue) || other.venue == venue)&&(identical(other.invitationMessage, invitationMessage) || other.invitationMessage == invitationMessage)&&(identical(other.additionalNotes, additionalNotes) || other.additionalNotes == additionalNotes)&&(identical(other.brideFamily, brideFamily) || other.brideFamily == brideFamily)&&(identical(other.groomFamily, groomFamily) || other.groomFamily == groomFamily)&&(identical(other.coupleStory, coupleStory) || other.coupleStory == coupleStory)&&(identical(other.engagementDate, engagementDate) || other.engagementDate == engagementDate)&&const DeepCollectionEquality().equals(other._timeline, _timeline)&&const DeepCollectionEquality().equals(other._engagementPhotos, _engagementPhotos)&&const DeepCollectionEquality().equals(other._galleryPhotos, _galleryPhotos)&&(identical(other.templateId, templateId) || other.templateId == templateId)&&(identical(other.language, language) || other.language == language)&&(identical(other.theme, theme) || other.theme == theme)&&(identical(other.isPublished, isPublished) || other.isPublished == isPublished)&&(identical(other.isDraft, isDraft) || other.isDraft == isDraft)&&(identical(other.isRsvpEnabled, isRsvpEnabled) || other.isRsvpEnabled == isRsvpEnabled)&&(identical(other.metaTitle, metaTitle) || other.metaTitle == metaTitle)&&(identical(other.metaDescription, metaDescription) || other.metaDescription == metaDescription)&&(identical(other.ogImage, ogImage) || other.ogImage == ogImage)&&(identical(other.viewCount, viewCount) || other.viewCount == viewCount)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,serverId,userId,slug,groomName,brideName,groomPhoto,bridePhoto,couplePhoto,weddingDate,weddingTime,venue,invitationMessage,additionalNotes,brideFamily,groomFamily,coupleStory,engagementDate,const DeepCollectionEquality().hash(_timeline),const DeepCollectionEquality().hash(_engagementPhotos),const DeepCollectionEquality().hash(_galleryPhotos),templateId,language,theme,isPublished,isDraft,isRsvpEnabled,metaTitle,metaDescription,ogImage,viewCount,createdAt,updatedAt]);

@override
String toString() {
  return 'Wedding(id: $id, serverId: $serverId, userId: $userId, slug: $slug, groomName: $groomName, brideName: $brideName, groomPhoto: $groomPhoto, bridePhoto: $bridePhoto, couplePhoto: $couplePhoto, weddingDate: $weddingDate, weddingTime: $weddingTime, venue: $venue, invitationMessage: $invitationMessage, additionalNotes: $additionalNotes, brideFamily: $brideFamily, groomFamily: $groomFamily, coupleStory: $coupleStory, engagementDate: $engagementDate, timeline: $timeline, engagementPhotos: $engagementPhotos, galleryPhotos: $galleryPhotos, templateId: $templateId, language: $language, theme: $theme, isPublished: $isPublished, isDraft: $isDraft, isRsvpEnabled: $isRsvpEnabled, metaTitle: $metaTitle, metaDescription: $metaDescription, ogImage: $ogImage, viewCount: $viewCount, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$WeddingCopyWith<$Res> implements $WeddingCopyWith<$Res> {
  factory _$WeddingCopyWith(_Wedding value, $Res Function(_Wedding) _then) = __$WeddingCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: '_id') String? serverId, String userId, String slug, String groomName, String brideName, String? groomPhoto, String? bridePhoto, String? couplePhoto, DateTime weddingDate, String? weddingTime, Venue? venue, String? invitationMessage, String? additionalNotes, FamilyInfo? brideFamily, FamilyInfo? groomFamily, String? coupleStory, DateTime? engagementDate, List<TimelineEvent> timeline, List<GalleryPhoto> engagementPhotos, List<GalleryPhoto> galleryPhotos, String templateId, String language, ThemeConfig? theme, bool isPublished, bool isDraft, bool isRsvpEnabled, String? metaTitle, String? metaDescription, String? ogImage, int viewCount, DateTime? createdAt, DateTime? updatedAt
});


@override $VenueCopyWith<$Res>? get venue;@override $FamilyInfoCopyWith<$Res>? get brideFamily;@override $FamilyInfoCopyWith<$Res>? get groomFamily;@override $ThemeConfigCopyWith<$Res>? get theme;

}
/// @nodoc
class __$WeddingCopyWithImpl<$Res>
    implements _$WeddingCopyWith<$Res> {
  __$WeddingCopyWithImpl(this._self, this._then);

  final _Wedding _self;
  final $Res Function(_Wedding) _then;

/// Create a copy of Wedding
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? serverId = freezed,Object? userId = null,Object? slug = null,Object? groomName = null,Object? brideName = null,Object? groomPhoto = freezed,Object? bridePhoto = freezed,Object? couplePhoto = freezed,Object? weddingDate = null,Object? weddingTime = freezed,Object? venue = freezed,Object? invitationMessage = freezed,Object? additionalNotes = freezed,Object? brideFamily = freezed,Object? groomFamily = freezed,Object? coupleStory = freezed,Object? engagementDate = freezed,Object? timeline = null,Object? engagementPhotos = null,Object? galleryPhotos = null,Object? templateId = null,Object? language = null,Object? theme = freezed,Object? isPublished = null,Object? isDraft = null,Object? isRsvpEnabled = null,Object? metaTitle = freezed,Object? metaDescription = freezed,Object? ogImage = freezed,Object? viewCount = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_Wedding(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,serverId: freezed == serverId ? _self.serverId : serverId // ignore: cast_nullable_to_non_nullable
as String?,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,groomName: null == groomName ? _self.groomName : groomName // ignore: cast_nullable_to_non_nullable
as String,brideName: null == brideName ? _self.brideName : brideName // ignore: cast_nullable_to_non_nullable
as String,groomPhoto: freezed == groomPhoto ? _self.groomPhoto : groomPhoto // ignore: cast_nullable_to_non_nullable
as String?,bridePhoto: freezed == bridePhoto ? _self.bridePhoto : bridePhoto // ignore: cast_nullable_to_non_nullable
as String?,couplePhoto: freezed == couplePhoto ? _self.couplePhoto : couplePhoto // ignore: cast_nullable_to_non_nullable
as String?,weddingDate: null == weddingDate ? _self.weddingDate : weddingDate // ignore: cast_nullable_to_non_nullable
as DateTime,weddingTime: freezed == weddingTime ? _self.weddingTime : weddingTime // ignore: cast_nullable_to_non_nullable
as String?,venue: freezed == venue ? _self.venue : venue // ignore: cast_nullable_to_non_nullable
as Venue?,invitationMessage: freezed == invitationMessage ? _self.invitationMessage : invitationMessage // ignore: cast_nullable_to_non_nullable
as String?,additionalNotes: freezed == additionalNotes ? _self.additionalNotes : additionalNotes // ignore: cast_nullable_to_non_nullable
as String?,brideFamily: freezed == brideFamily ? _self.brideFamily : brideFamily // ignore: cast_nullable_to_non_nullable
as FamilyInfo?,groomFamily: freezed == groomFamily ? _self.groomFamily : groomFamily // ignore: cast_nullable_to_non_nullable
as FamilyInfo?,coupleStory: freezed == coupleStory ? _self.coupleStory : coupleStory // ignore: cast_nullable_to_non_nullable
as String?,engagementDate: freezed == engagementDate ? _self.engagementDate : engagementDate // ignore: cast_nullable_to_non_nullable
as DateTime?,timeline: null == timeline ? _self._timeline : timeline // ignore: cast_nullable_to_non_nullable
as List<TimelineEvent>,engagementPhotos: null == engagementPhotos ? _self._engagementPhotos : engagementPhotos // ignore: cast_nullable_to_non_nullable
as List<GalleryPhoto>,galleryPhotos: null == galleryPhotos ? _self._galleryPhotos : galleryPhotos // ignore: cast_nullable_to_non_nullable
as List<GalleryPhoto>,templateId: null == templateId ? _self.templateId : templateId // ignore: cast_nullable_to_non_nullable
as String,language: null == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as String,theme: freezed == theme ? _self.theme : theme // ignore: cast_nullable_to_non_nullable
as ThemeConfig?,isPublished: null == isPublished ? _self.isPublished : isPublished // ignore: cast_nullable_to_non_nullable
as bool,isDraft: null == isDraft ? _self.isDraft : isDraft // ignore: cast_nullable_to_non_nullable
as bool,isRsvpEnabled: null == isRsvpEnabled ? _self.isRsvpEnabled : isRsvpEnabled // ignore: cast_nullable_to_non_nullable
as bool,metaTitle: freezed == metaTitle ? _self.metaTitle : metaTitle // ignore: cast_nullable_to_non_nullable
as String?,metaDescription: freezed == metaDescription ? _self.metaDescription : metaDescription // ignore: cast_nullable_to_non_nullable
as String?,ogImage: freezed == ogImage ? _self.ogImage : ogImage // ignore: cast_nullable_to_non_nullable
as String?,viewCount: null == viewCount ? _self.viewCount : viewCount // ignore: cast_nullable_to_non_nullable
as int,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

/// Create a copy of Wedding
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$VenueCopyWith<$Res>? get venue {
    if (_self.venue == null) {
    return null;
  }

  return $VenueCopyWith<$Res>(_self.venue!, (value) {
    return _then(_self.copyWith(venue: value));
  });
}/// Create a copy of Wedding
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FamilyInfoCopyWith<$Res>? get brideFamily {
    if (_self.brideFamily == null) {
    return null;
  }

  return $FamilyInfoCopyWith<$Res>(_self.brideFamily!, (value) {
    return _then(_self.copyWith(brideFamily: value));
  });
}/// Create a copy of Wedding
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FamilyInfoCopyWith<$Res>? get groomFamily {
    if (_self.groomFamily == null) {
    return null;
  }

  return $FamilyInfoCopyWith<$Res>(_self.groomFamily!, (value) {
    return _then(_self.copyWith(groomFamily: value));
  });
}/// Create a copy of Wedding
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ThemeConfigCopyWith<$Res>? get theme {
    if (_self.theme == null) {
    return null;
  }

  return $ThemeConfigCopyWith<$Res>(_self.theme!, (value) {
    return _then(_self.copyWith(theme: value));
  });
}
}


/// @nodoc
mixin _$Venue {

 String? get name; String? get address; String? get mapUrl; Coordinates? get coordinates;
/// Create a copy of Venue
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VenueCopyWith<Venue> get copyWith => _$VenueCopyWithImpl<Venue>(this as Venue, _$identity);

  /// Serializes this Venue to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Venue&&(identical(other.name, name) || other.name == name)&&(identical(other.address, address) || other.address == address)&&(identical(other.mapUrl, mapUrl) || other.mapUrl == mapUrl)&&(identical(other.coordinates, coordinates) || other.coordinates == coordinates));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,address,mapUrl,coordinates);

@override
String toString() {
  return 'Venue(name: $name, address: $address, mapUrl: $mapUrl, coordinates: $coordinates)';
}


}

/// @nodoc
abstract mixin class $VenueCopyWith<$Res>  {
  factory $VenueCopyWith(Venue value, $Res Function(Venue) _then) = _$VenueCopyWithImpl;
@useResult
$Res call({
 String? name, String? address, String? mapUrl, Coordinates? coordinates
});


$CoordinatesCopyWith<$Res>? get coordinates;

}
/// @nodoc
class _$VenueCopyWithImpl<$Res>
    implements $VenueCopyWith<$Res> {
  _$VenueCopyWithImpl(this._self, this._then);

  final Venue _self;
  final $Res Function(Venue) _then;

/// Create a copy of Venue
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = freezed,Object? address = freezed,Object? mapUrl = freezed,Object? coordinates = freezed,}) {
  return _then(_self.copyWith(
name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,mapUrl: freezed == mapUrl ? _self.mapUrl : mapUrl // ignore: cast_nullable_to_non_nullable
as String?,coordinates: freezed == coordinates ? _self.coordinates : coordinates // ignore: cast_nullable_to_non_nullable
as Coordinates?,
  ));
}
/// Create a copy of Venue
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CoordinatesCopyWith<$Res>? get coordinates {
    if (_self.coordinates == null) {
    return null;
  }

  return $CoordinatesCopyWith<$Res>(_self.coordinates!, (value) {
    return _then(_self.copyWith(coordinates: value));
  });
}
}


/// Adds pattern-matching-related methods to [Venue].
extension VenuePatterns on Venue {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Venue value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Venue() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Venue value)  $default,){
final _that = this;
switch (_that) {
case _Venue():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Venue value)?  $default,){
final _that = this;
switch (_that) {
case _Venue() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? name,  String? address,  String? mapUrl,  Coordinates? coordinates)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Venue() when $default != null:
return $default(_that.name,_that.address,_that.mapUrl,_that.coordinates);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? name,  String? address,  String? mapUrl,  Coordinates? coordinates)  $default,) {final _that = this;
switch (_that) {
case _Venue():
return $default(_that.name,_that.address,_that.mapUrl,_that.coordinates);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? name,  String? address,  String? mapUrl,  Coordinates? coordinates)?  $default,) {final _that = this;
switch (_that) {
case _Venue() when $default != null:
return $default(_that.name,_that.address,_that.mapUrl,_that.coordinates);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Venue implements Venue {
  const _Venue({this.name, this.address, this.mapUrl, this.coordinates});
  factory _Venue.fromJson(Map<String, dynamic> json) => _$VenueFromJson(json);

@override final  String? name;
@override final  String? address;
@override final  String? mapUrl;
@override final  Coordinates? coordinates;

/// Create a copy of Venue
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VenueCopyWith<_Venue> get copyWith => __$VenueCopyWithImpl<_Venue>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$VenueToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Venue&&(identical(other.name, name) || other.name == name)&&(identical(other.address, address) || other.address == address)&&(identical(other.mapUrl, mapUrl) || other.mapUrl == mapUrl)&&(identical(other.coordinates, coordinates) || other.coordinates == coordinates));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,address,mapUrl,coordinates);

@override
String toString() {
  return 'Venue(name: $name, address: $address, mapUrl: $mapUrl, coordinates: $coordinates)';
}


}

/// @nodoc
abstract mixin class _$VenueCopyWith<$Res> implements $VenueCopyWith<$Res> {
  factory _$VenueCopyWith(_Venue value, $Res Function(_Venue) _then) = __$VenueCopyWithImpl;
@override @useResult
$Res call({
 String? name, String? address, String? mapUrl, Coordinates? coordinates
});


@override $CoordinatesCopyWith<$Res>? get coordinates;

}
/// @nodoc
class __$VenueCopyWithImpl<$Res>
    implements _$VenueCopyWith<$Res> {
  __$VenueCopyWithImpl(this._self, this._then);

  final _Venue _self;
  final $Res Function(_Venue) _then;

/// Create a copy of Venue
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = freezed,Object? address = freezed,Object? mapUrl = freezed,Object? coordinates = freezed,}) {
  return _then(_Venue(
name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,mapUrl: freezed == mapUrl ? _self.mapUrl : mapUrl // ignore: cast_nullable_to_non_nullable
as String?,coordinates: freezed == coordinates ? _self.coordinates : coordinates // ignore: cast_nullable_to_non_nullable
as Coordinates?,
  ));
}

/// Create a copy of Venue
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CoordinatesCopyWith<$Res>? get coordinates {
    if (_self.coordinates == null) {
    return null;
  }

  return $CoordinatesCopyWith<$Res>(_self.coordinates!, (value) {
    return _then(_self.copyWith(coordinates: value));
  });
}
}


/// @nodoc
mixin _$Coordinates {

 double? get lat; double? get lng;
/// Create a copy of Coordinates
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CoordinatesCopyWith<Coordinates> get copyWith => _$CoordinatesCopyWithImpl<Coordinates>(this as Coordinates, _$identity);

  /// Serializes this Coordinates to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Coordinates&&(identical(other.lat, lat) || other.lat == lat)&&(identical(other.lng, lng) || other.lng == lng));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,lat,lng);

@override
String toString() {
  return 'Coordinates(lat: $lat, lng: $lng)';
}


}

/// @nodoc
abstract mixin class $CoordinatesCopyWith<$Res>  {
  factory $CoordinatesCopyWith(Coordinates value, $Res Function(Coordinates) _then) = _$CoordinatesCopyWithImpl;
@useResult
$Res call({
 double? lat, double? lng
});




}
/// @nodoc
class _$CoordinatesCopyWithImpl<$Res>
    implements $CoordinatesCopyWith<$Res> {
  _$CoordinatesCopyWithImpl(this._self, this._then);

  final Coordinates _self;
  final $Res Function(Coordinates) _then;

/// Create a copy of Coordinates
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? lat = freezed,Object? lng = freezed,}) {
  return _then(_self.copyWith(
lat: freezed == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double?,lng: freezed == lng ? _self.lng : lng // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// Adds pattern-matching-related methods to [Coordinates].
extension CoordinatesPatterns on Coordinates {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Coordinates value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Coordinates() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Coordinates value)  $default,){
final _that = this;
switch (_that) {
case _Coordinates():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Coordinates value)?  $default,){
final _that = this;
switch (_that) {
case _Coordinates() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double? lat,  double? lng)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Coordinates() when $default != null:
return $default(_that.lat,_that.lng);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double? lat,  double? lng)  $default,) {final _that = this;
switch (_that) {
case _Coordinates():
return $default(_that.lat,_that.lng);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double? lat,  double? lng)?  $default,) {final _that = this;
switch (_that) {
case _Coordinates() when $default != null:
return $default(_that.lat,_that.lng);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Coordinates implements Coordinates {
  const _Coordinates({this.lat, this.lng});
  factory _Coordinates.fromJson(Map<String, dynamic> json) => _$CoordinatesFromJson(json);

@override final  double? lat;
@override final  double? lng;

/// Create a copy of Coordinates
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CoordinatesCopyWith<_Coordinates> get copyWith => __$CoordinatesCopyWithImpl<_Coordinates>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CoordinatesToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Coordinates&&(identical(other.lat, lat) || other.lat == lat)&&(identical(other.lng, lng) || other.lng == lng));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,lat,lng);

@override
String toString() {
  return 'Coordinates(lat: $lat, lng: $lng)';
}


}

/// @nodoc
abstract mixin class _$CoordinatesCopyWith<$Res> implements $CoordinatesCopyWith<$Res> {
  factory _$CoordinatesCopyWith(_Coordinates value, $Res Function(_Coordinates) _then) = __$CoordinatesCopyWithImpl;
@override @useResult
$Res call({
 double? lat, double? lng
});




}
/// @nodoc
class __$CoordinatesCopyWithImpl<$Res>
    implements _$CoordinatesCopyWith<$Res> {
  __$CoordinatesCopyWithImpl(this._self, this._then);

  final _Coordinates _self;
  final $Res Function(_Coordinates) _then;

/// Create a copy of Coordinates
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? lat = freezed,Object? lng = freezed,}) {
  return _then(_Coordinates(
lat: freezed == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double?,lng: freezed == lng ? _self.lng : lng // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}


/// @nodoc
mixin _$FamilyInfo {

 String? get fatherName; String? get motherName; String? get address;
/// Create a copy of FamilyInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FamilyInfoCopyWith<FamilyInfo> get copyWith => _$FamilyInfoCopyWithImpl<FamilyInfo>(this as FamilyInfo, _$identity);

  /// Serializes this FamilyInfo to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FamilyInfo&&(identical(other.fatherName, fatherName) || other.fatherName == fatherName)&&(identical(other.motherName, motherName) || other.motherName == motherName)&&(identical(other.address, address) || other.address == address));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,fatherName,motherName,address);

@override
String toString() {
  return 'FamilyInfo(fatherName: $fatherName, motherName: $motherName, address: $address)';
}


}

/// @nodoc
abstract mixin class $FamilyInfoCopyWith<$Res>  {
  factory $FamilyInfoCopyWith(FamilyInfo value, $Res Function(FamilyInfo) _then) = _$FamilyInfoCopyWithImpl;
@useResult
$Res call({
 String? fatherName, String? motherName, String? address
});




}
/// @nodoc
class _$FamilyInfoCopyWithImpl<$Res>
    implements $FamilyInfoCopyWith<$Res> {
  _$FamilyInfoCopyWithImpl(this._self, this._then);

  final FamilyInfo _self;
  final $Res Function(FamilyInfo) _then;

/// Create a copy of FamilyInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? fatherName = freezed,Object? motherName = freezed,Object? address = freezed,}) {
  return _then(_self.copyWith(
fatherName: freezed == fatherName ? _self.fatherName : fatherName // ignore: cast_nullable_to_non_nullable
as String?,motherName: freezed == motherName ? _self.motherName : motherName // ignore: cast_nullable_to_non_nullable
as String?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [FamilyInfo].
extension FamilyInfoPatterns on FamilyInfo {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FamilyInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FamilyInfo() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FamilyInfo value)  $default,){
final _that = this;
switch (_that) {
case _FamilyInfo():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FamilyInfo value)?  $default,){
final _that = this;
switch (_that) {
case _FamilyInfo() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? fatherName,  String? motherName,  String? address)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FamilyInfo() when $default != null:
return $default(_that.fatherName,_that.motherName,_that.address);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? fatherName,  String? motherName,  String? address)  $default,) {final _that = this;
switch (_that) {
case _FamilyInfo():
return $default(_that.fatherName,_that.motherName,_that.address);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? fatherName,  String? motherName,  String? address)?  $default,) {final _that = this;
switch (_that) {
case _FamilyInfo() when $default != null:
return $default(_that.fatherName,_that.motherName,_that.address);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FamilyInfo implements FamilyInfo {
  const _FamilyInfo({this.fatherName, this.motherName, this.address});
  factory _FamilyInfo.fromJson(Map<String, dynamic> json) => _$FamilyInfoFromJson(json);

@override final  String? fatherName;
@override final  String? motherName;
@override final  String? address;

/// Create a copy of FamilyInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FamilyInfoCopyWith<_FamilyInfo> get copyWith => __$FamilyInfoCopyWithImpl<_FamilyInfo>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FamilyInfoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FamilyInfo&&(identical(other.fatherName, fatherName) || other.fatherName == fatherName)&&(identical(other.motherName, motherName) || other.motherName == motherName)&&(identical(other.address, address) || other.address == address));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,fatherName,motherName,address);

@override
String toString() {
  return 'FamilyInfo(fatherName: $fatherName, motherName: $motherName, address: $address)';
}


}

/// @nodoc
abstract mixin class _$FamilyInfoCopyWith<$Res> implements $FamilyInfoCopyWith<$Res> {
  factory _$FamilyInfoCopyWith(_FamilyInfo value, $Res Function(_FamilyInfo) _then) = __$FamilyInfoCopyWithImpl;
@override @useResult
$Res call({
 String? fatherName, String? motherName, String? address
});




}
/// @nodoc
class __$FamilyInfoCopyWithImpl<$Res>
    implements _$FamilyInfoCopyWith<$Res> {
  __$FamilyInfoCopyWithImpl(this._self, this._then);

  final _FamilyInfo _self;
  final $Res Function(_FamilyInfo) _then;

/// Create a copy of FamilyInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? fatherName = freezed,Object? motherName = freezed,Object? address = freezed,}) {
  return _then(_FamilyInfo(
fatherName: freezed == fatherName ? _self.fatherName : fatherName // ignore: cast_nullable_to_non_nullable
as String?,motherName: freezed == motherName ? _self.motherName : motherName // ignore: cast_nullable_to_non_nullable
as String?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$TimelineEvent {

 String get title; DateTime? get date; String? get description;
/// Create a copy of TimelineEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TimelineEventCopyWith<TimelineEvent> get copyWith => _$TimelineEventCopyWithImpl<TimelineEvent>(this as TimelineEvent, _$identity);

  /// Serializes this TimelineEvent to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TimelineEvent&&(identical(other.title, title) || other.title == title)&&(identical(other.date, date) || other.date == date)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,date,description);

@override
String toString() {
  return 'TimelineEvent(title: $title, date: $date, description: $description)';
}


}

/// @nodoc
abstract mixin class $TimelineEventCopyWith<$Res>  {
  factory $TimelineEventCopyWith(TimelineEvent value, $Res Function(TimelineEvent) _then) = _$TimelineEventCopyWithImpl;
@useResult
$Res call({
 String title, DateTime? date, String? description
});




}
/// @nodoc
class _$TimelineEventCopyWithImpl<$Res>
    implements $TimelineEventCopyWith<$Res> {
  _$TimelineEventCopyWithImpl(this._self, this._then);

  final TimelineEvent _self;
  final $Res Function(TimelineEvent) _then;

/// Create a copy of TimelineEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = null,Object? date = freezed,Object? description = freezed,}) {
  return _then(_self.copyWith(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,date: freezed == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [TimelineEvent].
extension TimelineEventPatterns on TimelineEvent {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TimelineEvent value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TimelineEvent() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TimelineEvent value)  $default,){
final _that = this;
switch (_that) {
case _TimelineEvent():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TimelineEvent value)?  $default,){
final _that = this;
switch (_that) {
case _TimelineEvent() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String title,  DateTime? date,  String? description)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TimelineEvent() when $default != null:
return $default(_that.title,_that.date,_that.description);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String title,  DateTime? date,  String? description)  $default,) {final _that = this;
switch (_that) {
case _TimelineEvent():
return $default(_that.title,_that.date,_that.description);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String title,  DateTime? date,  String? description)?  $default,) {final _that = this;
switch (_that) {
case _TimelineEvent() when $default != null:
return $default(_that.title,_that.date,_that.description);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TimelineEvent implements TimelineEvent {
  const _TimelineEvent({required this.title, this.date, this.description});
  factory _TimelineEvent.fromJson(Map<String, dynamic> json) => _$TimelineEventFromJson(json);

@override final  String title;
@override final  DateTime? date;
@override final  String? description;

/// Create a copy of TimelineEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TimelineEventCopyWith<_TimelineEvent> get copyWith => __$TimelineEventCopyWithImpl<_TimelineEvent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TimelineEventToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TimelineEvent&&(identical(other.title, title) || other.title == title)&&(identical(other.date, date) || other.date == date)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,date,description);

@override
String toString() {
  return 'TimelineEvent(title: $title, date: $date, description: $description)';
}


}

/// @nodoc
abstract mixin class _$TimelineEventCopyWith<$Res> implements $TimelineEventCopyWith<$Res> {
  factory _$TimelineEventCopyWith(_TimelineEvent value, $Res Function(_TimelineEvent) _then) = __$TimelineEventCopyWithImpl;
@override @useResult
$Res call({
 String title, DateTime? date, String? description
});




}
/// @nodoc
class __$TimelineEventCopyWithImpl<$Res>
    implements _$TimelineEventCopyWith<$Res> {
  __$TimelineEventCopyWithImpl(this._self, this._then);

  final _TimelineEvent _self;
  final $Res Function(_TimelineEvent) _then;

/// Create a copy of TimelineEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? date = freezed,Object? description = freezed,}) {
  return _then(_TimelineEvent(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,date: freezed == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$GalleryPhoto {

 String get url; String? get publicId; String? get caption; int get order;
/// Create a copy of GalleryPhoto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GalleryPhotoCopyWith<GalleryPhoto> get copyWith => _$GalleryPhotoCopyWithImpl<GalleryPhoto>(this as GalleryPhoto, _$identity);

  /// Serializes this GalleryPhoto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GalleryPhoto&&(identical(other.url, url) || other.url == url)&&(identical(other.publicId, publicId) || other.publicId == publicId)&&(identical(other.caption, caption) || other.caption == caption)&&(identical(other.order, order) || other.order == order));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,url,publicId,caption,order);

@override
String toString() {
  return 'GalleryPhoto(url: $url, publicId: $publicId, caption: $caption, order: $order)';
}


}

/// @nodoc
abstract mixin class $GalleryPhotoCopyWith<$Res>  {
  factory $GalleryPhotoCopyWith(GalleryPhoto value, $Res Function(GalleryPhoto) _then) = _$GalleryPhotoCopyWithImpl;
@useResult
$Res call({
 String url, String? publicId, String? caption, int order
});




}
/// @nodoc
class _$GalleryPhotoCopyWithImpl<$Res>
    implements $GalleryPhotoCopyWith<$Res> {
  _$GalleryPhotoCopyWithImpl(this._self, this._then);

  final GalleryPhoto _self;
  final $Res Function(GalleryPhoto) _then;

/// Create a copy of GalleryPhoto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? url = null,Object? publicId = freezed,Object? caption = freezed,Object? order = null,}) {
  return _then(_self.copyWith(
url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,publicId: freezed == publicId ? _self.publicId : publicId // ignore: cast_nullable_to_non_nullable
as String?,caption: freezed == caption ? _self.caption : caption // ignore: cast_nullable_to_non_nullable
as String?,order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [GalleryPhoto].
extension GalleryPhotoPatterns on GalleryPhoto {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GalleryPhoto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GalleryPhoto() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GalleryPhoto value)  $default,){
final _that = this;
switch (_that) {
case _GalleryPhoto():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GalleryPhoto value)?  $default,){
final _that = this;
switch (_that) {
case _GalleryPhoto() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String url,  String? publicId,  String? caption,  int order)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GalleryPhoto() when $default != null:
return $default(_that.url,_that.publicId,_that.caption,_that.order);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String url,  String? publicId,  String? caption,  int order)  $default,) {final _that = this;
switch (_that) {
case _GalleryPhoto():
return $default(_that.url,_that.publicId,_that.caption,_that.order);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String url,  String? publicId,  String? caption,  int order)?  $default,) {final _that = this;
switch (_that) {
case _GalleryPhoto() when $default != null:
return $default(_that.url,_that.publicId,_that.caption,_that.order);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GalleryPhoto implements GalleryPhoto {
  const _GalleryPhoto({required this.url, this.publicId, this.caption, this.order = 0});
  factory _GalleryPhoto.fromJson(Map<String, dynamic> json) => _$GalleryPhotoFromJson(json);

@override final  String url;
@override final  String? publicId;
@override final  String? caption;
@override@JsonKey() final  int order;

/// Create a copy of GalleryPhoto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GalleryPhotoCopyWith<_GalleryPhoto> get copyWith => __$GalleryPhotoCopyWithImpl<_GalleryPhoto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GalleryPhotoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GalleryPhoto&&(identical(other.url, url) || other.url == url)&&(identical(other.publicId, publicId) || other.publicId == publicId)&&(identical(other.caption, caption) || other.caption == caption)&&(identical(other.order, order) || other.order == order));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,url,publicId,caption,order);

@override
String toString() {
  return 'GalleryPhoto(url: $url, publicId: $publicId, caption: $caption, order: $order)';
}


}

/// @nodoc
abstract mixin class _$GalleryPhotoCopyWith<$Res> implements $GalleryPhotoCopyWith<$Res> {
  factory _$GalleryPhotoCopyWith(_GalleryPhoto value, $Res Function(_GalleryPhoto) _then) = __$GalleryPhotoCopyWithImpl;
@override @useResult
$Res call({
 String url, String? publicId, String? caption, int order
});




}
/// @nodoc
class __$GalleryPhotoCopyWithImpl<$Res>
    implements _$GalleryPhotoCopyWith<$Res> {
  __$GalleryPhotoCopyWithImpl(this._self, this._then);

  final _GalleryPhoto _self;
  final $Res Function(_GalleryPhoto) _then;

/// Create a copy of GalleryPhoto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? url = null,Object? publicId = freezed,Object? caption = freezed,Object? order = null,}) {
  return _then(_GalleryPhoto(
url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,publicId: freezed == publicId ? _self.publicId : publicId // ignore: cast_nullable_to_non_nullable
as String?,caption: freezed == caption ? _self.caption : caption // ignore: cast_nullable_to_non_nullable
as String?,order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$ThemeConfig {

 String get primaryColor; String get fontFamily; String? get coverImage;
/// Create a copy of ThemeConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ThemeConfigCopyWith<ThemeConfig> get copyWith => _$ThemeConfigCopyWithImpl<ThemeConfig>(this as ThemeConfig, _$identity);

  /// Serializes this ThemeConfig to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ThemeConfig&&(identical(other.primaryColor, primaryColor) || other.primaryColor == primaryColor)&&(identical(other.fontFamily, fontFamily) || other.fontFamily == fontFamily)&&(identical(other.coverImage, coverImage) || other.coverImage == coverImage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,primaryColor,fontFamily,coverImage);

@override
String toString() {
  return 'ThemeConfig(primaryColor: $primaryColor, fontFamily: $fontFamily, coverImage: $coverImage)';
}


}

/// @nodoc
abstract mixin class $ThemeConfigCopyWith<$Res>  {
  factory $ThemeConfigCopyWith(ThemeConfig value, $Res Function(ThemeConfig) _then) = _$ThemeConfigCopyWithImpl;
@useResult
$Res call({
 String primaryColor, String fontFamily, String? coverImage
});




}
/// @nodoc
class _$ThemeConfigCopyWithImpl<$Res>
    implements $ThemeConfigCopyWith<$Res> {
  _$ThemeConfigCopyWithImpl(this._self, this._then);

  final ThemeConfig _self;
  final $Res Function(ThemeConfig) _then;

/// Create a copy of ThemeConfig
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? primaryColor = null,Object? fontFamily = null,Object? coverImage = freezed,}) {
  return _then(_self.copyWith(
primaryColor: null == primaryColor ? _self.primaryColor : primaryColor // ignore: cast_nullable_to_non_nullable
as String,fontFamily: null == fontFamily ? _self.fontFamily : fontFamily // ignore: cast_nullable_to_non_nullable
as String,coverImage: freezed == coverImage ? _self.coverImage : coverImage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ThemeConfig].
extension ThemeConfigPatterns on ThemeConfig {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ThemeConfig value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ThemeConfig() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ThemeConfig value)  $default,){
final _that = this;
switch (_that) {
case _ThemeConfig():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ThemeConfig value)?  $default,){
final _that = this;
switch (_that) {
case _ThemeConfig() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String primaryColor,  String fontFamily,  String? coverImage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ThemeConfig() when $default != null:
return $default(_that.primaryColor,_that.fontFamily,_that.coverImage);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String primaryColor,  String fontFamily,  String? coverImage)  $default,) {final _that = this;
switch (_that) {
case _ThemeConfig():
return $default(_that.primaryColor,_that.fontFamily,_that.coverImage);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String primaryColor,  String fontFamily,  String? coverImage)?  $default,) {final _that = this;
switch (_that) {
case _ThemeConfig() when $default != null:
return $default(_that.primaryColor,_that.fontFamily,_that.coverImage);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ThemeConfig implements ThemeConfig {
  const _ThemeConfig({this.primaryColor = '#D4A574', this.fontFamily = 'Playfair Display', this.coverImage});
  factory _ThemeConfig.fromJson(Map<String, dynamic> json) => _$ThemeConfigFromJson(json);

@override@JsonKey() final  String primaryColor;
@override@JsonKey() final  String fontFamily;
@override final  String? coverImage;

/// Create a copy of ThemeConfig
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ThemeConfigCopyWith<_ThemeConfig> get copyWith => __$ThemeConfigCopyWithImpl<_ThemeConfig>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ThemeConfigToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ThemeConfig&&(identical(other.primaryColor, primaryColor) || other.primaryColor == primaryColor)&&(identical(other.fontFamily, fontFamily) || other.fontFamily == fontFamily)&&(identical(other.coverImage, coverImage) || other.coverImage == coverImage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,primaryColor,fontFamily,coverImage);

@override
String toString() {
  return 'ThemeConfig(primaryColor: $primaryColor, fontFamily: $fontFamily, coverImage: $coverImage)';
}


}

/// @nodoc
abstract mixin class _$ThemeConfigCopyWith<$Res> implements $ThemeConfigCopyWith<$Res> {
  factory _$ThemeConfigCopyWith(_ThemeConfig value, $Res Function(_ThemeConfig) _then) = __$ThemeConfigCopyWithImpl;
@override @useResult
$Res call({
 String primaryColor, String fontFamily, String? coverImage
});




}
/// @nodoc
class __$ThemeConfigCopyWithImpl<$Res>
    implements _$ThemeConfigCopyWith<$Res> {
  __$ThemeConfigCopyWithImpl(this._self, this._then);

  final _ThemeConfig _self;
  final $Res Function(_ThemeConfig) _then;

/// Create a copy of ThemeConfig
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? primaryColor = null,Object? fontFamily = null,Object? coverImage = freezed,}) {
  return _then(_ThemeConfig(
primaryColor: null == primaryColor ? _self.primaryColor : primaryColor // ignore: cast_nullable_to_non_nullable
as String,fontFamily: null == fontFamily ? _self.fontFamily : fontFamily // ignore: cast_nullable_to_non_nullable
as String,coverImage: freezed == coverImage ? _self.coverImage : coverImage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
