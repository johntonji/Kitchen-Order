import 'package:http/http.dart';

class ApiResponse {
  Response? response;
  StreamedResponse? streamedResponse;
  dynamic error;

  ApiResponse(this.response, this.streamedResponse, this.error);

  ApiResponse.withError(dynamic errorValue)
      : response = null,
        streamedResponse = null,
        error = errorValue;

  ApiResponse.withSuccess(Response responseValue)
      : response = responseValue,
        error = null,
        streamedResponse = null;

  ApiResponse.withSuccessStream(StreamedResponse responseValue)
      : response = null,
        error = null,
        streamedResponse = responseValue;
}
