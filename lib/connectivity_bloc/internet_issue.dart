// import 'dart:async';

// import 'package:flutter_bloc/flutter_bloc.dart';

// // Events
// abstract class ConnectivityEvent {}

// class CheckConnectivity extends ConnectivityEvent {}

// // States
// abstract class ConnectivityState {}

// class InternetConnected extends ConnectivityState {}

// class NoInternetConnection extends ConnectivityState {}

// class ConnectivityBloc extends Bloc<ConnectivityEvent, ConnectivityState> {
//   final Connectivity _connectivity = Connectivity();
//   StreamSubscription<ConnectivityResult>? _connectivitySubscription;

//   ConnectivityBloc() : super(NoInternetConnection()) {
//     _connectivitySubscription = _connectivity.onConnectivityChanged.listen((result) {
//       if (result != ConnectivityResult.none) {
//         add(CheckConnectivity());
//       } else {
//         add(NoInternetConnection());
//       }
//     });
//   }

//   @override
//   Stream<ConnectivityState> mapEventToState(ConnectivityEvent event) async* {
//     if (event is CheckConnectivity) {
//       final connectivityResult = await _connectivity.checkConnectivity();
//       if (connectivityResult != ConnectivityResult.none) {
//         yield InternetConnected();
//       } else {
//         yield NoInternetConnection();
//       }
//     }
//   }

//   @override
//   Future<void> close() {
//     _connectivitySubscription?.cancel();
//     return super.close();
//   }
// }
