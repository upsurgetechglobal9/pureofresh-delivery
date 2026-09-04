import 'dart:convert';
import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:chuck_interceptor/chuck_interceptor.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:deep_route/deep_material_app.dart';
// ignore: depend_on_referenced_packages
import 'package:firebase_crashlytics/firebase_crashlytics.dart' as crash;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pure_o_fresh_rider_app/delivery_boy_screens/basic_information.dart/logic/cubit/register_data_cubit.dart';
import 'package:pure_o_fresh_rider_app/delivery_boy_screens/login/repository/driver_type_repository.dart';
import 'package:pure_o_fresh_rider_app/delivery_boy_screens/my_orders_rides/cubit/my_order_rides_cubit.dart';
import 'package:pure_o_fresh_rider_app/delivery_boy_screens/my_orders_rides/my_orders_rides_repository.dart';
import 'package:pure_o_fresh_rider_app/delivery_boy_screens/navigation_bar/home/logic/bloc/dashboard_home_bloc.dart';
import 'package:pure_o_fresh_rider_app/delivery_boy_screens/navigation_bar/more/cms_screens/logic/cubit/delivery_preferences_cubit.dart';
import 'package:pure_o_fresh_rider_app/delivery_boy_screens/navigation_bar/more/cms_screens/repository/delivery_preferences_repository.dart';
import 'package:pure_o_fresh_rider_app/delivery_boy_screens/navigation_bar/more/cms_screens/repository/faqs_repository.dart';
import 'package:pure_o_fresh_rider_app/delivery_boy_screens/navigation_bar/more/cod_cash/logic/bloc/cod_cash_bloc.dart';
import 'package:pure_o_fresh_rider_app/delivery_boy_screens/navigation_bar/more/cod_cash/repository/cod_cash_repository.dart';
import 'package:pure_o_fresh_rider_app/firebase_options.dart';
import 'package:pure_o_fresh_rider_app/notification/controller/notification_controller.dart';
import 'package:pure_o_fresh_rider_app/utility/routes/on_generate_route.dart';
import 'package:pure_o_fresh_rider_app/utility/theme_data_color.dart';

