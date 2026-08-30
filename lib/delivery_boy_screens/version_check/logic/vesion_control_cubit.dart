import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

import '../../../../commons/cod_base_options.dart' as d;
import '../../../commons/url_links.dart';
import '../model/maintenance_model.dart';
import '../model/primary_check_in_model.dart';
import '../model/version_check_model.dart';

part 'vesion_control_state.dart';

class VesionControlCubit extends Cubit<VesionControlState> {
  VesionControlCubit() : super(VesionControlInitial());

  Future<void> checkingVersion() async {
    try {
      final versionMap = <String, dynamic>{
        'platform_type': "android",
        'version': VersionNumber.currentVersion,
      };
      FormData data = FormData.fromMap(versionMap);
      final dio = d.BaseApi().dioClient();
      return await dio.post('Version_control', data: data).then((response) {

        if (response.data['err_code'] == "valid") {
          // no need update
          emit(VersionUpdateNotNeedSate(
              versionCheckModel: VersionCheckModel.fromJson(response.data)));
        } else if (response.data['err_code'] == "invalid") {
          //update needed
          emit(UpdateNeededState(
              versionCheckModel: VersionCheckModel.fromJson(response.data)));
        } else {
          throw (response.data['message']);
        }
      });
    } catch (e) {
      emit(VersionCheckError(error: e.toString()));
    }
  }

  Future<void> maintenanceCheckApi() async {
    try {
      final dio = d.BaseApi().dioClient();
      return await dio.post('Maintenance_check').then((response) {
        if (response.data['err_code'] == "valid") {
          emit(UnderMaintenanceSate(
              underMaintenanceModel:
                  UnderMaintenanceModel.fromJson(response.data)));
        } else if (response.data['err_code'] == "invalid") {
          emit(WorkingFineSate());
        } else {
          throw (response.data['message']);
        }
      });
    } catch (e) {
      emit(VersionCheckError(error: e.toString()));
    }
  }

  Future<void> primaryCheckInApi() async {
    try {
      final dio = d.BaseApi().dioClient();
      return await dio.post('Validate_checkin').then((response) {
        print(jsonEncode(response.data));
        if (response.data['err_code'] == "valid") {
          emit(PrimaryCheckInSate(
              primaryCheckInModel:
                  PrimaryCheckInModel.fromJson(response.data)));
        } else {
          throw (response.data['message']);
        }
      });
    } catch (e) {
      emit(VersionCheckError(error: e.toString()));
    }
  }
}
