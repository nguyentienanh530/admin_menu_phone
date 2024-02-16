import 'package:admin_menu_mobile/screens/profile_screen/profile_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../config/config.dart';
import '../../features/auth/bloc/auth_bloc.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileState();
}

class _ProfileState extends State<ProfileScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        appBar: AppBar(actions: [_buildIconLogout()]),
        body: const ProfileView());
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

  @override
  bool get wantKeepAlive => true;
}
