// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'incentives_business_bloc.dart';

class IncentivesBusinessState extends Equatable {
  final bool incentivesLoading;
  final bool incentivesError;
  final IncentivesDataModel incentivesDataList;

  IncentivesBusinessState(
      {this.incentivesLoading = false,
      this.incentivesError = false,
      required this.incentivesDataList});

  @override
  List<Object> get props =>
      [incentivesLoading, incentivesError, incentivesDataList];

  IncentivesBusinessState copyWith({
    bool? incentivesLoading,
    bool? incentivesError,
    IncentivesDataModel? incentivesDataList,
  }) {
    return IncentivesBusinessState(
      incentivesLoading: incentivesLoading ?? false,
      incentivesError: incentivesError ?? false,
      incentivesDataList: incentivesDataList ?? this.incentivesDataList,
    );
  }
}

// class IncentivesBusinessInitial extends IncentivesBusinessState {}


// class IncentivesLoadedState extends IncentivesBusinessState {
//   final IncentivesDataModel incentivesModeldata;

//   const IncentivesLoadedState(this.incentivesModeldata);

//   @override
//   List<Object> get props => [incentivesModeldata];
// }
