library dio_flutter_transformer;

import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Dio has already implemented a [DefaultTransformer], and as the default
/// [Transformer]. If you want to custom the transformation of
/// request/response data, you can provide a [Transformer] by your self, andormer
/// replace the [DefaultTransformer] by setting the [dio.Transformer].
///
/// [RequestFormer] is especially for flutter, by which the json decoding
/// will be in background with [compute] function.

/// RequestFormer
class RequestFormer extends DefaultTransformer {
  RequestFormer() : super(jsonDecodeCallback: _parseJson);
}

// Must be top-level function
parseAndDecode(String response) {
  return jsonDecode(response);
}

_parseJson(String text) {
  return compute(parseAndDecode, text);
}
