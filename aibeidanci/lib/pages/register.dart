import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:helproommatespasscet4/model/db.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:helproommatespasscet4/model/constant.dart';
import 'dart:async';
import 'home_page.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'login_in.dart'; // 引入http库


class RegistPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RegistPageState();
}

class _RegistPageState extends State<RegistPage> {
  final accountEditingController = TextEditingController();
  final passwordEditingController = TextEditingController();
  final usernameEditingController = TextEditingController();
  bool _isShowPwd = false;
  DBClient client;
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final _normalFont = const TextStyle(fontSize: 18);

  @override
  void initState() {
    client=DBClient();
    _prefs.then((prefs) {
      accountEditingController.text =
          prefs.getString(Constant.userid) ?? null;
      passwordEditingController.text =
          prefs.getString(Constant.passwordKey) ?? null;
      usernameEditingController.text =
          prefs.getString(Constant.uesrName) ?? null;
    });
    super.initState();

  }

  Widget _buildTowidget() {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Image.asset('assets/img/svg.png'),
        ],
      ),
    );
  }
  Widget _buildAccountEditTextField() {
    return TextFormField(
      controller: accountEditingController,
      onChanged: (text) {
      },
      decoration: InputDecoration(
        focusColor: Colors.lightGreen,
        labelText: "账号",
        labelStyle: TextStyle(color: Colors.blueAccent),
        prefixIcon: Icon(
          Icons.person,
          color: Colors.grey,
        ),
      ),
    );
  }
  Widget _buildPWEditTextField() {
    return TextFormField(
      controller: passwordEditingController,
      onChanged: (text) {
      },
      obscureText: !_isShowPwd,
      decoration: InputDecoration(
        labelText: "密码",
        labelStyle: TextStyle(color: Colors.blueAccent),
        prefixIcon: Icon(
          Icons.lock,
          color: Colors.grey,
        ),
        // 是否显示密码
        suffixIcon: IconButton(
          icon: Icon((_isShowPwd) ? Icons.visibility : Icons.visibility_off),
          onPressed: () {
            setState(() {
              _isShowPwd = !_isShowPwd;
            });
          },
        ),
      ),
    );
  }
  Widget _buildUserNameditTextField() {
    return TextFormField(
      controller: usernameEditingController,
      onChanged: (text) {
      },
      decoration: InputDecoration(
        focusColor: Colors.lightGreen,
        labelText: "用户名",
        labelStyle: TextStyle(color: Colors.blueAccent),
        prefixIcon: Icon(
          Icons.person,
          color: Colors.grey,
        ),
      ),
    );
  }
  _buildButton() {
    return ButtonStyle(
        textStyle: MaterialStateProperty.all(
            TextStyle(fontSize: 18, color: Colors.white)),
        foregroundColor: MaterialStateProperty.resolveWith(
              (states) {
            if (states.contains(MaterialState.focused) &&
                !states.contains(MaterialState.pressed)) {
              //获取焦点时的颜色
              return Colors.blue;
            } else if (states.contains(MaterialState.pressed)) {
              //按下时的颜色
              return Colors.deepPurple;
            }
            //默认状态使用灰色
            return Colors.grey;
          },
        ),
        shape: MaterialStateProperty.all(StadiumBorder(
            side: BorderSide(
              //设置 界面效果
              style: BorderStyle.solid,
              color: Color(0xffC0C0C0),
            )))); //圆角弧度);
  }
  Widget _buildGoRegisterButton() {
    return Align(
      alignment: Alignment.center,
      child: ElevatedButton(
        child: Text('注册', style: _normalFont),
        style: _buildButton(),
        onPressed: _getRegisterPressed(),
      ),
    );
  }
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          '爱背单词',
          style: TextStyle(
            color: Colors.white, //设置字体颜色
            fontSize: 20, //设置字体大小
          ),
        ),
        centerTitle: true,
//          backgroundColor: Colors.blueAccent,//设置导航背景颜色
      ),
      backgroundColor: Colors.blueAccent,
      body: Container(
          margin: EdgeInsets.only(left: 25, right: 25),
          child: Column(
            children: <Widget>[
              _buildTowidget(),
              Padding(padding: EdgeInsets.only(top: 10)),
              Center(
                  child: Card(
                      elevation: 20,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
//                      child: Form(
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Container(
                          width: 270,
                          height: 250,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              _buildAccountEditTextField(),
                              _buildPWEditTextField(),
                              _buildUserNameditTextField(),
                              Container(
                                height: 10,
                              ),
                              // _buildLoginButton(),
                              _buildGoRegisterButton(),
                            ],
                          ),
                        ),
                      ))),

            ],
          )),
    );
  }
  _getRegisterPressed() {
    return () async {
      // 构造请求体，发送用户名和密码给后端
      String userId = accountEditingController.text;
      String password = passwordEditingController.text;
      String username = usernameEditingController.text;
      print('account: $userId');
      print('password: $password');
      print('username: $username');
      // 10.244.196.120
      // 发送POST请求给后端
      try {
        var url = Uri.parse('http://10.244.212.179:8090/elm/UserController/saveUser');
        var response = await http.post(
          url,
          body: {
            'userId': userId,
            'password': password,
            'userName': username,
          },
        );
        // 处理响应
        if (response.statusCode == 200) {
          print('response_save:$response');
          // 登录成功，跳转到主页
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => LogininPage()));
        } else {
          // 登录失败，给出错误提示
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('错误'),
              content: Text('注册失败'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            ),
          );
        }
      } catch (e) {
        // 处理异常
        print('Error: $e');
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('错误'),
            content: Text('注册失败'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
    };
  }
}
