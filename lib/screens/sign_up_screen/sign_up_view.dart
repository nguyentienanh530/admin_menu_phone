import 'package:admin_menu_mobile/config/config.dart';
import 'package:admin_menu_mobile/features/auth/bloc/auth_bloc.dart';
import 'package:admin_menu_mobile/features/register/cubit/register_cubit.dart';
import 'package:admin_menu_mobile/utils/app_alerts.dart';
import 'package:admin_menu_mobile/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
// import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';

import '../../widgets/widgets.dart';

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
                            title: AppText.registerFailureTitle,
                            desc: state.errorMessage, btnCancelOnPress: () {
                          context.read<RegisterCubit>().resetStatus();
                          context.pop();
                        });
                        break;
                      case FormzSubmissionStatus.success:
                        AppAlerts.successDialog(context,
                            title: AppText.success,
                            desc: AppText.registerSuccessTitle,
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

  Widget _buildBody() {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Center(child: _Wellcome()),
          SizedBox(height: defaultPadding),
          const _Email(),
          SizedBox(height: defaultPadding / 2),
          const _Password(),
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
    return Text(AppText.welcome,
        style: context.titleStyleLarge!.copyWith(
            color: context.colorScheme.secondaryContainer,
            fontWeight: FontWeight.bold));
  }
}

class _Email extends StatelessWidget {
  const _Email();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterCubit, RegisterState>(
        buildWhen: (previous, current) => previous.email != current.email,
        builder: (context, state) {
          return CommonTextField(
              keyboardType: TextInputType.emailAddress,
              hintText: AppText.email,
              errorText:
                  state.email.displayError != null ? 'invalid email' : null,
              onChanged: (value) =>
                  context.read<RegisterCubit>().emailChanged(value));
        });
  }
}

class _Password extends StatelessWidget {
  const _Password();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterCubit, RegisterState>(
        buildWhen: (previous, current) =>
            previous.password != current.password ||
            previous.isShowPassword != current.isShowPassword,
        builder: (context, state) {
          return CommonTextField(
              hintText: AppText.password,
              errorText: state.password.displayError != null
                  ? 'invalid password'
                  : null,
              onChanged: (value) =>
                  context.read<RegisterCubit>().passwordChanged(value),
              obscureText: !state.isShowPassword,
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
          text: AppText.signup,
          onTap: state.isValid
              ? () => context.read<RegisterCubit>().signUpFormSubmitted()
              : null);
    });
  }

  // void _handleSignUp({GlobalKey<FormState>? key, WidgetRef? ref}) {
  //   if (!key!.currentState!.validate()) return;
  //   ref!.read(signUpProvider.notifier).signUpWithEmailAndPassword(ref);
  //   // FocusScope.of(context!)
  //   //   ..nextFocus()
  //   //   ..unfocus();
  // }
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
            title: AppText.haveAnAccount,
            value: AppText.signin,
            valueStyle: context.textStyleSmall!.copyWith(
                color: context.colorScheme.secondaryContainer,
                fontWeight: FontWeight.bold)));
  }
}
