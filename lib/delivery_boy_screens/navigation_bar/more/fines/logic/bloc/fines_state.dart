part of 'fines_bloc.dart';

abstract class FinesState extends Equatable {
  const FinesState();

  @override
  List<Object> get props => [];
}

class FinesInitial extends FinesState {}

class FinesSuccess extends FinesState {
  final FinesModel finesModelData;

  const FinesSuccess(this.finesModelData);

  @override
  List<Object> get props => [finesModelData];
}

class FinesErrorState extends FinesState {
  final String errorMessage;

  const FinesErrorState(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}
