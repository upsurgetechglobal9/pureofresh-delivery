part of 'register_data_cubit.dart';

class RegisterDataState extends Equatable {
  final bool dataLoading;
  final bool isRegisterSucess;

  final String? error;

  const RegisterDataState({
    this.dataLoading = false,
    this.isRegisterSucess = false,
    this.error,
  });

  @override
  List<Object?> get props => [
        dataLoading,
        isRegisterSucess,
        error,
      ];

  RegisterDataState copyWith({
    bool? dataLoading,
    bool? isRegisterSucess,
    String? error,
  }) {
    return RegisterDataState(
      error: error ?? this.error,
      dataLoading: dataLoading ?? false,
      isRegisterSucess: isRegisterSucess ?? false,

    );
  }
}
