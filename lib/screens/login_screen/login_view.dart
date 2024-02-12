import 'package:admin_menu_mobile/config/router.dart';
import 'package:admin_menu_mobile/features/login/cubit/login_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';

import '../../utils/utils.dart';
import '../../widgets/widgets.dart';

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
                  color: context.colorScheme.secondary),
              child: Form(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Center(child: _Wellcome()),
                        SizedBox(height: defaultPadding),
                        const _Email(),
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
    return Text(AppText.welcomeBack,
        style: context.titleStyleLarge!.copyWith(
            color: context.colorScheme.tertiaryContainer,
            fontWeight: FontWeight.bold));
  }
}

class _Email extends StatelessWidget {
  const _Email();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(builder: (context, state) {
      return CommonTextField(
          keyboardType: TextInputType.emailAddress,
          hintText: AppText.email,
          // errorText: state.email.displayError != null ? 'invalid email' : null,
          onChanged: (value) {
//  context.read<RegisterCubit>().emailChanged(value));
          });
    });
  }
}

class _Password extends StatelessWidget {
  _Password();

  @override
  Widget build(BuildContext context) {
    return CommonTextField(
      hintText: AppText.password,
      onChanged: (value) {},

      // obscureText: !showPass,
      // suffixIcon: GestureDetector(
      //     onTap: () =>
      //         ref.read(_showPassProvider.notifier).state = _toggle(showPass),
      //     child:
      //         Icon(!showPass ? Icons.visibility_off : Icons.remove_red_eye))
    );
  }
}

class _ButtonLogin extends StatelessWidget {
  const _ButtonLogin({this.formKey});

  final GlobalKey<FormState>? formKey;
  @override
  Widget build(BuildContext context) {
    return CommonButton(text: AppText.login, onTap: () {});
  }
}

class _ButtonSignUp extends StatelessWidget {
  const _ButtonSignUp();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => context.push(RouteName.register),
        child: CommonLineText(
            title: AppText.noAccount,
            value: AppText.signup,
            valueStyle: context.textStyleSmall!.copyWith(
                color: context.colorScheme.tertiaryContainer,
                fontWeight: FontWeight.bold)));
  }
}
