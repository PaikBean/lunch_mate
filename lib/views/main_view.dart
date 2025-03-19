import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:lunch_mate/views/history_view.dart';
import 'package:lunch_mate/views/setting_view.dart';
import 'package:lunch_mate/widgets/custom_indicator.dart';

import '../core/database_helper.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  final DatabaseHelper dbHelper = DatabaseHelper();

  bool _isLoading = false;
  String _selectedMenu = "???";
  List<Map<String, dynamic>> _menuList = [];
  List<Map<String, dynamic>> _recentMenus = []; // ✅ 최근 선택된 메뉴 리스트
  bool _isRolling = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _loadMenus();
    _loadRecentMenus(); // ✅ 최근 선택된 메뉴 불러오기
  }

  // ✅ 데이터베이스에서 메뉴 가져오기
  Future<void> _loadMenus() async {
    setState(() {
      _isLoading = true;
    });

    List<Map<String, dynamic>> menus = await dbHelper.getMenus();

    setState(() {
      _menuList = menus;
      _isLoading = false;
    });
  }

  // ✅ 최근 선택된 메뉴 3개 가져오기
  Future<void> _loadRecentMenus() async {
    List<Map<String, dynamic>> recentMenus = await dbHelper.getRecentSelectedMenus();
    setState(() {
      _recentMenus = recentMenus;
    });
  }

  void _startRolling() {
    if (_isRolling || _menuList.isEmpty) return;

    setState(() {
      _isRolling = true;
    });

    int duration = 3000;
    int interval = 100;
    int count = 0;

    _timer = Timer.periodic(Duration(milliseconds: interval), (timer) {
      setState(() {
        _selectedMenu = _menuList[Random().nextInt(_menuList.length)]['name'];
      });

      count += interval;
      if (count >= duration) {
        timer.cancel();
        _finishRolling();
      }
    });
  }

  void _finishRolling() async {
    setState(() {
      _isRolling = false;
    });

    print("선택된 메뉴: $_selectedMenu");

    // ✅ DB 저장이 완료될 때까지 기다린 후 UI 업데이트
    await dbHelper.insertSelectedMenu(_selectedMenu);
    await _loadRecentMenus(); // ✅ insert가 끝난 후 실행!
  }

  Future<void> _launchNaverMap(String keyword) async {
    final encodedKeyword = Uri.encodeComponent(keyword);
    final appSchemeUrl = "nmap://search?query=$encodedKeyword&appname=com.app.lunch_mate";
    final webUrl = "https://m.map.naver.com/search2/search.naver?query=$encodedKeyword";

    // 네이버 지도 앱이 설치되어 있는지 확인
    if (await canLaunchUrl(Uri.parse(appSchemeUrl))) {
      await launchUrl(Uri.parse(appSchemeUrl));
    } else {
      // 앱이 없으면 웹 브라우저에서 열기
      await launchUrl(Uri.parse(webUrl), mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Stack(
        children: [
          Scaffold(
            backgroundColor: Color(0xFFf0f1f2),
            appBar: AppBar(
              backgroundColor: Colors.white,
              title: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "점심 메뉴 추천",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => SettingView()));
                      },
                      child: Icon(Icons.settings, color: Colors.grey),
                    )
                  ],
                ),
              ),
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 8),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    padding: EdgeInsets.all(24),
                    width: size.width,
                    height: 316,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white,
                    ),
                    child: Column(
                      children: [
                        Container(
                          color: Color(0xFfF3F4F6),
                          height: 192,
                          child: Center(
                            child: Text(
                              _selectedMenu,
                              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        GestureDetector(
                          onTap: () {
                            _startRolling();
                          },
                          child: Container(
                            height: 60,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.black,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/icons/dice.png',
                                  width: 22.5,
                                  height: 17.5,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  "돌리기",
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    padding: EdgeInsets.all(24),
                    width: size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "최근 기록",
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => HistoryView()));
                              },
                              child: Row(
                                children: [
                                  Icon(Icons.list),
                                  SizedBox(width: 12),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        ..._recentMenus.map((menu) => Container(
                          padding: EdgeInsets.all(12),
                          margin: EdgeInsets.only(bottom: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Color(0xFFF9FAFB),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(menu['name'], style: TextStyle(fontSize: 14, color: Colors.black)),
                                  Text(DateFormat("yyyy-MM-dd HH:mm").format(DateTime.parse(menu['selected_at'])), style: TextStyle(fontSize: 14, color: Color(0xFF6B7280))),
                                ],
                              ),
                              GestureDetector(
                                  onTap: () async => _launchNaverMap(menu['name']),
                                  child: Icon(Icons.chevron_right, color: Color(0xFF6B7280)),
                              ),
                            ],
                          ),
                        )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_isLoading)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.5),
                child: Center(child: CustomIndicator()),
              ),
            ),
        ],
      ),
    );
  }
}
