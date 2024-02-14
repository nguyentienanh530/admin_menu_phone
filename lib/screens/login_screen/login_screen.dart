import 'package:admin_menu_mobile/features/login/cubit/login_cubit.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'login_view.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: BlocProvider<LoginCubit>(
            create: (context) =>
                LoginCubit(context.read<AuthenticationRepository>()),
            child: const LoginView()));
  }
}
