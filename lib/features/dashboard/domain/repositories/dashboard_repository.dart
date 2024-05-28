import 'package:dartz/dartz.dart';
import 'package:tddboilerplate/core/core.dart';
import 'package:tddboilerplate/features/features.dart';
import 'package:tddboilerplate/utils/helper/entities/entities.dart';

abstract class DashboardRepository {
  Future<Either<Failure, RoomsEntity>> getRooms(GetRoomsParams params);

  Future<Either<Failure, MessagesEntity>> getMessages(GetMessagesParams params);

  Future<Either<Failure, MetaEntity>> sendMessage(PostSendMessageParams params);
}
