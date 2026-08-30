import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'select_language_state.dart';

class SelectLanguageCubit extends Cubit<SelectLanguageState> {
  SelectLanguageCubit()
      : super(SelectLanguageState(selectedLanguage: 'English', index: "0"));

  void changeLanguage(String stated, String index) =>
      emit(SelectLanguageState(selectedLanguage: stated, index: index));
}
