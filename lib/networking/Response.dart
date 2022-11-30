enum Status { LOADING, COMPLETED, ERROR, SUCCESS, LOGOUT, COMPLETE_MESSAGE }

class Response<T> {
  Status status;
  T? data;
  String? message;

  Response.loading(this.message) : status = Status.LOADING;
  Response.completed(this.data) : status = Status.COMPLETED;
  Response.error(this.message) : status = Status.ERROR;
  Response.success(this.message) : status = Status.SUCCESS;
  Response.logout(this.message) : status = Status.LOGOUT;

  Response.completedDataMessage(this.data, this.message)
      : status = Status.COMPLETE_MESSAGE;

  @override
  String toString() {
    return "Status : $status \n Message : $message \n Data : $data";
  }
}
