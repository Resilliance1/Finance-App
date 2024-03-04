import 'package:flutter/material.dart';
import 'ChangePasswordScreen.dart';
import 'MyAccountScreen.dart';
import 'ChangeEmailScreen.dart';


class SettingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffffffff),
      appBar: AppBar(
        elevation: 4,
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xff3a57e8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
        title: Text(
          "Settings",
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontStyle: FontStyle.normal,
            fontSize: 20,
            color: Color(0xffffffff),
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Color(0xffffffff),
            size: 22,
          ),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyAccountScreen())
            );
          },
        ),
      ),
      body: ListView(
        scrollDirection: Axis.vertical,
        padding: EdgeInsets.all(16),
        shrinkWrap: false,
        physics: ScrollPhysics(),
        children: [
          ListTile(
            tileColor: Color(0xffffffff),
            title: Text(
              "Change Password",
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.normal,
                fontSize: 16,
                color: Color(0xff000000),
              ),
              textAlign: TextAlign.start,
            ),
            dense: true,
            contentPadding: EdgeInsets.all(0),
            selected: false,
            selectedTileColor: Color(0x42000000),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
            ),

            trailing: Icon(Icons.arrow_forward_ios,
                color: Color(0xff000000), size: 18),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChangePasswordScreen()),
              );
            },
          ),
          Divider(
            color: Color(0x4d9e9e9e),
            height: 16,
            thickness: 1,
            indent: 0,
            endIndent: 0,
          ),
          ListTile(
            tileColor: Color(0xffffffff),
            title: Text(
              "Change Email",
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.normal,
                fontSize: 16,
                color: Color(0xff000000),
              ),
              textAlign: TextAlign.start,
            ),
            dense: true,
            contentPadding: EdgeInsets.all(0),
            selected: false,
            selectedTileColor: Color(0x42000000),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
            ),

            trailing: Icon(Icons.arrow_forward_ios,
                color: Color(0xff000000), size: 18),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChangeEmailScreen()),
              );
            },
          ),
          Divider(
            color: Color(0x4d9e9e9e),
            height: 16,
            thickness: 1,
            indent: 0,
            endIndent: 0,
          ),
          ListTile(
            tileColor: Color(0xffffffff),
            title: Text(
              "Delete Account",
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.normal,
                fontSize: 16,
                color: Color(0xff000000),
              ),
              textAlign: TextAlign.start,
            ),
            dense: true,
            contentPadding: EdgeInsets.all(0),
            selected: false,
            selectedTileColor: Color(0x42000000),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
            ),

            trailing: Icon(Icons.arrow_forward_ios,
                color: Color(0xff000000), size: 18),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}