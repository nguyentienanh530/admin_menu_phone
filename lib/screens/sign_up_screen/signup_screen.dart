import 'package:admin_menu_mobile/features/register/cubit/register_cubit.dart';
import 'package:admin_menu_mobile/screens/sign_up_screen/sign_up_view.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: BlocProvider<RegisterCubit>(
            create: (_) =>
                RegisterCubit(context.read<AuthenticationRepository>()),
            child: const SignUpView()));
  }
}
