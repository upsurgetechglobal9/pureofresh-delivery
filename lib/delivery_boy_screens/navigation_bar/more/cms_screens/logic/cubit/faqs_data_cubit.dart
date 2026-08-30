import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pure_o_fresh_rider_app/delivery_boy_screens/navigation_bar/more/cms_screens/models/faqs_model.dart';
import 'package:pure_o_fresh_rider_app/delivery_boy_screens/navigation_bar/more/cms_screens/repository/faqs_repository.dart';

part 'faqs_data_state.dart';

class FaqsDataCubit extends Cubit<FaqsDataState> {
  final FaqsRepository faqsRepository;
  FaqsDataCubit(this.faqsRepository) : super(const FaqsDataState());

  Future<void> featchFaqsData() async {
    try {
      emit(state.copyWith(dataLoading: true));
      final faqsResponseModel = await faqsRepository.featchFaqs();
      emit(state.copyWith(faqsResponseModel: faqsResponseModel));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  void updateCurrentIndex(int index) {
    emit(state.copyWith(currentIndex: index));
  }
}
