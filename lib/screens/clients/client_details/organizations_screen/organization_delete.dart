
import 'package:billing_mobile/bloc/organizations/organizations_bloc.dart';
import 'package:billing_mobile/bloc/organizations/organizations_state.dart';
import 'package:billing_mobile/custom_widget/custom_button.dart';
import 'package:billing_mobile/widgets/snackbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DeleteOrganizationDialog extends StatelessWidget {
  final int organizationId;

  DeleteOrganizationDialog({required this.organizationId});

  @override
  Widget build(BuildContext context) {
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
        title: const Center(
          child: Text(
          'Удалить организацию?', 
          style: TextStyle(
            fontSize: 20,
            fontFamily: 'Gilroy',
            fontWeight: FontWeight.w600,
            color: Color(0xff1E2E52),
          ),
        ),
      ),
      content: const Text(
       'Подтвердите удаление организации', 
        style: TextStyle(
          fontSize: 16,
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
            SizedBox(width: 8),
            Expanded(
              child: CustomButton(
                buttonText:  'Удалить', 
                onPressed: () {
                  // context.read<OrganizationBloc>().add(DeleteOrganization(organizationId)); 
                  // context.read<OrganizationBloc>().add(FetchOrganizationStatuses()); 

                 showCustomSnackBar(
                   context: context,
                   message: 'Организация успешно удален!',
                   isSuccess: true,
                 );
             
                  Navigator.of(context).pop();
                  Navigator.pop(context, true); 
                },

                buttonColor: Color(0xff1E2E52),
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
