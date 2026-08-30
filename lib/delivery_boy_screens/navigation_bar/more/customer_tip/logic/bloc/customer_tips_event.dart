part of 'customer_tips_bloc.dart';

abstract class CustomerTipsEvent extends Equatable {
  const CustomerTipsEvent();

  @override
  List<Object> get props => [];
}

class CustomerTipsFetching extends CustomerTipsEvent {
  final String accessToken;

  const CustomerTipsFetching({
    required this.accessToken,
  });
  @override
  List<Object> get props => [accessToken];
}