import 'commons/shared_prefs.dart';
import 'delivery_boy_screens/basic_information.dart/logic/bloc/basic_details_bloc.dart';
import 'delivery_boy_screens/basic_information.dart/repository/repository.dart';
import 'delivery_boy_screens/firebase_database_store/repository/firebase_driver_repository.dart';
import 'delivery_boy_screens/navigation_bar/home/logic/orders_list_bloc.dart';
import 'delivery_boy_screens/navigation_bar/home/notifications/logic/bloc/notifications_bloc.dart';
import 'delivery_boy_screens/navigation_bar/home/notifications/logic/cubit/ongoing_rides_data_cubit.dart';
import 'delivery_boy_screens/navigation_bar/home/notifications/repository/notifications_repository.dart';
import 'delivery_boy_screens/navigation_bar/home/repository/dashboard_details_repository.dart';
import 'delivery_boy_screens/navigation_bar/more/attendence_sheet/check_in/logic/bloc/check_in_out_bloc.dart';
import 'delivery_boy_screens/navigation_bar/more/attendence_sheet/check_in/repository/check_in_out_repository.dart';
import 'delivery_boy_screens/navigation_bar/more/attendence_sheet/logic/bloc/attendance_sheet_bloc.dart';
import 'delivery_boy_screens/navigation_bar/more/attendence_sheet/repository/attendance_sheet_repository.dart';
import 'delivery_boy_screens/navigation_bar/more/cms_screens/logic/bloc/cms_bloc.dart';
import 'delivery_boy_screens/navigation_bar/more/cms_screens/repository/cms_repository.dart';
import 'delivery_boy_screens/navigation_bar/more/code_wallet/logic/cubit/cod_wallet_data_cubit.dart';
import 'delivery_boy_screens/navigation_bar/more/code_wallet/repository/cod_wallet_repository.dart';
import 'delivery_boy_screens/navigation_bar/more/customer_tip/logic/bloc/customer_tips_bloc.dart';
import 'delivery_boy_screens/navigation_bar/more/customer_tip/repository/customer_tips_repository.dart';
import 'delivery_boy_screens/navigation_bar/more/delete_account/logic/delete_acount_cubit.dart';
import 'delivery_boy_screens/navigation_bar/more/incentives_business/logic/incentives_business_bloc.dart';
import 'delivery_boy_screens/navigation_bar/more/incentives_business/repository/incentives_repository.dart';
import 'delivery_boy_screens/navigation_bar/more/payout_history/logic/bloc/payout_history_bloc.dart';
import 'delivery_boy_screens/navigation_bar/more/payout_history/repository/payouts_repository.dart';
import 'delivery_boy_screens/navigation_bar/more/profile/logic/bloc/profile_details_bloc.dart';
import 'delivery_boy_screens/navigation_bar/more/profile/repository/profile_details_repository.dart';
import 'delivery_boy_screens/navigation_bar/more/raised_issues.dart/logic/raised_issues_bloc.dart';
import 'delivery_boy_screens/navigation_bar/more/raised_issues.dart/repository/raised_issues_repository.dart';
import 'delivery_boy_screens/navigation_bar/more/ratings/logic/bloc/ratings_view_bloc.dart';
import 'delivery_boy_screens/navigation_bar/more/ratings/repository/ratings_view_repository.dart';
import 'delivery_boy_screens/navigation_bar/more/refering_friend/logic/bloc/referrals_data_bloc.dart';
import 'delivery_boy_screens/navigation_bar/more/refering_friend/logic_for_friend/bloc/friend_refer_bloc_bloc.dart';
import 'delivery_boy_screens/navigation_bar/more/refering_friend/repository/referrals_repository.dart';
import 'delivery_boy_screens/navigation_bar/more/support_help/logic/bloc/support_help_bloc.dart';
import 'delivery_boy_screens/navigation_bar/more/support_help/repository/support_help_repository.dart';
import 'delivery_boy_screens/navigation_bar/my_earnings/logic/my_earnings_bloc.dart';
import 'delivery_boy_screens/navigation_bar/my_earnings/repository/my_earnings_repository.dart';
import 'delivery_boy_screens/navigation_bar/my_orders/logic/my_orders_bloc.dart';
import 'delivery_boy_screens/navigation_bar/my_orders/order_history/logic/bloc/my_order_history_bloc.dart';
import 'delivery_boy_screens/navigation_bar/my_orders/order_history/repository/my_orders_history_repository.dart';
import 'delivery_boy_screens/navigation_bar/my_orders/repository/my_orders_repository.dart';
import 'delivery_boy_screens/new_order/logic/new_order_bloc.dart';
import 'delivery_boy_screens/new_order/repository/new_order_repository.dart';
import 'delivery_boy_screens/new_order/screens/new_order_screen.dart';
import 'delivery_boy_screens/registration/select_city/logic/select_city_bloc.dart';
import 'delivery_boy_screens/registration/select_city/repository/select_city_repository.dart';
import 'delivery_boy_screens/registration/select_language/logic/bloc/languages_bloc.dart';
import 'delivery_boy_screens/registration/select_language/repository/language_repository.dart';
import 'delivery_boy_screens/registration/select_vehicle/logic/bloc/vehicle_information_bloc.dart';
import 'delivery_boy_screens/registration/select_vehicle/repository/select_vehicle_repository.dart';
import 'delivery_boy_screens/registration/select_work_area/logic/select_work_area_bloc.dart';
import 'delivery_boy_screens/registration/select_work_area/repository/select_work_area_repository.dart';
import 'delivery_boy_screens/registration/upload_profile_pic/logic/bloc/upload_profile_pic_bloc.dart';
import 'delivery_boy_screens/registration/upload_profile_pic/repository/profile_pic_repository.dart';
import 'delivery_boy_screens/registration/verification_documents/logic/bloc/verification_documents_bloc.dart';
import 'delivery_boy_screens/registration/verification_documents/repository/verification_documents_repository.dart';
import 'delivery_boy_screens/version_check/logic/vesion_control_cubit.dart';
import 'location_service/logic/location_controller/location_controller_cubit.dart';
import 'location_service/repository/location_service_repository.dart';
import 'notification_latest/awesome_notification/notification_channel_service.dart';
import 'notification_latest/noti_service.dart';
import 'notification_latest/notification_implementation.dart';
import 'utility/internet_handler/logic/internet/internet_cubit.dart';


Chuck? chuck;
final Battery battery = Battery();

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

