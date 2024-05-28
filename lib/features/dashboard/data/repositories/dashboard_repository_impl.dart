import 'package:dartz/dartz.dart';
import 'package:tddboilerplate/core/core.dart';
import 'package:tddboilerplate/features/features.dart';
import 'package:tddboilerplate/utils/helper/entities/entities.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  /// Data Source
  final DashboardRemoteDatasource _dataSource;

  const DashboardRepositoryImpl(this._dataSource);

  @override
  Future<Either<Failure, RoomsEntity>> getRooms(GetRoomsParams params) async {
    final response = await _dataSource.getRooms(params);

    return response.fold(
      (failure) => Left(failure),
      (response) async {
        if (response.data == [] ||
            response.data == null ||
            response.data!.isEmpty) {
          return Left(NoDataFailure());
        }
        return Right(response.toEntity());
      },
    );
  }

  @override
  Future<Either<Failure, MessagesEntity>> getMessages(
    GetMessagesParams params,
  ) async {
    final response = await _dataSource.getMessages(params);

    return response.fold(
      (failure) => Left(failure),
      (response) async {
        if (response.data == [] ||
            response.data == null ||
            response.data!.isEmpty) {
          return Left(NoDataFailure());
        }
        return Right(response.toEntity());
      },
    );
  }

  @override
  Future<Either<Failure, MetaEntity>> sendMessage(
    PostSendMessageParams params,
  ) async {
    final response = await _dataSource.sendMessage(params);

    return response.fold(
      (failure) => Left(failure),
      (response) => Right(response.toEntity()),
    );
  }
}
