import 'package:ecommerce_app_fluterr_nodejs/common/widgets/custom_textfield.dart';
import 'package:ecommerce_app_fluterr_nodejs/common/widgets/payments_details_dialog.dart';
import 'package:ecommerce_app_fluterr_nodejs/constants/global_variables.dart';
import 'package:ecommerce_app_fluterr_nodejs/constants/utils.dart';
import 'package:ecommerce_app_fluterr_nodejs/features/address/services/address_services.dart';
import 'package:ecommerce_app_fluterr_nodejs/models/product.dart';
import 'package:ecommerce_app_fluterr_nodejs/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:pay/pay.dart';
import 'package:provider/provider.dart';

class AddressScreen extends StatefulWidget {
  static const String routeName = '/address';
  final String totalAmount;
  final List<Product>? products;
  final List<int>? quantities;
  const AddressScreen({
    super.key,
    required this.totalAmount,
    this.products,
    this.quantities,
  });

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  final TextEditingController flatBuildingController = TextEditingController();
  final TextEditingController areaController = TextEditingController();
  final TextEditingController pincodeController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final _addressFormKey = GlobalKey<FormState>();
  String addressToBeUsed = "";
  bool isLoading = false;

  final Future<PaymentConfiguration> _googlePayConfigFuture =
      PaymentConfiguration.fromAsset('gpay.json');

  List<PaymentItem> paymentItems = [];
  final AddressServices addressServices = AddressServices();

  @override
  void initState() {
    super.initState();
    paymentItems.add(
      PaymentItem(
        amount: widget.totalAmount,
        label: "Total Amount",
        status: PaymentItemStatus.final_price,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    flatBuildingController.dispose();
    areaController.dispose();
    pincodeController.dispose();
    cityController.dispose();
  }

  void showPaymentDetailsDialog(String address) async {
    if (widget.products != null) {
      // Get seller's address for direct order
      final sellerAddress = await addressServices.getSellerAddress(
        context: context,
        sellerId: widget.products![0].sellerId,
      );

      // Calculate shipping fee
      final shippingFee = calculateShippingFee(address, sellerAddress);

      if (!mounted) return;

      showDialog(
        context: context,
        builder: (context) => PaymentDetailsDialog(
          originalAmount: double.parse(widget.totalAmount),
          shippingFee: shippingFee,
          onConfirm: () => processPayment(address, shippingFee),
        ),
      );
    } else {
      // For cart orders, we need to get addresses of all sellers
      final sellerAddresses = await addressServices.getSellerAddresses(context);
      double totalShippingFee = 0;

      // Calculate shipping fee for each seller
      for (var sellerAddress in sellerAddresses) {
        totalShippingFee += calculateShippingFee(address, sellerAddress);
      }

      if (!mounted) return;

      showDialog(
        context: context,
        builder: (context) => PaymentDetailsDialog(
          originalAmount: double.parse(widget.totalAmount),
          shippingFee: totalShippingFee,
          onConfirm: () => processPayment(address, totalShippingFee),
        ),
      );
    }
  }

  double calculateShippingFee(String userAddress, String sellerAddress) {
    // Extract city/town from addresses
    final userCity = userAddress.split(',').last.trim().toLowerCase();
    final sellerCity = sellerAddress.split(',').last.trim().toLowerCase();

    return userCity == sellerCity ? 5.0 : 10.0;
  }

  void processPayment(String address, double shippingFee) {
    if (widget.products != null) {
      // Buy Now case
      addressServices.placeDirectOrder(
        context: context,
        address: address,
        totalSum: double.parse(widget.totalAmount) + shippingFee,
        products: widget.products!,
        quantities: widget.quantities!,
      );
    } else {
      // Cart case
      addressServices.placeOrder(
        context: context,
        address: address,
        totalSum: double.parse(widget.totalAmount) + shippingFee,
      );
    }
  }

  void onGooglePayResult(res) {
    if (Provider.of<UserProvider>(context, listen: false)
        .user
        .address
        .isEmpty) {
      addressServices.saveUserAddress(
          context: context, address: addressToBeUsed);
    }
    if (widget.products != null) {
      // Buy Now case
      addressServices.placeDirectOrder(
        context: context,
        address: addressToBeUsed,
        totalSum: double.parse(widget.totalAmount),
        products: widget.products!,
        quantities: widget.quantities!,
      );
    } else {
      // Cart case
      addressServices.placeOrder(
        context: context,
        address: addressToBeUsed,
        totalSum: double.parse(widget.totalAmount),
      );
    }
  }

  void payPressed(String addressFromProvider) {
    addressToBeUsed = "";
    bool isForm = flatBuildingController.text.isNotEmpty ||
        areaController.text.isNotEmpty ||
        pincodeController.text.isNotEmpty ||
        cityController.text.isNotEmpty;

    if (isForm) {
      if (_addressFormKey.currentState!.validate()) {
        addressToBeUsed =
            '${flatBuildingController.text}, ${areaController.text}, ${cityController.text} - ${pincodeController.text}';
      } else {
        throw Exception("Please enter all values!");
      }
    } else if (addressFromProvider.isNotEmpty) {
      addressToBeUsed = addressFromProvider;
    } else {
      showSnackBar(context, "Please enter address!");
      throw Exception("Please enter all values!");
    }

    if (addressToBeUsed.isNotEmpty) {
      showPaymentDetailsDialog(addressToBeUsed);
    }
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
                    ),
                    const SizedBox(height: 10),
                    CustomTextField(
                      textController: areaController,
                      hintText: 'Area, Street',
                    ),
                    const SizedBox(height: 10),
                    CustomTextField(
                      textController: pincodeController,
                      hintText: 'District',
                    ),
                    const SizedBox(height: 10),
                    CustomTextField(
                      textController: cityController,
                      hintText: 'Town/City',
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
              FutureBuilder<PaymentConfiguration>(
                future: _googlePayConfigFuture,
                builder: (context, snapshot) => snapshot.hasData
                    ? GooglePayButton(
                        onPressed: () => payPressed(address),
                        paymentConfiguration: snapshot.data!,
                        paymentItems: paymentItems,
                        type: GooglePayButtonType.buy,
                        margin: const EdgeInsets.only(top: 15.0),
                        onPaymentResult: onGooglePayResult,
                        height: 75,
                        width: double.infinity,
                        theme: GooglePayButtonTheme.dark,
                        loadingIndicator: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}