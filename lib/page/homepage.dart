import 'package:doane/utils/const.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            flex: 2,
            child: Drawer(
              backgroundColor: const Color.fromARGB(255, 71, 139, 171),
              shape: const RoundedRectangleBorder(),
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 15.0),
                    child: PrimaryFont(
                      title: "DOANE MIS",
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      size: 26,
                    ),
                  ),
                  ListTile(
                    onTap: () {},
                    leading: const Icon(
                      Icons.person,
                      color: Colors.white,
                    ),
                    title: const PrimaryFont(
                      title: "Users",
                      color: Colors.white,
                    ),
                  )
                ],
              ),
            ),
          ),
          const Expanded(
            flex: 8,
            child: Column(),
          )
        ],
      ),
    );
  }
}
