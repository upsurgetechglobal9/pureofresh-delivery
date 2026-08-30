part of 'select_city_bloc.dart';

abstract class SelectCityEvent extends Equatable {
  const SelectCityEvent();

  @override
  List<Object> get props => [];
}

class CitiesFetchingEvent extends SelectCityEvent {
  final String searchKeyword;
  const CitiesFetchingEvent({
    required this.searchKeyword,
  });
  @override
  List<Object> get props => [searchKeyword];
}

// class FilterCitiesListEvent extends SelectCityEvent {
//   final SelectCityModel overallCitiesData;
//   final String searchKeyword;

//   const FilterCitiesListEvent({
//     required this.overallCitiesData,
//     required this.searchKeyword,
//   });

//   @override
//   List<Object> get props => [overallCitiesData, searchKeyword];
// }
