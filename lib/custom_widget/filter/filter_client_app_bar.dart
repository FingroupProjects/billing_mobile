import 'package:billing_mobile/custom_widget/filter/connectionType_list.dart';
import 'package:billing_mobile/custom_widget/filter/status_list.dart';
import 'package:billing_mobile/screens/clients/client_details/partner_list.dart';
import 'package:billing_mobile/screens/clients/client_details/tariff_list.dart';
import 'package:flutter/material.dart';

class FilterClientScreen extends StatefulWidget {
  final Function(Map<String, dynamic>)? onFilterSelected;
  final List? initialManagers;
  final List? initialRegions;
  final List? initialSources;
  final int? initialStatuses;
  final DateTime? initialFromDate;
  final DateTime? initialToDate;
  final bool? initialHasSuccessDeals;
  final bool? initialHasInProgressDeals;
  final bool? initialHasFailureDeals;
  final bool? initialHasNotices;
  final bool? initialHasContact;
  final bool? initialHasChat;
  final bool? initialHasNoReplies;
  final bool? initialHasUnreadMessages; 
  final bool? initialHasDeal;
  final VoidCallback? onResetFilters;

  FilterClientScreen({
    Key? key,
    this.onFilterSelected,
    this.initialManagers,
    this.initialRegions,
    this.initialSources,
    this.initialStatuses,
    this.initialFromDate,
    this.initialToDate,
    this.initialHasSuccessDeals,
    this.initialHasInProgressDeals,
    this.initialHasFailureDeals,
    this.initialHasNotices,
    this.initialHasContact,
    this.initialHasChat,
    this.initialHasNoReplies, 
    this.initialHasUnreadMessages, 
    this.initialHasDeal,
    this.onResetFilters,
  }) : super(key: key);

  @override
  _FilterClientScreenState createState() => _FilterClientScreenState();
}

class _FilterClientScreenState extends State<FilterClientScreen> {
  List _selectedFilters = [];

  
  int? selectedConnectionType;
  int? selectedStatus;
  int? selectedTariff;
  int? selectedPartner;
  
  bool? _hasSuccessDeals;
  bool? _hasInProgressDeals;
  bool? _hasFailureDeals;
  bool? _hasNotices;
  bool? _hasContact;
  bool? _hasChat;
  bool? _hasNoReplies;
  bool? _hasUnreadMessages; 
  bool? _hasDeal;

  int? _daysWithoutActivity;

  @override
  void initState() {
    super.initState();
    _selectedFilters = widget.initialManagers ?? [];
    _hasSuccessDeals = widget.initialHasSuccessDeals;
    _hasInProgressDeals = widget.initialHasInProgressDeals;
    _hasFailureDeals = widget.initialHasFailureDeals;
    _hasNotices = widget.initialHasNotices;
    _hasContact = widget.initialHasContact;
    _hasChat = widget.initialHasChat;
    _hasNoReplies = widget.initialHasNoReplies; 
    _hasUnreadMessages = widget.initialHasUnreadMessages; 
    _hasDeal = widget.initialHasDeal;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF4F7FD),
      appBar: AppBar(
        titleSpacing: 0,
        title: Text(
          'Фильтр',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Color(0xfff1E2E52), fontFamily: 'Gilroy'),
        ),
        backgroundColor: Colors.white,
        forceMaterialTransparency: true,
        elevation: 1,
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                widget.onResetFilters?.call();
                _selectedFilters.clear();
                _hasSuccessDeals = false;
                _hasInProgressDeals = false;
                _hasFailureDeals = false;
                _hasNotices = false;
                _hasContact = false;
                _hasChat = false;
                _hasNoReplies = false;
                _hasUnreadMessages = false;
                _hasDeal = false;
                _daysWithoutActivity = null;
              });
            },
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              backgroundColor: Colors.blueAccent.withOpacity(0.1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              side: BorderSide(color: Colors.blueAccent, width: 0.5),
            ),
            child: const Text( 'Сбросить',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.blueAccent,
                fontFamily: 'Gilroy',
              ),
            ),
          ),
          SizedBox(width: 10),
          TextButton(
            onPressed: () async {
              bool isAnyFilterSelected =
                  _selectedFilters.isNotEmpty ||
                  _hasSuccessDeals == true ||
                  _hasInProgressDeals == true ||
                  _hasFailureDeals == true ||
                  _hasNotices == true ||
                  _hasContact == true ||
                  _hasChat == true ||
                  _hasNoReplies == true || 
                  _hasUnreadMessages == true ||
                  _hasDeal == true ||
                  _daysWithoutActivity != null;

              if (isAnyFilterSelected) {

                print('Start Filter');
                widget.onFilterSelected?.call({
                  'filter': _selectedFilters,
                  'hasSuccessDeals': _hasSuccessDeals,
                  'hasInProgressDeals': _hasInProgressDeals,
                  'hasFailureDeals': _hasFailureDeals,
                  'hasNotices': _hasNotices,
                  'hasContact': _hasContact,
                  'hasChat': _hasChat,
                  'hasNoReplies': _hasNoReplies, 
                  'hasUnreadMessages': _hasUnreadMessages,
                  'hasDeal': _hasDeal,
                  'daysWithoutActivity': _daysWithoutActivity,
                });
              } else {
                print('NOTHING!!!!!!');
              }
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              backgroundColor: Colors.blueAccent.withOpacity(0.1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              side: BorderSide(color: Colors.blueAccent, width: 0.5),
            ),
            child: const Text('Применить',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.blueAccent,
                fontFamily: 'Gilroy',
              ),
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 4, bottom: 4),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                      Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: StatusList(
                          selectedstatus: null, 
                          onChanged: (String? newValue) {
                            selectedStatus = newValue != null ? int.parse(newValue) : null;
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                      Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: ConnectionTypeList(
                          selectedstatus: null, 
                          onChanged: (String? newValue) {
                            selectedConnectionType = newValue != null ? int.parse(newValue) : null;
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: TariffList(
                          selectedTariff: null, 
                          onChanged: (String? newValue) {
                            selectedTariff = newValue != null ? int.parse(newValue) : null;
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: PartnerList(
                          selectedPartner: selectedPartner.toString(),
                          onChanged: (value) {
                              selectedPartner = int.parse(value.toString());
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}