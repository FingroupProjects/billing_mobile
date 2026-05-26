import 'package:billing_mobile/screens/clients/client_details/organizations_screen/organization_details_screen.dart';
import 'package:flutter/material.dart';

class ClientDetailsScreen extends StatelessWidget {
  final int organizationId;

  const ClientDetailsScreen({
    required this.organizationId,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return OrganizationDetailsScreen(organizationId: organizationId);
  }
}
