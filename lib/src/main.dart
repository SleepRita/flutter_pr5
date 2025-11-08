import 'package:flutter/material.dart';
import 'package:flutter_pr5/src/service_locator.dart';
import 'app.dart';

void main() {
  setupLocator();
  runApp(const AnimalShelterApp());
}