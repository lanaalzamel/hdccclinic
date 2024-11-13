import 'package:get/get.dart';
import 'package:hdccapp/module/patient/recommendation/recommendation_server.dart';

import '../../../models/recommendation_model.dart';


class RecommendationController extends GetxController {
  var recommendations = <Recommendation>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchRecommendations();
  }

  Future<void> fetchRecommendations() async {
    try {
      isLoading(true);
      var fetchedRecommendations = await RecomendationSrevecie().getRecomendation("15|z8A9nowLTsTXdAdhLNDUdASSa5yKyVXVi4GasQ0Qc3e0b5cb");
      if (fetchedRecommendations.isNotEmpty) {
        recommendations.value = fetchedRecommendations;
      } else {
        recommendations.clear();
      }
    } catch (e) {
      print("Error fetching recommendations: $e");
    } finally {
      isLoading(false);
    }
  }
}
