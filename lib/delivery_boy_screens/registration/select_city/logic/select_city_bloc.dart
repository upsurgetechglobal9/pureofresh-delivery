import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../repository/select_city_repository.dart';
import '../select_city_model/select_city_model.dart';

part 'select_city_event.dart';
part 'select_city_state.dart';

class SelectCityBloc extends Bloc<SelectCityEvent, SelectCityState> {
  final SelectCityRepository selectCityRepository;

  SelectCityBloc({required this.selectCityRepository})
      : super(SelectCityInitial()) {
    on<SelectCityEvent>((event, emit) async {
      if (event is CitiesFetchingEvent) {
        try {
          print("arey ohh");
          SelectCityModel selectCityModel = await selectCityRepository
              .gettingCities(searchWord: event.searchKeyword);
          print("emit ${selectCityModel.errCode}");
          if (selectCityModel.data != null) {
            // emit(state.copyWith(codFetchingCompleted: true));
            emit(CitiesLoadedState(selectCityModel));
          }
        } catch (e) {
          print(e.toString());
        }
      }
    });
  }
}
// class SelectCityBloc extends Bloc<SelectCityEvent, SelectCityState> {
//   final SelectCityRepository selectCityRepository;

//   SelectCityBloc({required this.selectCityRepository})
//       : super(SelectCityInitial()) {
//     on<SelectCityEvent>((event, emit) async {
//       if (event is CitiesFetchingEvent) {
//         try {
//           print("arey ohh");
//           SelectCityModel selectCityModel =
//               await selectCityRepository.gettingCities();
//           print("emit ${selectCityModel.errCode}");
//           if (selectCityModel.data != null) {
//             // emit(state.copyWith(codFetchingCompleted: true));
//             emit(CitiesLoadedState(selectCityModel, selectCityModel));
//           }
//         } catch (e) {
//           print(e.toString());
//         }
//       }

//       if (event is FilterCitiesListEvent) {
//         var keyword = event.searchKeyword;
//         var OverallCitiesData = event.overallCitiesData;
//         // overall cities
//         List<Result> citiesResults =
//             List<Result>.of(event.overallCitiesData.data.results);
//         List<Result> filteredList = citiesResults
//             .where((element) => element.name.startsWith(event.searchKeyword))
//             .toList();
//         if (filteredList.length > 0) {
//           event.overallCitiesData.data.results = filteredList;
//           emit(CitiesLoadedState(event.overallCitiesData, OverallCitiesData));
//         } else {
//           event.overallCitiesData.data.results = [];
//           emit(CitiesLoadedState(event.overallCitiesData, OverallCitiesData));
//         }
//       }
//     });
//   }
// }
