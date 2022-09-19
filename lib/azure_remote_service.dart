import 'package:azure_remote_config/azure_remote_interceptor.dart';
import 'package:azure_remote_config/models/azure_error.dart';
import 'package:azure_remote_config/models/key.dart';
import 'package:azure_remote_config/models/key_value.dart';
import 'package:dio/dio.dart';

class AzureRemoteService {
  final String host;

  AzureRemoteService({
    required this.host,
    required String credential,
    required String secret,
  }) {
    dio.interceptors.add(
      AzureRemoteInterceptor(
        credential: credential,
        secret: secret,
      ),
    );
  }

  final String API_VERSION = "api_version=1.0";

  final Dio dio = Dio();

  Future<Response> _get(String path, Map<String, String> queryParams) async {
    return await dio.get(
      "https://$host$path",
      queryParameters: queryParams,
    );
  }

  Future<KeyValue> getKeyValue(String key, String label) async {
    final path = "/kv/$key";
    final params = {
      "label": label,
      "api_version": "1.0",
    };

    final response = await _get(path, params);

    return KeyValue.fromJson(response.data);
  }

  Future<List<AzureKey>> getKeys() async {
    final path = "/keys";
    final params = {
      "api_version": "1.0",
    };

    final response = await _get(path, params);

    final List<AzureKey> items = [];

    for (final i in response.data["items"]) {
      final item = AzureKey.fromJson(i);
      items.add(item);
    }

    return items;
  }
}
