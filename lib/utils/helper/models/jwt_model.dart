import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tddboilerplate/utils/utils.dart';

part 'jwt_model.freezed.dart';

part 'jwt_model.g.dart';

@freezed
class JWTModel with _$JWTModel {
  const factory JWTModel({
    @JsonKey(name: "exp") int? exp,
    @JsonKey(name: "sub") String? sub,
    @JsonKey(name: "user") UserLoginModel? user,
  }) = _JWTModel;

  const JWTModel._();

  factory JWTModel.fromJson(Map<String, dynamic> json) =>
      _$JWTModelFromJson(json);

  JWTEntity toEntity() {
    return JWTEntity(exp: exp, sub: sub, user: user?.toEntity());
  }
}
