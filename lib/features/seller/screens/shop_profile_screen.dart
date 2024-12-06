import 'package:ecommerce_app_fluterr_nodejs/common/widgets/product_card.dart';
import 'package:ecommerce_app_fluterr_nodejs/features/seller/models/shop_stats.dart';
import 'package:ecommerce_app_fluterr_nodejs/models/user.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce_app_fluterr_nodejs/models/product.dart';
import 'package:ecommerce_app_fluterr_nodejs/features/seller/services/seller_services.dart';
import 'package:ecommerce_app_fluterr_nodejs/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:ecommerce_app_fluterr_nodejs/constants/global_variables.dart';

class ShopProfileScreen extends StatefulWidget {
  static const String routeName = '/shop-profile';
  final String sellerId;
  const ShopProfileScreen({super.key, required this.sellerId});
  @override
  State<ShopProfileScreen> createState() => _ShopProfileScreenState();
}

class _ShopProfileScreenState extends State<ShopProfileScreen>
    with TickerProviderStateMixin {
  List<Product>? products;
  ShopStats? shopStats;
  User? shopOwner;  // Add this to store shop owner data
  final SellerServices sellerServices = SellerServices();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    fetchData();
  }

  fetchData() async {
    // Get shop owner data and products
    final data = await sellerServices.getShopData(context, widget.sellerId);
    shopOwner = data['shopOwner'];
    products = data['products'];
    shopStats = await sellerServices.getShopStats(context, widget.sellerId);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    

    return Scaffold(
      body: shopOwner == null
          ? const Center(child: CircularProgressIndicator())
          : CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 200,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            GlobalVariables.selectedNavBarColor,
                            Colors.blue.shade800,
                          ],
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 70,
                            backgroundImage: NetworkImage(shopOwner!.shopAvatar),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            shopOwner!.shopName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      _buildFollowButton(),
                      TabBar(
                        controller: _tabController,
                        tabs: const [
                          Tab(text: 'Shop Info'),
                          Tab(text: 'Products'),
                        ],
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height,
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            // Shop Info Tab
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Shop Description',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    shopOwner!.shopDescription,
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  const SizedBox(height: 16),
                                  _buildStatCard(),
                                ],
                              ),
                            ),
                            // Products Tab
                            GridView.builder(
                              padding: const EdgeInsets.all(8),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 0.75,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                              ),
                              itemCount: products!.length,
                              itemBuilder: (context, index) {
                                final product = products![index];
                                return ProductCard(product: product);
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildStatCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
              'Products', shopStats?.totalProducts.toString() ?? '0'),
          _buildStatItem('Rating', '${shopStats?.avgRating ?? 0.0}',
              subtitle: 'avg rating'),
          _buildStatItem(
            'Followers',
            shopStats?.followerCount.toString() ?? '0',
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, {String? subtitle}) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        if (subtitle != null)
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[500],
            ),
          ),
      ],
    );
  }


  // Thêm button Follow/Unfollow
  Widget _buildFollowButton() {
    final user = Provider.of<UserProvider>(context).user;
    final isCurrentUser = user.id ==
        widget.sellerId; // Thêm sellerId vào constructor của ShopProfileScreen
    final isFollowing = user.following.contains(widget.sellerId);

    if (isCurrentUser) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor:
              isFollowing ? Colors.grey : GlobalVariables.selectedNavBarColor,
          minimumSize: const Size(double.infinity, 45),
        ),
        onPressed: () async {
          if (isFollowing) {
            await sellerServices.unfollowSeller(
              context: context,
              sellerId: widget.sellerId,
            );
          } else {
            await sellerServices.followSeller(
              context: context,
              sellerId: widget.sellerId,
            );
          }
          fetchData(); // Refresh stats after follow/unfollow
        },
        child: Text(
          isFollowing ? 'Unfollow' : 'Follow',
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
