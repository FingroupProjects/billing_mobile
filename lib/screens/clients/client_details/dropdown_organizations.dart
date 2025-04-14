import 'package:billing_mobile/bloc/organizations/organizations_bloc.dart';
import 'package:billing_mobile/custom_widget/custom_card_tasks_tabBar.dart';
import 'package:billing_mobile/widgets/snackbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:billing_mobile/bloc/organizations/organizations_event.dart';
import 'package:billing_mobile/bloc/organizations/organizations_state.dart';
import 'package:billing_mobile/models/organizations_model.dart';

class OrganizationsWidget extends StatefulWidget {
  final int clientId;


  OrganizationsWidget({Key? key, required this.clientId, })
      : super(key: key);

  @override
  _OrganizationsWidgetState createState() => _OrganizationsWidgetState();
}

class _OrganizationsWidgetState extends State<OrganizationsWidget> {

  @override
  void initState() {
    super.initState();
    context.read<OrganizationBloc>().add(LoadOrganizationEvent(widget.clientId.toString()));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrganizationBloc, OrganizationState>(
      builder: (context, state) {
        List<Organization> organizations = [];
        
        if (state is OrganizationLoadingState) {
        } else if (state is OrganizationLoadedState) {
          organizations = state.organizations;
        } else if (state is OrganizationErrorState) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
           showCustomSnackBar(
             context: context,
             message: state.message,
             isSuccess: false,
           );
          });
        }

        return _buildOrganizationsList(organizations);
      },
    );
  }

  Widget _buildOrganizationsList(List<Organization> organizations) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTitleRow('Организации'),
        SizedBox(height: 4),
        if (organizations.isEmpty)
          _buildEmptyState()
        else
          Container(
            height: 350,
            child: ListView.builder(
              itemCount: organizations.length,
              itemBuilder: (context, index) {
                return _buildOrganizationItem(organizations[index]);
              },
            ),
          ),
      ],
    );
  }
   Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Container(
        decoration: TaskCardStyles.taskCardDecoration,
        child: const Center(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                SizedBox(height: 0),
                Text( 'Нет организаций',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Gilroy',
                    fontWeight: FontWeight.w500,
                    color: Color(0xff1E2E52),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOrganizationItem(Organization organization) {
    final createdAt = DateFormat('dd.MM.yyyy ')
        .format(organization.createdAt);
    // final updatedAt = DateFormat('dd.MM.yyyy HH:mm')
    //     .format(organization.updatedAt);

    return GestureDetector(
      onTap: () => _showEditOrganizationDialog(organization) ,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
        child: Container(
          decoration: BoxDecoration(
            color: Color(0xffF4F7FD),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
            child: Row(
              children: [
                Icon(Icons.business, color: Color(0xff1E2E52), size: 24),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        organization.name,
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Gilroy',
                          fontWeight: FontWeight.w600,
                          color: Color(0xff1E2E52),
                        ),
                      ),
                      SizedBox(height: 4),
                      Text( 'ИНН: ${organization.INN}',
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'Gilroy',
                          color: Color(0xff1E2E52),
                        ),
                      ),
                      SizedBox(height: 4),
                      Text( 'Статус: ${organization.hasAccess == 1 ? 'Активна' : 'Неактивна'}',
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'Gilroy',
                          color: Color(0xff1E2E52),
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Создана: $createdAt',
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'Gilroy',
                          color: Color(0xff1E2E52),
                        ),
                      ),
                    ],
                  ),
                ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Color(0xff1E2E52)),
                    onPressed: () => _showDeleteOrganizationDialog(organization),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row _buildTitleRow(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontFamily: 'Gilroy',
            fontWeight: FontWeight.w600,
            color: Color(0xff1E2E52),
          ),
        ),
          TextButton(
            onPressed: _showAddOrganizationDialog,
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              backgroundColor: Color(0xff1E2E52),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Добавить',
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Gilroy',
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
      ],
    );
  }

  void _showAddOrganizationDialog() {
    // showModalBottomSheet(
    //   context: context,
    //   backgroundColor: Colors.white,
    //   isScrollControlled: true,
    //   builder: (BuildContext context) {
    //     return Padding(
    //       padding: EdgeInsets.only(
    //         bottom: MediaQuery.of(context).viewInsets.bottom),
    //       child: CreateOrganizationDialog(
    //         clientId: widget.clientId,
    //         managerId: widget.managerId,
    //       ),
    //     );
    //   },
    // );
  }

  void _showEditOrganizationDialog(Organization organization) {
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => OrganizationDetailsScreen(
    //       organizationId: organization.id,
    //     ),
    //   ),
    // );
  }

  void _showDeleteOrganizationDialog(Organization organization) {
    // showDialog(
    //   context: context,
    //   builder: (BuildContext context) {
    //     return DeleteOrganizationDialog(
    //       organization: organization, 
    //       clientId: widget.clientId,
    //     );
    //   },
    // );
  }
}