import 'package:e_commerce/app/constants/app_colors.dart';
import 'package:e_commerce/app/constants/app_strings.dart';
import 'package:e_commerce/features/cart/views/cart_page.dart';
import 'package:e_commerce/features/categories/views/categories_list.dart';
import 'package:e_commerce/features/dashboard/widgets/banner_carousel.dart';
import 'package:e_commerce/features/dashboard/widgets/category_list.dart';
import 'package:e_commerce/features/dashboard/widgets/recommended_items.dart';
import 'package:e_commerce/features/dashboard/widgets/top_items_grid.dart';
import 'package:e_commerce/features/notifications/views/noitifications_page.dart';
import 'package:e_commerce/features/profile/views/profile_page.dart';
import 'package:e_commerce/features/sidebar/views/sidebar_view.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

class DashboardScreen extends StatefulWidget {
  final bool isDarkMode;
  final Function(bool) onThemeChanged;

  const DashboardScreen({
    Key? key,
    required this.isDarkMode,
    required this.onThemeChanged,
  }) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomePage(),
    CategoriesList(),
    CartPage(),
    ProfilePage(),
  ];

  void _onTabTapped(int index) async {
    if (index == 3) {
      bool authenticated = await _authenticate();
      if (authenticated) {
        setState(() {
          _currentIndex = index;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Authentication failed')),
        );
      }
    } else {
      setState(() {
        _currentIndex = index;
      });
    }
  }


  String _getTitle(int index) {
    switch (index) {
      case 1:
        return "Categories";
      case 2:
        return "Cart";
      case 3:
        return "Profile";
      default:
        return "Home";
    }
  }

  final LocalAuthentication auth = LocalAuthentication();

  Future<bool> _authenticate() async {
    try {
      bool canCheckBiometrics = await auth.canCheckBiometrics;
      bool isDeviceSupported = await auth.isDeviceSupported();

      if (!canCheckBiometrics || !isDeviceSupported) {

        return true;
      }

      bool didAuthenticate = await auth.authenticate(
        localizedReason: 'Please authenticate to access your Profile',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
      return didAuthenticate;
    } catch (e) {
      return false;
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: AppSidebar(
        isDarkMode: widget.isDarkMode,
        onThemeChanged: (bool value) {
          widget.onThemeChanged(value);
          setState(() {});
        },
      ),
      onDrawerChanged: (isOpened) {
        if (isOpened) {
          FocusScope.of(context).unfocus();
        }
      },
      appBar: AppBar(
        backgroundColor: AppColors().primary,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
              onPressed: (){
                  Navigator.pushNamed(context, NotificationsPage.routeName, arguments: {"id":1});
              },
              icon: const Icon(Icons.notifications),
          ),
        ],
        // leading: IconButton(
        //   icon: const Icon(Icons.menu),
        //   onPressed: () {
        //     FocusScope.of(context).unfocus();
        //     _scaffoldKey.currentState?.openDrawer();
        //   },
        // ),
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey,
        selectedFontSize: 15,
        unselectedFontSize: 15,
        selectedIconTheme: const IconThemeData(size: 24),
        unselectedIconTheme: const IconThemeData(size: 24),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.category), label: "Categories"),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: "Cart"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20,),
            // _greetingAndSearch(context),
            const SizedBox(height: 10),
            const BannerCarousel(),
            const CategoryList(),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                AppStrings.topItems,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const TopItemsGrid(),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                AppStrings.recommended,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const RecommendedItems(),
          ],
        ),
      ),
    );
  }

  // Widget _greetingAndSearch(BuildContext context) {
  //   final theme = Theme.of(context);
  //   final isDark = theme.brightness == Brightness.dark;
  //
  //   return Padding(
  //     padding: const EdgeInsets.all(16.0),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Center(
  //           child: Text(
  //             "${AppStrings.welcome} 👋",
  //             style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
  //           ),
  //         ),
  //         const SizedBox(height: 12),
  //         Material(
  //           elevation: 2,
  //           borderRadius: BorderRadius.circular(20),
  //           shadowColor: Colors.black12,
  //           child: TextField(
  //             autofocus: false, // <-- Add this line here
  //             decoration: InputDecoration(
  //               hintText: AppStrings.searchHint,
  //               hintStyle: TextStyle(
  //                 color: isDark ? Colors.white60 : Colors.grey,
  //                 fontSize: 16,
  //               ),
  //               prefixIcon: Icon(Icons.search,
  //                   color: isDark ? Colors.white70 : Colors.grey),
  //               contentPadding: const EdgeInsets.symmetric(vertical: 14),
  //               filled: true,
  //               fillColor: isDark ? Colors.black : Colors.white,
  //               enabledBorder: OutlineInputBorder(
  //                 borderRadius: BorderRadius.circular(20),
  //                 borderSide: BorderSide(
  //                   color: isDark ? Colors.white : Colors.black,
  //                   width: 1.5,
  //                 ),
  //               ),
  //               focusedBorder: OutlineInputBorder(
  //                 borderRadius: BorderRadius.circular(20),
  //                 borderSide: BorderSide(
  //                   color: isDark
  //                       ? Colors.white
  //                       : theme.primaryColor.withOpacity(0.4),
  //                   width: 1.5,
  //                 ),
  //               ),
  //             ),
  //             style: TextStyle(color: isDark ? Colors.white : Colors.black),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
