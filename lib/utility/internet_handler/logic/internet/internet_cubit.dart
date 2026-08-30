import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../model/internet_enum_data_model.dart';

part 'internet_state.dart';

class InternetCubit extends Cubit<InternetState> {
  final bool enableInitialConnectionCheck;
  InternetCubit({this.enableInitialConnectionCheck = false})
      : super(const InternetState(
          loading: true,
          internetConnectionType: InternetConnectionType.none,
        )) {
    monitorInternetConnection(enableInitialConnectionCheck);
  }

  final connectivity = Connectivity();
  late StreamSubscription _connectivityStreamSubscription;

  void checkConnectivity(List<ConnectivityResult> connectivityResult) {
    if (connectivityResult.contains(ConnectivityResult.wifi)) {
      emitInternetConnected(InternetConnectionType.wifi);
    } else if (connectivityResult.contains(ConnectivityResult.mobile)) {
      emitInternetConnected(InternetConnectionType.mobile);
    } else {
      // emitInternetConnected(InternetConnectionType.wifi);
      emitInternetDisconnected();
    }
  }

  Future<StreamSubscription<List<ConnectivityResult>>>
      monitorInternetConnection(bool enableInitialConnectionCheck) async {
    if (enableInitialConnectionCheck) {
      final initialConnectionStatus = await connectivity.checkConnectivity();
      checkConnectivity(initialConnectionStatus);
    }

    return _connectivityStreamSubscription =
        connectivity.onConnectivityChanged.listen(
      (connectivityResult) {
        checkConnectivity(connectivityResult);
      },
    );
  }

  void emitInternetConnected(InternetConnectionType internetConnectionType) {
    emit(state.copyWith(loading: true));
    emit(state.copyWith(
      connected: true,
      internetConnectionType: internetConnectionType,
    ));
  }

  void emitInternetDisconnected() {
    emit(state.copyWith(loading: true));
    emit(state.copyWith(disconnected: true));
  }

  @override
  Future<void> close() {
    _connectivityStreamSubscription.cancel();
    return super.close();
  }

  @pragma('vm:entry-point')

  /// Check for internet connectivity
  Future<bool> isInternetAvailable() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult.contains(ConnectivityResult.none)) {
      return false;
    }
    return true;
  }
}



// import 'dart:async';
// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:equatable/equatable.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// import '../../model/internet_enum.dart';

// part 'internet_state.dart';

// class InternetCubit extends Cubit<InternetState> {
//   final Connectivity connectivity;

//   InternetCubit({required this.connectivity}) : super(InternetLoading()) {
//     monitorInternetConnection();
//   }

//   late StreamSubscription _connectivityStreamSubscription;

//   void checkConnectivity(ConnectivityResult connectivityResult) {
//     if (connectivityResult == ConnectivityResult.wifi) {
//       emitInternetConnected(ConnectionType.wifi);
//     } else if (connectivityResult == ConnectivityResult.mobile) {
//       emitInternetConnected(ConnectionType.mobile);
//     } else if (connectivityResult == ConnectivityResult.none) {
//       emitInternetDisconnected();
//     }
//   }

//   Future<StreamSubscription<ConnectivityResult>>
//       monitorInternetConnection() async {
//     final initialConnectionStatus = await connectivity.checkConnectivity();
//     checkConnectivity(initialConnectionStatus);

//     return _connectivityStreamSubscription =
//         connectivity.onConnectivityChanged.listen(
//       (connectivityResult) {
//         checkConnectivity(connectivityResult);
//       },
//     );
//   }

//   void emitInternetConnected(ConnectionType connectionType) {
//     emit(InternetLoading());
//     emit(InternetConnected(connectionType: connectionType));
//   }

//   void emitInternetDisconnected() {
//     print("hanged up");
//     emit(InternetLoading());
//     emit(InternetDisconnected());
//   }

//   @override
//   Future<void> close() {
//     _connectivityStreamSubscription.cancel();
//     return super.close();
//   }
// }
