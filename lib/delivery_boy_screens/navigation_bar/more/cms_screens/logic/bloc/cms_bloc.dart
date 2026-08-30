import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../fines/repository/fines_repository.dart';
import '../../models/cms_model.dart';
import '../../repository/cms_repository.dart';

part 'cms_event.dart';
part 'cms_state.dart';

class CmsBloc extends Bloc<CmsEvent, CmsState> {
  final CmsRepository cmsRepository;

  CmsBloc({required this.cmsRepository}) : super(CmsInitial()) {
    on<CmsEvent>((event, emit) async {
      if (event is CmsFetchingEvent) {
        try {


       emit(CMSLoadingState());
          CmsModel cmsModelData =
              await cmsRepository.cmsApiCall(apiname: event.api);
      
          if (cmsModelData.errCode == 'valid') {
            print("its valid man");
            emit(CmsSuccessState(cmsModelData));
          }
        } catch (e) {
          emit(CmsFailedState(e.toString()));
          print(e.toString());
        }
      }
    });
  }
}
