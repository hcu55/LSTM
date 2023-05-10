import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:bob/screens/Login/initPage.dart';
import 'package:bob/screens/MyPage/manage_baby.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:intl/intl.dart';
import '../models/model.dart';
import 'package:bob/screens/MyPage/invitation.dart';
import 'package:bob/screens/MyPage/switchNotice.dart';
import 'package:bob/screens/MyPage/withdraw.dart';
import 'package:bob/screens/MyPage/modifyUser.dart';
import 'package:bob/widgets/appbar.dart';
import 'package:get/get.dart' hide Trans;
import 'package:bob/services/backend.dart';
import '../services/storage.dart';
import 'package:easy_localization/easy_localization.dart' hide StringTranslateExtension;
import '../langauges.dart';
// 앱에서 지원하는 언어 리스트 변수
final supportedLocales = [
  Locale('en', 'US'),
  Locale('ko', 'KR')
];
class MainMyPage extends StatefulWidget{
  final User userinfo;
  final List<Baby> babies;
  const MainMyPage(this.userinfo, this.babies, {Key?key}):super(key:key);
  @override
  State<MainMyPage> createState() => _MainMyPage();
}
class _MainMyPage extends State<MainMyPage>{
  late Map<int, Baby> activeBabies={};
  late Map<int, Baby> disactiveBabies={};
  String selectedLanguageMode = '한국어';
  //late List<int> babyIds;
  //var locale = Locale('en','US');

