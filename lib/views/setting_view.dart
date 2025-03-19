import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/database_helper.dart';

class SettingView extends StatefulWidget {
  const SettingView({super.key});

  @override
  State<SettingView> createState() => _SettingViewState();
}

class _SettingViewState extends State<SettingView> {
  final DatabaseHelper dbHelper = DatabaseHelper(); // ✅ DB 헬퍼 추가

  double _rollingDuration = 3; // 기본 3초

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _rollingDuration = prefs.getDouble('rolling_duration') ?? 3;
    });
  }

  Future<void> _updateRollingDuration(double value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('rolling_duration', value);
  }

  Future<void> _clearHistory() async {
    await dbHelper.clearSelectedMenuHistory(); // ✅ DB 기록 삭제
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('검색 기록이 삭제되었습니다.')),
    );
  }

  Future<void> _sendEmail() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'developer@example.com',
      queryParameters: {'subject': '앱 문의'},
    );

    if (await canLaunchUrl(emailLaunchUri)) {
      await launchUrl(emailLaunchUri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("이메일을 열 수 없습니다.")),
      );
    }
  }

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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:[
            Text(
              "점심메뉴 추출 시간",
              style: TextStyle(
                fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color:Colors.black
              ),
            ),
            SizedBox(height: 8),
            Slider(
              value: _rollingDuration,
              min: 1,
              max: 10,
              divisions: 9,
              label: "${_rollingDuration.toStringAsFixed(0)}초",
              activeColor: Colors.black,  // ✅ 슬라이더 트랙 색상 검정
              thumbColor: Colors.black,   // ✅ 슬라이더 썸(조절 버튼) 색상 검정
              onChanged: (value) {
                setState(() {
                  _rollingDuration = value;
                });
              },
              onChangeEnd: (value) async {
                await _updateRollingDuration(value);
              },
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Text(
                  "검색 전체 기록 지우기",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color:Colors.black
                  ),
                ),
                Spacer(),
                GestureDetector(
                  onTap: () {
                    _clearHistory();
                  },
                  child: Container(
                    height: 48,
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.black,
                    ),
                    child: Center(
                      child: Text(
                        "지우기",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "v 0.1.0",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.withAlpha(128),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "문의 : jaehyuk.dev@gmail.com",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.withAlpha(128),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
