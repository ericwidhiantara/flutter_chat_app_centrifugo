import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tddboilerplate/core/core.dart';
import 'package:tddboilerplate/features/features.dart';
import 'package:tddboilerplate/utils/utils.dart';

part 'create_room_cubit.freezed.dart';
part 'create_room_state.dart';

class CreateRoomCubit extends Cubit<CreateRoomState> {
  CreateRoomCubit(this._usecase) : super(const _Loading());
  final PostCreateRoomUsecase _usecase;

  Future<void> createRoom(PostCreateRoomParams params) async {
    emit(const _Loading());
    final data = await _usecase.call(params);

    data.fold(
      (l) {
        if (l is ServerFailure) {
          emit(_Failure(l, l.message ?? ""));
        } else if (l is NoDataFailure) {
          emit(const _Empty());
        } else if (l is UnauthorizedFailure) {
          emit(_Failure(l, l.message ?? ""));
        }
      },
      (r) => emit(_Success(r)),
    );
  }
}
