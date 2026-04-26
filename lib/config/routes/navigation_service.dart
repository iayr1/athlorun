// class NavigationService {
//   static final  navigatorKey = GlobalKey<NavigatorState>();
// }

import 'package:flutter/material.dart';

class NavigationService {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;
}
