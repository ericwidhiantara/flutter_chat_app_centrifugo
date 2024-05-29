import 'package:dartz/dartz.dart';
import 'package:tddboilerplate/core/core.dart';
import 'package:tddboilerplate/features/features.dart';

abstract class RoomsRemoteDatasource {
  Future<Either<Failure, RoomsResponse>> getRooms(GetRoomsParams params);
}

class RoomsRemoteDatasourceImpl implements RoomsRemoteDatasource {
  final DioClient _client;

  RoomsRemoteDatasourceImpl(this._client);

  @override
  Future<Either<Failure, RoomsResponse>> getRooms(GetRoomsParams params) async {
    final response = await _client.getRequest(
      "${ListAPI.rooms}?page=${params.page}",
      converter: (response) =>
          RoomsResponse.fromJson(response as Map<String, dynamic>),
    );

    return response;
  }
}
