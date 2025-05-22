class BaseResponse<T> {
  final bool isSuccess;
  final T? data;
  final ResponseError? error;

  BaseResponse({
    required this.isSuccess,
    this.data,
    this.error,
  });

  factory BaseResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    return BaseResponse<T>(
      isSuccess: json['isSuccess'] as bool,
      data: json['data'] != null ? fromJsonT(json['data']) : null,
      error: json['error'] != null ? ResponseError.fromJson(json['error']) : null,
    );
  }
}

class ResponseError {
  final String code;
  final String message;

  ResponseError({
    required this.code,
    required this.message,
  });

  factory ResponseError.fromJson(Map<String, dynamic> json) {
    return ResponseError(
      code: json['code'] ?? '',
      message: json['message'] ?? '',
    );
  }
}