import 'package:foap/helper/imports/chat_imports.dart';
import 'package:foap/helper/imports/common_import.dart';
import 'package:google_static_maps_controller/google_static_maps_controller.dart';

class LocationChatTile extends StatelessWidget {
  final ChatMessageModel message;
  const LocationChatTile({Key? key, required this.message}) : super(key: key);

  //addon comment design related changes

  @override
  Widget build(BuildContext context) {
    var controller = StaticMapController(
      googleApiKey: AppConfigConstants.googleMapApiKey,
      height: (MediaQuery.of(context).size.width * 0.65).toInt(),
      width: (MediaQuery.of(context).size.width * 0.65).toInt(),
      zoom: 15,
      center: Location(message.mediaContent.location!.latitude,
          message.mediaContent.location!.longitude),
    );
    ImageProvider image = controller.image;

    return Image(image: image).round(10);
  }
}
