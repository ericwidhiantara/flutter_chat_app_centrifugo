import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tddboilerplate/features/features.dart';
import 'package:tddboilerplate/utils/utils.dart';

part 'login_response.freezed.dart';
part 'login_response.g.dart';

@freezed
class LoginResponse with _$LoginResponse {
  const factory LoginResponse({
    @JsonKey(name: 'meta') MetaModel? meta,
    @JsonKey(name: 'data') LoginDataResponse? data,
  }) = _LoginResponse;

  const LoginResponse._(); // Added constructor

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);

  LoginEntity toEntity() {
    return LoginEntity(
      meta: meta?.toEntity(),
      data: data?.toEntity(),
    );
  }
}

@freezed
class LoginDataResponse with _$LoginDataResponse {
  const factory LoginDataResponse({
    @JsonKey(name: 'access_token') String? accessToken,
    @JsonKey(name: 'refresh_token') String? refreshToken,
  }) = _LoginDataResponse;

  const LoginDataResponse._(); // Added constructor

  factory LoginDataResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginDataResponseFromJson(json);

  LoginDataEntity toEntity() {
    return LoginDataEntity(
      accessToken: accessToken,
      refreshToken: refreshToken,
    );
  }
}
