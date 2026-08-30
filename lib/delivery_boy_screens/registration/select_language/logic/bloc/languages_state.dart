part of 'languages_bloc.dart';

abstract class LanguagesState extends Equatable {
  const LanguagesState();

  @override
  List<Object> get props => [];
}

class LanguagesInitial extends LanguagesState {}

class LanguagesLoadedState extends LanguagesState {
  final LanguageModel languageModel;

  const LanguagesLoadedState(this.languageModel);

  @override
  List<Object> get props => [languageModel];
}

class LanguageContinueLoadedState extends LanguagesState {
  final dynamic confirmationText;

  const LanguageContinueLoadedState(this.confirmationText);

  @override
  List<Object> get props => [confirmationText];
}

class SelectedLanguageState extends LanguagesState {
  final String selectedLanguage;

  const SelectedLanguageState(this.selectedLanguage);

  @override
  List<Object> get props => [selectedLanguage];
}
