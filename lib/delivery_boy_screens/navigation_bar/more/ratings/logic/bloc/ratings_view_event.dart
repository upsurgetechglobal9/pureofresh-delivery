part of 'ratings_view_bloc.dart';

abstract class RatingsViewEvent extends Equatable {
  const RatingsViewEvent();

  @override
  List<Object> get props => [];
}

class RatingsViewFetchingEvent extends RatingsViewEvent {
  final String accessToken;

  const RatingsViewFetchingEvent({
    required this.accessToken,
  });
  @override
  List<Object> get props => [accessToken];
}
