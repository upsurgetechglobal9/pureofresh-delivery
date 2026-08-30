part of 'select_work_area_bloc.dart';

// abstract class SelectWorkAreaEvent extends Equatable {
//   const SelectWorkAreaEvent();

//   @override
//   List<Object> get props => [];
// }

abstract class SelectWorkAreaEvent extends Equatable {
  const SelectWorkAreaEvent();

  @override
  List<Object> get props => [];
}

class SelectWorkAreaFetching extends SelectWorkAreaEvent {
  final String cityId;
  final String searchLetter;

  const SelectWorkAreaFetching({
    required this.cityId,
    required this.searchLetter,
  });
  @override
  List<Object> get props => [cityId, searchLetter];
}

class WorkAreasetupEvent extends SelectWorkAreaEvent {
  final String cityId;
  final String locationId;

  const WorkAreasetupEvent({
    required this.cityId,
    required this.locationId,
  });
  @override
  List<Object> get props => [cityId, locationId];
}
