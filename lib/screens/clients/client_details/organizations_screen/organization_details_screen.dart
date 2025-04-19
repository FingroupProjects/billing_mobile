import 'package:billing_mobile/bloc/organizationsById/organizationsById_bloc.dart';
import 'package:billing_mobile/bloc/organizationsById/organizationsById_event.dart';
import 'package:billing_mobile/bloc/organizationsById/organizationsById_state.dart';
import 'package:billing_mobile/custom_widget/custom_button.dart';
import 'package:billing_mobile/models/organizations_model.dart';
import 'package:billing_mobile/widgets/snackbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class OrganizationDetailsScreen extends StatefulWidget {
  final int organizationId;

  const OrganizationDetailsScreen({
    required this.organizationId,
    Key? key,
  }) : super(key: key);

  @override
  _OrganizationDetailsScreenState createState() => _OrganizationDetailsScreenState();
}

class _OrganizationDetailsScreenState extends State<OrganizationDetailsScreen> {
  List<Map<String, String>> details = [];

  @override
  void initState() {
    super.initState();
    context.read<OrganizationByIdBloc>().add(FetchOrganizationByIdEvent(widget.organizationId.toString()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context, 'Просмотр организации'),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: BlocConsumer<OrganizationByIdBloc, OrganizationByIdState>(
          listener: (context, state) {
            if (state is OrganizationByIdLoaded) {
              _updateDetails(state.organizations);
            } else if (state is OrganizationByIdError) {
              showCustomSnackBar(
                context: context,
                message: state.message,
                isSuccess: false,
              );
            }
          },
          builder: (context, state) {
            if (state is OrganizationByIdLoading) {
              return const Center(child: CircularProgressIndicator(color: Color(0xff1E2E52)));
            } else if (state is OrganizationByIdLoaded && details.isNotEmpty) {
              return ListView(
                children: [
                  _buildDetailsList(),
                ],
              );
            } else if (state is OrganizationByIdError) {
              return Center(child: Text(state.message));
            }
            return const Center(child: Text('Нет данных для отображения'));
          },
        ),
      ),
    );
  }

  void _updateDetails(List<Organization> organizations) {
    if (organizations.isNotEmpty) {
      final org = organizations.first;
      setState(() {
        details = [
          {'label': 'Название:', 'value': org.name},
          {'label': 'ИНН:', 'value': org.INN.toString()},
          {'label': 'Телефон:', 'value': org.phone},
          {'label': 'Адрес:', 'value': org.address},
          {'label': 'Доступ:', 'value': org.hasAccess == 1 ? 'Есть' : 'Нет'},
          {'label': 'Создано:', 'value': DateFormat('dd.MM.yyyy').format(org.createdAt)},
          {'label': 'Обновлено:', 'value': DateFormat('dd.MM.yyyy').format(org.updatedAt)},
          {'label': 'Тип бизнеса:', 'value': org.businessTypeName.toString()},
          {'label': 'Причина отказа:', 'value': org.rejectCause ?? '' },
        ];
      });
    }
  }

  AppBar _buildAppBar(BuildContext context, String title) {
    return AppBar(
      backgroundColor: Colors.white,
      forceMaterialTransparency: true,
      elevation: 0,
      centerTitle: false,
      leadingWidth: 40,
      leading: Padding(
        padding: const EdgeInsets.only(left: 0),
        child: Transform.translate(
          offset: const Offset(0, -2),
          child: IconButton(
            icon: Image.asset(
              'assets/icons/arrow-left.png',
              width: 24,
              height: 24,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
      title: Transform.translate(
        offset: const Offset(-10, 0),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontFamily: 'Gilroy',
            fontWeight: FontWeight.w600,
            color: Color(0xff1E2E52),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailsList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: details.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: _buildDetailItem(
            details[index]['label']!,
            details[index]['value']!,
          ),
        );
      },
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLabel(label),
            const SizedBox(width: 8),
            Expanded(
              child: label == 'Адрес:'
                  ? GestureDetector(
                      onTap: () {
                        _showFullTextDialog('Адрес:', value);
                      },
                      child: _buildValue(value, label, maxLines: 1),
                    )
                  : _buildValue(value, label, maxLines: 1),
            ),
          ],
        );
      },
    );
  }

  Widget _buildLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 16,
        fontFamily: 'Gilroy',
        fontWeight: FontWeight.w400,
        color: Color(0xff99A4BA),
      ),
    );
  }

  Widget _buildValue(String value, String label, {int? maxLines}) {
    if (value.isEmpty) return Container();
    return Text(
      value,
      style: TextStyle(
        fontSize: 16,
        fontFamily: 'Gilroy',
        fontWeight: FontWeight.w500,
        color: const Color(0xFF1E2E52),
        decoration: label == 'Адрес:' ? TextDecoration.underline : TextDecoration.none,
      ),
      maxLines: maxLines,
      overflow: maxLines != null ? TextOverflow.ellipsis : TextOverflow.visible,
    );
  }

  void _showFullTextDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xff1E2E52),
                    fontSize: 18,
                    fontFamily: 'Gilroy',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                constraints: const BoxConstraints(maxHeight: 400),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SingleChildScrollView(
                  child: Text(
                    content,
                    textAlign: TextAlign.start,
                    style: const TextStyle(
                      color: Color(0xff1E2E52),
                      fontSize: 16,
                      fontFamily: 'Gilroy',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: CustomButton(
                  buttonText: 'Закрыть',
                  onPressed: () => Navigator.pop(context),
                  buttonColor: const Color(0xff1E2E52),
                  textColor: Colors.white,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}