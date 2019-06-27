import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'package:simple_permissions/simple_permissions.dart';

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion;
  Permission permission;

  initPlatform() async {
    String platform;
    try {
      platform = await SimplePermissions.platformVersion;
    } catch (e) {
      platform = "plateform not found";
    }
    if (!mounted) return;
    setState(() => _platformVersion = platform);
  }

  @override
  void initState() {
    initPlatform();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Permissions'),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              Text('platform version is $_platformVersion\n'),
              Divider(height: 10.0),
              DropdownButton(
                items: _getDropDownItems(),
                value: permission,
                onChanged: onDropdownChanged,
              ),
              Divider(height: 10.0),
              RaisedButton(
                color: Colors.greenAccent,
                onPressed: checkPermission,
                child: Text('Check permission'),
              ),
              Divider(height: 10.0),
              RaisedButton(
                color: Colors.orange,
                onPressed: requestPermission,
                child: Text('Request permission'),
              ),
              Divider(height: 10.0),
              RaisedButton(
                onPressed: getStatus,
                color: Colors.blueAccent,
                child: Text('Get status'),
              ),
              Divider(height: 10.0),
              RaisedButton(
                onPressed: SimplePermissions.openSettings,
                color: Colors.redAccent,
                child: Text('Open settings'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _getDropDownItems() {
    List<DropdownMenuItem<Permission>> items = List();

    Permission.values.forEach((permission) {
      var item = DropdownMenuItem(
          child: Text(getPermissionString(permission)), value: permission);
      items.add(item);
    });
    return items;
  }

  void onDropdownChanged(Permission value) {
    setState(() => this.permission = value);
    print(permission);
  }

  void checkPermission() async {
    bool result = await SimplePermissions.checkPermission(permission);
    print('Permission is: ${result.toString()}');
  }

  void requestPermission() async {
    PermissionStatus result = await SimplePermissions.requestPermission(permission);
    print('Request: ${result.toString()}');
  }

  void getStatus() async {
    PermissionStatus result = await SimplePermissions.getPermissionStatus(permission);
    print('Permission status: ${result.toString()}');
  }
}
