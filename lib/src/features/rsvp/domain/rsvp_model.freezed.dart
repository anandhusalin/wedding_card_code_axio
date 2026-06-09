// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'rsvp_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Rsvp {

 String get id;@JsonKey(name: '_id') String? get serverId; String get weddingId; String get guestName; String? get phone; int get numberOfGuests; String get status; String? get message; DateTime? get createdAt;
/// Create a copy of Rsvp
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RsvpCopyWith<Rsvp> get copyWith => _$RsvpCopyWithImpl<Rsvp>(this as Rsvp, _$identity);

  /// Serializes this Rsvp to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Rsvp&&(identical(other.id, id) || other.id == id)&&(identical(other.serverId, serverId) || other.serverId == serverId)&&(identical(other.weddingId, weddingId) || other.weddingId == weddingId)&&(identical(other.guestName, guestName) || other.guestName == guestName)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.numberOfGuests, numberOfGuests) || other.numberOfGuests == numberOfGuests)&&(identical(other.status, status) || other.status == status)&&(identical(other.message, message) || other.message == message)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,serverId,weddingId,guestName,phone,numberOfGuests,status,message,createdAt);

@override
String toString() {
  return 'Rsvp(id: $id, serverId: $serverId, weddingId: $weddingId, guestName: $guestName, phone: $phone, numberOfGuests: $numberOfGuests, status: $status, message: $message, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $RsvpCopyWith<$Res>  {
  factory $RsvpCopyWith(Rsvp value, $Res Function(Rsvp) _then) = _$RsvpCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: '_id') String? serverId, String weddingId, String guestName, String? phone, int numberOfGuests, String status, String? message, DateTime? createdAt
});




}
/// @nodoc
class _$RsvpCopyWithImpl<$Res>
    implements $RsvpCopyWith<$Res> {
  _$RsvpCopyWithImpl(this._self, this._then);

  final Rsvp _self;
  final $Res Function(Rsvp) _then;

/// Create a copy of Rsvp
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? serverId = freezed,Object? weddingId = null,Object? guestName = null,Object? phone = freezed,Object? numberOfGuests = null,Object? status = null,Object? message = freezed,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,serverId: freezed == serverId ? _self.serverId : serverId // ignore: cast_nullable_to_non_nullable
as String?,weddingId: null == weddingId ? _self.weddingId : weddingId // ignore: cast_nullable_to_non_nullable
as String,guestName: null == guestName ? _self.guestName : guestName // ignore: cast_nullable_to_non_nullable
as String,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,numberOfGuests: null == numberOfGuests ? _self.numberOfGuests : numberOfGuests // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [Rsvp].
extension RsvpPatterns on Rsvp {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Rsvp value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Rsvp() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Rsvp value)  $default,){
final _that = this;
switch (_that) {
case _Rsvp():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Rsvp value)?  $default,){
final _that = this;
switch (_that) {
case _Rsvp() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: '_id')  String? serverId,  String weddingId,  String guestName,  String? phone,  int numberOfGuests,  String status,  String? message,  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Rsvp() when $default != null:
return $default(_that.id,_that.serverId,_that.weddingId,_that.guestName,_that.phone,_that.numberOfGuests,_that.status,_that.message,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: '_id')  String? serverId,  String weddingId,  String guestName,  String? phone,  int numberOfGuests,  String status,  String? message,  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _Rsvp():
return $default(_that.id,_that.serverId,_that.weddingId,_that.guestName,_that.phone,_that.numberOfGuests,_that.status,_that.message,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: '_id')  String? serverId,  String weddingId,  String guestName,  String? phone,  int numberOfGuests,  String status,  String? message,  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _Rsvp() when $default != null:
return $default(_that.id,_that.serverId,_that.weddingId,_that.guestName,_that.phone,_that.numberOfGuests,_that.status,_that.message,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Rsvp extends Rsvp {
  const _Rsvp({required this.id, @JsonKey(name: '_id') this.serverId, required this.weddingId, required this.guestName, this.phone, this.numberOfGuests = 1, required this.status, this.message, this.createdAt}): super._();
  factory _Rsvp.fromJson(Map<String, dynamic> json) => _$RsvpFromJson(json);

@override final  String id;
@override@JsonKey(name: '_id') final  String? serverId;
@override final  String weddingId;
@override final  String guestName;
@override final  String? phone;
@override@JsonKey() final  int numberOfGuests;
@override final  String status;
@override final  String? message;
@override final  DateTime? createdAt;

/// Create a copy of Rsvp
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RsvpCopyWith<_Rsvp> get copyWith => __$RsvpCopyWithImpl<_Rsvp>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RsvpToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Rsvp&&(identical(other.id, id) || other.id == id)&&(identical(other.serverId, serverId) || other.serverId == serverId)&&(identical(other.weddingId, weddingId) || other.weddingId == weddingId)&&(identical(other.guestName, guestName) || other.guestName == guestName)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.numberOfGuests, numberOfGuests) || other.numberOfGuests == numberOfGuests)&&(identical(other.status, status) || other.status == status)&&(identical(other.message, message) || other.message == message)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,serverId,weddingId,guestName,phone,numberOfGuests,status,message,createdAt);

