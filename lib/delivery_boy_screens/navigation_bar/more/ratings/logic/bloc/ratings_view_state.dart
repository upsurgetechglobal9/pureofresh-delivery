part of 'ratings_view_bloc.dart';

abstract class RatingsViewState extends Equatable {
  const RatingsViewState();

  @override
  List<Object> get props => [];
}

class RatingsViewInitial extends RatingsViewState {}

class RatingDetailsLoaded extends RatingsViewState {
  final RatingsViewModel ratingsViewModelData;

  const RatingDetailsLoaded(this.ratingsViewModelData);

  @override
  List<Object> get props => [ratingsViewModelData];
}
