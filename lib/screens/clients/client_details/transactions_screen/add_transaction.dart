
import 'package:billing_mobile/bloc/clients_by_id/clientById_bloc.dart';
import 'package:billing_mobile/bloc/clients_by_id/clientById_event.dart';
import 'package:billing_mobile/bloc/transactions/transactions_bloc.dart';
import 'package:billing_mobile/bloc/transactions/transactions_event.dart';
import 'package:billing_mobile/bloc/transactions/transactions_state.dart';
import 'package:billing_mobile/custom_widget/custom_button.dart';
import 'package:billing_mobile/custom_widget/custom_textfield.dart';
import 'package:billing_mobile/custom_widget/custom_textfield_deadline.dart';
import 'package:billing_mobile/widgets/snackbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateTransactionScreen extends StatefulWidget {
  final int clientId;

  const CreateTransactionScreen({required this.clientId});

  @override
  _CreateTransactionScreenState createState() => _CreateTransactionScreenState();
}

class _CreateTransactionScreenState extends State<CreateTransactionScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController sumController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: Transform.translate(
          offset: const Offset(-10, 0),
          child: const Text(
            'Пополнить баланс',
            style: TextStyle(
              fontSize: 20,
              fontFamily: 'Gilroy',
              fontWeight: FontWeight.w600,
              color: Color(0xff1E2E52),
            ),
          ),
        ),
        centerTitle: false,
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
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
        leadingWidth: 40,
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocListener<TransactionBloc, TransactionState>(
              listener: (context, state) {
                if (state is TransactionCreateError) {
                  showCustomSnackBar(
                    context: context,
                    message: state.message,
                    isSuccess: false,
                  );
                } else if (state is TransactionCreated) {
                  showCustomSnackBar(
                    context: context,
                    message: 'Транзакция успешно создана!',
                    isSuccess: true,
                  );
                  context.read<ClientByIdBloc>().add(FetchClientByIdEvent(clientId: widget.clientId.toString()));
                  Navigator.pop(context, true);
                }
              },
              child: GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(left: 16, right: 16, top: 0, bottom: 80), 
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const SizedBox(height: 8),
                        CustomTextFieldDate(
                          controller: dateController,
                          label: 'Дата',
                          withTime: false,
                          useCurrentDateAsDefault: true,
                        ),
                        const SizedBox(height: 8),
                        CustomTextField(
                          controller: sumController,
                          hintText: 'Введите сумму',
                          label:'Сумма',
                          keyboardType: TextInputType.number,
                          validator: (value) { if (value == null || value.isEmpty) { return 'Поле обязательно для заполнения'; } return null; },
                        ),
                        SizedBox(height: 8),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: CustomButton(
                    buttonText: 'Отмена',
                    buttonColor: Color(0xffF4F7FD),
                    textColor: Colors.black,
                    onPressed: () {
                     Navigator.pop(context);
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: BlocBuilder<TransactionBloc, TransactionState>(
                    builder: (context, state) {
                      if (state is TransactionLoading) {
                        return const Center(child: CircularProgressIndicator(color: Color(0xff1E2E52)));
                      } else {
                        return CustomButton(
                          buttonText: 'Сохранить',
                          buttonColor: Color(0xff4759FF),
                          textColor: Colors.white,
                          onPressed: _submitForm,
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      context.read<TransactionBloc>().add(CreateTransactions(
        clientId: widget.clientId,
        date: dateController.text,
        sum: sumController.text,
      ));    
    } else {
      showCustomSnackBar(
        context: context,
        message:'Заполните все обязательные поля!',
        isSuccess: false,
      );
    }
  }
}