import 'package:flutter/material.dart';
import 'package:lunch_mate/views/history_view.dart';
import 'package:lunch_mate/views/setting_view.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
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
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color:Colors.black
                  ),
                ),
                GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => SettingView()));
                  },
                  child: Icon(
                    Icons.settings,
                    color: Colors.grey,
                  ),
                )
              ],
            ),
          ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
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
                  ),
                  SizedBox(height: 16),
                  GestureDetector(
                    onTap: (){print("돌리기");},
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
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white
                            ),
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
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      GestureDetector(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => HistoryView()));
                          },
                          child: Row(
                            children: [
                              Icon(Icons.list),
                              SizedBox(width: 12),
                            ],
                          )
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Container(
                    padding: EdgeInsets.all(12),
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
                            Text("비빔밥", style: TextStyle(fontSize: 14, color: Colors.black)),
                            Text("오늘 12:30", style: TextStyle(fontSize: 14, color: Color(0xFF6B7280))),
                          ],
                        ),
                        IconButton(
                          onPressed: () {
                            print("맛집 찾기로 이동");
                          },
                          icon: Icon(
                            Icons.chevron_right,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  Container(
                    padding: EdgeInsets.all(12),
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
                            Text("김치찌개", style: TextStyle(fontSize: 14, color: Colors.black)),
                            Text("어제 12:15", style: TextStyle(fontSize: 14, color: Color(0xFF6B7280))),
                          ],
                        ),
                        IconButton(
                          onPressed: () {
                            print("맛집 찾기로 이동");
                          },
                          icon: Icon(
                            Icons.chevron_right,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  Container(
                    padding: EdgeInsets.all(12),
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
                            Text("규동", style: TextStyle(fontSize: 14, color: Colors.black)),
                            Text("2025.02.11 12:30", style: TextStyle(fontSize: 14, color: Color(0xFF6B7280))),
                          ],
                        ),
                        IconButton(
                          onPressed: () {
                            print("맛집 찾기로 이동");
                          },
                          icon: Icon(
                            Icons.chevron_right,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
