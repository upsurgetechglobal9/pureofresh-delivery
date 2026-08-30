part of 'languages_bloc.dart';

abstract class LanguagesEvent extends Equatable {
  const LanguagesEvent();

  @override
  List<Object> get props => [];
}

class LanguagesFetching extends LanguagesEvent {
  const LanguagesFetching();
  @override
  List<Object> get props => [];
}

class ContinueButtonClicked extends LanguagesEvent {
  final String selectedLanguage;

  const ContinueButtonClicked({
    required this.selectedLanguage,
  });
  @override
  List<Object> get props => [selectedLanguage];
}
