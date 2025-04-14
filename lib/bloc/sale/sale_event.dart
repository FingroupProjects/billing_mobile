import 'package:equatable/equatable.dart';

abstract class SaleEvent extends Equatable {
  const SaleEvent();

  @override
  List<Object> get props => [];
}

class LoadSaleEvent extends SaleEvent {}

class ResetSaleEvent extends SaleEvent {}