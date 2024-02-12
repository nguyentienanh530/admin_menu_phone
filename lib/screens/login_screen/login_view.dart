import 'package:admin_menu_mobile/config/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../utils/utils.dart';
import '../../widgets/widgets.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [const _ButtonSignUp()]
            .animate(interval: 50.ms)
            .slideX(
                begin: -0.1,
                end: 0,
                curve: Curves.easeInOutCubic,
                duration: 400.ms)
            .fadeIn(curve: Curves.easeInOutCubic, duration: 400.ms));
  }
}

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   State<StatefulWidget> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

//   @override
//   void dispose() {
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final toast = FToast().init(context);

//     return Scaffold(
//         resizeToAvoidBottomInset: false,
//         body: Stack(children: [
//           SizedBox(
//               height: context.sizeDevice.height,
//               child: Image.asset('assets/image/onBoarding2.jpeg',
//                   fit: BoxFit.cover)),
//           Center(
//               child: Container(
//                   height: context.sizeDevice.height * 0.5,
//                   margin: EdgeInsets.symmetric(horizontal: defaultPadding),
//                   padding: EdgeInsets.symmetric(horizontal: defaultPadding),
//                   decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(defaultBorderRadius),
//                       color: context.colorScheme.secondaryContainer),
//                   child: Form(
//                       key: _formKey,
//                       child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             const Center(child: _Wellcome()),
//                             SizedBox(height: defaultPadding),
//                             const _Email(),
//                             SizedBox(height: defaultPadding / 2),
//                             _Password(),
//                             SizedBox(height: defaultPadding),
//                             _ButtonLogin(formKey: _formKey),
//                             SizedBox(height: defaultPadding / 2),
//                             const Center(child: _ButtonSignUp())
//                           ]))))
//         ]));
//   }
// }

// class _Wellcome extends StatelessWidget {
//   const _Wellcome();

//   @override
//   Widget build(BuildContext context) {
//     return Text(AppText.welcomeBack,
//         style: context.titleStyleLarge!.copyWith(
//             color: context.colorScheme.secondary, fontWeight: FontWeight.bold));
//   }
// }

// class _Email extends StatelessWidget {
//   const _Email();

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<Login, RegisterState>(builder: (context, state) {
//       return CommonTextField(
//           keyboardType: TextInputType.emailAddress,
//           hintText: AppText.email,
//           errorText: state.email.displayError != null ? 'invalid email' : null,
//           onChanged: (value) =>
//               context.read<RegisterCubit>().emailChanged(value));
//     });
//   }
// }

// class _Password extends ConsumerWidget {
//   _Password();

//   final _showPassProvider = StateProvider<bool>((ref) => false);
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final loginState = ref.watch(loginProvider);
//     final showPass = ref.watch(_showPassProvider);
//     final logInProvider = ref.read(loginProvider.notifier);
//     return CommonTextField(
//         hintText: AppText.password,
//         onChanged: (value) => logInProvider.onPasswordChange(value),
//         validator: (p0) =>
//             Password.showPasswordErrorMessage(loginState.password!.error),
//         obscureText: !showPass,
//         suffixIcon: GestureDetector(
//             onTap: () =>
//                 ref.read(_showPassProvider.notifier).state = _toggle(showPass),
//             child:
//                 Icon(!showPass ? Icons.visibility_off : Icons.remove_red_eye)));
//   }

//   bool _toggle(bool value) => !value;
// }

// class _ButtonLogin extends ConsumerWidget {
//   const _ButtonLogin({this.formKey});

//   final GlobalKey<FormState>? formKey;
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return CommonButton(
//         text: AppText.login,
//         onTap: () {
//           _handleLogin(formKey: formKey, ref: ref);
//         });
//   }

//   void _handleLogin({WidgetRef? ref, GlobalKey<FormState>? formKey}) {
//     if (formKey!.currentState!.validate()) {
//       ref!.read(loginProvider.notifier).loginWithEmail(ref);
//     }
//   }
// }

class _ButtonSignUp extends StatelessWidget {
  const _ButtonSignUp();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => context.push(RouteName.register),
        child: CommonLineText(
            title: AppText.noAccount,
            value: AppText.signup,
            valueStyle: context.titleStyleSmall!.copyWith(
                color: context.colorScheme.secondary,
                fontWeight: FontWeight.bold)));
  }
}
