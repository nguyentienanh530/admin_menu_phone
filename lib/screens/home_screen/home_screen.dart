import 'package:admin_menu_mobile/config/config.dart';
import 'package:admin_menu_mobile/features/auth/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:
            AppBar(title: const Text('home'), actions: [_buildIconLogout()]),
        body: const SizedBox());
  }

  Widget _buildIconLogout() {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return IconButton(
            onPressed: () {
              context.read<AuthBloc>().add(const AuthLogoutRequested());
              context.go(RouteName.login);
            },
            icon: const Icon(Icons.logout_outlined));
      },
    );
  }
}
