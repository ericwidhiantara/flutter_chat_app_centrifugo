import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tddboilerplate/utils/utils.dart';

part 'user_login_model.freezed.dart';
part 'user_login_model.g.dart';

@freezed
class UserLoginModel with _$UserLoginModel {
  const factory UserLoginModel({
    @JsonKey(name: 'user_id') String? userId,
    @JsonKey(name: 'email') String? email,
    @JsonKey(name: 'name') String? name,
    @JsonKey(name: 'username') String? username,
    @JsonKey(name: 'phone') String? phone,
    @JsonKey(name: 'picture') String? picture,
    @JsonKey(name: 'is_active') bool? isActive,
    @JsonKey(name: 'created_at') int? createdAt,
    @JsonKey(name: 'updated_at') int? updatedAt,
  }) = _UserLoginModel;

  const UserLoginModel._(); // Added constructor

  factory UserLoginModel.fromJson(Map<String, dynamic> json) =>
      _$UserLoginModelFromJson(json);

  UserLoginEntity toEntity() {
    return UserLoginEntity(
      userId: userId,
      email: email,
      name: name,
      username: username,
      phone: phone,
      picture: picture,
      isActive: isActive,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
