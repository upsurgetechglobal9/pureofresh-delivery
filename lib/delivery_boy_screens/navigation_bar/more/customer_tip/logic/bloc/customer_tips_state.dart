part of 'customer_tips_bloc.dart';

class CustomerTipsState extends Equatable {
  final bool tipsFetchingStarted;
  final bool tipsFetchingCompleted;

  const CustomerTipsState({
    this.tipsFetchingStarted = false,
    this.tipsFetchingCompleted = false,
  });

  @override
  List<Object> get props => [tipsFetchingStarted, tipsFetchingCompleted];

  CustomerTipsState copyWith({
    bool? tipsFetchingStarted,
    bool? tipsFetchingCompleted,
  }) {
    return CustomerTipsState(
      tipsFetchingStarted: tipsFetchingStarted ?? false,
      tipsFetchingCompleted: tipsFetchingCompleted ?? false,
    );
  }
}

class CustomerTipsInitial extends CustomerTipsState {}

class TipsLoadedState extends CustomerTipsState {
  final CustomerTipsModel customerTipsData;

  const TipsLoadedState(this.customerTipsData);

  @override
  List<Object> get props => [customerTipsData];
}

class TipsErrorState extends CustomerTipsState {
  final String errorMessage;

  const TipsErrorState(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}
