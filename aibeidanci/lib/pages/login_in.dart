import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:helproommatespasscet4/model/db.dart';
import 'package:helproommatespasscet4/pages/register.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:helproommatespasscet4/model/constant.dart';
import 'dart:async';
import 'home_page.dart';
import 'dart:convert';
import 'package:http/http.dart' as http; // 引入http库


class LogininPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LogininPage> {
  final accountEditingController = TextEditingController();
  final passwordEditingController = TextEditingController();
  bool _isShowPwd = false;
  DBClient client;
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final _normalFont = const TextStyle(fontSize: 18);
  bool _isEnableLogin = false;

  @override
  void initState() {
    client=DBClient();
    _prefs.then((prefs) {
      accountEditingController.text =
          prefs.getString(Constant.userid) ?? null;
      passwordEditingController.text =
          prefs.getString(Constant.passwordKey) ?? null;
      // _checkUserInput();
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
      controller:
      passwordEditingController,
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
            return Colors.white;
          },
        ),
        shape: MaterialStateProperty.all(StadiumBorder(
            side: BorderSide(
          //设置 界面效果
          style: BorderStyle.solid,
          color: Color(0xffC0C0C0),
        )))); //圆角弧度);
  }

  Widget _buildLoginButton() {
    return Align(
      alignment: Alignment.center,
      child: ElevatedButton(
        child: Text('登录', style: _normalFont),
        style: _buildButton(),
        onPressed: _getLoginButtonPressed(),
      ),
    );
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
                              Container(
                                height: 10,
                              ),
                              Row(
                                children: <Widget>[
                                  SizedBox(width: 20), // 可选的间距
                                  _buildLoginButton(),
                                  SizedBox(width: 100), // 可选的间距
                                  _buildGoRegisterButton(),
                                ],
                              )

                            ],
                          ),
                        ),
                      ))),

            ],
          )),
    );
  }
  _getLoginButtonPressed() {
    return () async {
      // 构造请求体，发送用户名和密码给后端
      String userId = accountEditingController.text;
      String password = passwordEditingController.text;
      print('account: $userId');
      print('password: $password');
      // 发送POST请求给后端
      try {
        var url = Uri.parse("http://10.244.212.179:8090/elm/UserController/getUserByIdAndPassword")
            .replace(queryParameters: {
          'userId': userId,
          'password': password,
        });
        var response = await http.get(url);
        // 处理响应
        if (response.statusCode == 200) {
          var jsonResponse = jsonDecode(response.body);
          // 检查返回数据
          if (jsonResponse != null) {
            print('response_login:$jsonResponse');
            Map<String, dynamic> users = {
              'userId': jsonResponse['userId'], // 可以是任意唯一标识符，如UUID或自增ID
              'username': jsonResponse['userName'],
              'password': jsonResponse['password']
            };
            print('Map_user:$users');
            int id = await client.insertUser(jsonResponse['userId'],jsonResponse['userName'],jsonResponse['password']);
            print('登录成功,id: $id');
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => HomePage()));
          }
          else {
            print('登录失败，未找到用户信息');
          }
        } else {
          // 登录失败，给出错误提示
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('登录失败'),
              content: Text('用户名或密码错误'),
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
            title: Text('登陆失败'),
            content: Text('用户名或密码错误'),
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
  _getRegisterPressed() {
    return () async {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => RegistPage()));
    };
  }

}
