import 'package:flutter/material.dart';
import 'package:venda_ingressos/screens/eventos.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
  runApp(MaterialApp(home: Eventos(), debugShowCheckedModeBanner: false));
}
