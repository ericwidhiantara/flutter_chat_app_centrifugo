import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:tddboilerplate/core/core.dart';
import 'package:tddboilerplate/features/features.dart';
import 'package:tddboilerplate/utils/utils.dart';

abstract class ChatsRemoteDatasource {
  Future<Either<Failure, MessagesResponse>> getMessages(
    GetMessagesParams params,
  );

  Future<Either<Failure, MetaModel>> sendMessage(PostSendMessageParams params);

  Future<Either<Failure, MetaModel>> readSingleMessage(
    PostReadSingleMessageParams params,
  );

  Future<Either<Failure, MetaModel>> readAllMessage(
    PostReadAllMessageParams params,
  );
}

class ChatsRemoteDatasourceImpl implements ChatsRemoteDatasource {
  final DioClient _client;

  ChatsRemoteDatasourceImpl(this._client);

  @override
  Future<Either<Failure, MessagesResponse>> getMessages(
    GetMessagesParams params,
  ) async {
    final response = await _client.getRequest(
      "${ListAPI.messages}/room/${params.roomId}?page=${params.page}&limit=${params.limit}&search=${params.search}",
      converter: (response) =>
          MessagesResponse.fromJson(response as Map<String, dynamic>),
    );

    return response;
  }

  @override
  Future<Either<Failure, MetaModel>> sendMessage(
    PostSendMessageParams params,
  ) async {
    final FormData formData = FormData.fromMap({
      "room_id": params.roomId,
      "text": params.text,
    });

    final response = await _client.postRequest(
      ListAPI.messages,
      formData: formData,
      converter: (response) =>
          MetaModel.fromJson(response["meta"] as Map<String, dynamic>),
    );

    return response;
  }

  @override
  Future<Either<Failure, MetaModel>> readSingleMessage(
    PostReadSingleMessageParams params,
  ) async {
    final FormData formData = FormData.fromMap({
      "message_id": params.messageId,
      "message_status": params.messageStatus,
    });

    final response = await _client.putRequest(
      ListAPI.messages,
      formData: formData,
      converter: (response) =>
          MetaModel.fromJson(response["meta"] as Map<String, dynamic>),
    );

    return response;
  }

  @override
  Future<Either<Failure, MetaModel>> readAllMessage(
    PostReadAllMessageParams params,
  ) async {
    final response = await _client.putRequest(
      "${ListAPI.getMessagesByRoomId}/${params.roomId}/readAll",
      converter: (response) =>
          MetaModel.fromJson(response["meta"] as Map<String, dynamic>),
    );

    return response;
  }
}
