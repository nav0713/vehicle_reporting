import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vehicle_reporting/bloc/security/security_bloc.dart';
import 'package:vehicle_reporting/services.dart/security_services.dart';

import '../../security/security.dart';
import '../../style.dart';
import '../home/gradient_background.dart';
import '../home/header.dart';

class SecurityLoginScreen extends StatefulWidget {
  final double deviceHeight;
  final double deviceWidth;
  final String title;

  final String type;
  const SecurityLoginScreen({
    super.key,
    required this.deviceHeight,
    required this.deviceWidth,
    required this.title,
    required this.type,
  });

  @override
  State<SecurityLoginScreen> createState() => _SecurityLoginScreenState();
}

final formKey = GlobalKey<FormBuilderState>();

class _SecurityLoginScreenState extends State<SecurityLoginScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SecurityBloc, SecurityState>(
      listener: (context, state) {
        if(state is SecurityLoginPageLoaded){
          if(!state.success!){
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        backgroundColor: Colors.red,
        content: Center(
        
        child: Text("Invalid username or password",style: TextStyle(color: Colors.white),))));
          }
        }
        if(state is SecurityLoggedInState){
           Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (BuildContext context) {
                        return  BlocProvider(
                          create: (context) => SecurityBloc()..add((GetReportedVehicles())),
                          child: const Security()
                        );
                      }));
        }
        // TODO: implement listener
      },
      builder: (context, state) {
        if (state is SecurityLoginPageLoaded) {
          return Scaffold(
            resizeToAvoidBottomInset: true,
            body: Stack(
              children: [
                Header(
                  deviceHeight: widget.deviceHeight,
                  deviceWidth: widget.deviceWidth,
                ),
                Align(
                    alignment: Alignment.bottomCenter,
                    child: BackGroundGradient(
                        deviceHeight: widget.deviceHeight,
                        deviceWidth: widget.deviceWidth)),
                SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 52),
                    width: widget.deviceWidth,
                    child: FormBuilder(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: widget.deviceHeight * .45,
                          ),
                          Text(
                            widget.title,
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall!
                                .copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          ////username
                          FormBuilderTextField(
                            name: 'username',
                            decoration:
                                normalTextFieldStyle("username", "username"),
                            validator: (value) {
                              if (value == null) {
                                return "This field is required";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          ////password
                          FormBuilderTextField(
                            obscureText: true,
                            name: 'password',
                            decoration:
                                normalTextFieldStyle("password", "password"),
                            validator: (value) {
                              if (value == null) {
                                return "This field is required";
                              }
                              return null;
                            },
                          ),

                          const SizedBox(
                            height: 32,
                          ),
                          SizedBox(
                            height: 50,
                            width: 200,
                            child: ElevatedButton.icon(
                                style: mainBtnStyle(Colors.deepOrange,
                                    Colors.transparent, Colors.white30),
                                onPressed: () async {
                                  if (formKey.currentState!.saveAndValidate()) {
                                    context.read<SecurityBloc>().add(
                                        LoginSecurity(
                                            username: formKey.currentState!
                                                .value['username'],
                                            password: formKey.currentState!
                                                .value['password'],
                                            type: "security"));
                                  }
                                },
                                icon: const Icon(Icons.shield_rounded),
                                label: const Text("  Login")),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                    top: 30,
                    left: 20,
                    child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.arrow_back))),
              ],
            ),
          );
        }
        if (state is SecurityLoadingScreen) {
          return const Scaffold(
            body: Center(
              child:  CircularProgressIndicator(
                color: Colors.black,
              ),
            ),
          );
        }
        return Container();
      },
    );
  }
}
