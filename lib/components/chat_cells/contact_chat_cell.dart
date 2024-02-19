import 'package:foap/helper/imports/chat_imports.dart';
import 'package:foap/helper/imports/common_import.dart';

class ContactChatTile extends StatelessWidget {
  final ChatMessageModel message;

  const ContactChatTile({Key? key, required this.message}) : super(key: key);

  //addon comment design related changes

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 5),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Heading6Text(
                LocalizationString.contact, weight: TextWeight.bold,color: message.isMineMessage ? AppColorConstants.grayscale900 : AppColorConstants.whiteClr),
              const SizedBox(height: 2),
              BodyLargeText(
                message.mediaContent.contact!.displayName,
                fSize: FontSizes.b3,
                color: message.isMineMessage ? AppColorConstants.grayscale900 : AppColorConstants.whiteClr
              ),
              const SizedBox(height: 2),
              BodyLargeText(
                message.mediaContent.contact!.phones.map((e) => e.number).toString(),
                fSize: FontSizes.b3,
                color: message.isMineMessage ? AppColorConstants.grayscale900 : AppColorConstants.whiteClr
              ),
            ],
          ),
        ),
        const SizedBox(width: 5),
        ThemeIconWidget(
          ThemeIcon.nextArrow,
          size: 15,
          color: message.isMineMessage ? AppColorConstants.grayscale900 : AppColorConstants.whiteClr,
        )
      ],
    ).bP8;
  }
}
