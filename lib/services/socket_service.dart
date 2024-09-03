import 'package:flutter/material.dart';
// ignore: library_prefixes
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';

// ignore: constant_identifier_names
enum ServerStatus { Online, Offline, Connecting }

class SocketService with ChangeNotifier {
  ServerStatus _serverStatus = ServerStatus.Connecting;

  final IO.Socket _socket = IO.io(
      'http://192.168.1.3:3000/',
      OptionBuilder()
          .setTransports(['websocket'])
          .enableAutoConnect()
          // .setExtraHeaders({'foo': 'bar'})
          .build());

  ServerStatus get serverStatus => _serverStatus;
  IO.Socket? get socket => _socket;
  Function get emit => _socket.emit;

  SocketService() {
    _initConfig();
  }

  void _initConfig() {
    // Dart client

    _socket.onConnect((_) {
      _serverStatus = ServerStatus.Online;
      notifyListeners();
    });

    _socket.onDisconnect((_) {
      _serverStatus = ServerStatus.Offline;
      notifyListeners();
    });
  }
}
