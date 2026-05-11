import 'package:ddd_setup/core/network/dio_client.dart';
import 'package:ddd_setup/features/auth/data/model/login_dto.dart';
import 'package:ddd_setup/features/auth/data/model/login_resp_model.dart';
import 'package:injectable/injectable.dart';

@singleton
class AuthApi {
  final DioClient _dioClient;
  AuthApi(this._dioClient);

  Future<LoginRespModel> login(LoginDto dto) async {
    final res = await _dioClient.post("/app/user/login", data: dto.toJson());
    final loginData = (res.data as Map<String, dynamic>)['data'];
    if (loginData is! Map<String, dynamic>) {
      throw StateError('login response missing data field');
    }
    return LoginRespModel.fromJson(loginData);
  }
}
