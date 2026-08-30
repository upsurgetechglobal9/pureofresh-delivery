import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pure_o_fresh_rider_app/delivery_boy_screens/navigation_bar/navigationbar_screen.dart';

import '../../../../commons/ConvertText.dart';
import '../../../../commons/shared_prefs.dart';
import '../../../basic_information.dart/screens/enter_mobile_number_screen.dart';
import '../logic/bloc/languages_bloc.dart';

class SelectLanguageScreen extends StatefulWidget {
  final String type;
  const SelectLanguageScreen({super.key, required this.type});

  @override
  State<SelectLanguageScreen> createState() => _SelectLanguageScreenState();
}

class _SelectLanguageScreenState extends State<SelectLanguageScreen> {
  int currentIndex = Constants.prefs!.getInt('selectedLanguageId') ?? 0;
  String selectedLanguage = "English";
  List languageList = ["English", "తెలుగు"];

  @override
  void initState() {
    // selectedLanguage = Constants.prefs!.getString('selectedLanguage')!;
    // TODO: implement initState
    super.initState();
    context.read<LanguagesBloc>().add(const LanguagesFetching());
  }

  @override
  Widget build(BuildContext context) {
    return
        // BlocProvider(
        //   create: (context) => SelectLanguageCubit(),
        //   child:
        BlocConsumer<LanguagesBloc, LanguagesState>(
      listener: (context, state) {
        if (state is LanguageContinueLoadedState) {
          print("languages are fixed ${state.confirmationText}");
          Constants.prefs
              ?.setString('selectedLanguage', selectedLanguage)
              .toString();
          print(
              "languages are  ${Constants.prefs?.getString('selectedLanguage')}");
          if (widget.type == 'language') {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const BottomsNaviScreen(index: 3)));
          } else {
            // Navigator.pushReplacement(
            //     context,
            //     MaterialPageRoute(
            //       builder: (context) => const EnterMobileNumberScreen(),
            //     ));
          }
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 120,
              ),
              Text("Select Language",
                  style: GoogleFonts.manrope(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: const Color(0xFF7ec245),
                  )),
              Text("Select One Below",
                  style: GoogleFonts.manrope(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  )),
              BlocBuilder<LanguagesBloc, LanguagesState>(
                builder: (context, state) {
                  if (state is LanguagesLoadedState) {
                    if (state.languageModel.data.isEmpty) {
                      return const Center(
                        child: Text("No Data Found"),
                      );
                    }
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      alignment: Alignment.center,
                      child: GridView.builder(
                        itemCount: state.languageModel.data.length,
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                mainAxisExtent: 80,
                                mainAxisSpacing: 10,
                                crossAxisSpacing: 10,
                                crossAxisCount: 2),
                        itemBuilder: (context, index) => GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedLanguage =
                                  state.languageModel.data[index].name;
                              currentIndex = index;
                            });
                            Constants.prefs
                                ?.setInt('selectedLanguageId', index);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            alignment: Alignment.centerLeft,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all()),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(state.languageModel.data[index].name),
                                (currentIndex == index)
                                    ? const Icon(Icons.check_circle_sharp,
                                        color: Color(0xFF7ec245))
                                    : const Icon(
                                        Icons.circle_outlined,
                                        color: Color(0xFF7ec245),
                                      )
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                  return const Padding(
                    padding: EdgeInsets.all(48.0),
                    child: CircularProgressIndicator(strokeWidth: 3),
                  );
                },
              ),
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: SizedBox(
                  height: 45,
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF7ec245),
                    ),
                    onPressed: () {
                      context.read<LanguagesBloc>().add(ContinueButtonClicked(
                          selectedLanguage: selectedLanguage));
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //       builder: (context) =>
                      //           const EnterMobileNumberScreen(),
                      //     ));
                    },
                    child: widget.type == ""
                        ? Text(
                            ConvertText.getTitle("CONTINUE"),
                            style: GoogleFonts.manrope(
                              letterSpacing: 0.8,
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          )
                        : Text(
                            ConvertText.getTitle("SUBMIT"),
                            style: GoogleFonts.manrope(
                              letterSpacing: 0.8,
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
