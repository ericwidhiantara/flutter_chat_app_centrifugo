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
}

class ChatsRemoteDatasourceImpl implements ChatsRemoteDatasource {
  final DioClient _client;

  ChatsRemoteDatasourceImpl(this._client);

  @override
  Future<Either<Failure, MessagesResponse>> getMessages(
    GetMessagesParams params,
  ) async {
    final response = await _client.getRequest(
      "${ListAPI.messages}/${params.roomId}?page=${params.page}",
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
      "text": params.text,
    });

    final response = await _client.postRequest(
      "${ListAPI.messages}/${params.roomId}/create",
      formData: formData,
      converter: (response) =>
          MetaModel.fromJson(response["meta"] as Map<String, dynamic>),
    );

    return response;
  }
}
