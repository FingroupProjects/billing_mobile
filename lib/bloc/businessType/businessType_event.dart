import 'package:equatable/equatable.dart';

abstract class BusinessTypeEvent extends Equatable {
  const BusinessTypeEvent();

  @override
  List<Object> get props => [];
}

class LoadBusinessTypeEvent extends BusinessTypeEvent {}

class ResetBusinessTypeEvent extends BusinessTypeEvent {}