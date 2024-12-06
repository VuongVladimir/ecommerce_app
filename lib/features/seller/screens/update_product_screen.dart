import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:ecommerce_app_fluterr_nodejs/common/widgets/custom_button.dart';
import 'package:ecommerce_app_fluterr_nodejs/common/widgets/custom_textfield.dart';
import 'package:ecommerce_app_fluterr_nodejs/constants/global_variables.dart';
import 'package:ecommerce_app_fluterr_nodejs/constants/utils.dart';
import 'package:ecommerce_app_fluterr_nodejs/features/seller/services/seller_services.dart';
import 'package:ecommerce_app_fluterr_nodejs/models/product.dart';
import 'package:flutter/material.dart';

class UpdateProductScreen extends StatefulWidget {
  static const String routeName = '/update-product';
  final Product product;
  const UpdateProductScreen({super.key, required this.product});

  @override
  State<UpdateProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<UpdateProductScreen> {
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final SellerServices sellerServices = SellerServices();

  List<File> newImages = [];
  List<String> images = [];
  String category = 'Mobiles';
  List<String> productCategories = [
    'Mobiles',
    'Essentials',
    'Appliances',
    'Books',
    'Fashion',
  ];

  final _addProductFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    category = widget.product.category;
    images = widget.product.images;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    productNameController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    quantityController.dispose();
  }

  void selectImages() async {
    var res = await pickImages();
    setState(() {
      newImages = res;
    });
  }

  // void sellProduct() {
  //   if (_addProductFormKey.currentState!.validate() || images.isNotEmpty) {
  //     adminServices.sellProduct(
  //       context: context,
  //       name: productNameController.text,
  //       description: descriptionController.text,
  //       price: double.parse(priceController.text),
  //       quantity: int.parse(quantityController.text),
  //       category: category,
  //       images: images,
  //     );
  //   }
  // }

  void updateProduct() {
    if (productNameController.text.isNotEmpty ||
        descriptionController.text.isNotEmpty ||
        priceController.text.isNotEmpty ||
        quantityController.text.isNotEmpty ||
        newImages.isNotEmpty || category != widget.product.category) {
      sellerServices.updateProduct(
        context: context,
        product: widget.product,
        images: images,
        name: (productNameController.text.isNotEmpty) ? productNameController.text : widget.product.name,
        description: (descriptionController.text.isNotEmpty) ? descriptionController.text : widget.product.description,
        price: (priceController.text.isNotEmpty) ? double.parse(priceController.text) : widget.product.price,
        quantity: (quantityController.text.isNotEmpty) ? int.parse(quantityController.text) : widget.product.quantity,
        category: category,
        newImages: newImages,
      );
    }
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
          title: const Text(
            "Update Product",
            style: TextStyle(color: Colors.black),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _addProductFormKey,
          child: Padding(
            padding: const EdgeInsets.all(13),
            child: Column(
              children: [
                const SizedBox(height: 3),
                images.isNotEmpty
                    ? CarouselSlider(
                        items: images.map((i) {
                          return Builder(
                            builder: (BuildContext context) => Image.network(
                              i,
                              fit: BoxFit.cover,
                              height: 200,
                            ),
                          );
                        }).toList(),
                        options: CarouselOptions(
                          viewportFraction: 1,
                          height: 200,
                        ),
                      )
                    : GestureDetector(
                        onTap: selectImages,
                        child: DottedBorder(
                          borderType: BorderType.RRect,
                          radius: const Radius.circular(20),
                          dashPattern: [10, 4],
                          strokeCap: StrokeCap.round,
                          child: Container(
                            width: double.infinity,
                            height: 140,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.folder_open,
                                  size: 40,
                                ),
                                const SizedBox(height: 15),
                                Text(
                                  "Select Product Images",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.grey.shade400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                const SizedBox(height: 30),
                CustomTextField(
                  textController: productNameController,
                  hintText: widget.product.name,
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  textController: descriptionController,
                  hintText: widget.product.description,
                  maxLines: 5,
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  textController: priceController,
                  hintText: widget.product.price.toString(),
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  textController: quantityController,
                  hintText: widget.product.quantity.toString(),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: DropdownButton(
                    value: category,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items: productCategories.map((String item) {
                      return DropdownMenuItem(
                        value: item,
                        child: Text(item),
                      );
                    }).toList(),
                    onChanged: (String? newVal) {
                      setState(() {
                        category = newVal!;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 10),
                CustomButton(
                  text: 'Update',
                  function: updateProduct,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
