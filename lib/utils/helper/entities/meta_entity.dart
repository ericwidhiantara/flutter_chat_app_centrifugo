import 'package:freezed_annotation/freezed_annotation.dart';

part 'meta_entity.freezed.dart';
part 'meta_entity.g.dart';

@freezed
class MetaEntity with _$MetaEntity {
  const factory MetaEntity({
    bool? success,
    int? code,
    String? message,
  }) = _MetaEntity;

  const MetaEntity._();

  factory MetaEntity.fromJson(Map<String, dynamic> json) =>
      _$MetaEntityFromJson(json);
}
