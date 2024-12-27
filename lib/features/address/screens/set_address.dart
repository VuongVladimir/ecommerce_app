import 'package:ecommerce_app_fluterr_nodejs/common/widgets/custom_button.dart';
import 'package:ecommerce_app_fluterr_nodejs/common/widgets/custom_textfield.dart';
import 'package:ecommerce_app_fluterr_nodejs/constants/global_variables.dart';
import 'package:ecommerce_app_fluterr_nodejs/constants/utils.dart';
import 'package:ecommerce_app_fluterr_nodejs/features/address/services/address_services.dart';
import 'package:ecommerce_app_fluterr_nodejs/providers/user_provider.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class SetAddressScreen extends StatefulWidget {
  static const String routeName = '/set-address';
  const SetAddressScreen({
    super.key,
  });

  @override
  State<SetAddressScreen> createState() => _SetAddressScreenState();
}

class _SetAddressScreenState extends State<SetAddressScreen> {
  final TextEditingController flatBuildingController = TextEditingController();
  final TextEditingController areaController = TextEditingController();
  final TextEditingController pincodeController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final _addressFormKey = GlobalKey<FormState>();
  bool isLoading = false;

  final AddressServices addressServices = AddressServices();

  @override
  void dispose() {
    super.dispose();
    flatBuildingController.dispose();
    areaController.dispose();
    pincodeController.dispose();
    cityController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var address = context.watch<UserProvider>().user.address;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: GlobalVariables.appBarGradient,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              if (address.isNotEmpty)
                Column(
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black38),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          address,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w300),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'OR',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              Form(
                key: _addressFormKey,
                child: Column(
                  children: [
                    CustomTextField(
                      textController: flatBuildingController,
                      hintText: 'Flat, House no, Building',
                      keyboardType: TextInputType.text,
                    ),
                    const SizedBox(height: 10),
                    CustomTextField(
                      textController: areaController,
                      hintText: 'Area, Street',
                      keyboardType: TextInputType.text,
                    ),
                    const SizedBox(height: 10),
                    CustomTextField(
                      textController: pincodeController,
                      hintText: 'District',
                      keyboardType: TextInputType.text,
                    ),
                    const SizedBox(height: 10),
                    CustomTextField(
                      textController: cityController,
                      hintText: 'Town/City',
                      keyboardType: TextInputType.text,
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              CustomButton(
                text: 'Set new address',
                function: () {
                  String newAddress = "";
                  if (_addressFormKey.currentState!.validate()) {
                    newAddress =
                        '${flatBuildingController.text}, ${areaController.text}, ${cityController.text} - ${pincodeController.text}';
                    addressServices.saveUserAddress(
                        context: context, address: newAddress);
                  } else {
                    showSnackBar(context, "Please enter all values!");
                    throw Exception("Please enter all values!");
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
