

class AppUrls {
  //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Base Urls~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
  static String baseUrl = "http://18.223.248.119/NaqlahAPI/Naqla";

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Auth Urls~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
  static String loginDriverUrl = "$baseUrl/LoginDriver";
  static String verifyDriverOtpUrl = "$baseUrl/DriverCheckVerify";
  static String getDriverByID = "$baseUrl/GetDriverByID";
  static String updateDriver = "$baseUrl/UpdateDriver";
  static String getNotifications = "$baseUrl/GetNotifications";


  //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Order Urls~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
  static String getDriverNewOrders = "$baseUrl/DriverNewOrders";
  static String getDriverCurrentOrders = "$baseUrl/DriverCurrentOrders";
  static String getDriverAllOrders = "$baseUrl/DriverAllOrders";
  static String acceptOrder = "$baseUrl/AcceptOrder";
  static String driverGetOrderByID = "$baseUrl/DriverGetOrderByID";
  static String changeOrderStatus = "$baseUrl/OrderStatus";


}
