import 'package:flutter/material.dart';
import 'package:umrah_by_lamar/common/static_var.dart';
import 'package:umrah_by_lamar/controller/prebook_controller.dart';
import 'package:umrah_by_lamar/screen/widgets/custom_btn.dart';
import 'package:umrah_by_lamar/screen/widgets/custom_user_form.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../model/prebook_models/activity_questions_model.dart';
import 'prebook_stepper.dart';

class ActivityQuestionsView extends StatefulWidget {
  const ActivityQuestionsView({super.key, required this.updateCurrentStep});
  final ValueChanged<Steppers> updateCurrentStep;

  @override
  State<ActivityQuestionsView> createState() => _ActivityQuestionsViewState();
}

class _ActivityQuestionsViewState extends State<ActivityQuestionsView> {
  final _staticVar = StaticVar();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Consumer<PrebookController>(builder: (context, data, child) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 1.h, width: 100.w),
          GestureDetector(
            onTap: () {
              widget.updateCurrentStep(Steppers.roomRequest);
            },
            child: Icon(
              Icons.keyboard_arrow_left,
              color: _staticVar.primaryColor,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
              AppLocalizations.of(context)?.pleaseAnswerThisQuestions ??
                  'Please answer this questions for the activities',
              style: TextStyle(fontSize: _staticVar.titleFontSize.sp, color: _staticVar.gray)),
          SizedBox(height: 2.h),
          Form(
            key: _formKey,
            child: SizedBox(
                height: 55.h,
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    for (var question in data.activityQuestions?.data ?? <Questions>[])
                      _buildQuestion(question)
                  ],
                )),
          ),
          SizedBox(height: 1.h),
          SizedBox(
              width: 100.w,
              height: 6.h,
              child: CustomBTN(
                  onTap: () {
                    if ((_formKey.currentState?.validate() ?? false) == true) {
                      _formKey.currentState?.save();
                      widget.updateCurrentStep(Steppers.activityQuestions);
                    }
                  },
                  title: AppLocalizations.of(context)?.next ?? "Next"))
        ],
      );
    });
  }

  _buildQuestion(Questions question) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: _staticVar.defaultPadding),
      padding: EdgeInsets.all(_staticVar.defaultPadding),
      decoration: BoxDecoration(
          boxShadow: [_staticVar.shadow],
          color: _staticVar.cardcolor,
          borderRadius: BorderRadius.circular(_staticVar.defaultRadius)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              (question.required ?? false)
                  ? "${AppLocalizations.of(context)?.required ?? 'Required'}*"
                  : "",
              style: TextStyle(
                fontSize: _staticVar.subTitleFontSize.sp,
                color: _staticVar.redColor,
              ),
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            question.text ?? '',
            style: TextStyle(
                fontSize: _staticVar.titleFontSize.sp, fontWeight: _staticVar.titleFontWeight),
          ),
          SizedBox(height: 2.h),
          CustomUserForm(
            hintText: AppLocalizations.of(context)?.answer ?? 'Answer',
            maxLine: 2,
            onSaved: (value) {
              question.answer = value;
            },
          )
        ],
      ),
    );
  }
}
