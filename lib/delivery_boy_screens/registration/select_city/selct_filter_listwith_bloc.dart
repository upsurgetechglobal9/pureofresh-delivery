// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// // 1. Define the Bloc
// class FilteredListBloc extends Bloc<FilterEvent, List<String>> {
//   FilteredListBloc() : super([]);

//   @override
//   Stream<List<String>> mapEventToState(FilterEvent event) async* {
//     if (event is FilterDataEvent) {
//       // 4. Implement the filtering logic here
//       final filteredList = event.filterCriteria.isEmpty
//           ? []
//           : state.where((item) => item.contains(event.filterCriteria)).toList();
//       yield filteredList;
//     }
//   }
// }

// // 2. Define the events
// abstract class FilterEvent {}

// class FilterDataEvent extends FilterEvent {
//   final String filterCriteria;

//   FilterDataEvent(this.filterCriteria);
// }

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: BlocProvider(
//         create: (context) => FilteredListBloc(),
//         child: MyHomePage(),
//       ),
//     );
//   }
// }

// class MyHomePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final filteredListBloc = BlocProvider.of<FilteredListBloc>(context);

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Filter List with Bloc'),
//       ),
//       body: BlocBuilder<FilteredListBloc, List<String>>(
//         builder: (context, filteredList) {
//           return Column(
//             children: [
//               TextField(
//                 onChanged: (value) {
//                   // 3. Dispatch the filtering event
//                   filteredListBloc.add(FilterDataEvent(value));
//                 },
//                 decoration: InputDecoration(
//                   labelText: 'Filter List',
//                 ),
//               ),
//               Expanded(
//                 child: ListView.builder(
//                   itemCount: filteredList.length,
//                   itemBuilder: (context, index) {
//                     return ListTile(
//                       title: Text(filteredList[index]),
//                     );
//                   },
//                 ),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }
// }
