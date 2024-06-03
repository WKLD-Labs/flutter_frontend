import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginListener with ChangeNotifier {
  bool _login = false;
  bool get isLogin => _login;
  void update(bool isLogin) {
    _login = isLogin;
    notifyListeners();
  }
}

class _NavigationDestination {
    const _NavigationDestination(this.label, this.icon, this.selectedIcon, this.route);

    final String label;
    final Widget icon;
    final Widget selectedIcon;
    final String route;
  }

class NavDrawer extends StatelessWidget {
  const NavDrawer(this.context, {super.key});
  final BuildContext context;

  static LoginListener loginListener = LoginListener();
      static const List<_NavigationDestination> _loggedInDestinations = <_NavigationDestination>[
    _NavigationDestination(
      'Home', Icon(Icons.home_outlined), Icon(Icons.home), '/'
    ),
    // _NavigationDestination(
    //   'Dummy', Icon(Icons.egg_outlined), Icon(Icons.egg), '/dummy'
    // ),
    _NavigationDestination(
      'Jadwal', Icon(Icons.calendar_today), Icon(Icons.calendar_today), '/jadwal'
    ),
    _NavigationDestination(
      'Agenda', Icon(Icons.calendar_month), Icon(Icons.calendar_month), '/agenda'
    ),
    _NavigationDestination(
        'Pertemuan', Icon(Icons.event_outlined), Icon(Icons.event), '/pertemuan'
    ),
    _NavigationDestination(
        'Inventory', Icon(Icons.inventory_2_outlined), Icon(Icons.inventory_2_outlined), '/inventory'
    ),
    _NavigationDestination(
      'Document', Icon(Icons.document_scanner_outlined), Icon(Icons.document_scanner), '/document'
    ),
    _NavigationDestination(
      'Jadwal Ruangan', Icon(Icons.room_outlined), Icon(Icons.room), '/roomschedule'
    ),
    _NavigationDestination(
      'Member', Icon(Icons.person_2_outlined), Icon(Icons.person_2), '/member'
      ),
  ];

  static const List<_NavigationDestination> _loggedOutDestinations = <_NavigationDestination>[
    _NavigationDestination(
      'Home', Icon(Icons.home_outlined), Icon(Icons.home), '/'
    ),
    _NavigationDestination(
      'Login', Icon(Icons.login_outlined), Icon(Icons.login), '/login'
    ),
  ];

  
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(listenable: loginListener, builder: (context, child) {
      List<_NavigationDestination> navigationDrawerDestinations = loginListener.isLogin ? _loggedInDestinations : _loggedOutDestinations;
      String currentRoute = GoRouter.of(context).routeInformationProvider.value.uri.toString();
      int routeIndex = 0;
      for (_NavigationDestination navItem in navigationDrawerDestinations) {
        if (navItem.route == currentRoute) {
          break;
        }
        routeIndex++;
      }
      return NavigationDrawer(
          onDestinationSelected: (int screen) {
            Navigator.pop(context);
            context.go(navigationDrawerDestinations[screen].route);
          },
          selectedIndex: routeIndex,
          children: <Widget>[
            Padding(padding: const EdgeInsets.fromLTRB(14, 8, 8, 14), child: Image.asset('assets/images/HomePage/LogoASE-Text.png'),),
            
            ...navigationDrawerDestinations.map(
              (_NavigationDestination destination) {
              return NavigationDrawerDestination(
                  icon: destination.icon,
                  selectedIcon: destination.selectedIcon,
                  label: Text(destination.label));
              }
            ),

            const Padding(
                padding: EdgeInsets.fromLTRB(28, 16, 16, 28), child: Divider()),
          ],
        );
      },
    );
  } 
}