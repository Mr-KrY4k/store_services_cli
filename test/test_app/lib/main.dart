import 'package:flutter/material.dart';

import 'generated/store_service/store_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StoreService().init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final ads = StoreService().ads;
  final analytics = StoreService().analytics;
  final remoteConfig = StoreService().remoteConfig;
  final push = StoreService().push;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          spacing: 16,
          children: [
            FutureBuilder(
              future: ads.advertisingId,
              builder: (context, asyncSnapshot) {
                return Text(
                  "Ads: ${ads.advertisingType} - ${asyncSnapshot.data}",
                );
              },
            ),
            FutureBuilder(
              future: analytics.appInstanceId,
              builder: (context, asyncSnapshot) {
                return Text("Analytics: ${asyncSnapshot.data}");
              },
            ),
            Builder(
              builder: (context) {
                final color = remoteConfig.getString("color");
                return Text("Color: ${color.isEmpty ? "No color" : color}");
              },
            ),
            FutureBuilder(
              future: push.token,
              builder: (context, asyncSnapshot) {
                return Text("Push Token: ${asyncSnapshot.data}");
              },
            ),
          ],
        ),
      ),
    );
  }
}
