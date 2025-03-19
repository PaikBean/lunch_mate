import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../core/database_helper.dart';
import '../widgets/custom_indicator.dart';

class HistoryView extends StatefulWidget {
  const HistoryView({super.key});

  @override
  State<HistoryView> createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView> {
  final DatabaseHelper dbHelper = DatabaseHelper();

  bool _isLoading = false;
  List<Map<String, dynamic>> _menusHistory = []; // ✅ 최근 선택된 메뉴 리스트

  Future<void> _loadAllMenus() async {
    List<Map<String, dynamic>> allMenus = await dbHelper.getAllMenus();
    setState(() {
      _menusHistory = allMenus;
    });
  }

  Future<void> _deleteMenu(int id) async {
    await dbHelper.deleteSelectedMenu(id); // ✅ DB에서 삭제
    _loadAllMenus(); // ✅ UI 갱신
  }

  Future<void> _launchNaverMap(String keyword) async {
    final encodedKeyword = Uri.encodeComponent(keyword);
    final appSchemeUrl = "nmap://search?query=$encodedKeyword&appname=com.app.lunch_mate";
    final webUrl = "https://m.map.naver.com/search2/search.naver?query=$encodedKeyword";

    if (await canLaunchUrl(Uri.parse(appSchemeUrl))) {
      await launchUrl(Uri.parse(appSchemeUrl));
    } else {
      await launchUrl(Uri.parse(webUrl), mode: LaunchMode.externalApplication);
    }
  }

  @override
  void initState() {
    super.initState();
    _loadAllMenus();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Stack(
        children: [
          Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                backgroundColor: Colors.white,
                title: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "최근 기록",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
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
                      margin: EdgeInsets.symmetric(horizontal: 16),
                      padding: EdgeInsets.all(16),
                      width: size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ..._menusHistory.map((menu) => Dismissible(
                            key: Key(menu['id'].toString()), // ✅ 각 항목에 고유 키 부여
                            direction: DismissDirection.endToStart, // ✅ 왼쪽으로 스와이프 시 삭제
                            background: Container(
                              color: Color(0xFFFF6B6B),
                              alignment: Alignment.centerRight,
                              padding: EdgeInsets.only(right: 20),
                              child: Icon(Icons.delete, color: Colors.white),
                            ),
                            onDismissed: (direction) {
                              _deleteMenu(menu['id']); // ✅ 삭제 함수 호출
                            },
                            child: Container(
                              padding: EdgeInsets.all(12),
                              margin: EdgeInsets.only(bottom: 16),
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
                            ),
                          )),
                        ],
                      ),
                    ),
                  ],
                ),
              )
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
