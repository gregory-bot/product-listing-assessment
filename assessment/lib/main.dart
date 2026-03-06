import 'package:flutter/material.dart';
import 'di/service_locator.dart';
import 'router.dart';

void main() {
  setupServiceLocator();
  runApp(const WinpFluxApp());
}

class WinpFluxApp extends StatelessWidget {
  const WinpFluxApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'WINP Flux Assessment',
      routerConfig: appRouter,
    );
  }
}
