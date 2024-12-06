import 'package:ecommerce_app_fluterr_nodejs/constants/global_variables.dart';
import 'package:ecommerce_app_fluterr_nodejs/features/account/services/account_services.dart';
import 'package:ecommerce_app_fluterr_nodejs/features/seller/screens/analytics_screen.dart';
import 'package:ecommerce_app_fluterr_nodejs/features/seller/screens/orders_screen.dart';
import 'package:ecommerce_app_fluterr_nodejs/features/seller/screens/products_screen.dart';
import 'package:ecommerce_app_fluterr_nodejs/features/seller/screens/shop_profile_screen.dart';
import 'package:ecommerce_app_fluterr_nodejs/features/seller/services/seller_services.dart';
import 'package:ecommerce_app_fluterr_nodejs/models/user.dart';
import 'package:ecommerce_app_fluterr_nodejs/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SellerScreen extends StatefulWidget {
  static const String routeName = '/seller-home';
  const SellerScreen({super.key});

  @override
  State<SellerScreen> createState() => _SellerScreenState();
}

class _SellerScreenState extends State<SellerScreen> {
  int _page = 0;
  double bottomBarWidth = 42;
  double bottomBarBorderWidth = 5;
  final SellerServices sellerServices = SellerServices();
  User? shopOwner;
  List<Widget> pages = [
    const ProductsScreen(),
    const AnalyticsScreen(),
    const OrdersScreen(),
  ];
  void updatePage(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  fetchData() async {
    // Get shop owner data and products
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final data =
        await sellerServices.getShopData(context, userProvider.user.id);
    shopOwner = data['shopOwner'];
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    return shopOwner == null
        ? const Center(child: CircularProgressIndicator())
        : Scaffold(
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(60),
              child: AppBar(
                flexibleSpace: Container(
                  decoration: const BoxDecoration(
                    gradient: GlobalVariables.appBarGradient,
                  ),
                ),
                title: Row(
                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () => Navigator.pushNamed(context, ShopProfileScreen.routeName, arguments: userProvider.user.id),
                      child: CircleAvatar(
                        radius: 25,
                        backgroundImage: NetworkImage(shopOwner!.shopAvatar),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(left: 10),
                        child: Text(
                          shopOwner!.shopName,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    
                    PopupMenuButton(
                      icon: const Icon(Icons.menu_rounded),
                      onSelected: (value) {
                        if (value == 'logout') {
                          AccountServices().logOut(context);
                        }
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'logout',
                          child: Text('Log out'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            body: pages[_page],
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: _page,
              selectedItemColor: GlobalVariables.selectedNavBarColor,
              unselectedItemColor: GlobalVariables.unselectedNavBarColor,
              backgroundColor: GlobalVariables.backgroundColor,
              iconSize: 28,
              onTap: updatePage,
              items: [
                BottomNavigationBarItem(
                  icon: Container(
                    width: bottomBarWidth,
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          color: _page == 0
                              ? GlobalVariables.selectedNavBarColor
                              : GlobalVariables.backgroundColor,
                          width: bottomBarBorderWidth,
                        ),
                      ),
                    ),
                    child: const Icon(Icons.home_outlined),
                  ),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Container(
                    width: bottomBarWidth,
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          color: _page == 1
                              ? GlobalVariables.selectedNavBarColor
                              : GlobalVariables.backgroundColor,
                          width: bottomBarBorderWidth,
                        ),
                      ),
                    ),
                    child: const Icon(Icons.analytics_outlined),
                  ),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Container(
                    width: bottomBarWidth,
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          color: _page == 2
                              ? GlobalVariables.selectedNavBarColor
                              : GlobalVariables.backgroundColor,
                          width: bottomBarBorderWidth,
                        ),
                      ),
                    ),
                    child: const Icon(Icons.all_inbox_outlined),
                  ),
                  label: '',
                ),
              ],
            ),
          );
  }
}
