import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<({User? user, Failure? failure})> call(LoginParams params) async {
    try {
      final user = await repository.login(params.email, params.password);
      return (user: user, failure: null);
    } catch (e) {
      return (user: null, failure: ServerFailure(e.toString()));
    }
  }
}

class LoginParams extends Equatable {
  final String email;
  final String password;

  const LoginParams({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}
