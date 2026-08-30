import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../commons/ConvertText.dart';
import '../logic/bloc/pending_registration_bloc.dart';

class PendingRegistrationscreen extends StatefulWidget {
  const PendingRegistrationscreen({super.key});

  @override
  State<PendingRegistrationscreen> createState() =>
      _PendingRegistrationscreenState();
}

class _PendingRegistrationscreenState extends State<PendingRegistrationscreen> {
  @override
  void initState() {
    // TODO: implement initState
    context.read<PendingRegistrationBloc>().add(PendingfetchingEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PendingRegistrationBloc, PendingRegistrationState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              ConvertText.getTitle('Registration Pending'),
            ),
          ),
          body: Center(
            child: Column(
              children: [
                Text(
                  ConvertText.getTitle(
                      'Please complete the flow of registration'),
                ),
                ListTile(
                  title: Text(ConvertText.getTitle(
                      "Click to Complete pending details")),
                  trailing: Icon(Icons.arrow_forward_ios_rounded),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
