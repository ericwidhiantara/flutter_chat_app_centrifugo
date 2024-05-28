import 'package:freezed_annotation/freezed_annotation.dart';

part 'pagination_entity.freezed.dart';
part 'pagination_entity.g.dart';

@freezed
class PaginationEntity with _$PaginationEntity {
  const factory PaginationEntity({
    int? totalPage,
    int? totalData,
    int? prevPage,
    int? nextPage,
    int? currentPage,
  }) = _PaginationEntity;

  const PaginationEntity._(); // Added constructor

  factory PaginationEntity.fromJson(Map<String, dynamic> json) =>
      _$PaginationEntityFromJson(json);
}
