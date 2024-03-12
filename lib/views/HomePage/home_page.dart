import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../widgets/nav_drawer.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('wkldLabs'),
      ),
      body: const SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              _Header(),
              Card (
                margin: EdgeInsets.fromLTRB(24, 12, 24, 6),
                clipBehavior: Clip.hardEdge,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      title: Text('Jadwal Ruangan Hari Ini:'),
                      subtitle: Text('Lorem ipsum dolor sit amet, consectetur adipiscing elit. Suspendisse scelerisque purus augue, aliquam mattis odio pretium at. Nunc laoreet ex vel lorem tempus, sit amet faucibus dolor vestibulum. Suspendisse gravida odio quis velit gravida, nec ornare lorem pharetra. Integer purus felis, suscipit vel cursus ut, sollicitudin a libero.'),
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
                          Icon(FontAwesomeIcons.facebook, size: 48),
                          Icon(FontAwesomeIcons.xTwitter, size: 48),
                          Icon(FontAwesomeIcons.linkedin, size: 48),
                          Icon(FontAwesomeIcons.instagram, size: 48),
                          Icon(FontAwesomeIcons.youtube, size: 48),
                        ],
                      ),
                    ),
                  ],
                )
              ),
              
            ],
          ),
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