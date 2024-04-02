import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

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

  static const List<_NavigationDestination> _navigationDrawerDestinations = <_NavigationDestination>[
    _NavigationDestination(
      'Home', Icon(Icons.home_outlined), Icon(Icons.home), '/'
    ),
    _NavigationDestination(
      'Dummy', Icon(Icons.egg_outlined), Icon(Icons.egg), '/dummy'
    ),
    _NavigationDestination(
        'Login', Icon(Icons.login_outlined), Icon(Icons.login), '/login'
    ),
    _NavigationDestination(
        'Pertemuan', Icon(Icons.egg_outlined), Icon(Icons.egg), '/pertemuan'
    )
  ];

  
  @override
  Widget build(BuildContext context) {
    String currentRoute = GoRouter.of(context).routeInformationProvider.value.uri.toString();
    int routeIndex = 0;
    for (_NavigationDestination navItem in _navigationDrawerDestinations) {
      if (navItem.route == currentRoute) {
        break;
      }
      routeIndex++;
    }
    return NavigationDrawer(
        onDestinationSelected: (int screen) {
          Navigator.pop(context);
          context.go(_navigationDrawerDestinations[screen].route);
        },
        selectedIndex: routeIndex,
        children: <Widget>[
          Padding(padding: const EdgeInsets.fromLTRB(14, 8, 8, 14), child: Image.asset('assets/images/HomePage/LogoASE-Text.png'),),
          
          ..._navigationDrawerDestinations.map(
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
  } 
}