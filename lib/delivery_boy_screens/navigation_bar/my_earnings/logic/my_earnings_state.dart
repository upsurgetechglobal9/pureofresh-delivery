part of 'my_earnings_bloc.dart';

abstract class MyEarningsState extends Equatable {
  const MyEarningsState();

  @override
  List<Object> get props => [];
}

class MyEarningsInitial extends MyEarningsState {}

class MyEarningsSuccessState extends MyEarningsState {
  final MyEarningsModel myEarningsModelData;

  const MyEarningsSuccessState(this.myEarningsModelData);

  @override
  List<Object> get props => [myEarningsModelData];
}

class MyEarningsFailedState extends MyEarningsState {}

class MyEarningsLoadingState extends MyEarningsState {}
