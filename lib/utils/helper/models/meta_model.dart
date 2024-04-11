import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tddboilerplate/utils/utils.dart';

part 'meta_model.freezed.dart';
part 'meta_model.g.dart';

@freezed
class MetaModel with _$MetaModel {
  const factory MetaModel({
    bool? success,
    int? code,
    String? message,
  }) = _MetaModel;

  const MetaModel._();

  factory MetaModel.fromJson(Map<String, dynamic> json) =>
      _$MetaModelFromJson(json);

  MetaEntity toEntity() => MetaEntity(
        success: success,
        code: code,
        message: message,
      );
}
