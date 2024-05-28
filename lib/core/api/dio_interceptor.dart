import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tddboilerplate/utils/utils.dart';

class DioInterceptor extends Interceptor with FirebaseCrashLogger {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    String headerMessage = "";
    options.headers.forEach((k, v) => headerMessage += '► $k: $v\n');

    try {
      options.queryParameters.forEach(
        (k, v) => debugPrint(
          '► $k: $v',
        ),
      );
    } catch (_) {}
    try {
      if (options.data is FormData) {
        final formDataMap = <String, dynamic>{}
          ..addEntries(
            options.data.fields as Iterable<MapEntry<String, dynamic>>,
          )
          ..addEntries(
            options.data.files as Iterable<MapEntry<String, dynamic>>,
          );

        final String result = formDataMap.entries
            .map((entry) => '► ${entry.key}: ${entry.value}')
            .join('\n');
        log.d(
          // ignore: unnecessary_null_comparison
          "REQUEST ► ︎ ${options.method != null ? options.method.toUpperCase() : 'METHOD'} ${"${options.baseUrl}${options.path}"}\n\n"
          "Headers:\n"
          "$headerMessage\n"
          "❖ QueryParameters : \n"
          "Body: {\n$result \n}",
        );
      } else {
        const JsonEncoder encoder = JsonEncoder.withIndent('  ');
        final String prettyJson = encoder.convert(options.data);
        log.d(
          // ignore: unnecessary_null_comparison
          "REQUEST ► ︎ ${options.method != null ? options.method.toUpperCase() : 'METHOD'} ${"${options.baseUrl}${options.path}"}\n\n"
          "Headers:\n"
          "$headerMessage\n"
          "❖ QueryParameters : \n"
          "Body: $prettyJson",
        );
      }
    } catch (e, stackTrace) {
      log.e("Failed to extract json request $e");
      nonFatalError(error: e, stackTrace: stackTrace);
    }

    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    log.e(
      "<-- ${err.message} ${err.response?.requestOptions != null ? (err.response!.requestOptions.baseUrl + err.response!.requestOptions.path) : 'URL'}\n\n"
      "${err.response != null ? err.response!.data : 'Unknown Error'}",
    );

    nonFatalError(error: err, stackTrace: err.stackTrace);
    super.onError(err, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    String headerMessage = "";
    response.headers.forEach((k, v) => headerMessage += '► $k: $v\n');

    const JsonEncoder encoder = JsonEncoder.withIndent('  ');
    final String prettyJson = encoder.convert(response.data);
    log.d(
      // ignore: unnecessary_null_comparison
      "◀ ︎RESPONSE ${response.statusCode} ${response.requestOptions != null ? (response.requestOptions.baseUrl + response.requestOptions.path) : 'URL'}\n\n"
      "Headers:\n"
      "$headerMessage\n"
      "❖ Results : \n"
      "Response: $prettyJson",
    );
    super.onResponse(response, handler);
  }
}
