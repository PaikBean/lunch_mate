import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class MenuPicker extends StatefulWidget {
  final List<String> menuList;
  final void Function(String) onResult;

  const MenuPicker({
    super.key,
    required this.menuList,
    required this.onResult,
  });

  @override
  State<MenuPicker> createState() => _MenuPickerState();
}

class _MenuPickerState extends State<MenuPicker> {
  String _selectedMenu = "";
  bool _isRolling = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _selectedMenu = widget.menuList.isNotEmpty ? widget.menuList.first : "메뉴 없음";
  }

  void _startRolling() {
    if (_isRolling || widget.menuList.isEmpty) return;

    setState(() {
      _isRolling = true;
    });

    int duration = 3000; // 3초 동안 회전
    int interval = 100; // 0.1초마다 변경
    int count = 0;

    _timer = Timer.periodic(Duration(milliseconds: interval), (timer) {
      setState(() {
        _selectedMenu = widget.menuList[Random().nextInt(widget.menuList.length)];
      });

      count += interval;
      if (count >= duration) {
        timer.cancel();
        _finishRolling();
      }
    });
  }

  void _finishRolling() {
    setState(() {
      _isRolling = false;
    });

    widget.onResult(_selectedMenu);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 200,
          height: 100,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 2),
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          child: Text(
            _selectedMenu,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(height: 16),
        ElevatedButton(
          onPressed: _isRolling ? null : _startRolling,
          child: Text(_isRolling ? "돌리는 중..." : "메뉴 돌리기"),
        ),
      ],
    );
  }
}
