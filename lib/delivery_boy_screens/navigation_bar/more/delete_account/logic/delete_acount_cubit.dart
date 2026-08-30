import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:pure_o_fresh_rider_app/commons/shared_prefs.dart';

import '/../../commons/cod_base_options.dart' as d;

part 'delete_acount_state.dart';

class DeleteAcountCubit extends Cubit<DeleteAcountState> {
  DeleteAcountCubit() : super(DeleteAcountInitial());

  Future<void> deleteAcountApi() async {
    try {
      final deletionMap = <String, dynamic>{
        'access_token': Constants.prefs!.getString('token')
      };
      FormData data = FormData.fromMap(deletionMap);
      final dio = d.BaseApi().dioClient();
      return await dio.post('Delete_account', data: data).then((response) {
        if (response.data['err_code'] == "valid") {
          emit(DeleteAcountSuccessState());
        } else if (response.data['err_code'] == "invalid") {
          emit(DeleteAcountFailedState());
        } else {
          throw (response.data['message']);
        }
      });
    } catch (e) {
      "Error occured While deleting $e";
    }
  }

  Future<void> logoutApi() async {
    try {
      final logoutMap = <String, dynamic>{
        'access_token': Constants.prefs!.getString('token')
      };
      FormData data = FormData.fromMap(logoutMap);
      final dio = d.BaseApi().dioClient();
      return await dio.post('Logout', data: data).then((response) {
        if (response.data['err_code'] == "valid") {
          emit(DeleteAcountSuccessState());
        } else if (response.data['err_code'] == "invalid") {
          emit(DeleteAcountFailedState());
        } else {
          throw (response.data['message']);
        }
      });
    } catch (e) {
      "Error occured While deleting $e";
    }
  }
}
