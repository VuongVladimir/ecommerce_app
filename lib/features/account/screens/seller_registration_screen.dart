import 'dart:io';
import 'package:ecommerce_app_fluterr_nodejs/constants/utils.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce_app_fluterr_nodejs/common/widgets/custom_button.dart';
import 'package:ecommerce_app_fluterr_nodejs/common/widgets/custom_textfield.dart';
import 'package:ecommerce_app_fluterr_nodejs/constants/global_variables.dart';
import 'package:ecommerce_app_fluterr_nodejs/features/seller/services/seller_services.dart';
import 'package:dotted_border/dotted_border.dart';

class SellerRegistrationScreen extends StatefulWidget {
  static const String routeName = '/seller-registration';
  const SellerRegistrationScreen({Key? key}) : super(key: key);

  @override
  State<SellerRegistrationScreen> createState() =>
      _SellerRegistrationScreenState();
}

class _SellerRegistrationScreenState extends State<SellerRegistrationScreen> {
  final TextEditingController _shopNameController = TextEditingController();
  final TextEditingController _shopDescriptionController =
      TextEditingController();
  final SellerServices sellerServices = SellerServices();
  String? requestStatus;
  File? avatarImage;

  final _registrationFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkRequestStatus();
  }

  @override
  void dispose() {
    super.dispose();
    _shopNameController.dispose();
    _shopDescriptionController.dispose();
  }

  void selectImage() async {
    var res = await pickImage();
    setState(() {
      avatarImage = res;
    });
  }

  void checkRequestStatus() async {
    String status = await sellerServices.checkRequestStatus(context);
    setState(() {
      requestStatus = status;
    });
  }

  void registerSeller() async {
    if (_registrationFormKey.currentState!.validate() && avatarImage != null) {
      String status = await sellerServices.registerSeller(
        context: context,
        shopName: _shopNameController.text,
        shopDescription: _shopDescriptionController.text,
        avatar: avatarImage!,
      );
      setState(() {
        requestStatus = status;
      });
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
            'Seller Registration',
            style: TextStyle(color: Colors.black),
          ),
        ),
      ),
      body: (requestStatus == null)
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Form(
                key: _registrationFormKey,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    children: [
                      if (requestStatus != 'none')
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          margin: const EdgeInsets.only(bottom: 30),
                          width: double.infinity,
                          
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 161, 219, 246),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              requestStatus == 'pending'
                                  ? 'Your request is pending'
                                  : (requestStatus == 'approved')
                                      ? 'Your request has been approved!'
                                      : 'Your request has been rejected!',
                              style: TextStyle(
                                color: requestStatus == 'rejected'
                                    ? Colors.orange.shade900
                                    : Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                        ),
                      GestureDetector(
                        onTap: selectImage,
                        child: avatarImage != null
                            ? Image.file(
                                avatarImage!,
                                height: 150,
                                width: 150,
                                fit: BoxFit.cover,
                              )
                            : DottedBorder(
                                borderType: BorderType.RRect,
                                radius: const Radius.circular(10),
                                dashPattern: const [10, 4],
                                strokeCap: StrokeCap.round,
                                child: Container(
                                  width: 150,
                                  height: 150,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.add_photo_alternate_outlined,
                                        size: 40,
                                      ),
                                      const SizedBox(height: 15),
                                      Text(
                                        'Add Shop Avatar',
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
                        textController: _shopNameController,
                        hintText: 'Shop Name',
                      ),
                      const SizedBox(height: 10),
                      CustomTextField(
                        textController: _shopDescriptionController,
                        hintText: 'Shop Description',
                        maxLines: 5,
                      ),
                      const SizedBox(height: 20),
                      CustomButton(
                        text: 'Send Request',
                        function: requestStatus != 'pending' ? registerSeller : null,
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
