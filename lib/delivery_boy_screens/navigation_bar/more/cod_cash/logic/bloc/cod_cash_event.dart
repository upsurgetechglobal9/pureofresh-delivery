part of 'cod_cash_bloc.dart';

abstract class CodCashEvent extends Equatable {
  const CodCashEvent();

  @override
  List<Object> get props => [];
}

class CODCashFetching extends CodCashEvent {
  final String accessToken;

  const CODCashFetching({
    required this.accessToken,
  });
  @override
  List<Object> get props => [accessToken];
}
