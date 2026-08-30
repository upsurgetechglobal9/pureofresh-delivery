part of 'cms_bloc.dart';

abstract class CmsEvent extends Equatable {
  const CmsEvent();

  @override
  List<Object> get props => [];
}

class CmsFetchingEvent extends CmsEvent {
  final String api;

  const CmsFetchingEvent({
    required this.api,
  });
  @override
  List<Object> get props => [api];
}
