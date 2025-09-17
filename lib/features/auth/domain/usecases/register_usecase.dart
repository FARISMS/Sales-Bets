import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  Future<({User? user, Failure? failure})> call(RegisterParams params) async {
    try {
      final user = await repository.register(
        params.email,
        params.password,
        params.name,
      );
      return (user: user, failure: null);
    } catch (e) {
      return (user: null, failure: ServerFailure(e.toString()));
    }
  }
}

class RegisterParams extends Equatable {
  final String email;
  final String password;
  final String name;

  const RegisterParams({
    required this.email,
    required this.password,
    required this.name,
  });

  @override
  List<Object> get props => [email, password, name];
}
