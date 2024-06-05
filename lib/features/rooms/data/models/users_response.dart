import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tddboilerplate/features/features.dart';
import 'package:tddboilerplate/utils/utils.dart';

part 'users_response.freezed.dart';
part 'users_response.g.dart';

@freezed
class UsersResponse with _$UsersResponse {
  const factory UsersResponse({
    @JsonKey(name: 'meta') MetaModel? meta,
    @JsonKey(name: 'data') List<UserLoginModel>? data,
    @JsonKey(name: 'pagination') PaginationModel? pagination,
  }) = _UsersResponse;

  const UsersResponse._(); // Added constructor

  factory UsersResponse.fromJson(Map<String, dynamic> json) =>
      _$UsersResponseFromJson(json);

  UsersEntity toEntity() {
    return UsersEntity(
      data: data?.map((user) => user.toEntity()).toList(),
      meta: meta?.toEntity(),
      pagination: pagination?.toEntity(),
    );
  }
}
