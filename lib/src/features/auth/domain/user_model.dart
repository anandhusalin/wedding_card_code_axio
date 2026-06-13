import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
abstract class User with _$User {
  const User._();

  const factory User({
    @JsonKey(name: '_id') // ignore: invalid_annotation_target
    required String id,
    required String email,
    required String displayName,
    String? avatarUrl,
    @Default('free') String plan,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
