import 'package:billing_mobile/api/api_service.dart';
import 'package:billing_mobile/bloc/organizations/organizations_bloc.dart';
import 'package:billing_mobile/bloc/organizations/organizations_state.dart';
import 'package:billing_mobile/custom_widget/custom_button.dart';
import 'package:billing_mobile/widgets/snackbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ActiveDeactiveOrganizationDialog extends StatelessWidget {
  final int organizationId;
  final bool active;

  ActiveDeactiveOrganizationDialog({required this.organizationId, required this.active});
    final ApiService apiService = ApiService();


  @override
  Widget build(BuildContext context) {
    final String actionText = active ? 'Деактивировать' : 'Активировать';
    final String dialogTitle = '$actionText?';
    final String dialogContent = 'Вы хотите ${actionText.toLowerCase()} организацию?';
    final String successMessage = 'Организация успешно ${actionText.toLowerCase()}!';

    return BlocListener<OrganizationBloc, OrganizationState>(
      listener: (context, state) {
        if (state is OrganizationError) {
          showCustomSnackBar(
            context: context,
            message: state.message,
            isSuccess: false,
          );
        }
      },
      child: AlertDialog(
        backgroundColor: Colors.white,
        title: Center(
          child: Text(
            dialogTitle,
            style: const TextStyle(
              fontSize: 20,
              fontFamily: 'Gilroy',
              fontWeight: FontWeight.w600,
              color: Color(0xff1E2E52),
            ),
          ),
        ),
        content: Text(
          dialogContent,
          style: const TextStyle(
            fontSize: 14,
            fontFamily: 'Gilroy',
            fontWeight: FontWeight.w500,
            color: Color(0xff1E2E52),
          ),
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: CustomButton(
                  buttonText: 'Отменить',
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  buttonColor: Colors.red,
                  textColor: Colors.white,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: CustomButton(
                  buttonText: actionText,
                  onPressed: () async {
                    // context.read<OrganizationBloc>().add(
                    //   active
                    //       ? DeactivateOrganization(organizationId)
                    //       : ActivateOrganization(organizationId),
                    // );
                    // context.read<OrganizationBloc>().add(FetchOrganization());
                     await apiService.OrganizationActiveDeactivate(organizationId);

                    showCustomSnackBar(
                      context: context,
                      message: successMessage,
                      isSuccess: true,
                    );

                    Navigator.of(context).pop();
                    Navigator.pop(context, true);
                  },
                  buttonColor: const Color(0xff1E2E52),
                  textColor: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}