import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tddboilerplate/core/core.dart';
import 'package:tddboilerplate/features/features.dart';
import 'package:tddboilerplate/utils/utils.dart';

part 'chat_form_cubit.freezed.dart';
part 'chat_form_state.dart';

class ChatFormCubit extends Cubit<ChatFormState> {
  ChatFormCubit(
    this._sendMessageUsecase,
    this._readSingleMessageUsecase,
    this._readAllMessageUsecase,
  ) : super(const _Loading());
  final PostSendMessageUsecase _sendMessageUsecase;
  final PostReadSingleMessageUsecase _readSingleMessageUsecase;
  final PostReadAllMessageUsecase _readAllMessageUsecase;

  Future<void> sendMessage(PostSendMessageParams params) async {
    emit(const _Loading());
    final data = await _sendMessageUsecase.call(params);

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

  Future<void> readSingleMessage(PostReadSingleMessageParams params) async {
    emit(const _Loading());
    final data = await _readSingleMessageUsecase.call(params);

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

  Future<void> readAllMessage(PostReadAllMessageParams params) async {
    emit(const _Loading());
    final data = await _readAllMessageUsecase.call(params);

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
