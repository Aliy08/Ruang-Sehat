import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ruang_sehat/theme/app_colors.dart';
import 'package:ruang_sehat/features/auth/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:ruang_sehat/features/home/screens/home_screen.dart';
import 'package:ruang_sehat/utils/snackbar_helper.dart';

class AuthForm extends StatefulWidget {
  final bool isLogin;
  final VoidCallback onSwitchToLogin;

  const AuthForm({
    super.key,
    required this.isLogin,
    required this.onSwitchToLogin,
  });

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _isObsecure = true;
  // bool _rememberMe = false;

  Future<void> handleSubmit() async {
    if (usernameController.text.isEmpty ||
        passwordController.text.isEmpty ||
        (!widget.isLogin && nameController.text.isEmpty)) {
      SnackbarHelper.show(
        context,
        message: "Semua field wajib diisi",
        isError: true,
      );
      return;
    }

    final auth = context.read<AuthProvider>();
    bool success;

    if (widget.isLogin) {
      success = await auth.login(
        usernameController.text.trim(),
        passwordController.text.trim(),
      );
    } else {
      success = await auth.register(
        nameController.text.trim(),
        usernameController.text.trim(),
        passwordController.text.trim(),
      );
    }

    if (!context.mounted) return;

    if (success) {
      // tampilkan succes message dari provider
      if (auth.successMesage != null) {
        SnackbarHelper.show(context, message: auth.successMesage!);
        // SnackBar(
        //   duration: const Duration(seconds: 2),
        //   content: Text(auth.successMesage!),
        // );
      }

      if (widget.isLogin) {
        Navigator.pushReplacementNamed(
          context,
          HomeScreen.routeName,
        );
      } else {
        widget.onSwitchToLogin();
      }
    } else {
      //  Tampilkan error dari provider
      if (auth.errorMessage != null) {
        SnackbarHelper.show(context,
            message: auth.errorMessage!, isError: true);
        // SnackBar(
        //   duration: const Duration(seconds: 2),
        //   content: Text(auth.errorMessage!),
        // );
      }
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: AppColors.hintText),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.border, width: 2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 14),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// NAME (Register only)
        if (!widget.isLogin) ...[
          const SizedBox(height: 18),
          const Text(
            'Name',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: nameController,
            decoration: _inputDecoration('Enter Your Name'),
          ),
        ],
        // Field Username
        SizedBox(height: 18),
        Text(
          'Username',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: usernameController,
          decoration: InputDecoration(
            hintText: 'Enter Your Username',
            hintStyle: TextStyle(color: AppColors.hintText),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.border, width: 2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 15.0,
              horizontal: 14.0,
            ),
          ),
        ),

        // Field Password
        SizedBox(height: 18),
        Text(
          'Password',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: passwordController,
          obscureText: _isObsecure,
          decoration: InputDecoration(
            hintText: 'Enter Your Password',
            hintStyle: TextStyle(color: AppColors.hintText),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.border, width: 2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 15.0,
              horizontal: 14.0,
            ),
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  _isObsecure = !_isObsecure;
                });
              },
              icon: Icon(
                _isObsecure ? Icons.visibility_off : Icons.visibility,
                color: AppColors.hintText,
              ),
            ),
          ),
        ),

        // Button Login/Register
        SizedBox(height: 18),
        ElevatedButton(
          onPressed: handleSubmit,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            minimumSize: const Size.fromHeight(53),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            widget.isLogin ? 'Login' : 'Register',
            style: TextStyle(
              color: AppColors.secondary,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        // Remember Me & Fotgot Password
        if (widget.isLogin) ...[
          SizedBox(height: 18),
          Row(
            children: [
              Checkbox(
                value: true,
                onChanged: (value) {},
                activeColor: AppColors.primary,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,
                side: BorderSide(color: AppColors.hintText, width: 2),
              ),
              const Text(
                'Remember Me',
                style: TextStyle(
                  color: AppColors.hintText,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const Spacer(),
              const Text(
                'Forgot Password?',
                style: TextStyle(
                  color: AppColors.hintText,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  decoration: TextDecoration.underline,
                ),
              ),
            ],
          ),
        ],

        // Divider with Text
        SizedBox(height: 18),
        Row(
          children: [
            Expanded(child: Divider(thickness: 1, color: AppColors.border)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                'Or Login with',
                style: TextStyle(
                  color: AppColors.hintText,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Expanded(child: Divider(thickness: 1, color: AppColors.border)),
          ],
        ),

        // Login with Google
        SizedBox(height: 18),
        Center(
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: AppColors.secondary.withOpacity(0.3),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border, width: 2),
            ),
            child: Center(
              child: SvgPicture.asset(
                'assets/icons/google1.svg',
              ),
            ),
          ),
        ),
      ],
    );
  }
}
