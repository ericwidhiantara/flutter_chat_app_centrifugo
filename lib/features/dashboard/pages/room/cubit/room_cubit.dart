import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tddboilerplate/core/core.dart';
import 'package:tddboilerplate/features/features.dart';

part 'room_cubit.freezed.dart';
part 'room_state.dart';

class RoomCubit extends Cubit<RoomState> {
  RoomCubit(this._usecase) : super(const _Loading());
  final GetRoomsUsecase _usecase;

  Future<void> fetchRoomList(GetRoomsParams params) async {
    /// Only show loading in 1 page
    await _fetchData(params);
  }

  Future<void> refreshRoom(GetRoomsParams params) async {
    await _fetchData(params);
  }

  Future<void> _fetchData(GetRoomsParams params) async {
    if (params.page == 1) {
      emit(const _Loading());
    }

    final data = await _usecase.call(params);
    data.fold(
      (l) async {
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
