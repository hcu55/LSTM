import 'dart:ffi';

import 'package:bob/services/storage.dart';
import 'package:dio/dio.dart';
import 'dart:convert';

const String PATH = 'http://20.249.219.241:8000';
final dio = Dio();    // 서버와 통신을 하기 위해 필요한 패키지

loginService(id, pass) async{
  try{
    Response response = await dio.post('${PATH}/api/user/login/', data: {'email' : id, 'password': pass});
    return response.data;
  }on DioError catch (e) {
    return null;
  }
}
// 중복 검사 서비스
emailOverlapService(id) async{
  try{
    Response response = await dio.post('${PATH}/api/user/exist/', data: {'email' : id});
    return response.data;
  }on DioError catch (e) {
    dio.options.headers['Authorization'] = await refresh();
    Response response = await dio.post('${PATH}/api/user/exist/', data: {'email' : id});
    return response.data;
  }
}
// 회원가입 서비스
registerService(email, pass, name, phone) async{
  Response response = await dio.post('${PATH}/api/user/registration/',
      data: {"email": email, "password1": pass, "password2": pass, "name": name, "phone": phone}
  );
  return response;
}

getMyBabies() async{
  try{
    dio.options.headers['Authorization'] = await getToken();
    Response response = await dio.post('${PATH}/api/baby/lists/');
    if(response.statusCode == 200){
      return response.data as List<dynamic>;
    }
  }catch(e){
    dio.options.headers['Authorization'] = await refresh();
    Response response = await dio.post('${PATH}/api/baby/lists/');
    if(response.statusCode == 200){
      return response.data as List<dynamic>;
    }
  }
}
getBaby(int id) async{
  try{
    dio.options.headers['Authorization'] = await getToken();
    Response response = await dio.post('${PATH}/api/baby/${id}/get/');
    if(response.statusCode == 200){
      return response.data;
    }
  }catch(e){
    dio.options.headers['Authorization'] = await refresh();
    Response response = await dio.post('${PATH}/api/baby/${id}/get/');
    if(response.statusCode == 200){
      return response.data;
    }
  }

}
setBabyService(data) async{
  try{
    dio.options.headers['Authorization'] = await getToken();
    Response response = await dio.post('${PATH}/api/baby/set/', data: data);
    if(response.statusCode == 200){
      return response.data;
    }
  }catch(e){
    dio.options.headers['Authorization'] = await refresh();
    Response response = await dio.post('${PATH}/api/baby/set/', data: data);
    return response.data;
  }
}
editUserService(data) async{
  try{
    dio.options.headers['Authorization'] = await refresh(); //await getToken();
    Response response = await dio.post('${PATH}/api/user/edit/', data: data);
    return response.data;
  }catch(e){
    dio.options.headers['Authorization'] = await refresh();
    Response response = await dio.post('${PATH}/api/user/edit/', data: data);
    return response.data;
  }
}
editBabyService(int bId, String bName, String bGender) async{
  try{
    dio.options.headers['Authorization'] = await refresh(); //await getToken();
    Response response = await dio.post('${PATH}/api/baby/modify/', data: {"babyid":bId, "baby_name": bName, "gender":bGender});
    return response.statusCode;
  }catch(e){
    dio.options.headers['Authorization'] = await refresh();
    Response response = await dio.post('${PATH}/api/baby/modify/', data: {"babyid":bId, "baby_name": bName, "gender":bGender});
    return response.statusCode;
  }
}
deleteUserService() async{
  try{
    dio.options.headers['Authorization'] = await getToken();
    Response response = await dio.get('${PATH}/api/user/remove/');
    return response.statusCode;
  }on DioError catch (e) {
    return 405;
  }
}

deleteBabyService(int babyID) async{
  try{
    dio.options.headers['Authorization'] = await getToken();
    Response response = await dio.get('$PATH/api/baby/$babyID/delete/');
    return response.statusCode;
  }on DioError catch (e) {
    return 405;
  }
}

