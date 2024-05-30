import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tddboilerplate/core/core.dart';
import 'package:tddboilerplate/features/features.dart';
import 'package:tddboilerplate/utils/helper/entities/entities.dart';

part 'add_participant_cubit.freezed.dart';
part 'add_participant_state.dart';

class AddParticipantCubit extends Cubit<AddParticipantState> {
  AddParticipantCubit(this._usecase) : super(const _Loading());
  final PostAddParticipantUsecase _usecase;

  Future<void> addParticipant(PostAddParticipantParams params) async {
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
