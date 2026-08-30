import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/cod_cash_model.dart';
import '../../repository/cod_cash_repository.dart';

part 'cod_cash_event.dart';
part 'cod_cash_state.dart';

class CodCashBloc extends Bloc<CodCashEvent, CodCashState> {
  final CODRepository codRepository;

  CodCashBloc({required this.codRepository}) : super(CodCashInitial()) {
    on<CodCashEvent>((event, emit) async {
      if (event is CODCashFetching) {
        try {
          print(event.accessToken);
          CodCashModel codcashresponse = await codRepository.codCash(
            userName: event.accessToken,
          );
          if (codcashresponse.errCode == "valid") {
            print("emit$codcashresponse");//7849464946
            // emit(state.copyWith(codFetchingCompleted: true));
            emit(CodCashLoadedState(codcashresponse));
          }
        } catch (e) {
          print(e.toString());
        }
      }
    });
  }
}
