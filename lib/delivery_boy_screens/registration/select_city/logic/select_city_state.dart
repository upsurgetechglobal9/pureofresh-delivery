part of 'select_city_bloc.dart';

abstract class SelectCityState extends Equatable {
  const SelectCityState();

  @override
  List<Object> get props => [];
}

class SelectCityInitial extends SelectCityState {}

class CitiesLoadedState extends SelectCityState {
  final SelectCityModel selectCityModel;

  const CitiesLoadedState(this.selectCityModel);

  @override
  List<Object> get props => [selectCityModel];
}

// class CitiesLoadedState extends SelectCityState {
//   final SelectCityModel selectCityModel;
//   final SelectCityModel overallCitiesData;

//   const CitiesLoadedState(this.selectCityModel, this.overallCitiesData);

//   @override
//   List<Object> get props => [selectCityModel, overallCitiesData];
// }
