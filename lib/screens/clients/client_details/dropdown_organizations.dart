import 'package:billing_mobile/api/api_service.dart';
import 'package:billing_mobile/bloc/organizations/organizations_bloc.dart';
import 'package:billing_mobile/custom_widget/custom_card_tasks_tabBar.dart';
import 'package:billing_mobile/screens/clients/client_details/organizations_screen/add_organization.dart';
import 'package:billing_mobile/screens/clients/client_details/organizations_screen/organization_activate_deactivate.dart';
import 'package:billing_mobile/screens/clients/client_details/organizations_screen/organization_details_screen.dart';
import 'package:billing_mobile/widgets/snackbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:billing_mobile/bloc/organizations/organizations_event.dart';
import 'package:billing_mobile/bloc/organizations/organizations_state.dart';
import 'package:billing_mobile/models/organizations_model.dart';

class    OrganizationsWidget extends StatefulWidget {
  final int clientId;

  OrganizationsWidget({Key? key, required this.clientId}) : super(key: key);

  @override
  _OrganizationsWidgetState createState() => _OrganizationsWidgetState();
}

class _OrganizationsWidgetState extends State<OrganizationsWidget> {
  final ApiService _apiService = ApiService(); // Добавляем ApiService

  @override
  void initState() {
    super.initState();
    context.read<OrganizationBloc>().add(FetchOrganizationEvent(widget.clientId.toString()));
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
        if (state is OrganizationLoading) {
          // No UI rendered during loading, as per original behavior
        } else if (state is OrganizationLoaded) {
          organizations = state.organizations;
        } else if (state is OrganizationError) {
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
        const SizedBox(height: 4),
        if (organizations.isEmpty)
          _buildEmptyState()
        else
          ConstrainedBox(
            constraints: const BoxConstraints(
              maxHeight: 300,
              minHeight: 0,
            ),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: organizations.length,
              itemBuilder: (context, index) {
                return _buildOrganizationItem(organizations[index]);
              },
            ),
          )
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
                Text(
                  'Нет организаций',
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
    final createdAt = DateFormat('dd.MM.yyyy').format(organization.createdAt);
    final isActive = organization.hasAccess == 1;

    return GestureDetector(
      onTap: () => _showDetailsOrganizationScreen(organization),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xffF4F7FD),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isActive ? Colors.green : Colors.red,
              width: 1.5,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
            child: Row(
              children: [
                const Icon(Icons.business, color: Color(0xff1E2E52), size: 24),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        organization.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontFamily: 'Gilroy',
                          fontWeight: FontWeight.w600,
                          color: Color(0xff1E2E52),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Баланс: ${organization.balance?.toStringAsFixed(2) ?? '0.00'}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontFamily: 'Gilroy',
                          color: Color(0xff1E2E52),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Телефон: ${organization.phone.isNotEmpty ? organization.phone : 'Не указан'}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontFamily: 'Gilroy',
                          color: Color(0xff1E2E52),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Создана: $createdAt',
                        style: const TextStyle(
                          fontSize: 14,
                          fontFamily: 'Gilroy',
                          color: Color(0xff1E2E52),
                        ),
                      ),
                    ],
                  ),
                ),
                FutureBuilder<bool>(
                  future: _apiService.isAdmin(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const SizedBox.shrink();
                    }
                    final isAdmin = snapshot.data ?? false;
                    return isAdmin
                        ? IconButton(
                            icon: Image.asset(
                              isActive ? 'assets/icons/power_on.png' : 'assets/icons/power_off.png',
                              width: 28,
                              height: 28,
                            ),
                            onPressed: () => _showActivateDeactivateOrganizationDialog(organization),
                          )
                        : const SizedBox.shrink();
                  },
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
          style: const TextStyle(
            fontSize: 18,
            fontFamily: 'Gilroy',
            fontWeight: FontWeight.w600,
            color: Color(0xff1E2E52),
          ),
        ),
        FutureBuilder<bool>(
          future: _apiService.isAdmin(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SizedBox.shrink();
            }
            final isAdmin = snapshot.data ?? false;
            return isAdmin
                ? TextButton(
                    onPressed: _showAddOrganizationScreen,
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      backgroundColor: const Color(0xff1E2E52),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Создать',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Gilroy',
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  )
                : const SizedBox.shrink();
          },
        ),
      ],
    );
  }

  void _showAddOrganizationScreen() async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => CreateOrganizationScreen(clientId: widget.clientId),
      ),
    );

    if (result == true) {
      context.read<OrganizationBloc>().add(FetchOrganizationEvent(widget.clientId.toString()));
    }
  }

  void _showDetailsOrganizationScreen(Organization organization) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OrganizationDetailsScreen(organizationId: organization.id),
      ),
    );
  }

  void _showActivateDeactivateOrganizationDialog(Organization organization) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ActiveDeactiveOrganizationDialog(
          organizationId: organization.id,
          active: organization.hasAccess == 1,
        );
      },
    );
  }
}