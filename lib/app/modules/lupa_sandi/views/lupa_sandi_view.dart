import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:petshop/app/routes/app_pages.dart';
import 'package:petshop/app/theme/theme.dart';
import '../controllers/lupa_sandi_controller.dart';

class LupaSandiView extends GetView<LupaSandiController> {
  LupaSandiView({Key? key}) : super(key: key);

  final LupaSandiController controller = Get.put(LupaSandiController());

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final shouldPop = await Get.offAllNamed(Routes.LOGIN);
        return shouldPop;
      },
      child: AnnotatedRegion(
        value: SystemUiOverlayStyle(
          statusBarBrightness: Brightness.dark,
          statusBarIconBrightness: Brightness.light,
          statusBarColor: backgroundOrange,
        ),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: backgroundOrange,
          body: LayoutBuilder(
            builder: (context, constraints) {
              final textScale = MediaQuery.of(context).textScaleFactor;
              final bodyHeight = MediaQuery.of(context).size.height;
              -MediaQuery.of(context).padding.top;
              final bodyWidth = MediaQuery.of(context).size.width;
              return SingleChildScrollView(
                reverse: true,
                padding: EdgeInsets.only(
                  left: bodyWidth * 0.05,
                  right: bodyWidth * 0.05,
                  bottom: bodyHeight * 0.02,
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: bodyHeight * 0.06,
                    ),
                    Row(
                      children: [
                        IconButton(
                            onPressed: () => Get.offAllNamed(Routes.LOGIN),
                            icon: Icon(
                              Icons.arrow_back,
                              color: light,
                            ))
                      ],
                    ),
                    SizedBox(height: bodyHeight * 0.18),
                    Column(
                      children: [
                        Image.asset(
                          'assets/icons/logo.png',
                          width: bodyWidth * 0.5,
                          height: bodyHeight * 0.2,
                        ),
                        SizedBox(
                          height: bodyHeight * 0.03,
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: bodyWidth * 0.9,
                                height: bodyHeight * 0.02,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Grey1,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Kami akan kirimkan link reset password ke email anda",
                                      textAlign: TextAlign.center,
                                      textScaleFactor: 1,
                                      style: regular12pt.copyWith(color: Red1),
                                    ),
                                  ],
                                ),
                              ),
                            ]),
                        SizedBox(
                          height: bodyHeight * 0.03,
                        ),
                        Form(
                          key: controller.emailKey.value,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: bodyWidth * 1,
                                height: bodyHeight * 0.085,
                                child: TextFormField(
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  onTap: () {
                                    FocusScopeNode currentFocus =
                                        FocusScope.of(context);

                                    if (!currentFocus.hasPrimaryFocus) {
                                      currentFocus.unfocus();
                                    }
                                  },
                                  controller: controller.emailC,
                                  validator: controller.emailValidator,
                                  style: TextStyle(color: dark),
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                      prefixIcon: Align(
                                          widthFactor: 1.0,
                                          heightFactor: 1.0,
                                          child: Icon(
                                            IconlyLight.message,
                                            color: Red1,
                                          )),
                                      hintText: 'Email',
                                      hintStyle: heading6.copyWith(
                                          color: Red1,
                                          fontSize: 14 * textScale),
                                      focusColor: Yellow1,
                                      fillColor: light,
                                      filled: true,
                                      errorStyle: TextStyle(
                                        fontSize: 13.5 * textScale,
                                        color: light,
                                        background: Paint()
                                          ..strokeWidth = 13
                                          ..color = errorBg
                                          ..style = PaintingStyle.stroke
                                          ..strokeJoin = StrokeJoin.round,
                                      ),
                                      errorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: errorBg, width: 1.8),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          gapPadding: 2),
                                      focusedErrorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: error, width: 1.8),
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Yellow1, width: 1.8),
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12))),
                                ),
                              ),
                              SizedBox(
                                height: bodyHeight * 0.025,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: bodyHeight * 0.035,
                        ),
                        Container(
                          width: bodyWidth * 1,
                          height: bodyHeight * 0.07,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(80),
                            color: Red1,
                          ),
                          child: TextButton(
                            onPressed: () {
                              if (controller.emailKey.value.currentState!
                                  .validate()) {
                                controller.lupaSandi(controller.emailC.text);
                              }
                            },
                            /*authC.login(emailC.text, passC.text)*/
                            child: Text(
                              'Lupa Sandi',
                              textScaleFactor: 1.25,
                              style: headingBtn.copyWith(
                                color: Yellow1,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                        padding: EdgeInsets.only(
                            bottom:
                                MediaQuery.of(context).viewInsets.bottom * 1))
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
