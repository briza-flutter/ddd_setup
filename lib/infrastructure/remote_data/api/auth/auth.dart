import 'package:ddd_setup/common/utils/map_utils.dart';
import 'package:ddd_setup/domain/auth/models/auth_result.dart';
import 'package:ddd_setup/domain/user/entity/user.dart';
import 'package:ddd_setup/infrastructure/remote_data/api/auth/models/login_dto.dart';
import 'package:ddd_setup/infrastructure/remote_data/http_client/dio_client.dart';
import 'package:injectable/injectable.dart';

@singleton
class AuthApi {
  final DioClient _dioClient;
  AuthApi(this._dioClient);

  Future<(User, Token)> login(LoginDto loginDto) async {
    final res =
        await _dioClient.post("/app/user/login", data: loginDto.toJson());
    final Map<String, dynamic> map = res.data;
    final token = map.nested<Token>("data.token");
    final user = User.fromJson(map.nested("data.appUser"));
    return (user, token!);
  }
}