// 추가 양육자 초대
invitationService(data) async{
  try{
    dio.options.headers['Authorization'] = await getToken();
    Response response = await dio.post('${PATH}/api/baby/connect/',data: data);
    return response.data;
  }on DioError catch (e) {
    dio.options.headers['Authorization'] = await refresh();
    Response response = await dio.post('${PATH}/api/baby/connect/',data: data);
    return response.data;
  }
}
// 초대 수락 API
acceptInvitationService(int babyId) async{
  try{
    dio.options.headers['Authorization'] = await getToken();
    Response response = await dio.post('${PATH}/api/baby/activate/',data: {"babyid": babyId});
    return response.data;
  }on DioError catch (e) {
    dio.options.headers['Authorization'] = await refresh();
    Response response = await dio.post('${PATH}/api/baby/activate/',data: {"babyid": babyId});
    return response.data;
  }
}
// 토큰 갱신
refresh() async{
  var refreshDio = Dio();   // 토큰 갱신 요청을 담당할 dio 객체
  refreshDio.options.headers['Authorization'] = await getToken();
  String refresh = await getRefreshToken();
  final refreshResponse = await refreshDio.post('${PATH}/api/user/token/refresh/', data: {"refresh":refresh});
  // 갱신된 AccessToken과 RefreshToken 파싱
  final newAccessToken = refreshResponse.data["access"];
  // login storage - update
  await updateTokenInfo(newAccessToken);
  return "Bearer ${newAccessToken}";
}

//// 1. home page
lifesetService(int babyId, int mode, String content) async{
  try{
    dio.options.headers['Authorization'] = await getToken();
    Response response = await dio.post('${PATH}/api/life/set/',data: {"babyid": babyId, "mode" : mode, "content":content});
    return response.data;
  }on DioError catch (e) {
    dio.options.headers['Authorization'] = await refresh();
    Response response = await dio.post('${PATH}/api/life/set/',data: {"babyid": babyId});
    return response.data;
  }
}

growthService(int babyId, double height, double weight, String date) async{
  try{
    dio.options.headers['Authorization'] = await getToken();
    Response response = await dio.post('${PATH}/api/growth/set/',data: {"baby": babyId, "height" : height, "weight":weight, "date":date});
    return response.data;
  }on DioError catch (e) {
    dio.options.headers['Authorization'] = await refresh();
    Response response = await dio.post('${PATH}/api/growth/set/',data: {"baby": babyId, "height" : height, "weight":weight, "date":date});
    return response.data;
  }
}

growthGetService(int babyId) async {
  try{
    dio.options.headers['Authorization'] = await getToken();
    Response response = await dio.post('${PATH}/api/growth/$babyId/get/');
    return response.data;
  }on DioError catch (e) {
    dio.options.headers['Authorization'] = await refresh();
    Response response = await dio.post('${PATH}/api/growth/$babyId/get/');
    return response.data;
  }
}

vaccineCheckByIdService(int id) async {
  try{
    dio.options.headers['Authorization'] = await getToken();
    Response response = await dio.post('$PATH/api/health/$id/get/');
    return response.data;
  }on DioError catch (e) {
    dio.options.headers['Authorization'] = await refresh();
    Response response = await dio.post('$PATH/api/health/$id/get/');
    return response.data;
  }
}

vaccineSetService(int id, String checkName, int mode, String state) async {
  try{
    dio.options.headers['Authorization'] = await getToken();
    Response response = await dio.post('$PATH/api/health/set/', data:{"baby":id, "check_name":checkName, "mode":mode, "state":state});
    return response.data;
  }on DioError catch (e) {
    dio.options.headers['Authorization'] = await refresh();
    Response response = await dio.post('$PATH/api/health/set/', data:{"baby":id, "check_name":checkName, "mode":mode, "state":state});
    return response.data;
  }
}
