class IPConfigurations{

  static String serverIp = "https://fooduat.eatsbee.com/backoffice/apibackendmobile";

  static String serverImagePath = "https://fooduat.eatsbee.com/backoffice";

  static String userLogin = "https://fooduat.eatsbee.com/backoffice/apibackendmobile/login"; //POST
  static String getTermsConditions="https://fooduat.eatsbee.com/backoffice/apibackendmobile/terms_and_conditions";
  static String getNewOrders = "$serverIp/new_orders"; //GET
  static String getProcessingOrders = "$serverIp/processing_orders"; //GET
  static String getReadyOrders = "$serverIp/ready_orders"; //GET
  static String acceptOrders = "$serverIp/accept_order"; //POST
  static String cancelOrders = "$serverIp/cancel_order"; //POST
  static String readyForPickupOrders = "$serverIp/ready_order"; //POST
  static String completeOrders = "$serverIp/complete_order"; //POST
  static String menuItems = "$serverIp/menu_items"; //POST

  static String addPrinters="$serverIp/print_store"; //POST
  static String delUpPrinter="$serverIp/printer_action"; //POST
  static String getPrinters="$serverIp/get_printers"; //GET

  static String getDefaultPrinter="$serverIp/get_default_printer"; //GET
  static String setDefaultPrinter="$serverIp/set_default_printer"; //POST

  static String printerLogs="$serverIp/print_logs_store";//POST
  static String updateLogs="$serverIp/update_log_status"; //POST

  static String availabilityStatus="$serverIp/update_ordering_status"; //POST
  static String pauseOrderStatus="$serverIp/set_pause_order"; //POST
  static String getOrderingStatus="$serverIp/order_pause_status"; //GET

  static String getPauseStatusData="$serverIp/get_pause_metadata"; //POST
  static String getTimezone="$serverIp/get_timezone"; //GET

  static String verify2fa="$serverIp/verify_2fa_code"; //POST

  static String getNotifi="$serverIp/get_notifications"; //GET
  static String clearNotif="$serverIp/clear_notifications"; //DELETE
  static String readNotif="$serverIp/read_notification"; //POST

  static String printStatusUpdate="$serverIp/order_update_print_status"; //POST
}