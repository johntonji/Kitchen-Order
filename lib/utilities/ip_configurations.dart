class IPConfigurations{
  //Server Address
  static String serverIp = "https://fooduat.eatsbee.com/backoffice/apibackendmobile";
  static String serverImagePath = "https://fooduat.eatsbee.com/backoffice";

  //Server APIs
  static String userLogin = "$serverIp/login"; //POST
  static String getNewOrders = "$serverIp/new_orders"; //GET
  static String getProcessingOrders = "$serverIp/processing_orders"; //GET
  static String getReadyOrders = "$serverIp/ready_orders"; //GET
  static String acceptOrders = "$serverIp/accept_order"; //POST
  static String cancelOrders = "$serverIp/cancel_order"; //POST
  static String readyForPickupOrders = "$serverIp/ready_order"; //POST
  static String completeOrders = "$serverIp/complete_order"; //POST

}