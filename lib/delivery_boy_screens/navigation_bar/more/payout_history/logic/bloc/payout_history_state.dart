part of 'payout_history_bloc.dart';

abstract class PayoutHistoryState extends Equatable {
  const PayoutHistoryState();

  @override
  List<Object> get props => [];
}

class PayoutHistoryInitial extends PayoutHistoryState {}

class PayoutHistorySuccessState extends PayoutHistoryState {
  final PayoutHistoryModel payoutHistoryModelData;

  const PayoutHistorySuccessState(this.payoutHistoryModelData);

  @override
  List<Object> get props => [payoutHistoryModelData];
}

class PayoutHistoryInavalidState extends PayoutHistoryState {}
