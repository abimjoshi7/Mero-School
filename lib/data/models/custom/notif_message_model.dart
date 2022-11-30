class NotifMessageModel {
  Map<String, dynamic>? messageReceived;

  Map<String, dynamic>? get() => messageReceived;

  void setMessage(Map<String, dynamic> message) {
    this.messageReceived = message;
  }

  static final NotifMessageModel _notifMessageModel = NotifMessageModel.init();

  factory NotifMessageModel() {
    return _notifMessageModel;
  }

  NotifMessageModel.init();
}