Future<void> removeAndRecreateNotificationChannels(
    BuildContext? context, String type) async {
  try {
    // Directly remove the channels if they exist
    final removedAlerts = await AwesomeNotifications().removeChannel('alerts');
    if (removedAlerts) {
      print('alerts channel removed');
    } else {
      print('alerts channel not found (or already removed)');
    }

    final removedBuzzer =
        await AwesomeNotifications().removeChannel('buzzer_channel');
    if (removedBuzzer) {
      print('buzzer_channel removed');
    } else {
      print('buzzer_channel not found (or already removed)');
    }

    // Create notification channels
    final String sound = Platform.isAndroid
        ? 'resource://raw/warning'
        : 'warning.mp3';
    final notification = NotificationImplementation(
      awesomeChannelService: AwesomeChannelService(
        sound: sound,
      ),
    );

    // Initialize notifications on a background thread
    await Future.wait<void>([
      notification.initialize(),
      notification.fcmInitialize(),
    ]);

    if (type == 'init' && context != null) {
      final notificationService =
          NotificationService(FlutterLocalNotificationsPlugin());
      await notificationService.initialize(context);
    }
  } catch (e) {
    print('Error in removeAndRecreateNotificationChannels: $e');
  }
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call initializeApp before using other Firebase services.
  // await FirebaseMessaging.instance.requestPermission();
  NotificationSettings settings =
      await FirebaseMessaging.instance.requestPermission();
  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print('User granted permission for notifications');
  } else {
    print('User declined or has not granted permission for notifications');
  }
  print('Handling a background message ${message.messageId}');
  print(message.data);
}

int? isrideviewed;
Future<void> main() async {
  if (kDebugMode) {
    chuck = Chuck(
      showInspectorOnShake: true,
      navigatorKey: MyApp.navigatorKey,
      showNotification: true,
    );
  }
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final prefs = await SharedPreferences.getInstance();
  Constants.prefs = await SharedPreferences.getInstance();
  // Constants.prefs!.remove('isrideviewed');
  print("✅ notification_handled = ${prefs.getBool('notification_handled')}");
  isrideviewed = Constants.prefs?.getInt('isrideviewed') ?? 1;
  await Permission.notification.isDenied.then((value) {
    if (value) {
      print(value);
      Permission.notification.request();
    }
  });
  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    // You can display a notification popup here
    if (message.notification != null) {
      print("main first ${message.data.toString()}");
    }
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
    // Handle foreground messages here
    if (message.notification != null) {
      print("main open initstate ${message.data.toString()}");

      print(message.data);
      print(message.data['type']);
      if (message.data['order_accept_notification'] == '1') {
        print("new ride 3");
        MyApp.navigatorKey.currentState?.pushNamed(
          NewOrderScreen.routeName,
          arguments: {
            'orderId': message.data['operation_id'],
            'apptype': message.data['apptype']
          },
        );
      }
    }
  });

  const String sound = Platform.isAndroid
      ? 'resource://raw/finalbuzzer'
      : 'finalbuzzer.mp3';
  final notification = NotificationImplementation(
    awesomeChannelService: AwesomeChannelService(
      sound: sound,
    ),
  );

  await notification.initialize();
  await notification.fcmInitialize();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

