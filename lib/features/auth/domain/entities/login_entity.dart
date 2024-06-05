import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tddboilerplate/utils/utils.dart';

part 'login_entity.freezed.dart';

part 'login_entity.g.dart';

@freezed
class LoginEntity with _$LoginEntity {
  const factory LoginEntity({
    MetaEntity? meta,
    LoginDataEntity? data,
  }) = _LoginEntity;

  const LoginEntity._(); // Added constructor

  factory LoginEntity.fromJson(Map<String, dynamic> json) =>
      _$LoginEntityFromJson(json);
}

@freezed
class LoginDataEntity with _$LoginDataEntity {
  const factory LoginDataEntity({
    String? accessToken,
    String? refreshToken,
  }) = _LoginDataEntity;

  const LoginDataEntity._(); // Added constructor

  factory LoginDataEntity.fromJson(Map<String, dynamic> json) =>
      _$LoginDataEntityFromJson(json);
}