@override
String toString() {
  return 'Rsvp(id: $id, serverId: $serverId, weddingId: $weddingId, guestName: $guestName, phone: $phone, numberOfGuests: $numberOfGuests, status: $status, message: $message, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$RsvpCopyWith<$Res> implements $RsvpCopyWith<$Res> {
  factory _$RsvpCopyWith(_Rsvp value, $Res Function(_Rsvp) _then) = __$RsvpCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: '_id') String? serverId, String weddingId, String guestName, String? phone, int numberOfGuests, String status, String? message, DateTime? createdAt
});




}
/// @nodoc
class __$RsvpCopyWithImpl<$Res>
    implements _$RsvpCopyWith<$Res> {
  __$RsvpCopyWithImpl(this._self, this._then);

  final _Rsvp _self;
  final $Res Function(_Rsvp) _then;

/// Create a copy of Rsvp
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? serverId = freezed,Object? weddingId = null,Object? guestName = null,Object? phone = freezed,Object? numberOfGuests = null,Object? status = null,Object? message = freezed,Object? createdAt = freezed,}) {
  return _then(_Rsvp(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,serverId: freezed == serverId ? _self.serverId : serverId // ignore: cast_nullable_to_non_nullable
as String?,weddingId: null == weddingId ? _self.weddingId : weddingId // ignore: cast_nullable_to_non_nullable
as String,guestName: null == guestName ? _self.guestName : guestName // ignore: cast_nullable_to_non_nullable
as String,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,numberOfGuests: null == numberOfGuests ? _self.numberOfGuests : numberOfGuests // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$RsvpStats {

 int get total; int get attending; int get notAttending; int get maybe;
/// Create a copy of RsvpStats
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RsvpStatsCopyWith<RsvpStats> get copyWith => _$RsvpStatsCopyWithImpl<RsvpStats>(this as RsvpStats, _$identity);

  /// Serializes this RsvpStats to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RsvpStats&&(identical(other.total, total) || other.total == total)&&(identical(other.attending, attending) || other.attending == attending)&&(identical(other.notAttending, notAttending) || other.notAttending == notAttending)&&(identical(other.maybe, maybe) || other.maybe == maybe));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,total,attending,notAttending,maybe);

@override
String toString() {
  return 'RsvpStats(total: $total, attending: $attending, notAttending: $notAttending, maybe: $maybe)';
}


}

/// @nodoc
abstract mixin class $RsvpStatsCopyWith<$Res>  {
  factory $RsvpStatsCopyWith(RsvpStats value, $Res Function(RsvpStats) _then) = _$RsvpStatsCopyWithImpl;
@useResult
$Res call({
 int total, int attending, int notAttending, int maybe
});




}
/// @nodoc
class _$RsvpStatsCopyWithImpl<$Res>
    implements $RsvpStatsCopyWith<$Res> {
  _$RsvpStatsCopyWithImpl(this._self, this._then);

  final RsvpStats _self;
  final $Res Function(RsvpStats) _then;

/// Create a copy of RsvpStats
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? total = null,Object? attending = null,Object? notAttending = null,Object? maybe = null,}) {
  return _then(_self.copyWith(
total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,attending: null == attending ? _self.attending : attending // ignore: cast_nullable_to_non_nullable
as int,notAttending: null == notAttending ? _self.notAttending : notAttending // ignore: cast_nullable_to_non_nullable
as int,maybe: null == maybe ? _self.maybe : maybe // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [RsvpStats].
extension RsvpStatsPatterns on RsvpStats {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RsvpStats value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RsvpStats() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RsvpStats value)  $default,){
final _that = this;
switch (_that) {
case _RsvpStats():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RsvpStats value)?  $default,){
final _that = this;
switch (_that) {
case _RsvpStats() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int total,  int attending,  int notAttending,  int maybe)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RsvpStats() when $default != null:
return $default(_that.total,_that.attending,_that.notAttending,_that.maybe);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int total,  int attending,  int notAttending,  int maybe)  $default,) {final _that = this;
switch (_that) {
case _RsvpStats():
return $default(_that.total,_that.attending,_that.notAttending,_that.maybe);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int total,  int attending,  int notAttending,  int maybe)?  $default,) {final _that = this;
switch (_that) {
case _RsvpStats() when $default != null:
return $default(_that.total,_that.attending,_that.notAttending,_that.maybe);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RsvpStats implements RsvpStats {
  const _RsvpStats({this.total = 0, this.attending = 0, this.notAttending = 0, this.maybe = 0});
  factory _RsvpStats.fromJson(Map<String, dynamic> json) => _$RsvpStatsFromJson(json);

@override@JsonKey() final  int total;
@override@JsonKey() final  int attending;
@override@JsonKey() final  int notAttending;
@override@JsonKey() final  int maybe;

/// Create a copy of RsvpStats
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RsvpStatsCopyWith<_RsvpStats> get copyWith => __$RsvpStatsCopyWithImpl<_RsvpStats>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RsvpStatsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RsvpStats&&(identical(other.total, total) || other.total == total)&&(identical(other.attending, attending) || other.attending == attending)&&(identical(other.notAttending, notAttending) || other.notAttending == notAttending)&&(identical(other.maybe, maybe) || other.maybe == maybe));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,total,attending,notAttending,maybe);

@override
String toString() {
  return 'RsvpStats(total: $total, attending: $attending, notAttending: $notAttending, maybe: $maybe)';
}


}

/// @nodoc
abstract mixin class _$RsvpStatsCopyWith<$Res> implements $RsvpStatsCopyWith<$Res> {
  factory _$RsvpStatsCopyWith(_RsvpStats value, $Res Function(_RsvpStats) _then) = __$RsvpStatsCopyWithImpl;
@override @useResult
$Res call({
 int total, int attending, int notAttending, int maybe
});




}
/// @nodoc
class __$RsvpStatsCopyWithImpl<$Res>
    implements _$RsvpStatsCopyWith<$Res> {
  __$RsvpStatsCopyWithImpl(this._self, this._then);

  final _RsvpStats _self;
  final $Res Function(_RsvpStats) _then;

/// Create a copy of RsvpStats
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? total = null,Object? attending = null,Object? notAttending = null,Object? maybe = null,}) {
  return _then(_RsvpStats(
total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,attending: null == attending ? _self.attending : attending // ignore: cast_nullable_to_non_nullable
as int,notAttending: null == notAttending ? _self.notAttending : notAttending // ignore: cast_nullable_to_non_nullable
as int,maybe: null == maybe ? _self.maybe : maybe // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
