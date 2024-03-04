import 'package:admin_menu_mobile/common/bloc/bloc_helper.dart';
import 'package:admin_menu_mobile/common/bloc/generic_bloc_state.dart';
import 'package:admin_menu_mobile/features/user/bloc/user_bloc.dart';
import 'package:admin_menu_mobile/features/user/data/model/user_model.dart';
import 'package:admin_menu_mobile/core/utils/utils.dart';
import 'package:admin_menu_mobile/common/widget/common_bottomsheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/config.dart';
import '../../../auth/bloc/auth_bloc.dart';
import '../../../../common/widget/empty_screen.dart';
import '../../../../common/widget/error_screen.dart';
import '../../../../common/widget/loading_screen.dart';

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
                buildWhen: (previous, current) =>
                    context.read<UserBloc>().operation == ApiOperation.select,
                builder: (context, state) {
                  return (switch (state.status) {
                    Status.loading => const LoadingScreen(),
                    Status.failure => ErrorScreen(errorMsg: state.error),
                    Status.empty => const EmptyScreen(),
                    Status.success => _buildBody(state.data ?? UserModel())
                  });
                })));
  }

  Widget _buildBody(UserModel user) {
    return Column(
        children: [
      _CardProfife(user: user),
      Expanded(
          child: SingleChildScrollView(
              child: Column(children: [
        _ItemProfile(
            svgPath: 'assets/icon/user_config.svg',
            title: 'Cập nhật thông tin',
            onTap: () => _handleUserUpdated(user)),
        _ItemProfile(
            svgPath: 'assets/icon/lock.svg',
            title: 'Đổi mật khẩu',
            onTap: () => context.push(RouteName.changePassword)),
        _ItemProfile(
            svgPath: 'assets/icon/print.svg',
            title: 'Cài đặt máy in',
            onTap: () => context.push(RouteName.printSeting)),
        _ItemProfile(
            svgPath: 'assets/icon/logout.svg',
            title: 'Đăng xuất',
            onTap: () => _handleLogout())
      ])))
    ]
            .animate(interval: 50.ms)
            .slideX(
                begin: -0.1,
                end: 0,
                curve: Curves.easeInOutCubic,
                duration: 500.ms)
            .fadeIn(curve: Curves.easeInOutCubic, duration: 500.ms));
  }

  _handleUserUpdated(UserModel user) async {
    var result = await context.push<bool>(RouteName.updateUser, extra: user);
    if (result is bool && result) {
      if (!mounted) return;
      var userID = context.read<AuthBloc>().state.user.id;
      context.read<UserBloc>().add(UserFecthed(userID: userID));
    }
    // late UserModel newUser;
    // late File imageFile;
    // bool isUpdate = await updateUserDialog(
    //     user: user,
    //     type: Type.update,
    //     context: context,
    //     userData: (userModel, image) {
    //       newUser = userModel;
    //       imageFile = image;
    //     });
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
                        colorFilter: ColorFilter.mode(
                            context.colorScheme.primary, BlendMode.srcIn))),
                Text(title, style: context.textStyleSmall)
              ]),
              Padding(
                  padding: EdgeInsets.all(defaultPadding),
                  child: const Icon(Icons.arrow_forward_ios_rounded, size: 15))
            ]))));
  }
}

class _CardProfife extends StatelessWidget {
  const _CardProfife({required this.user});
  final UserModel user;
  @override
  Widget build(BuildContext context) {
    return Card(
        child: Padding(
            padding: EdgeInsets.symmetric(vertical: defaultPadding),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              user.image.isEmpty
                  ? _buildImageAsset(context)
                  : _buildImageNetwork(context),
              SizedBox(height: defaultPadding),
              Text(user.name, style: context.textStyleMedium),
              SizedBox(height: defaultPadding / 4),
              _buildItem(context, Icons.email_rounded, user.email),
              SizedBox(height: defaultPadding / 4),
              user.phoneNumber.isEmpty
                  ? const SizedBox()
                  : _buildItem(context, Icons.phone_android_rounded,
                      user.phoneNumber.toString())
            ])));
  }

  Widget _buildImageAsset(BuildContext context) {
    return Container(
        height: context.sizeDevice.width * 0.2,
        width: context.sizeDevice.width * 0.2,
        decoration: BoxDecoration(
            border: Border.all(color: context.colorScheme.primary),
            shape: BoxShape.circle,
            image: const DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage('assets/icon/profile.png'))));
  }

  Widget _buildImageNetwork(BuildContext context) {
    return Container(
        height: context.sizeDevice.width * 0.2,
        width: context.sizeDevice.width * 0.2,
        decoration: BoxDecoration(
            border: Border.all(color: context.colorScheme.primary),
            shape: BoxShape.circle,
            image: DecorationImage(
                fit: BoxFit.cover, image: NetworkImage(user.image))));
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
