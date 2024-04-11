import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tddboilerplate/utils/utils.dart';

part 'jwt_entity.freezed.dart';
part 'jwt_entity.g.dart';

@freezed
class JWTEntity with _$JWTEntity {
  const factory JWTEntity({
    int? exp,
    String? sub,
    UserLoginEntity? user,
  }) = _JWTEntity;

  const JWTEntity._();

  factory JWTEntity.fromJson(Map<String, dynamic> json) =>
      _$JWTEntityFromJson(json);
}
