import 'package:dartz/dartz.dart';
import 'package:tddboilerplate/core/core.dart';
import 'package:tddboilerplate/features/features.dart';
import 'package:tddboilerplate/utils/helper/entities/entities.dart';

abstract class ChatsRepository {
  Future<Either<Failure, MessagesEntity>> getMessages(GetMessagesParams params);

  Future<Either<Failure, MetaEntity>> sendMessage(PostSendMessageParams params);

  Future<Either<Failure, MetaEntity>> readSingleMessage(
    PostReadSingleMessageParams params,
  );

  Future<Either<Failure, MetaEntity>> readAllMessage(
    PostReadAllMessageParams params,
  );
}
