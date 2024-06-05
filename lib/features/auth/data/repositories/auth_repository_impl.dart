import 'package:dartz/dartz.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:tddboilerplate/core/core.dart';
import 'package:tddboilerplate/features/auth/auth.dart';
import 'package:tddboilerplate/utils/utils.dart';

class AuthRepositoryImpl implements AuthRepository {
  /// Data Source
  final AuthRemoteDatasource authRemoteDatasource;
  final MainBoxMixin mainBoxMixin;

  const AuthRepositoryImpl(this.authRemoteDatasource, this.mainBoxMixin);

  @override
  Future<Either<Failure, LoginEntity>> login(LoginParams loginParams) async {
    final response = await authRemoteDatasource.login(loginParams);

    return response.fold(
      (failure) => Left(failure),
      (response) {
        final data = JwtDecoder.decode(response.data!.accessToken!);

        final JWTModel res = JWTModel.fromJson(data);
        mainBoxMixin.addData<UserLoginEntity>(
          MainBoxKeys.tokenData,
          res.user!.toEntity(),
        );
        mainBoxMixin.addData(MainBoxKeys.isLogin, true);
        mainBoxMixin.addData(MainBoxKeys.token, response.data?.accessToken);

        return Right(response.toEntity());
      },
    );
  }

  @override
  Future<Either<Failure, Register>> register(
    RegisterParams registerParams,
  ) async {
    final response = await authRemoteDatasource.register(registerParams);

    return response.fold(
      (failure) => Left(failure),
      (registerResponse) {
        return Right(registerResponse.toEntity());
      },
    );
  }
}
