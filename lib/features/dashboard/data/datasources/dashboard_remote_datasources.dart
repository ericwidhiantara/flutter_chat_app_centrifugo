import 'package:dartz/dartz.dart';
import 'package:tddboilerplate/core/core.dart';
import 'package:tddboilerplate/features/dashboard/dashboard.dart';

abstract class DashboardRemoteDatasource {
  Future<Either<Failure, RoomsResponse>> getRooms(GetRoomsParams params);
}

class DashboardRemoteDatasourceImpl implements DashboardRemoteDatasource {
  final DioClient _client;

  DashboardRemoteDatasourceImpl(this._client);

  @override
  Future<Either<Failure, RoomsResponse>> getRooms(GetRoomsParams params) async {
    final response = await _client.getRequest(
      "${ListAPI.rooms}?page=${params.page}",
      converter: (response) =>
          RoomsResponse.fromJson(response as Map<String, dynamic>),
      isIsolate: true,
    );

    return response;
  }
}
