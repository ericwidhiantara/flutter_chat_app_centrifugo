import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tddboilerplate/utils/utils.dart';

part 'participant_data_cubit.freezed.dart';
part 'participant_data_state.dart';

class ParticipantDataCubit extends Cubit<ParticipantDataState> {
  ParticipantDataCubit() : super(const _Init());

  List<UserLoginEntity> selectedItems = [];

  Future<void> selectParticipant(
    BuildContext context,
    UserLoginEntity item,
  ) async {
    emit(const _Init());

    if (selectedItems.contains(item)) {
      selectedItems.remove(item);
    } else {
      // max length is 1
      if (selectedItems.isNotEmpty) {
        "Anggota maksimal 2 orang".toToastError(context);
      } else {
        selectedItems.add(item);
      }
    }
    emit(const _AddParticipant());
  }
}
