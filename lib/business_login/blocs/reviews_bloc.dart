import 'dart:async';

import 'package:mero_school/data/models/response/related_plan_response.dart';
import 'package:mero_school/data/repositories/my_network_client.dart';
import 'package:mero_school/networking/Response.dart';
import 'package:mero_school/presentation/constants/strings.dart';
import 'package:mero_school/utils/common.dart';
import 'package:mero_school/utils/preference.dart';
import 'package:mero_school/data/models/response/review_response.dart';
import 'package:rxdart/rxdart.dart';
import 'package:mero_school/data/models/request/review_added_request.dart';

import 'base_bloc.dart';

class ReviewsBloc extends BaseBloc {
  StreamController? _dataController;
  bool? _isStreaming;

  StreamSink<Response<ReviewResponse>> get dataSink =>
      _dataController!.sink as StreamSink<Response<ReviewResponse>>;

  Stream<Response<ReviewResponse>> get dataStream =>
      _dataController!.stream as Stream<Response<ReviewResponse>>;

  StreamSink<Response<RelatedPlanResponse>> get relatedPlanSink =>
      _relatedPlanController!.sink as StreamSink<Response<RelatedPlanResponse>>;

  Stream<Response<RelatedPlanResponse>> get relatedPlanStream =>
      _relatedPlanController!.stream as Stream<Response<RelatedPlanResponse>>;

  StreamController? _relatedPlanController;

  initBloc() {
    _dataController = BehaviorSubject<Response<ReviewResponse>>();
    _relatedPlanController = BehaviorSubject<Response<RelatedPlanResponse>>();

    myNetworkClient = MyNetworkClient();
    _isStreaming = true;
  }

  fetchRelatedPlan(String? courseId) async {
    relatedPlanSink.add(Response.loading('Getting a Data!'));
    try {
      // var t = await Preference.getString(token);

      RelatedPlanResponse response =
          await myNetworkClient.getRelatedPlans(courseId);
      relatedPlanSink.add(Response.completed(response));
    } catch (e) {
      // RelatedPlanResponse response = new RelatedPlanResponse.fromJson(status: false, message: "Record Not found", data: []);
      relatedPlanSink.add(Response.error("${e.toString()}"));

      print(e);
    }
  }

  updateRelatedPlan(RelatedPlanResponse? systemSettings) {
    relatedPlanSink.add(Response.completed(systemSettings));
  }

  fetchData(String? courseId) async {
    dataSink.add(Response.loading('Getting a Data!'));
    try {
      var t = await Preference.getString(token);

      ReviewResponse response =
          await myNetworkClient.getReviews(Common.checkNullOrNot(t), courseId);
      dataSink.add(Response.completed(response));
    } catch (e) {
      ReviewResponse response = new ReviewResponse(
          status: false, message: "Record Not found", data: []);
      dataSink.add(Response.completed(response));
      print(e);
    }
  }

  Future<ReviewResponse> addedReview(String? courseId, String firstName,
      String lastName, double rating, String review) async {
    var t = await Preference.getString(token);

    var request = ReviewAddedRequest(
        authToken: Common.checkNullOrNot(t),
        courseId: courseId,
        firstName: firstName,
        lastName: lastName,
        isMyReview: false,
        rating: rating,
        review: review);

    ReviewResponse response = await myNetworkClient.reviewAdded(request);
    return response;
  }

  dispose() {
    _isStreaming = false;
    _dataController?.close();
    _relatedPlanController?.close();
  }
}
