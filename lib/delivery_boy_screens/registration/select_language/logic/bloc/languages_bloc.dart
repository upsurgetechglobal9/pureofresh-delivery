import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:pure_o_fresh_rider_app/commons/LangaugesData.dart';

import '../../models/language_model.dart';
import '../../repository/language_repository.dart';

part 'languages_event.dart';
part 'languages_state.dart';

// class LanguagesBloc extends Bloc<LanguagesEvent, LanguagesState> {
//   LanguagesBloc() : super(LanguagesInitial());

//   @override
//   Stream<LanguagesState> mapEventToState(
//     LanguagesEvent event,
//   ) async* {
//     // TODO: implement mapEventToState
//   }
// }

class LanguagesBloc extends Bloc<LanguagesEvent, LanguagesState> {
  final LanguagesRepository languagesRepository;

  LanguagesBloc({required this.languagesRepository})
      : super(LanguagesInitial()) {
    on<LanguagesEvent>((event, emit) async {
      if (event is LanguagesFetching) {
        try {
          LanguageModel languageModel =
              await languagesRepository.gettingLanuages();
          emit(LanguagesLoadedState(languageModel));
        } catch (e) {
          if (kDebugMode) {
            print(e.toString());
          }
        }
      }

      if (event is ContinueButtonClicked) {
        try {
          dynamic confirmForContinue = await languagesRepository
              .continueWithLanguage(language: event.selectedLanguage);

          if (confirmForContinue != null) {
            LangaugesData.titles = confirmForContinue;
            // emit(state.copyWith(codFetchingCompleted: true));
            emit(LanguageContinueLoadedState(confirmForContinue));
          }
        } catch (e) {
          if (kDebugMode) {
            print(e.toString());
          }
        }
      }
    });
  }
}

// class LangBloc extends Bloc<LanguagesEvent, SelectedLanguageState> {
//   LangBloc(super.initialState);
// }
