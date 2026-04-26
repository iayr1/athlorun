// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'track_client.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps,no_leading_underscores_for_local_identifiers,unused_element

class _TrackClient implements TrackClient {
  _TrackClient(
    this._dio, {
    this.baseUrl,
    this.errorLogger,
  });

  final Dio _dio;

  String? baseUrl;

  final ParseErrorLogger? errorLogger;

  @override
  Future<SportsResponseModel> chooseSports() async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<SportsResponseModel>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          'https://dev.athlorun.connectonmap.com/v1/sports',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late SportsResponseModel _value;
    try {
      _value = SportsResponseModel.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<ActivitiesRequestModel> submitActivity(
    String id,
    String polyline,
    String sportId,
    String completedAt,
    String distanceInKM,
    String durationInSeconds,
    String stepsCount,
    String name,
    String description,
    String mapType,
    String gearId,
    String hideStatistics,
    String exertion,
    File mediaFile,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = FormData();
    _data.fields.add(MapEntry(
      'polyline',
      polyline,
    ));
    _data.fields.add(MapEntry(
      'sportId',
      sportId,
    ));
    _data.fields.add(MapEntry(
      'completedAt',
      completedAt,
    ));
    _data.fields.add(MapEntry(
      'distanceInKM',
      distanceInKM,
    ));
    _data.fields.add(MapEntry(
      'durationInSeconds',
      durationInSeconds,
    ));
    _data.fields.add(MapEntry(
      'stepsCount',
      stepsCount,
    ));
    _data.fields.add(MapEntry(
      'name',
      name,
    ));
    _data.fields.add(MapEntry(
      'description',
      description,
    ));
    _data.fields.add(MapEntry(
      'mapType',
      mapType,
    ));
    _data.fields.add(MapEntry(
      'gearId',
      gearId,
    ));
    _data.fields.add(MapEntry(
      'hideStatistics',
      hideStatistics,
    ));
    _data.fields.add(MapEntry(
      'exertion',
      exertion,
    ));
    _data.files.add(MapEntry(
      'mediaFiles',
      MultipartFile.fromFileSync(
        mediaFile.path,
        filename: mediaFile.path.split(Platform.pathSeparator).last,
      ),
    ));
    final _options = _setStreamType<ActivitiesRequestModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
      contentType: 'multipart/form-data',
    )
        .compose(
          _dio.options,
          'https://dev.athlorun.connectonmap.com/v1/users/${id}/activities',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late ActivitiesRequestModel _value;
    try {
      _value = ActivitiesRequestModel.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  RequestOptions _setStreamType<T>(RequestOptions requestOptions) {
    if (T != dynamic &&
        !(requestOptions.responseType == ResponseType.bytes ||
            requestOptions.responseType == ResponseType.stream)) {
      if (T == String) {
        requestOptions.responseType = ResponseType.plain;
      } else {
        requestOptions.responseType = ResponseType.json;
      }
    }
    return requestOptions;
  }

  String _combineBaseUrls(
    String dioBaseUrl,
    String? baseUrl,
  ) {
    if (baseUrl == null || baseUrl.trim().isEmpty) {
      return dioBaseUrl;
    }

    final url = Uri.parse(baseUrl);

    if (url.isAbsolute) {
      return url.toString();
    }

    return Uri.parse(dioBaseUrl).resolveUri(url).toString();
  }
}
