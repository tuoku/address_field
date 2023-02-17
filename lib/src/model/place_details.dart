import 'result.dart';

class PlaceDetails {
  List<String>? htmlAttributions;
  Result? result;
  String? status;

  PlaceDetails({this.htmlAttributions, this.result, this.status});

  PlaceDetails.fromJson(Map<String, dynamic> json) {
    if (json['html_attributions'] != null) {
      htmlAttributions = <String>[];
      json['html_attributions'].forEach((v) {
        htmlAttributions!.add(v);
      });
    }
    result =
        json['result'] != null ? new Result.fromJson(json['result']) : null;
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.htmlAttributions != null) {
      data['html_attributions'] = this.htmlAttributions!.map((v) => v).toList();
    }
    if (this.result != null) {
      data['result'] = this.result!.toJson();
    }
    data['status'] = this.status;
    return data;
  }
}
