part of 'fines_bloc.dart';

abstract class FinesEvent extends Equatable {
  const FinesEvent();

  @override
  List<Object> get props => [];
}

class FinesFetchingEvent extends FinesEvent {
  const FinesFetchingEvent();

  @override
  List<Object> get props => [];
}
