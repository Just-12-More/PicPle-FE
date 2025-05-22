import 'package:picple/data/model/response/nearby_photos_response.dart';

import '../model/request/nearby_photos_request.dart';
import '../model/response/base_response.dart';

abstract class PhotoDataSource {
  Future<BaseResponse<NearbyPhotosData>> getNearbyPhotos(NearbyPhotosRequest request);
}