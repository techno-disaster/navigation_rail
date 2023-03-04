import 'package:flutter/material.dart';

const _tabletBreakpoint = 720.0;
const _desktopBreakpoint = 1440.0;
const _minHeight = 400.0;
const _drawerWidth = 270.0;
const _railSize = 72.0;
const _denseRailSize = 56.0;

class NavRail extends StatelessWidget {
  final FloatingActionButton? floatingActionButton;
  final int currentIndex;
  final Widget? body;
  final Widget? title;
  final ValueChanged<int> onTap;
  final List<BottomNavigationBarItem> tabs;
  final WidgetBuilder? drawerHeaderBuilder, drawerFooterBuilder;
  final Color? bottomNavigationBarColor;
  final double tabletBreakpoint, desktopBreakpoint, minHeight, drawerWidth;
  final List<Widget>? actions;
  final BottomNavigationBarType bottomNavigationBarType;
  final Color? bottomNavigationBarSelectedColor,
      bottomNavigationBarUnselectedColor;
  final bool isDense;
  final bool hideTitleBar;
  final GlobalKey<ScaffoldState>? scaffoldKey;

  const NavRail({
    Key? key,
    required this.currentIndex,
    required this.tabs,
    required this.onTap,
    this.scaffoldKey,
    this.actions,
    this.isDense = false,
    this.floatingActionButton,
    this.drawerFooterBuilder,
    this.drawerHeaderBuilder,
    this.body,
    this.title,
    this.bottomNavigationBarColor,
    this.tabletBreakpoint = _tabletBreakpoint,
    this.desktopBreakpoint = _desktopBreakpoint,
    this.drawerWidth = _drawerWidth,
    this.bottomNavigationBarType = BottomNavigationBarType.fixed,
    this.bottomNavigationBarSelectedColor,
    this.bottomNavigationBarUnselectedColor,
    this.minHeight = _minHeight,
    this.hideTitleBar = false,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: Directionality.of(context),
      child: LayoutBuilder(
        builder: (_, dimens) {
          if (dimens.maxWidth >= tabletBreakpoint &&
              dimens.maxHeight > minHeight) {
            return Scaffold(
              body: Row(
                children: <Widget>[
                  _buildDrawer(context),
                  Expanded(child: body!),
                ],
              ),
            );
          }
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              title: title,
            ),
            drawer: _buildDrawer(context),
            body: body,
          );
        },
      ),
    );
  }

  Widget buildRail(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext p0, BoxConstraints p1) {
        return Padding(
          padding: const EdgeInsets.all(5),
          child: SingleChildScrollView(
            child: Row(
              children: [
                Expanded(
                    child: IntrinsicHeight(
                  child: NavigationRail(
                    extended: true,
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    minWidth: isDense ? _denseRailSize : _railSize,
                    selectedIconTheme: IconThemeData(
                      color: Theme.of(context).colorScheme.secondary
                    ),
                    selectedLabelTextStyle: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    unselectedIconTheme: IconThemeData(
                      color: Colors.grey,
                    ),
                    selectedIndex: currentIndex,
                    onDestinationSelected: (val) => onTap(val),
                    destinations: tabs
                        .map((e) => NavigationRailDestination(
                              label: Text(e.label!),
                              icon: e.icon,
                            ))
                        .toList(),
                  ),
                )),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      width: 250,
      child: SafeArea(
        child: Column(
          children: <Widget>[
            if (drawerHeaderBuilder != null) ...[
              drawerHeaderBuilder!(context),
            ],
            Expanded(child: buildRail(context)),
            if (drawerFooterBuilder != null) ...[
              drawerFooterBuilder!(context),
            ],
          ],
        ),
      ),
    );
  }
}
