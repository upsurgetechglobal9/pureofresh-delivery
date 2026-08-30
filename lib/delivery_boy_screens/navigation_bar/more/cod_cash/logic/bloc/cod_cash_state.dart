part of 'cod_cash_bloc.dart';

class CodCashState extends Equatable {
  final bool codFetchingStarted;
  final bool codFetchingCompleted;

  const CodCashState({
    this.codFetchingStarted = false,
    this.codFetchingCompleted = false,
  });

  @override
  List<Object> get props => [codFetchingStarted, codFetchingCompleted];

  CodCashState copyWith({
    bool? codFetchingStarted,
    bool? codFetchingCompleted,
  }) {
    return CodCashState(
      codFetchingStarted: codFetchingStarted ?? false,
      codFetchingCompleted: codFetchingCompleted ?? false,
    );
  }
}

class CodCashInitial extends CodCashState {}

class CodCashLoadedState extends CodCashState {
  final CodCashModel cashModel;

  const CodCashLoadedState(this.cashModel);

  @override
  List<Object> get props => [cashModel];
}
