import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tddboilerplate/utils/utils.dart';

part 'pagination_model.freezed.dart';

part 'pagination_model.g.dart';

@freezed
class PaginationModel with _$PaginationModel {
  const factory PaginationModel({
    @JsonKey(name: 'total_page') int? totalPage,
    @JsonKey(name: 'total_data') int? totalData,
    @JsonKey(name: 'prev_page') int? prevPage,
    @JsonKey(name: 'next_page') int? nextPage,
    @JsonKey(name: 'current_page') int? currentPage,
  }) = _PaginationModel;

  const PaginationModel._(); // Added constructor

  factory PaginationModel.fromJson(Map<String, dynamic> json) =>
      _$PaginationModelFromJson(json);

  PaginationEntity toEntity() {
    return PaginationEntity(
      totalPage: totalPage,
      totalData: totalData,
      prevPage: prevPage,
      nextPage: nextPage,
      currentPage: currentPage,
    );
  }
}
