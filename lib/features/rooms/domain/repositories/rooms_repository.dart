import 'package:dartz/dartz.dart';
import 'package:tddboilerplate/core/core.dart';
import 'package:tddboilerplate/features/features.dart';
import 'package:tddboilerplate/utils/utils.dart';

abstract class RoomsRepository {
  Future<Either<Failure, RoomsEntity>> getRooms(GetRoomsParams params);

  Future<Either<Failure, MetaEntity>> createRoom(PostCreateRoomParams params);
}
