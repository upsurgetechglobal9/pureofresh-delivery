part of 'select_work_area_bloc.dart';

abstract class SelectWorkAreaState extends Equatable {
  const SelectWorkAreaState();

  @override
  List<Object> get props => [];
}

class SelectWorkAreaInitial extends SelectWorkAreaState {}

class SelectWorkAreaLoadedState extends SelectWorkAreaState {
  final SelectWorkAreaModel selectWorkAreaModel;

  const SelectWorkAreaLoadedState(this.selectWorkAreaModel);

  @override
  List<Object> get props => [selectWorkAreaModel];
}

class NextButtonClickedState extends SelectWorkAreaState {}

class LoadingState extends SelectWorkAreaState {}
