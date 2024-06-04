import 'package:dartz/dartz.dart';
import 'package:tddboilerplate/core/core.dart';
import 'package:tddboilerplate/features/features.dart';
import 'package:tddboilerplate/utils/utils.dart';

abstract class RoomsRemoteDatasource {
  Future<Either<Failure, RoomsResponse>> getRooms(GetRoomsParams params);

  Future<Either<Failure, CreateRoomResponse>> createRoom(
    PostCreateRoomParams params,
  );

  Future<Either<Failure, UsersResponse>> getUsers(GetUsersParams params);

  Future<Either<Failure, MetaModel>> addParticipant(
    PostAddParticipantParams params,
  );
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

  @override
  Future<Either<Failure, CreateRoomResponse>> createRoom(
    PostCreateRoomParams params,
  ) async {
    final response = await _client.postRequest(
      ListAPI.rooms,
      data: {
        "name": params.name,
      },
      converter: (response) =>
          CreateRoomResponse.fromJson(response as Map<String, dynamic>),
    );

    return response;
  }

  @override
  Future<Either<Failure, UsersResponse>> getUsers(GetUsersParams params) async {
    final response = await _client.getRequest(
      "${ListAPI.users}?page=${params.page}",
      converter: (response) =>
          UsersResponse.fromJson(response as Map<String, dynamic>),
    );

    return response;
  }

  @override
  Future<Either<Failure, MetaModel>> addParticipant(
    PostAddParticipantParams params,
  ) async {
    final response = await _client.postRequest(
      "${ListAPI.rooms}/${params.roomId}/participants",
      data: {
        "user_id": params.userId,
      },
      converter: (response) =>
          MetaModel.fromJson(response["meta"] as Map<String, dynamic>),
    );

    return response;
  }
}
