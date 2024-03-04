import 'package:admin_menu_mobile/features/login/cubit/login_cubit.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:admin_menu_mobile/config/router.dart';
import 'package:admin_menu_mobile/common/dialog/app_alerts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';

import '../../../../common/widget/common_button.dart';
import '../../../../common/widget/common_line_text.dart';
import '../../../../common/widget/common_text_field.dart';
import '../../../../core/utils/utils.dart';

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

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      SizedBox(
          height: context.sizeDevice.height,
          child:
              Image.asset('assets/image/onBoarding2.jpeg', fit: BoxFit.cover)),
      Center(
          child: Container(
              height: context.sizeDevice.height * 0.5,
              margin: EdgeInsets.symmetric(horizontal: defaultPadding),
              padding: EdgeInsets.symmetric(horizontal: defaultPadding),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(defaultBorderRadius),
                  color: context.colorScheme.background),
              child: BlocListener<LoginCubit, LoginState>(
                  listener: (context, state) {
                    switch (state.status) {
                      case FormzSubmissionStatus.inProgress:
                        AppAlerts.loadingDialog(context);
                        break;
                      case FormzSubmissionStatus.failure:
                        AppAlerts.failureDialog(context,
                            title: AppString.errorTitle,
                            desc: state.errorMessage, btnCancelOnPress: () {
                          context.read<LoginCubit>().resetStatus();
                          context.pop();
                        });
                        break;
                      case FormzSubmissionStatus.success:
                        context.go(RouteName.home);
                        break;
                      default:
                    }
                  },
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Center(child: _Wellcome()),
                        SizedBox(height: defaultPadding),
                        _Email(),
                        SizedBox(height: defaultPadding / 2),
                        _Password(),
                        SizedBox(height: defaultPadding),
                        const _ButtonLogin(),
                        SizedBox(height: defaultPadding / 2),
                        const Center(child: _ButtonSignUp())
                      ]
                          .animate(interval: 50.ms)
                          .slideX(
                              begin: -0.1,
                              end: 0,
                              curve: Curves.easeInOutCubic,
                              duration: 400.ms)
                          .fadeIn(
                              curve: Curves.easeInOutCubic,
                              duration: 400.ms)))))
    ]);
  }
}

class _Wellcome extends StatelessWidget {
  const _Wellcome();

  @override
  Widget build(BuildContext context) {
    return Text(AppString.welcomeBack,
        style: context.titleStyleLarge!.copyWith(
            color: context.colorScheme.tertiaryContainer,
            fontWeight: FontWeight.bold));
  }
}

class _Email extends StatelessWidget {
  _Email();
  final TextEditingController _emailcontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(builder: (context, state) {
      return CommonTextField(
          controller: _emailcontroller,
          keyboardType: TextInputType.emailAddress,
          hintText: AppString.email,
          prefixIcon: const Icon(Icons.email_rounded),
          errorText: state.email.displayError != null ? 'invalid email' : null,
          onChanged: (value) => context.read<LoginCubit>().emailChanged(value));
    });
  }
}

class _Password extends StatelessWidget {
  _Password();
  final TextEditingController _passwordcontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(builder: (context, state) {
      return CommonTextField(
          maxLines: 1,
          controller: _passwordcontroller,
          hintText: AppString.password,
          onChanged: (value) =>
              context.read<LoginCubit>().passwordChanged(value),
          obscureText: !state.isShowPassword!,
          errorText:
              state.password.displayError != null ? 'invalid password' : null,
          prefixIcon: const Icon(Icons.password_rounded),
          suffixIcon: GestureDetector(
              onTap: () => context.read<LoginCubit>().isShowPasswordChanged(),
              child: Icon(!state.isShowPassword!
                  ? Icons.visibility_off
                  : Icons.remove_red_eye)));
    });
  }
}

class _ButtonLogin extends StatelessWidget {
  const _ButtonLogin();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(builder: (context, state) {
      return CommonButton(
          text: AppString.login,
          onTap: state.isValid
              ? () => context.read<LoginCubit>().logInWithCredentials()
              : null);
    });
  }
}

class _ButtonSignUp extends StatelessWidget {
  const _ButtonSignUp();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => context.go(RouteName.register),
        child: CommonLineText(
            title: AppString.noAccount,
            value: AppString.signup,
            valueStyle: context.textStyleSmall!.copyWith(
                color: context.colorScheme.tertiaryContainer,
                fontWeight: FontWeight.bold)));
  }
}
