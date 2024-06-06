import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:tddboilerplate/core/core.dart';
import 'package:tddboilerplate/dependencies_injection.dart';
import 'package:tddboilerplate/features/features.dart';
import 'package:tddboilerplate/utils/utils.dart';

typedef ResponseConverter<T> = T Function(dynamic response);

class DioClient with MainBoxMixin, FirebaseCrashLogger {
  String baseUrl = const String.fromEnvironment("BASE_URL");

  String? _auth;
  bool _isUnitTest = false;
  late Dio _dio;

  DioClient({bool isUnitTest = false}) {
    _isUnitTest = isUnitTest;

    try {
      _auth = getData(MainBoxKeys.token);
    } catch (_) {}

    _dio = _createDio();

    if (!_isUnitTest) _dio.interceptors.add(DioInterceptor());
  }

  Dio get dio {
    if (_isUnitTest) {
      /// Return static dio if is unit test
      return _dio;
    } else {
      /// We need to recreate dio to avoid token issue after login
      try {
        _auth = getData(MainBoxKeys.token);
      } catch (_) {}

      final dio = _createDio();

      if (!_isUnitTest) dio.interceptors.add(DioInterceptor());

      return dio;
    }
  }

  Dio _createDio() => Dio(
        BaseOptions(
          baseUrl: baseUrl,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            if (_auth != null) ...{
              //expired token example
              // 'Authorization':
              //     "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOi8vMTAwLjk4LjEwMy44Njo4MDAwL2FwaS9sb2dpbiIsImlhdCI6MTcxNDk5MjQ1OCwiZXhwIjoxNzE1MDc4ODU4LCJuYmYiOjE3MTQ5OTI0NTgsImp0aSI6IjBMblM4T0tpZnNsZFFHU2giLCJzdWIiOiIzIiwicHJ2IjoiMjNiZDVjODk0OWY2MDBhZGIzOWU3MDFjNDAwODcyZGI3YTU5NzZmNyIsInVzZXJfaWQiOjN9.1wS4Tj9zOMM2kuHponOZ8m7RFO_SvA3gHOXvSjqT258",
              'Authorization': "Bearer $_auth",
            },
          },
          receiveTimeout: const Duration(minutes: 1),
          connectTimeout: const Duration(minutes: 1),
          validateStatus: (int? status) {
            return status! > 0;
          },
        ),
      );

  Future<Either<Failure, T>> getRequest<T>(
    String url, {
    Map<String, dynamic>? queryParameters,
    required ResponseConverter<T> converter,
    bool isIsolate = true,
  }) async {
    try {
      final response = await dio.get(url, queryParameters: queryParameters);
      if (response.statusCode! != 200) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
        );
      }

      if (!isIsolate) {
        return Right(converter(response.data));
      }
      final isolateParse = IsolateParser<T>(
        response.data as Map<String, dynamic>,
        converter,
      );
      final result = await isolateParse.parseInBackground();
      return Right(result);
    } on DioException catch (e, stackTrace) {
      if (e.type == DioExceptionType.unknown) {
        if (e.response?.statusCode == 401 ||
            e.response?.data["meta"]["code"] == 401) {
          sl<AuthCubit>().logout();
          return Left(
            UnauthorizedFailure(
              e.response?.data["meta"]["message"].toString() ?? "Unauthorized",
            ),
          );
        }
        if (e.response?.statusCode == 404) {
          return Left(
            NoDataFailure(),
          );
        }
        return Left(
          ServerFailure(
            e.response?.data["meta"]["message"].toString() ?? "Error occurred",
          ),
        );
      }
      if (!_isUnitTest) {
        nonFatalError(error: e, stackTrace: stackTrace);
      }
      if (e.response?.statusCode == 401 ||
          e.response?.data["meta"]["code"] == 401) {
        sl<AuthCubit>().logout();
        return Left(
          UnauthorizedFailure(
            e.response?.data["meta"]["message"].toString() ?? "Unauthorized",
          ),
        );
      }
      if (e.response?.statusCode == 404) {
        return Left(
          NoDataFailure(),
        );
      }
      return Left(
        ServerFailure(
          e.response?.data["meta"]["message"].toString() ?? "Error occurred",
        ),
      );
    }
  }

  Future<Either<Failure, T>> postRequest<T>(
    String url, {
    Map<String, dynamic>? data,
    FormData? formData,
    required ResponseConverter<T> converter,
    bool isIsolate = true,
  }) async {
    try {
      final Response response = await dio.post(url, data: formData ?? data);
      if (response.statusCode! != 200) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
        );
      }

      if (!isIsolate) {
        return Right(converter(response.data));
      }
      final isolateParse = IsolateParser<T>(
        response.data as Map<String, dynamic>,
        converter,
      );
      final result = await isolateParse.parseInBackground();
      return Right(result);
    } on DioException catch (e, stackTrace) {
      log.i(e.type);
      log.i(e.response?.data);
      if (e.type == DioExceptionType.unknown) {
        if (e.response?.statusCode == 401 ||
            e.response?.data["meta"]["code"] == 401) {
          sl<AuthCubit>().logout();
          return Left(
            UnauthorizedFailure(
              e.response?.data["meta"]["message"].toString() ?? "Unauthorized",
            ),
          );
        }
        if (e.response?.statusCode == 404) {
          return Left(
            NoDataFailure(),
          );
        }
        return Left(
          ServerFailure(
            e.response?.data["meta"]["message"].toString() ?? "Error occurred",
          ),
        );
      }
      if (!_isUnitTest) {
        nonFatalError(error: e, stackTrace: stackTrace);
      }
      if (e.response?.statusCode == 401 ||
          e.response?.data["meta"]["code"] == 401) {
        sl<AuthCubit>().logout();
        return Left(
          UnauthorizedFailure(
            e.response?.data["meta"]["message"].toString() ?? "Unauthorized",
          ),
        );
      }
      if (e.response?.statusCode == 404) {
        return Left(
          NoDataFailure(),
        );
      }
      return Left(
        ServerFailure(
          e.response?.data["meta"]["message"].toString() ?? "Error occurred",
        ),
      );
    }
  }

  Future<Either<Failure, T>> patchRequest<T>(
    String url, {
    Map<String, dynamic>? data,
    required ResponseConverter<T> converter,
    bool isIsolate = true,
  }) async {
    try {
      final response = await dio.patch(url, data: data);
      if (response.statusCode! != 200) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
        );
      }

      if (!isIsolate) {
        return Right(converter(response.data));
      }
      final isolateParse = IsolateParser<T>(
        response.data as Map<String, dynamic>,
        converter,
      );
      final result = await isolateParse.parseInBackground();
      return Right(result);
    } on DioException catch (e, stackTrace) {
      if (e.type == DioExceptionType.unknown) {
        if (e.response?.statusCode == 401 ||
            e.response?.data["meta"]["code"] == 401) {
          sl<AuthCubit>().logout();
          return Left(
            UnauthorizedFailure(
              e.response?.data["meta"]["message"].toString() ?? "Unauthorized",
            ),
          );
        }
        if (e.response?.statusCode == 404) {
          return Left(
            NoDataFailure(),
          );
        }
        return Left(
          ServerFailure(
            e.response?.data["meta"]["message"].toString() ?? "Error occurred",
          ),
        );
      }
      if (!_isUnitTest) {
        nonFatalError(error: e, stackTrace: stackTrace);
      }
      if (e.response?.statusCode == 401 ||
          e.response?.data["meta"]["code"] == 401) {
        sl<AuthCubit>().logout();
        return Left(
          UnauthorizedFailure(
            e.response?.data["meta"]["message"].toString() ?? "Unauthorized",
          ),
        );
      }
      if (e.response?.statusCode == 404) {
        return Left(
          NoDataFailure(),
        );
      }
      return Left(
        ServerFailure(
          e.response?.data["meta"]["message"].toString() ?? "Error occurred",
        ),
      );
    }
  }

  Future<Either<Failure, T>> deleteRequest<T>(
    String url, {
    required ResponseConverter<T> converter,
    bool isIsolate = true,
  }) async {
    try {
      final response = await dio.delete(url);
      if (response.statusCode! != 200) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
        );
      }

      if (!isIsolate) {
        return Right(converter(response.data));
      }
      final isolateParse = IsolateParser<T>(
        response.data as Map<String, dynamic>,
        converter,
      );
      final result = await isolateParse.parseInBackground();
      return Right(result);
    } on DioException catch (e, stackTrace) {
      if (e.type == DioExceptionType.unknown) {
        if (e.response?.statusCode == 401 ||
            e.response?.data["meta"]["code"] == 401) {
          sl<AuthCubit>().logout();
          return Left(
            UnauthorizedFailure(
              e.response?.data["meta"]["message"].toString() ?? "Unauthorized",
            ),
          );
        }
        if (e.response?.statusCode == 404) {
          return Left(
            NoDataFailure(),
          );
        }
        return Left(
          ServerFailure(
            e.response?.data["meta"]["message"].toString() ?? "Error occurred",
          ),
        );
      }
      if (!_isUnitTest) {
        nonFatalError(error: e, stackTrace: stackTrace);
      }
      if (e.response?.statusCode == 401 ||
          e.response?.data["meta"]["code"] == 401) {
        sl<AuthCubit>().logout();
        return Left(
          UnauthorizedFailure(
            e.response?.data["meta"]["message"].toString() ?? "Unauthorized",
          ),
        );
      }
      if (e.response?.statusCode == 404) {
        return Left(
          NoDataFailure(),
        );
      }
      return Left(
        ServerFailure(
          e.response?.data["meta"]["message"].toString() ?? "Error occurred",
        ),
      );
    }
  }
}
