import 'package:ecommerce_app_fluterr_nodejs/common/widgets/product_card.dart';
import 'package:ecommerce_app_fluterr_nodejs/constants/global_variables.dart';
import 'package:ecommerce_app_fluterr_nodejs/features/account/widgets/single_product.dart';
import 'package:ecommerce_app_fluterr_nodejs/features/home/services/home_services.dart';
import 'package:ecommerce_app_fluterr_nodejs/features/product_details/screens/product_details_screen.dart';
import 'package:ecommerce_app_fluterr_nodejs/models/product.dart';
import 'package:ecommerce_app_fluterr_nodejs/providers/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoryDealsScreen extends StatefulWidget {
  static const String routeName = '/category-deals';
  final String category;
  const CategoryDealsScreen({super.key, required this.category});

  @override
  State<CategoryDealsScreen> createState() => _CategoryDealsScreenState();
}

class _CategoryDealsScreenState extends State<CategoryDealsScreen> {
  List<Product>? productList;
  final HomeServices homeServices = HomeServices();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final productProvider = Provider.of<ProductProvider>(context, listen: false);
    getCategoryProducts().then((products) {
    productProvider.setProducts(products);
  });
  }

  getCategoryProducts() async {
    productList = await homeServices.fetchCategoryProducts(
      context: context,
      category: widget.category,
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: GlobalVariables.appBarGradient,
            ),
          ),
          title: Text(
            widget.category,
            style: const TextStyle(color: Colors.black),
          ),
        ),
      ),
      body: productList == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Keep shopping for ${widget.category}",
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
                const SizedBox(height: 15),
                Expanded(
                  child: GridView.builder(
                    itemCount: productList!.length,
                    padding: const EdgeInsets.all(8),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.75,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemBuilder: (context, index) {
                      final product = productList![index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            ProductDetailsScreen.routeName,
                            arguments: product,
                          );
                        },
                        // child: Column(
                        //   children: [
                        //     // SizedBox(
                        //     //   height: 140,
                        //     //   child: SingleProduct(image: productData.images[0]),
                        //     // ),
                        //     Flexible(
                        //         child: SingleProduct(image: product.images[0])),
                        //     Container(
                        //       alignment: Alignment.topLeft,
                        //       padding: const EdgeInsets.only(left: 11),
                        //       child: Text(
                        //         product.name,
                        //         overflow: TextOverflow.ellipsis,
                        //         maxLines: 2,
                        //       ),
                        //     ),
                        //   ],
                        // ),
                        child: ProductCard(product: product),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
