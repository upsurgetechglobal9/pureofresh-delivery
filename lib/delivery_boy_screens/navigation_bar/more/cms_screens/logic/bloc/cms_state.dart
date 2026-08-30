part of 'cms_bloc.dart';

abstract class CmsState extends Equatable {
  const CmsState();

  @override
  List<Object> get props => [];
}

class CmsInitial extends CmsState {
   
}


class CMSLoadingState extends CmsState {}

class CmsSuccessState extends CmsState {
  final CmsModel cmsModelData;

  const CmsSuccessState(this.cmsModelData);

  @override
  List<Object> get props => [cmsModelData];
}

class CmsFailedState extends CmsState {
  final String cmserror;

  const CmsFailedState(this.cmserror);

  @override
  List<Object> get props => [cmserror];
}
