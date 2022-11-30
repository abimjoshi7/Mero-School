abstract class Model<T> {
  T fromJson(dynamic response);
  Map<String, dynamic> toJson();
}
