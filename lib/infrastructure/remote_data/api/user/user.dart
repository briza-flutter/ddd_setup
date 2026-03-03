import 'package:ddd_setup/infrastructure/remote_data/api/user/models/user_model.dart';
import 'package:ddd_setup/infrastructure/remote_data/http_client/dio_client.dart';
import 'package:injectable/injectable.dart';

@singleton
class UserApi {
  final DioClient _dioClient;
  UserApi(this._dioClient);

  Future<UserModel> getUserInfo(int userId) async {
    final res = await _dioClient.get("/app/user/$userId");
    return UserModel.fromJson(res.data["data"]);
  }
}
