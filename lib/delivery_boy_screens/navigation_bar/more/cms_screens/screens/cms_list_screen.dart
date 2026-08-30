import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pure_o_fresh_rider_app/delivery_boy_screens/navigation_bar/more/cms_screens/screens/delivery_preferences.dart';
import 'package:pure_o_fresh_rider_app/delivery_boy_screens/navigation_bar/more/cms_screens/screens/faqs_data_screen.dart';
import 'package:pure_o_fresh_rider_app/delivery_boy_screens/navigation_bar/more/cms_screens/widgets/dotted_line.dart';
import 'package:pure_o_fresh_rider_app/utility/colors_data.dart';
import 'package:pure_o_fresh_rider_app/utility/common_text.dart';

import '../../../../../commons/ConvertText.dart';
import '../../../../../utility/widgets/theme_spinner.dart';
import '../logic/cubit/delivery_preferences_cubit.dart';
import 'cms_typewise_screens.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  void initState() {
    // TODO: implement initState
    context.read<DeliveryPreferencesCubit>().featchDeliveryType();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        // backgroundColor: Colors.transparent,
        backgroundColor: Colors.white,
        elevation: 0,
        titleSpacing: 4,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.black,
              size: 16,
            ),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        // leading: null,
        title: Text(
          ConvertText.getTitle("Settings"),
          style: GoogleFonts.manrope(
            fontSize: 15,
            color: Colors.black,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          padding: const EdgeInsets.all(0),
          // physics: BouncingScrollPhysics(),
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          children: [
            BlocBuilder<DeliveryPreferencesCubit, DeliveryPreferencesState>(
              builder: (context, deliveryPreferencesState) {
                if (deliveryPreferencesState.typeLoad) {
                  return const ThemeSpinner(
                    size: 50,
                  );
                } else {
                  if (deliveryPreferencesState.typeId != null) {
                    print(deliveryPreferencesState.typeId);
                    if (deliveryPreferencesState.typeId == '1') {
                      return ListTile(
                        dense: true,
                        title: CommonProximaNovaTextWidget(
                          text: "Delivery Preferences",
                          fontSize: 14,
                          color: ColorsData.blackColor,
                          fontWeight: FontWeight.w600,
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 16,
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const DeliveryPreferencesScreen(
                                isFromProfile: false,
                              ),
                            ),
                          );
                        },
                      );
                    } else if (deliveryPreferencesState.typeId == '2') {
                      return const SizedBox(
                        height: 0,
                        width: 0,
                      );
                    } else {
                      return const SizedBox(
                        height: 0,
                        width: 0,
                      );
                    }
                  } else {
                    return const ThemeSpinner();
                  }
                }
              },
            ),
            const DottedLineWidget(),
            ListTile(
              dense: true,
              title: CommonProximaNovaTextWidget(
                text: "Terms and Conditions",
                fontSize: 14,
                color: ColorsData.blackColor,
                fontWeight: FontWeight.w600,
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CMsTypeWiseScreen(
                        apiType: "pages/terms",
                        titleType:
                            ConvertText.getTitle('Terms and Conditions')),
                  ),
                );
              },
            ),
            const DottedLineWidget(),
            ListTile(
              dense: true,
              title: CommonProximaNovaTextWidget(
                text: "Privacy and Policy",
                fontSize: 14,
                color: ColorsData.blackColor,
                fontWeight: FontWeight.w600,
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CMsTypeWiseScreen(
                      apiType: 'pages/privacy',
                      titleType: ConvertText.getTitle('Privacy and Policy'),
                    ),
                  ),
                );
              },
            ),
            const DottedLineWidget(),
            ListTile(
              dense: true,
              title: CommonProximaNovaTextWidget(
                text: "About Us",
                fontSize: 14,
                color: ColorsData.blackColor,
                fontWeight: FontWeight.w600,
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CMsTypeWiseScreen(
                        apiType: 'pages/about',
                        titleType: 'About Us',
                      ),
                    ));
              },
            ),
            const DottedLineWidget(),
            ListTile(
              dense: true,
              title: CommonProximaNovaTextWidget(
                text: "FAQ",
                fontSize: 14,
                color: ColorsData.blackColor,
                fontWeight: FontWeight.w600,
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const FaqsDataScreen(),
                    ));
              },
            ),
          ],
        ),
      ),
    );
  }
}
