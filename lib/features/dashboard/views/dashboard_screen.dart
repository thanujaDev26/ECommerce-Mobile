import 'package:e_commerce/app/constants/app_colors.dart';
import 'package:e_commerce/app/constants/app_strings.dart';
import 'package:e_commerce/features/cart/views/cart_page.dart';
import 'package:e_commerce/features/categories/views/categories_list.dart';
import 'package:e_commerce/features/dashboard/services/user_service.dart';
import 'package:e_commerce/features/dashboard/viewmodels/user_profile.dart';
import 'package:e_commerce/features/dashboard/widgets/banner_carousel.dart';
import 'package:e_commerce/features/dashboard/widgets/category_list.dart';
import 'package:e_commerce/features/dashboard/widgets/recommended_items.dart';
import 'package:e_commerce/features/dashboard/widgets/top_items_grid.dart';
import 'package:e_commerce/features/notifications/views/noitifications_page.dart';
import 'package:e_commerce/features/profile/views/profile_page.dart';
import 'package:e_commerce/features/sidebar/views/sidebar_view.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  String? _token;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  UserProfile? userProfile;
  int _currentIndex = 0;

  // final List<Widget> _pages = [
  //   HomePage(userProfile: userProfile,),
  //   CategoriesList(),
  //   CartPage(),
  //   ProfilePage(),
  // ];

  @override
  void initState() {
    super.initState();
    _loadToken();
    _loadUserProfile();

  }

  Future<void> _loadUserProfile() async {
    final model = await UserService.fetchUser();
    if (model != null) {
      setState(() {
        userProfile = UserProfile.fromUserModel(model);
      });
    }
  }

  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _token = prefs.getString('authToken');
    });
    debugPrint("JWT Token: $_token");
  }

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
    if (_currentIndex == 0 && userProfile == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Home")),
        body: const Center(child: Text("Failed to load user profile")),
      );
    }
    final List<Widget> pages = [
      HomePage(userProfile: userProfile),
      const CategoriesList(),
      const CartPage(),
      const ProfilePage(),
    ];
    return WillPopScope(
      onWillPop: () async{
        return false;
      },
      child: Scaffold(
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
          children: pages,
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
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  final UserProfile? userProfile;
  const HomePage({super.key, required this.userProfile});

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
            RecommendedItems(user: userProfile!,),
          ],
        ),
      ),
    );
  }

}
