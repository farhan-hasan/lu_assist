import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lu_assist/src/core/utils/extension/context_extension.dart';

class BottomNavScreen extends StatelessWidget {
  const BottomNavScreen({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  // Todo: Implement PopScope
  Future<bool> _handleBackButton(BuildContext context) async {
    // Custom logic for back button handling
    // For example, show a confirmation dialog
    final bool shouldPop = await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('App'),
            content: const Text('Do you want to exit?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Yes'),
              ),
            ],
          ),
        ) ??
        false;

    if (shouldPop) {
      // Navigate back using go_router
      context.pop();
    }
    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: BottomNavigationBar(
          onTap: (index) {
            navigationShell.goBranch(index,
                initialLocation: index == navigationShell.currentIndex);
          },
          currentIndex: navigationShell.currentIndex,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.newspaper, size: context.width*.06,),
              label: "News Feed",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.schedule, size: context.width*.06,),
              label: "Bus Schedule",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add, size: context.width*.06,),
              label: "Bus Request",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.pin_drop, size: context.width*.06,),
              label: "Bus Hunt",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person, size: context.width*.06,),
              label: "Profile",
            ),
          ]),
    );
  }
}
