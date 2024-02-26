import 'package:admin_menu_mobile/common/bloc/generic_bloc_state.dart';
import 'package:admin_menu_mobile/features/user/bloc/user_bloc.dart';
import 'package:admin_menu_mobile/features/user/model/user_model.dart';
import 'package:admin_menu_mobile/utils/utils.dart';
import 'package:admin_menu_mobile/widgets/common_bottomsheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import '../../config/config.dart';
import '../../features/auth/bloc/auth_bloc.dart';
import '../../widgets/empty_screen.dart';
import '../../widgets/error_screen.dart';
import '../../widgets/loading_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileState();
}

class _ProfileState extends State<ProfileScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    getUser();
    super.initState();
  }

  getUser() {
    if (!mounted) return;
    var userID = context.read<AuthBloc>().state.user.id;
    context.read<UserBloc>().add(UserFecthed(userID: userID));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return const Scaffold(body: ProfileView());
  }

  // Widget _buildIconLogout() {
  //   return BlocBuilder<AuthBloc, AuthState>(
  //     builder: (context, state) {
  //       return IconButton(
  //           onPressed: () {
  //             context.read<AuthBloc>().add(const AuthLogoutRequested());
  //             context.go(RouteName.login);
  //           },
  //           icon: const Icon(Icons.logout_outlined));
  //     },
  //   );
  // }

  @override
  bool get wantKeepAlive => true;
}

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Padding(
            padding: EdgeInsets.all(defaultPadding),
            child: BlocBuilder<UserBloc, GenericBlocState<UserModel>>(
              builder: (context, state) {
                return (switch (state.status) {
                  Status.loading => const LoadingScreen(),
                  Status.failure => ErrorScreen(errorMsg: state.error),
                  Status.empty => const EmptyScreen(),
                  Status.success => _buildBody(state)
                });
              },
            )));
  }

  Widget _buildBody(GenericBlocState<UserModel> state) {
    logger.d(state.data?[0].toString());
    return Column(children: [
      const _CardProfife(),
      Expanded(
          child: SingleChildScrollView(
              child: Column(children: [
        _ItemProfile(
            svgPath: 'assets/icon/user_config.svg',
            title: 'Cập nhật thông tin',
            onTap: () {}),
        _ItemProfile(
            svgPath: 'assets/icon/print.svg',
            title: 'Cài đặt máy in',
            onTap: () {}),
        _ItemProfile(
            svgPath: 'assets/icon/logout.svg',
            title: 'Đăng xuất',
            onTap: () => _handleLogout())
      ])))
    ]);
  }

  _handleLogout() {
    showModalBottomSheet<void>(
        context: context,
        builder: (context) => CommonBottomSheet(
            title: 'Chắc chắn muốn đăng xuất?',
            textCancel: 'Hủy',
            textConfirm: 'Đăng xuất',
            textConfirmColor: context.colorScheme.errorContainer,
            onCancel: () => context.pop(),
            onConfirm: () {
              context.read<AuthBloc>().add(const AuthLogoutRequested());
              context.go(RouteName.login);
            }));
  }
}

class _ItemProfile extends StatelessWidget {
  const _ItemProfile(
      {required this.svgPath, required this.title, required this.onTap});
  final String svgPath;
  final String title;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        child: SizedBox(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(children: [
                Padding(
                    padding: EdgeInsets.all(defaultPadding),
                    child: SvgPicture.asset(svgPath,
                        color: context.colorScheme.primary)),
                Text(title, style: context.textStyleSmall),
              ]),
              Padding(
                padding: EdgeInsets.all(defaultPadding),
                child: const Icon(Icons.arrow_forward_ios_rounded, size: 15),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _CardProfife extends StatelessWidget {
  const _CardProfife();

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Padding(
      padding: EdgeInsets.symmetric(vertical: defaultPadding),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(
            height: context.sizeDevice.width * 0.2,
            width: context.sizeDevice.width * 0.2,
            decoration: BoxDecoration(
                border: Border.all(color: context.colorScheme.primary),
                shape: BoxShape.circle,
                image: const DecorationImage(
                    image: AssetImage('assets/icon/profile.png')))),
        SizedBox(height: defaultPadding),
        Text('Nguyen Tien Anh', style: context.textStyleMedium),
        SizedBox(height: defaultPadding / 4),
        _buildItem(context, Icons.email_rounded, 'nguyentienanh530@gmail.com'),
        SizedBox(height: defaultPadding / 4),
        _buildItem(context, Icons.phone_android_rounded, '0328023993')
      ]),
    ));
  }

  Widget _buildItem(BuildContext context, IconData icon, String title) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Icon(icon, size: 15),
      const SizedBox(width: 3),
      Text(title,
          style: context.textStyleSmall!
              .copyWith(color: Colors.white.withOpacity(0.5)))
    ]);
  }
}
