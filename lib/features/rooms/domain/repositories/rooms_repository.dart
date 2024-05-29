import 'package:dartz/dartz.dart';
import 'package:tddboilerplate/core/core.dart';
import 'package:tddboilerplate/features/features.dart';

abstract class RoomsRepository {
  Future<Either<Failure, RoomsEntity>> getRooms(GetRoomsParams params);
}