  @override
  void initState() {
    for(int i=0;i<widget.babies.length;i++){
      Baby baby = widget.babies[i];
      if(baby.relationInfo.active){
        activeBabies[baby.relationInfo.BabyId] = baby;
      }else{
        disactiveBabies[baby.relationInfo.BabyId] = baby;
      }
    }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: renderAppbar_with_alarm('bob', context),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            margin: const EdgeInsets.fromLTRB(10,0,10,0),
            padding: const EdgeInsets.all(20),
              child :Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${widget.userinfo.name} 님', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
                          const SizedBox(height: 5),
                          const Text('실시간으로 갱신합니다.')
                        ],
                      ),
                      Image.asset('assets/images/person.png',scale: 12, color: Colors.grey[800])
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(5),
                        width: 120,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('관리중인 아기', style: TextStyle(color: Colors.grey[600])),
                            Center(
                              child: Text(activeBabies.length.toString(), style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 25)),
                            ),
                            const SizedBox(height: 15)
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        padding: const EdgeInsets.all(5),
                        width: 120,
                        decoration: BoxDecoration(
                          color : Color(0xffffdbe6),  //F8B5C5FF
                          //color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Like', style: TextStyle(color: Colors.grey[600])),
                            const Center(
                              child: Text('7', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 25)),
                            ),
                            const SizedBox(height: 15)
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              )
          ),
          Divider(color: Colors.grey[200], thickness: 7),
          Expanded(
            child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          //margin: const EdgeInsets.all(10),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('main4_manageBaby'.tr, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color:Color(0xfffa625f),)),
                              const SizedBox(height: 10),
                              SizedBox(
                                  height: 110,
                                  child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: activeBabies.length + 1,
                                      itemBuilder: (BuildContext context, int index){
                                        if(index < activeBabies.length){
                                          return drawBaby(activeBabies[activeBabies.keys.toList()[index]]!);
                                        }else{
                                          return Container(
                                              padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                                              child: Column(
                                                  children:[
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        border: Border.all(width: 0.5, color: Colors.grey),
                                                        shape: BoxShape.circle,
                                                      ),
                                                      child: IconButton(
                                                          onPressed: () async{
                                                            await Get.to(ManageBabyWidget(activeBabies.values.toList()));
                                                            await reloadBabies();
                                                          },
                                                          iconSize: 40,
                                                          color: Colors.grey,
                                                          icon: const Icon(Icons.add)),
                                                    ),
                                                    const SizedBox(height: 8),
                                                    Text('main4_addBaby'.tr)
                                                  ]
                                              )
                                          );
                                        }
                                      }
                                  )
                              )
                            ],
                          )
                      ),
                      getSettingScreen('main4_babyAddModify'.tr, const Icon(Icons.edit_attributes_sharp),() async{
                        await Get.to(ManageBabyWidget(activeBabies.values.toList()));
                        await reloadBabies();
                      }),
                      getSettingScreen('main4_InviteBabysitter'.tr, const Icon(Icons.diamond_outlined),() async{
                        //print(disactiveBabies.length);
                        await Get.to(() => Invitation(activeBabies.values.toList(), disactiveBabies.values.toList()));
                        await reloadBabies();
                      }),
                      getSettingScreen('main4_switch_Alarm'.tr, const Icon(Icons.notifications_off_outlined),(){
                        Get.to(() => SwitchNotice(activeBabies.values.toList()));
                      }),
                      const Text('Common'),
                      const SizedBox(height: 10),
                      getSettingScreen('main4_logout'.tr, const Icon(Icons.logout),() => logout()),
                      getSettingScreen('main4_modifyUserInfo'.tr, const Icon(Icons.mode_edit_outlined),() async {
                        var modifyInfo = await Get.to(() => ModifyUser(widget.userinfo));
                        if(modifyInfo != null){
                          setState((){
                            widget.userinfo.modifyUserInfo(modifyInfo['pass'], modifyInfo['name'], modifyInfo['phone']);
                          });
                        }
                      }),
                      getLanguageModeScreen('main4_changeLanguage'.tr),
                      getSettingScreen('main4_withdrawal'.tr, const Icon(Icons.minimize),(){
                        Get.to(() => const WithdrawService());
                      }),
                    ],
                  ),
                )
            ),
          )

        ],
      )
    );
  }
  changeLanguageMode(){
    Get.dialog(
        AlertDialog(
          title: const Text('언어모드 변경'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextButton(
                    onPressed: (){
                      setState(() {
                        selectedLanguageMode = '한국어';
                        Get.updateLocale(const Locale('ko','KR'));
                      });
                      Get.back();
                    },
                    child: const Text('한국어')
                ),
                const Divider(thickness: 0.2, color: Colors.grey),
                TextButton(
                    onPressed: (){
                      setState(() {
                        selectedLanguageMode = 'English';
                        Get.updateLocale(const Locale('en','US'));
                      });
                      Get.back();
                    },
                    child: const Text('English')
                ),
                const Divider(thickness: 0.2, color: Colors.grey),
                TextButton(
                    onPressed: (){
                      setState(() {
                        selectedLanguageMode = '中国';
                      });
                      Get.back();
                    },
                    child: const Text('中国')
                ),
              ],
            )
        )
    );
  }
  reloadBabies() async{
    List<int> existedIds = activeBabies.keys.toList() + disactiveBabies.keys.toList();
    activeBabies.clear();
    disactiveBabies.clear();
    List<dynamic> babyRelationList = await getMyBabies();
    for(int i=0; i < babyRelationList.length; i++){
      var baby = await getBaby(babyRelationList[i]['baby']);
      baby['relationInfo'] = (Baby_relation.fromJson(babyRelationList[i])).toJson();
      setState(() {
        if(babyRelationList[i]['active']){
          activeBabies[babyRelationList[i]['baby']] = Baby.fromJson(baby);
        }else{
          disactiveBabies[babyRelationList[i]['baby']] = Baby.fromJson(baby);
        }
      });
    }
  }
  logout() async{
    //await reloadBabies();
    //print(babiesIndexingMap);
    //print(babyRelationList);
    await deleteLogin();
    Get.offAll(LoginInit());
  }
  Container getLanguageModeScreen(title){
    return Container(
      padding: const EdgeInsets.all(8),
        child: InkWell(
            onTap: ()=> changeLanguageMode(),
            child : Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(children: [const Icon(Icons.language), const SizedBox(width: 30), Text(title)]),
                    Text(selectedLanguageMode, style: const TextStyle(color: Colors.grey))
                  ],
                ),
                const SizedBox(height: 8),
                Divider(thickness: 1, color: Colors.grey[300]),
              ],
            )
        )
    );
  }
  Container getSettingScreen(title, icon, func){
    return Container(
      padding: const EdgeInsets.all(8),
      child: InkWell(
          onTap: func,
          child : Column(
            children: [
              Row(children: [icon, const SizedBox(width: 30), Text(title)]),
              const SizedBox(height: 8),
              Divider(thickness: 1, color: Colors.grey[300]),
            ],
          )
      )
    );
  }
  Widget drawBaby(Baby baby){
    return InkWell(
      child: Container(
          padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
          child: Column(
              children:[
                Image.asset('assets/images/baby.png',scale: 10),
                const SizedBox(height: 8),
                Text(baby.name)
              ]
          )
      ),
      onTap: (){
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context){
              return AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                content: SizedBox(
                  height: 300,
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.topRight,
                        child: IconButton(
                            onPressed: (){Navigator.pop(context);},
                            icon: const Icon(Icons.close)
                        ),
                      ),
                      const SizedBox(height: 10),
                      Image.asset('assets/images/baby.png',scale: 8),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                        child: Text(baby.name, style: const TextStyle(fontSize: 24,fontWeight: FontWeight.bold)),
                      ),
                      Text('생일 : ${DateFormat('yyyy년 MM월 dd일').format(baby.birth)}', style:const TextStyle(fontSize: 20)),
                      Text('성별 : ${baby.getGenderString()}', style:const TextStyle(fontSize: 20)),
                      Text('관계 : ${baby.relationInfo.getRelationString()}', style:const TextStyle(fontSize: 20)),
                    ],
                  ),
                )
              );
            }
        );
      },
    );
  }
}
