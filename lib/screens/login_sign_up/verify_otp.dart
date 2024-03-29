import 'package:foap/helper/imports/common_import.dart';
import 'package:get/get.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';

import '../../controllers/login_controller.dart';

class VerifyOTPScreen extends StatefulWidget {
  final bool isVerifyingEmail;
  final bool isVerifyingPhone;
  final int? otp;

  final String token;

  const VerifyOTPScreen(
      {Key? key,
      required this.isVerifyingEmail,
      required this.isVerifyingPhone,
      this.otp,
      required this.token})
      : super(key: key);

  @override
  VerifyOTPScreenState createState() => VerifyOTPScreenState();
}

class VerifyOTPScreenState extends State<VerifyOTPScreen> {
  TextEditingController controller = TextEditingController(text: "");
  final LoginController loginController = Get.find();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // controller = TextEditingController(text:  widget.otp.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColorConstants.backgroundColor,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          const SizedBox(
            height: 55,
          ),
          // Center(
          //     child: Image.asset(
          //   'assets/logo.png',
          //   width: 80,
          //   height: 25,
          // )),
          const SizedBox(
            height: 105,
          ),
          Heading4Text(
            LocalizationString.helpToGetAccount,
            weight: TextWeight.bold,
            color: AppColorConstants.themeColor,
            textAlign: TextAlign.start,
          ),
          BodyLargeText(
            LocalizationString.pleaseEnterOneTimePassword,
          ).setPadding(top: 43, bottom: 35),
          Heading4Text(
            widget.otp.toString(),
            weight: TextWeight.bold,
            color: AppColorConstants.themeColor,
            textAlign: TextAlign.start,
          ).setPadding(bottom: 35),
          Obx(() => PinCodeTextField(
                autofocus: true,
                controller: controller,
                highlightColor: Colors.blue,
                defaultBorderColor: Colors.transparent,
                hasTextBorderColor: Colors.transparent,
                pinBoxColor: AppColorConstants.themeColor.withOpacity(0.5),
                highlightPinBoxColor: AppColorConstants.themeColor,
                // highlightPinBoxColor: Colors.orange,
                maxLength: 6,
                hasError: loginController.hasError.value,
                onTextChanged: (text) {
                  loginController.otpTextFilled(text);
                },
                onDone: (text) {
                  loginController.otpCompleted();
                },
                pinBoxWidth: 40,
                pinBoxHeight: 40,
                // hasUnderline: true,
                wrapAlignment: WrapAlignment.spaceAround,
                pinBoxDecoration:
                    ProvidedPinBoxDecoration.defaultPinBoxDecoration,
                pinTextStyle: TextStyle(
                    fontSize: FontSizes.h5, fontWeight: TextWeight.medium),
                pinTextAnimatedSwitcherTransition:
                    ProvidedPinBoxTextAnimation.scalingTransition,
                pinTextAnimatedSwitcherDuration:
                    const Duration(milliseconds: 300),
                highlightAnimationBeginColor: Colors.black,
                highlightAnimationEndColor: Colors.white12,
                keyboardType: TextInputType.number,
              )),
          Obx(() => Row(
                children: [
                  BodyLargeText(
                    LocalizationString.didntReceivedCode,
                  ),
                  BodyLargeText(
                    LocalizationString.resendOTP,
                    weight: TextWeight.medium,
                    color: loginController.canResendOTP.value == false
                        ? AppColorConstants.disabledColor
                        : AppColorConstants.themeColor,
                  ).ripple(() {
                    if (loginController.canResendOTP.value == true) {
                      loginController.resendOTP(
                          token: widget.token, context: context);
                    }
                  }),
                  loginController.canResendOTP.value == false
                      ? TweenAnimationBuilder<Duration>(
                          duration: const Duration(minutes: 2),
                          tween: Tween(
                              begin: const Duration(minutes: 2),
                              end: Duration.zero),
                          onEnd: () {
                            loginController.canResendOTP.value = true;
                            setState(() {});
                          },
                          builder: (BuildContext context, Duration value,
                              Widget? child) {
                            final minutes = value.inMinutes;
                            final seconds = value.inSeconds % 60;
                            return BodyLargeText(' ($minutes:$seconds)',
                                textAlign: TextAlign.center,
                                color: AppColorConstants.themeColor);
                          })
                      : Container()
                ],
              )).setPadding(top: 20, bottom: 25),
          const Spacer(),
          Obx(() => loginController.otpFilled.value == true
              ? addSubmitBtn()
              : Container()),
          const SizedBox(
            height: 55,
          )
        ]),
      ).setPadding(left: 25, right: 25),
    );
  }

  addSubmitBtn() {
    return AppThemeButton(
      onPress: () {
        loginController.callVerifyOTP(
          isVerifyingPhone: widget.isVerifyingPhone,
          isVerifyingEmail: widget.isVerifyingEmail,
          otp: controller.text,
          token: widget.token,
        );
      },
      text: LocalizationString.verify,
    );
  }
}
