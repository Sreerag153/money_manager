import 'package:flutter/material.dart';

class EventFormProvider extends ChangeNotifier {
  String name = '';
  double totalAmount = 0;
  int members = 0;
  String category = '';
  String paymentType = 'Cash';
  String status = 'Pending';
  String? attachmentPath;

  void init(dynamic event, String defaultCategory) {
    name = event?.name ?? '';
    totalAmount = event?.totalAmount ?? 0;
    members = event?.members ?? 0;
    status = event?.status ?? 'Pending';
    paymentType = event?.paymentType ?? 'Cash';
    attachmentPath = event?.attachmentPath;
    category = event?.category ?? defaultCategory;
  }

  double get splitAmount => members > 0 ? totalAmount / members : 0;

  void updateName(String val) { name = val; notifyListeners(); }
  void updateAmount(String val) { totalAmount = double.tryParse(val) ?? 0; notifyListeners(); }
  void updateMembers(String val) { members = int.tryParse(val) ?? 0; notifyListeners(); }
  void updateCategory(String val) { category = val; notifyListeners(); }
  void updatePayment(String val) { paymentType = val; notifyListeners(); }
  void updateStatus(String val) { status = val; notifyListeners(); }
  void updateAttachment(String? path) { attachmentPath = path; notifyListeners(); }
}