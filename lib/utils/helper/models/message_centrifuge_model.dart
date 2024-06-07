import 'package:tddboilerplate/features/features.dart';

class MessageCentrifugeModel {
  final String event;
  final MessageDataEntity data;
  
  MessageCentrifugeModel({
    required this.event,
    required this.data,
  });
}
