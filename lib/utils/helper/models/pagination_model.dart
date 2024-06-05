import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tddboilerplate/utils/utils.dart';

part 'pagination_model.freezed.dart';
part 'pagination_model.g.dart';

@freezed
class PaginationModel with _$PaginationModel {
  const factory PaginationModel({
    @JsonKey(name: 'page_number') int? pageNumber,
    @JsonKey(name: 'page_size') int? pageSize,
    @JsonKey(name: 'total') int? total,
    @JsonKey(name: 'total_pages') int? totalPages,
  }) = _PaginationModel;

  const PaginationModel._(); // Added constructor

  factory PaginationModel.fromJson(Map<String, dynamic> json) =>
      _$PaginationModelFromJson(json);

  PaginationEntity toEntity() {
    return PaginationEntity(
      pageNumber: pageNumber,
      pageSize: pageSize,
      total: total,
      totalPages: totalPages,
    );
  }
}
