import 'package:ecommerce_app_fluterr_nodejs/features/account/screens/seller_registration_screen.dart';
import 'package:ecommerce_app_fluterr_nodejs/features/account/services/account_services.dart';
import 'package:ecommerce_app_fluterr_nodejs/features/account/widgets/account_button.dart';
import 'package:ecommerce_app_fluterr_nodejs/features/address/screens/set_address.dart';
import 'package:ecommerce_app_fluterr_nodejs/features/admin/screens/sellers_screen.dart';
import 'package:ecommerce_app_fluterr_nodejs/features/seller/screens/seller_screen.dart';
import 'package:ecommerce_app_fluterr_nodejs/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TopButton extends StatelessWidget {
  const TopButton({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;
    return Column(
      children: [
        Row(
          children: [
            AccountButton(
              text: 'Your Orders',
              onTap: () {},
            ),
            AccountButton(
              text: (user.type == 'seller') ? 'My Shop' : 'Turn Seller',
              onTap: () {
                if (user.type == 'seller') {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    SellerScreen.routeName,
                    (route) => false,
                  );
                } else {
                  Navigator.pushNamed(
                    context,
                    SellerRegistrationScreen.routeName,
                  );
                }
              },
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            AccountButton(
              text: 'Log Out',
              onTap: () => AccountServices().logOut(context),
            ),
            AccountButton(
              text: 'Set home address',
              onTap: () {
                Navigator.pushNamed(context, SetAddressScreen.routeName);
              },
            ),
          ],
        ),
      ],
    );
  }
}
