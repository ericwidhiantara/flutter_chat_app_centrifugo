import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tdd_boilerplate/core/core.dart';
import 'package:tdd_boilerplate/features/features.dart';
import 'package:tdd_boilerplate/utils/helper/helper.dart';

part 'saved_users_cubit.freezed.dart';

part 'saved_users_state.dart';

class SavedUsersCubit extends Cubit<SavedUsersState> {
  SavedUsersCubit(
    this._getSavedUsers,
    this._addUser,
    this._removeUser,
    this._clearUsers,
  ) : super(const _Loading());
  final GetSavedUsersUseCase _getSavedUsers;
  final AddUserUseCase _addUser;
  final RemoveUserUseCase _removeUser;
  final ClearUsersUseCase _clearUsers;

  Future<void> fetchUsers() async {
    //Only show loading in first page
    await _fetchData();
  }

  Future<void> refreshUsers() async {
    await _fetchData();
  }

  Future<void> _fetchData() async {
    log.i("fetch saved data called");
    emit(const _Loading());

    final data = await _getSavedUsers.call(null);
    log.i(data);

    data.fold(
      (l) {
        if (l is ServerFailure) {
          emit(_Failure(l.message ?? ""));
        } else if (l is NoDataFailure) {
          emit(const _Empty());
        }
      },
      (r) {
        if (r.isNotEmpty) {
          log.i(r);
          emit(_Success(r, ""));
        } else {
          emit(const _Empty());
        }
      },
    );
  }

  Future<void> saveArticle(
    UserEntity article, {
    bool isSave = true,
  }) async {
    await _addUser.call(article);
    emit(
      _Success(
        null,
        isSave ? "Berhasil menyimpan data" : "Berhasil menghapus data",
      ),
    );
  }

  Future<void> deleteArticle(UserEntity article) async {
    await _removeUser.call(article);

    emit(const _Success(null, "Berhasil menghapus data"));
    await _fetchData();
  }

  Future<void> clearArticle() async {
    await _clearUsers.call(null);

    emit(const _Success(null, "Berhasil menghapus data"));
    emit(const _Empty());
  }
}
