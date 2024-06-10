import 'dart:math';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:wkldlabs_flutter_frontend/widgets/nav_drawer.dart';
import 'package:wkldlabs_flutter_frontend/views/RoomSchedule/room_schedule_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Key refreshKey = Key(Random().nextInt(1000).toString());

  void reloadChild() {
    setState(() {
      refreshKey = Key(Random().nextInt(1000).toString());
    });
  }

  @override
  void initState() {
    NavDrawer.loginListener.addListener(reloadChild);
    super.initState();
  }

  @override
  void dispose() {
    NavDrawer.loginListener.removeListener(reloadChild);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('wkldLabs'),
      ),
      body: RefreshIndicator(
        onRefresh: () async => reloadChild(),
        child: ListView(
          children: [
                _Header(),
                RoomScheduleToday(key: refreshKey,),
                Card(
                  margin: EdgeInsets.fromLTRB(24, 6, 24, 6),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        title: Text('Alamat Lab:'),
                        subtitle: Text('Gedung TULT Lantai 6, Jl. Telekomunikasi Terusan Buah Batu, Bandung - 40257, Indonesia')
                      ),
                    ],
                  )
                ),
                Card(
                  margin: EdgeInsets.fromLTRB(24, 6, 24, 6),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        title: Text('Media Sosial:'),
                        subtitle: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton(
                              icon: Icon(Icons.web),
                              iconSize: 32,
                              onPressed: () async {
                                await launchUrl(Uri.parse("https://wkldlabs.misa.pw"));
                              },
                            ),
                            IconButton(
                              icon: Icon(FontAwesomeIcons.linkedin),
                              iconSize: 32,
                              onPressed: () async {
                                await launchUrl(Uri.parse("https://www.linkedin.com/company/rplgdc-labs/mycompany/"));
                              },
                            ),
                            IconButton(
                              icon: Icon(FontAwesomeIcons.instagram),
                              iconSize: 32,
                              onPressed: () async {
                                await launchUrl(Uri.parse("http://instagram.com/rplgdc_"));
                              },
                            ),
                            IconButton(
                              icon: Icon(FontAwesomeIcons.link),
                              iconSize: 32,
                              onPressed: () async {
                                await launchUrl(Uri.parse("https://linktr.ee/rplgdc_laboratory"));
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                ),
                
              ],
        ),
      ),
      endDrawer: NavDrawer(context),
    );
  }
}




class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 256,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [
          Theme.of(context).colorScheme.inversePrimary,
          Theme.of(context).colorScheme.inversePrimary.withAlpha(0),
        ], begin: Alignment.topCenter, end: Alignment.bottomCenter, stops: const [0.9, 1]),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/HomePage/ikbal.png'),
            const SizedBox(
              width: 256,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('OPEN RECRUITMENT EXTENDED!', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, height: 1), ),
                  SizedBox(height: 8,),
                  Text('Sekarang adalah saat yang tepat bagi kalian untuk bergabung dengan keluarga kami. Siapkan dirimu dan jadilah bagian dari perjalanan kami yang penuh inovasi!'),
                ],
              ),
            )
          ],
        ),
    );
  }
}