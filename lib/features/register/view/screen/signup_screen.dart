import 'package:admin_menu_mobile/features/register/cubit/register_cubit.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:admin_menu_mobile/config/config.dart';
import 'package:admin_menu_mobile/features/auth/bloc/auth_bloc.dart';
import 'package:admin_menu_mobile/features/user/bloc/user_bloc.dart';
import 'package:admin_menu_mobile/features/user/data/model/user_model.dart';
import 'package:admin_menu_mobile/common/dialog/app_alerts.dart';
import 'package:admin_menu_mobile/core/utils/utils.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';

import '../../../../common/widget/common_button.dart';
import '../../../../common/widget/common_line_text.dart';
import '../../../../common/widget/common_text_field.dart';

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

class SignUpView extends StatelessWidget {
  const SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    // final toast = FToast().init(context);

    return Stack(children: [
      SizedBox(
          height: context.sizeDevice.height,
          child: Image.asset('assets/image/chosseBackground.jpeg',
              fit: BoxFit.cover)),
      Center(
          child: Container(
              height: context.sizeDevice.height * 0.5,
              padding: EdgeInsets.symmetric(horizontal: defaultPadding),
              margin: EdgeInsets.symmetric(horizontal: defaultPadding),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(defaultBorderRadius),
                  color: context.colorScheme.background),
              child: BlocListener<RegisterCubit, RegisterState>(
                  listener: (context, state) {
                    switch (state.status) {
                      case FormzSubmissionStatus.inProgress:
                        AppAlerts.loadingDialog(context);
                        break;
                      case FormzSubmissionStatus.failure:
                        AppAlerts.failureDialog(context,
                            title: AppString.registerFailureTitle,
                            desc: state.errorMessage, btnCancelOnPress: () {
                          context.read<RegisterCubit>().resetStatus();
                          context.pop();
                        });
                        break;
                      case FormzSubmissionStatus.success:
                        _handleCreateUser(context, state.email.value);
                        AppAlerts.successDialog(context,
                            title: AppString.success,
                            desc: AppString.registerSuccessTitle,
                            btnOkOnPress: () {
                          context
                              .read<AuthBloc>()
                              .add(const AuthLogoutRequested());
                          context.go(RouteName.login);
                        });
                        break;
                      default:
                    }
                  },
                  child: _buildBody())))
    ]);
  }

  void _handleCreateUser(BuildContext context, String email) {
    var userID = context.read<AuthBloc>().state.user.id;
    var user = UserModel().copyWith(
        id: userID,
        name: email,
        email: email,
        role: 'admin',
        createAt: DateTime.now().toString());
    context.read<UserBloc>().add(UserCreated(user: user));
  }

  Widget _buildBody() {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Center(child: _Wellcome()),
          SizedBox(height: defaultPadding),
          _Email(),
          SizedBox(height: defaultPadding / 2),
          _Password(),
          SizedBox(height: defaultPadding),
          const _ButtonSignUp(),
          SizedBox(height: defaultPadding / 2),
          const Center(child: _ButtonSignIn())
        ]
            .animate(interval: 50.ms)
            .slideX(
                begin: -0.1,
                end: 0,
                curve: Curves.easeInOutCubic,
                duration: 400.ms)
            .fadeIn(curve: Curves.easeInOutCubic, duration: 400.ms));
  }
}

class _Wellcome extends StatelessWidget {
  const _Wellcome();

  @override
  Widget build(BuildContext context) {
    return Text(AppString.welcome,
        style: context.titleStyleLarge!.copyWith(
            color: context.colorScheme.secondaryContainer,
            fontWeight: FontWeight.bold));
  }
}

class _Email extends StatelessWidget {
  _Email();
  final TextEditingController _emailcontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterCubit, RegisterState>(
        buildWhen: (previous, current) => previous.email != current.email,
        builder: (context, state) {
          return CommonTextField(
              controller: _emailcontroller,
              keyboardType: TextInputType.emailAddress,
              hintText: AppString.email,
              prefixIcon: const Icon(Icons.email_rounded),
              errorText:
                  state.email.displayError != null ? 'invalid email' : null,
              onChanged: (value) =>
                  context.read<RegisterCubit>().emailChanged(value));
        });
  }
}

class _Password extends StatelessWidget {
  _Password();
  final TextEditingController _passwordcontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterCubit, RegisterState>(
        buildWhen: (previous, current) =>
            previous.password != current.password ||
            previous.isShowPassword != current.isShowPassword,
        builder: (context, state) {
          return CommonTextField(
              maxLines: 1,
              controller: _passwordcontroller,
              hintText: AppString.password,
              errorText: state.password.displayError != null
                  ? 'invalid password'
                  : null,
              onChanged: (value) =>
                  context.read<RegisterCubit>().passwordChanged(value),
              obscureText: !state.isShowPassword,
              prefixIcon: const Icon(Icons.password_rounded),
              suffixIcon: GestureDetector(
                  onTap: () =>
                      context.read<RegisterCubit>().ishowPasswordChanged(),
                  child: Icon(!state.isShowPassword
                      ? Icons.visibility_off
                      : Icons.remove_red_eye)));
        });
  }
}

class _ButtonSignUp extends StatelessWidget {
  const _ButtonSignUp();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterCubit, RegisterState>(builder: (context, state) {
      return CommonButton(
          text: AppString.signup,
          onTap: state.isValid
              ? () => context.read<RegisterCubit>().signUpFormSubmitted()
              : null);
    });
  }
}

class _ButtonSignIn extends StatelessWidget {
  const _ButtonSignIn();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          context.replace(RouteName.login);
        },
        child: CommonLineText(
            title: AppString.haveAnAccount,
            value: AppString.signin,
            valueStyle: context.textStyleSmall!.copyWith(
                color: context.colorScheme.secondaryContainer,
                fontWeight: FontWeight.bold)));
  }
}
