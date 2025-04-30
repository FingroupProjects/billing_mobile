import 'package:billing_mobile/custom_widget/custom_card_tasks_tabBar.dart';
import 'package:billing_mobile/models/clients_model.dart';
import 'package:flutter/material.dart';

class InActiveClientCard extends StatelessWidget {
  final Client client;
  final VoidCallback? onTap;

  const InActiveClientCard({
    Key? key,
    required this.client,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: TaskCardStyles.taskCardDecoration.copyWith(
          border: Border.all(
            color: client.isActive ? Colors.green : Colors.red,
            width: 1.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start, 
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: RichText(
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    text: TextSpan(
                      text: client.name,
                      style: TaskCardStyles.titleStyle.copyWith(
                        fontSize: 16,
                      ),
                      children: const <TextSpan>[
                        TextSpan(
                          text: '\n\u200B',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xff1E2E52),
                            fontFamily: 'Gilroy',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Text(
                  client.isDemo ? 'Демо' : '',
                  style: const TextStyle(
                    fontSize: 16, 
                    fontFamily: 'Gilroy',
                    fontWeight: FontWeight.w500, 
                    color: Colors.green,
                    // color: Color(0xff1E2E52),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoRow(
                        label: 'Телефон: ',
                        value: client.phone,
                      ),
                      const SizedBox(height: 4),
                      _buildInfoRow(
                        label: 'Тариф: ',
                        value: client.tariff.name,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: TaskCardStyles.priorityContainerDecoration.copyWith(
                    color:  Colors.white,
                  ),
                  child: Text(
                    "Баланс: ${client.balance}",
                    style: TaskCardStyles.priorityStyle.copyWith(
                      color: const Color(0xff1E2E52), 
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow({required String label, required String value}) {
    return RichText(
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        children: [
          TextSpan(
            text: label,
            style: const TextStyle(
              fontSize: 14,
              fontFamily: 'Gilroy',
              fontWeight: FontWeight.w400,
              color: Color(0xff99A4BA),
            ),
          ),
          TextSpan(
            text: value,
            style: const TextStyle(
              fontSize: 14,
              fontFamily: 'Gilroy',
              fontWeight: FontWeight.w400,
              color: Color(0xff1E2E52),
            ),
          ),
        ],
      ),
    );
  }
}