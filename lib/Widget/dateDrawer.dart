import 'package:flutter/material.dart';

class DateDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text(
              '달력을 넣어야하는지 강의실 선택을 넣어야하는지'
                  '고민인데.... 흠 물어봐야할듯??',
              // + 버튼으로 예약 추가를 표시하던데
              // 가천알림이 처럼 돋보기 해서 강의실을 찾던지
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
            decoration: BoxDecoration(
                color: Colors.green,
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage('assets/images/cover.jpg'))),
          ),
          ListTile(
            leading: Icon(Icons.input),
            title: Text('Welcome'),
            onTap: () => {},
          ),
          ListTile(
            leading: Icon(Icons.verified_user),
            title: Text('Profile'),
            onTap: () => {Navigator.of(context).pop()},
          ),
        ],
      ),
    );
  }
}