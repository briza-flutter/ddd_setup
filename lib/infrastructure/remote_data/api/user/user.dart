import 'package:ddd_setup/infrastructure/remote_data/api/user/models/vo.dart';
import 'package:ddd_setup/infrastructure/remote_data/http_client/dio_client.dart';
import 'package:injectable/injectable.dart';

@singleton
class UserApi {
  final DioClient _dioClient;
  UserApi(this._dioClient);

  Future<UserVo> getUserInfo(int userId) async {
    final res = await _dioClient.get("/app/user/$userId");
    return UserVo.fromJson(res.data["data"]);
  }
}
