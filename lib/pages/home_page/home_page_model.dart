import '/flutter_flow/flutter_flow_util.dart';
import 'home_page_widget.dart' show HomePageWidget;
import 'package:flutter/material.dart';

class HomePageModel extends FlutterFlowModel<HomePageWidget> {
  ///  Local state fields for this page.

  String? recognizedTextVar;

  ///  State fields for stateful widgets in this page.

  bool isDataUploading_imageFromButton = false;
  FFUploadedFile uploadedLocalFile_imageFromButton =
      FFUploadedFile(bytes: Uint8List.fromList([]), originalFilename: '');

  // Stores action output result for [Custom Action - preprocessImage] action in CaptureImage widget.
  FFUploadedFile? processedImage;
  // Stores action output result for [Custom Action - readTextFromImage] action in CaptureImage widget.
  String? recognizedText;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