// The navigator key is necessary to navigate using static methods
  static GlobalKey<NavigatorState> get navigatorKey => DeepMaterialApp.customKey;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    String sound = Platform.isAndroid
        ? 'resource://raw/finalbuzzer'
        : 'finalbuzzer.mp3';
    final notification = NotificationImplementation(
      awesomeChannelService: AwesomeChannelService(
        // notificationIcon: icon,
        sound: sound,
      ),
    );
    notification.initialize();
    notification.fcmInitialize();
    final notificationService =
        NotificationService(FlutterLocalNotificationsPlugin());
    notificationService.initialize(context);
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    isrideviewed = Constants.prefs?.getInt('isrideviewed');

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print("didchange first notidata${jsonEncode(message.toMap())}");
      if (message.notification != null) {
        if (message.data['order_accept_notification'] == '1') {
          print("new ride 1");
          MyApp.navigatorKey.currentState?.pushNamed(
            NewOrderScreen.routeName,
            arguments: {
              'orderId': message.data['operation_id'],
              'apptype': message.data['apptype']
            },
          );
        }
      }
    });
    print("notifications");
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      print("didchange opened notidata${jsonEncode(message.toMap())}");
      if (message.data['order_accept_notification'] == '1') {
        print("new ride 2");
        MyApp.navigatorKey.currentState?.pushNamed(
          NewOrderScreen.routeName,
          arguments: {
            'orderId': message.data['operation_id'],
            'apptype': message.data['apptype']
          },
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: CODRepository()),
        RepositoryProvider.value(value: CustomerTipsRepository()),
        RepositoryProvider.value(value: RefferalRepository()),
        RepositoryProvider.value(value: LanguagesRepository()),
        RepositoryProvider.value(value: BasicInformationRepository()),
        RepositoryProvider.value(value: SelectVehicleRepository()),
        RepositoryProvider.value(value: SelectCityRepository()),
        RepositoryProvider.value(value: SelectWorkAreaRepository()),
        RepositoryProvider.value(value: VerificationDocumentsRepository()),
        RepositoryProvider.value(value: AttendanceSheetReposotory()),
        RepositoryProvider.value(value: CheckInOutRepository()),
        RepositoryProvider.value(value: ProfileDetailsReposotory()),
        RepositoryProvider.value(value: DashBoardDetailsReposotory()),
        RepositoryProvider.value(value: RatingsViewRepository()),
        RepositoryProvider.value(value: NewOrderRepository()),
        RepositoryProvider.value(value: SupportHelpRepository()),
        RepositoryProvider.value(value: IncentivesReposotory()),
        RepositoryProvider.value(value: MyOrdersRepository()),
        RepositoryProvider.value(value: MyOrderHistorRepository()),
        RepositoryProvider.value(value: UploadImageRepository()),
        RepositoryProvider.value(value: MyEarningsRepository()),
        RepositoryProvider.value(value: PayoutHistorysRepository()),
        RepositoryProvider.value(value: RaisedIssuesRepository()),
        RepositoryProvider.value(value: NotificationsRepository()),
        RepositoryProvider.value(value: CmsRepository()),
        RepositoryProvider.value(value: LocationServiceRepository()),
        RepositoryProvider.value(value: RiderTypeRepository()),
        RepositoryProvider.value(value: DeliveryPreferencesRepository()),
        RepositoryProvider.value(value: FaqsRepository()),
        RepositoryProvider<MyOrdersRidesRepository>(
          create: (context) => MyOrdersRidesRepository(),
        ),
        RepositoryProvider(
          create: (context) => WalletRepository(),
        ),
        RepositoryProvider(
          create: (context) => FirebaseUserRepository(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => LocationControllerCubit(
              locationServiceRepository: LocationServiceRepository(),
            ),
          ),
          BlocProvider(
            create: (context) => CodCashBloc(
              codRepository: context.read<CODRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) =>
                RegisterDataCubit(context.read<BasicInformationRepository>()),
          ),
          BlocProvider(
            create: (context) => CustomerTipsBloc(
              customerTipsRepository: context.read<CustomerTipsRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => ReferralsDataBloc(
              refferalRepository: context.read<RefferalRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => LanguagesBloc(
              languagesRepository: context.read<LanguagesRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => BasicDetailsBloc(
              basicInformationRepository:
                  context.read<BasicInformationRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => VehicleInformationBloc(
              selectVehicleRepository: context.read<SelectVehicleRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => SelectCityBloc(
              selectCityRepository: context.read<SelectCityRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => SelectWorkAreaBloc(
              selectWorkAreaRepository:
                  context.read<SelectWorkAreaRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => VerificationDocumentsBloc(
              verificationDocumentsRepository:
                  context.read<VerificationDocumentsRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => AttendanceSheetBloc(
              attendanceSheetReposotory:
                  context.read<AttendanceSheetReposotory>(),
            ),
          ),
          BlocProvider(
            create: (context) => CheckInOutBloc(
              checkInOutRepository: context.read<CheckInOutRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => ProfileDetailsBloc(
              profileDetailsReposotory:
                  context.read<ProfileDetailsReposotory>(),
            ),
          ),
          BlocProvider(
            create: (context) => DashboardHomeBloc(
                dashBoardDetailsReposotory:
                    context.read<DashBoardDetailsReposotory>()),
          ),
          BlocProvider(
            create: (context) => RatingsViewBloc(
                ratingsViewRepository: context.read<RatingsViewRepository>()),
          ),
          BlocProvider(
            create: (context) => NewOrderBloc(
                newOrderRepository: context.read<NewOrderRepository>()),
          ),
          BlocProvider(
            create: (context) => SupportHelpBloc(
                supportHelpRepository: context.read<SupportHelpRepository>()),
          ),
          BlocProvider(
            create: (context) => IncentivesBusinessBloc(
                incentivesReposotory: context.read<IncentivesReposotory>()),
          ),
          BlocProvider(
            create: (context) => MyOrdersBloc(
                myOrdersRepository: context.read<MyOrdersRepository>()),
          ),
          BlocProvider(
            create: (context) => MyOrderHistoryBloc(
                myOrderHistorRepository:
                    context.read<MyOrderHistorRepository>()),
          ),
          BlocProvider(
            create: (context) => OrdersListBloc(
                dashBoardDetailsReposotory:
                    context.read<DashBoardDetailsReposotory>()),
          ),
          BlocProvider(
            create: (context) => UploadProfilePicBloc(
                uploadImageRepository: context.read<UploadImageRepository>()),
          ),
          BlocProvider(
            create: (context) => MyEarningsBloc(
                myEarningsRepository: context.read<MyEarningsRepository>()),
          ),
          BlocProvider(
            create: (context) => PayoutHistoryBloc(
                payoutHistorysRepository:
                    context.read<PayoutHistorysRepository>()),
          ),
          BlocProvider(
            create: (context) => RaisedIssuesBloc(
                raisedIssuesRepository: context.read<RaisedIssuesRepository>()),
          ),
          BlocProvider(
            create: (context) => NotificationsBloc(
                notificationsRepository:
                    context.read<NotificationsRepository>()),
          ),
          BlocProvider(
            create: (context) =>
                CmsBloc(cmsRepository: context.read<CmsRepository>()),
          ),
          BlocProvider(
            create: (context) => FriendReferBlocBloc(
                refferalRepository: context.read<RefferalRepository>()),
          ),
          BlocProvider(
            create: (context) => VesionControlCubit(),
          ),
          BlocProvider(
            create: (context) => DeleteAcountCubit(),
          ),
          //Internet cubit
          BlocProvider(
            create: (context) =>
                InternetCubit(enableInitialConnectionCheck: false),
          ),
          BlocProvider(
            create: (context) => DeliveryPreferencesCubit(
                context.read<DeliveryPreferencesRepository>()),
          ),
          BlocProvider(
            create: (context) => OngoingRidesDataCubit(
                context.read<DashBoardDetailsReposotory>()),
          ),
          BlocProvider(
            create: (context) =>
                MyOrderRidesCubit(context.read<MyOrdersRidesRepository>()),
          ),
          BlocProvider(
            create: (context) =>
                CodWalletDataCubit(context.read<WalletRepository>()),
          ),
        ],
        child: SafeArea(
          top: false,
          child: DeepMaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'PureOFresh Rider',
            navigatorKey: MyApp.navigatorKey,
            onGenerateRoute: onGenerateRoute,
            theme: ThemeData(
              useMaterial3: false,
              primarySwatch: ThemeColor.primarySwatchThemeColor(0xff000000),
              colorScheme: ColorScheme.fromSwatch(
                primarySwatch: ThemeColor.primarySwatchThemeColor(0xff000000),
              ).copyWith(),
            ),
          ),
        ),

        //  BlocBuilder<InternetCubit, InternetState>(
        //   builder: (context, internetState) {
        //     if (internetState is InternetConnected) {
        //       return MaterialApp(
        //         debugShowCheckedModeBanner: false,
        //         title: 'Pure O Fresh Delivery Boy',
        //         navigatorKey: MyApp.navigatorKey,
        //         onGenerateRoute: onGenerateRoute,
        //         theme: ThemeData(
        //           primarySwatch: Colors.blue,
        //           colorScheme: ColorScheme.fromSwatch(
        //             primarySwatch: Colors.green,
        //           ).copyWith(),
        //         ),
        //       );
        //     } else if (internetState is InternetDisconnected) {
        //       // MyApp.navigatorKey.currentState?.pushNamed(
        //       //   NoInternetScreen.routeName,
        //       // );
        //       Navigator.push(
        //           context,
        //           MaterialPageRoute(
        //             builder: (context) => NoInternetScreen(),
        //           ));
        //     }
        //     return CircularProgressIndicator();
        //   },
        // ),
      ),
    );
  }
}
