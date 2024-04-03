import 'package:crust_and_co/components/widgets/loading_indicator.dart';
import 'package:crust_and_co/constants/app_language.dart';
import 'package:crust_and_co/screens/auth/sign_up_bloc/sign_up_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_repository/user_repository.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen(this.userRepository, {super.key});

  @override
  _SignupScreenState createState() => _SignupScreenState();

  final UserRepository userRepository;
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignUpBloc(widget.userRepository),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(AppLanguage.signUp),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocConsumer<SignUpBloc, SignUpState>(
            listener: (context, state) {
              if (state is SignUpSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text(AppLanguage.successPleaseLogin)));
                Navigator.of(context).pop();
              }
              if (state is SignUpError) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(state.message)));
              }
            },
            builder: (context, state) {
              if (state is SignUpProcessing) {
                final screenHeight = MediaQuery.of(context).size.height;
                return Center(
                  child: SizedBox(
                      height: screenHeight * 0.1,
                      width: screenHeight * 0.1,
                      child: const LoadingIndicator()),
                );
              }
              return _signupForm(context);
            },
          ),
        ),
      ),
    );
  }

  Form _signupForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _fullNameController,
            decoration: const InputDecoration(
              labelText: AppLanguage.fullName,
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter your full name';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(
              labelText: AppLanguage.email,
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter your email';
              }
              // Add email validation logic here
              return null;
            },
          ),
          TextFormField(
            controller: _passwordController,
            decoration: const InputDecoration(
              labelText: AppLanguage.password,
            ),
            obscureText: true,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter a password';
              }
              // Add password validation logic here
              return null;
            },
          ),
          TextFormField(
            controller: _confirmPasswordController,
            decoration: const InputDecoration(
              labelText: AppLanguage.confirmPassword,
            ),
            obscureText: true,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please confirm your password';
              }
              if (value != _passwordController.text) {
                return 'Passwords dont match';
              }
              // Add password confirmation logic here
              return null;
            },
          ),
          const SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                final MyUser myUser = MyUser(
                    id: "",
                    fullName: _fullNameController.text,
                    email: _emailController.text);
                context.read<SignUpBloc>().add(SignUpRequired(
                    myUser: myUser, password: _passwordController.text));
              }
            },
            child: const Text(AppLanguage.signUp),
          ),
        ],
      ),
    );
  }
}
