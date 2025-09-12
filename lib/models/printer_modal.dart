
class PrinterModal {
  String? printerId;
  String? printerName;
  String? ipAddress;
  String? autoPrint;
  String? deviceUuid;
  String? merchantId;
  String? printerType;
  String? serviceId;



  PrinterModal(
      { this.printerId,
        required this.printerName,
       required this.ipAddress,
       required this.autoPrint,
       required this.deviceUuid,
       required this.merchantId,
       required this.printerType,
       required this.serviceId
        });

  PrinterModal.fromJson(Map<String, dynamic> json) {
    printerId = json['printer_id'].toString();
    printerName = json['printer_name'].toString();
    ipAddress = json['ip_address'].toString();
    autoPrint = json['auto_print'];
    deviceUuid = json['device_uuid'].toString();
    merchantId = json['merchant_id'].toString();
    printerType = json['printer_model'].toString();
    serviceId = json['service_id'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['printer_id'] = printerId;
    data['printer_name'] = printerName;
    data['ip_address'] = ipAddress;
    data['auto_print'] = autoPrint;
    data['device_uuid'] = deviceUuid;
    data['merchant_id'] = merchantId;
    data['printer_model'] = printerType;
    data['service_id'] = serviceId;
    return data;
  }
}