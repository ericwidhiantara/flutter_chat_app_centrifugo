import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tddboilerplate/core/core.dart';
import 'package:tddboilerplate/features/features.dart';

part 'participant_cubit.freezed.dart';
part 'participant_state.dart';

class ParticipantCubit extends Cubit<ParticipantState> {
  ParticipantCubit(this._usecase) : super(const _Loading());
  final GetUsersUsecase _usecase;

  Future<void> fetchParticipantList(GetUsersParams params) async {
    /// Only show loading in 1 page
    await _fetchData(params);
  }

  Future<void> refreshParticipant(GetUsersParams params) async {
    await _fetchData(params);
  }

  Future<void> _fetchData(GetUsersParams params) async {
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
