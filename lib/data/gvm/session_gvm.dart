import 'package:flutter/material.dart';
import 'package:flutter_blog/_core/utils/my_http.dart';
import 'package:flutter_blog/data/repository/user_repository.dart';
import 'package:flutter_blog/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

class SessionUser {
  int? id;
  String? username;
  String? accessToken;
  bool? isLogin;

  SessionUser({this.id, this.username, this.accessToken, this.isLogin = false});
}

class SessionGVM extends Notifier<SessionUser> {
  // TODO 2: 모름
  final mContext = navigatorKey.currentContext!;
  UserRepository userRepository = const UserRepository();

  @override
  SessionUser build() {
    return SessionUser(
        id: null, username: null, accessToken: null, isLogin: false);
  }

  Future<void> login(String username, String password) async {
    final body = {
      "username": username,
      "password": password,
    };

    final (responseBody, accessToken) =
        await userRepository.findByUsernameAndPassword(body);

    if (!responseBody["success"]) {
      ScaffoldMessenger.of(mContext!).showSnackBar(
        SnackBar(content: Text("로그인 실패 : ${responseBody["errorMessage"]}")),
      );
      return;
    }
    // 1. 토큰을 Storage 저장
    await secureStorage.write(key: "accessToken", value: accessToken); // I/O

    // 2. SessionUser 갱신
    Map<String, dynamic> data = responseBody["response"];
    state = SessionUser(
        id: data["id"],
        username: data["username"],
        accessToken: accessToken,
        isLogin: true);

    // 3. Dio 토큰 세팅
    dio.options.headers["Authorization"] = accessToken;

    Logger().d("로그인", dio.options.headers);

    Navigator.popAndPushNamed(mContext, "/post/list");
  }

  Future<void> join(String username, String email, String password) async {
    final body = {
      "username": username,
      "email": email,
      "password": password,
    };

    Map<String, dynamic> responseBody = await userRepository.save(body);
    if (!responseBody["success"]) {
      ScaffoldMessenger.of(mContext!).showSnackBar(
        SnackBar(content: Text("회원가입 실패 : ${responseBody["errorMessage"]}")),
      );
      return;
    }

    Navigator.pushNamed(mContext, "/login");
  }

  Future<void> logout() async {
    // 1. 디바이스 토큰 삭제
    await secureStorage.delete(key: "accessToken");

    // 2. 상태 갱신
    state = SessionUser();

    // 3. dio 갱신
    dio.options.headers["Authorization"] = "";

    // 4. 화면 다 파괴하고, LoginPage 가기
    Navigator.pushNamedAndRemoveUntil(mContext, "/login", (route) => false);

    //Navigator.popAndPushNamed(mContext, "/login");

    // 4.1 성공 : 화면이동 혹은 아래와 같이 이전화면을 다 날려버리면 됨.

    // 지금까지의 모든 화면을 날리고 (route=false) 로긴화면으로 가는법
    //Navigator.pushAndRemoveUntil(mContext, MaterialPageRoute(builder: (context) => LoginPage()),(route) => route.settings.name == "/write");
    // Navigator.pushAndRemoveUntil(mContext,
    //     MaterialPageRoute(builder: (context) => LoginPage()), (route) => false);

    //ref.invalidate(postListProvider);
    // 4.3 실패 : 혹은 화면이동할때 PostListView의 상태를 ref.invalidate()로 강제로 다 날리는 법
    // 이건 안됨!! 왜냐하면 vm만 날라가고 ui는 pop이 안되서, 다시 화면 불러올때, vm이 초기화가 안됨
  }

  // 1. 절대 SessionUser가 있을 수가 없다.
  Future<void> autoLogin() async {
    // 1. 토큰 디바이스에서 가져오기
    String? accessToken = await secureStorage.read(key: "accessToken");

    if (accessToken == null) {
      Navigator.popAndPushNamed(mContext, "/login");
      return;
    }

    Map<String, dynamic> responseBody =
        await userRepository.autoLogin(accessToken);

    if (!responseBody["success"]) {
      Navigator.popAndPushNamed(mContext, "/login");
      return;
    }

    Map<String, dynamic> data = responseBody["response"];
    state = SessionUser(
        id: data["id"],
        username: data["username"],
        accessToken: accessToken,
        isLogin: true);

    dio.options.headers["Authorization"] = accessToken;

    Navigator.popAndPushNamed(mContext, "/post/list");
  }
}

final sessionProvider = NotifierProvider<SessionGVM, SessionUser>(() {
  return SessionGVM();
});
