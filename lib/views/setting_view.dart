import 'package:flutter/material.dart';

class SettingView extends StatefulWidget {
  const SettingView({super.key});

  @override
  State<SettingView> createState() => _SettingViewState();
}

class _SettingViewState extends State<SettingView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "설정",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color:Colors.black
                ),
              )
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Text("후보 메뉴 목록 편집"),
          Text("점심메뉴 돌리는 시간 설정"),
          Text("식당 검색 플랫폼 설정"),
          Text("검색 전체 기록 지우기"),
          Text("개발자"),
          Text("연락처"),
          Text("개인정보처리방침")
        ],
      ),
    );
  }
}
