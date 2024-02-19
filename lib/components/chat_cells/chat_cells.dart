import 'dart:convert';

import 'package:foap/helper/imports/chat_imports.dart';
import 'package:foap/helper/imports/common_import.dart';
import 'package:foap/helper/string_extension.dart';
import 'package:get/get.dart';
import 'package:visibility_detector/visibility_detector.dart';

class ChatMessageTile extends StatefulWidget {
  final ChatMessageModel message;
  final bool showName;
  final bool actionMode;
  final Function(ChatMessageModel) replyMessageTapHandler;
  final Function(ChatMessageModel) messageTapHandler;

  ChatMessageTile(
      {Key? key,
      required this.message,
      required this.showName,
      required this.actionMode,
      required this.replyMessageTapHandler,
      required this.messageTapHandler})
      : super(key: key);

  @override
  State<ChatMessageTile> createState() => _ChatMessageTileState();
}

class _ChatMessageTileState extends State<ChatMessageTile> {
  final ChatDetailController chatDetailController = Get.find();

  //addon comment design related changes

  @override
  Widget build(BuildContext context) {
    return
      widget.message.messageContentType == MessageContentType.groupAction
        ?
      ChatGroupActionCell(message: widget.message)
        :
      Row(
            children: [
              widget.actionMode
                  ? Obx(() => Row(
                        children: [
                          ThemeIconWidget(
                            chatDetailController.isSelected(widget.message)
                                ? ThemeIcon.checkMarkWithCircle
                                : ThemeIcon.circleOutline,
                            size: 20,
                            color: AppColorConstants.disabledColor,
                          ).ripple(() {
                            chatDetailController.selectMessage(widget.message);
                          }),
                          const SizedBox(
                            width: 10,
                          )
                        ],
                      ))
                  : Container(),
              Expanded(
                child: Row(
                  mainAxisAlignment: widget.message.isMineMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
                  children: [
                    IntrinsicWidth(
                      child: Container(
                        constraints: BoxConstraints(minWidth: MediaQuery.of(context).size.width * 0.23,maxWidth: MediaQuery.of(context).size.width * 0.75),
                        color: widget.message.messageContentType == MessageContentType.gif ||
                            widget.message.messageContentType ==
                                MessageContentType.sticker
                            ? Colors.transparent
                            : widget.message.isMineMessage
                            ? AppColorConstants.backgroundColor
                            : AppColorConstants.themeColor.darken(0.05),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            widget.showName ? nameWidget(context) : Container(),
                            widget.message.messageContentType == MessageContentType.forward
                                ? Row(
                              children: [
                                ThemeIconWidget(
                                  ThemeIcon.fwd,
                                  size: 15,
                                  color: AppColorConstants.iconColor,
                                ).rotate(-40).rP4,
                                BodyLargeText(
                                  LocalizationString.forward,
                                ),
                              ],
                            )
                                : Container(),
                            const SizedBox(
                              height: 2,
                            ),
                            widget.message.isDeleted == true
                                ? deletedMessageWidget()
                                : widget.message.isReply
                                ? replyContentWidget()
                                : contentWidget(widget.message).ripple(() {
                              widget.messageTapHandler(widget.message);
                            }),
                            const SizedBox(
                              height: 1,
                            ),
                            MessageDeliveryStatusView(message: widget.message),
                          ],
                        ).p8,
                      ).round(10),
                    ),
                  ],
                ),
              )
              // message.isMineMessage ? Container() : const Spacer(),
            ],
          );
  }

  Widget deletedMessageWidget() {
    return DeletedMessageChatTile(message: widget.message);
  }

  Widget replyContentWidget() {
    if (widget.message.messageReplyContentType == MessageContentType.text) {
      return ReplyTextChatTile(
        message: widget.message,
        messageTapHandler: widget.messageTapHandler,
        replyMessageTapHandler: widget.replyMessageTapHandler,
      );
    } else if (widget.message.messageReplyContentType == MessageContentType.photo) {
      return ReplyImageChatTile(
          message: widget.message,
          messageTapHandler: widget.messageTapHandler,
          replyMessageTapHandler: widget.replyMessageTapHandler);
    } else if (widget.message.messageReplyContentType == MessageContentType.gif) {
      return ReplyStickerChatTile(
          message: widget.message,
          messageTapHandler: widget.messageTapHandler,
          replyMessageTapHandler: widget.replyMessageTapHandler);
    } else if (widget.message.messageReplyContentType == MessageContentType.video) {
      return ReplyVideoChatTile(
          message: widget.message,
          messageTapHandler: widget.messageTapHandler,
          replyMessageTapHandler: widget.replyMessageTapHandler);
    } else if (widget.message.messageReplyContentType == MessageContentType.audio) {
      return ReplyAudioChatTile(
          message: widget.message, replyMessageTapHandler: widget.replyMessageTapHandler);
    } else if (widget.message.messageReplyContentType == MessageContentType.contact) {
      return ReplyContactChatTile(
          message: widget.message,
          messageTapHandler: widget.messageTapHandler,
          replyMessageTapHandler: widget.replyMessageTapHandler);
    } else if (widget.message.messageReplyContentType ==
        MessageContentType.location) {
      return ReplyLocationChatTile(
          message: widget.message,
          messageTapHandler: widget.messageTapHandler,
          replyMessageTapHandler: widget.replyMessageTapHandler);
    } else if (widget.message.messageReplyContentType == MessageContentType.profile) {
      return ReplyUserProfileChatTile(
          message: widget.message,
          messageTapHandler: widget.messageTapHandler,
          replyMessageTapHandler: widget.replyMessageTapHandler);
    } else if (widget.message.messageReplyContentType == MessageContentType.file) {
      return ReplyFileChatTile(
          message: widget.message,
          messageTapHandler: widget.messageTapHandler,
          replyMessageTapHandler: widget.replyMessageTapHandler);
    }
    return TextChatTile(message: widget.message);
  }

  Widget contentWidget(ChatMessageModel messageModel) {
    if (messageModel.messageContentType == MessageContentType.text) {
      return TextChatTile(message: messageModel);
    } else if (messageModel.messageContentType == MessageContentType.photo) {
      return ImageChatTile(message: messageModel);
    } else if (messageModel.messageContentType == MessageContentType.gif) {
      return StickerChatTile(message: messageModel);
    } else if (messageModel.messageContentType == MessageContentType.video) {
      return VideoChatTile(message: messageModel);
    } else if (messageModel.messageContentType == MessageContentType.audio) {
      return AudioChatTile(message: messageModel);
    } else if (messageModel.messageContentType == MessageContentType.post) {
      return PostChatTile(message: messageModel);
    } else if (messageModel.messageContentType == MessageContentType.location) {
      return LocationChatTile(message: messageModel);
    } else if (messageModel.messageContentType == MessageContentType.forward) {
      return contentWidget(messageModel.originalMessage);
    } else if (messageModel.messageContentType == MessageContentType.contact) {
      return ContactChatTile(message: messageModel);
    } else if (messageModel.messageContentType == MessageContentType.profile) {
      return UserProfileChatTile(message: messageModel);
    } else if (messageModel.messageContentType == MessageContentType.file) {
      return FileChatTile(message: messageModel);
    }
    return TextChatTile(message: widget.message);
  }

  Widget nameWidget(BuildContext context) {
    return BodyLargeText(
      widget.message.isMineMessage ? LocalizationString.you : widget.message.sender!.userName,
      weight: TextWeight.bold,
      fSize: FontSizes.b3,
        // color: Colors.red,

    );
  }
}

class MessageDeliveryStatusView extends StatefulWidget {
  final ChatMessageModel message;

  const MessageDeliveryStatusView({Key? key, required this.message})
      : super(key: key);

  @override
  State<MessageDeliveryStatusView> createState() => _MessageDeliveryStatusViewState();
}

class _MessageDeliveryStatusViewState extends State<MessageDeliveryStatusView> {
  @override
  Widget build(BuildContext context) {
    final ChatDetailController chatDetailController = Get.find();

    return VisibilityDetector(
        key: UniqueKey(),
        onVisibilityChanged: (visibilityInfo) {
          var visiblePercentage = visibilityInfo.visibleFraction * 100;

          //addon comment

          /*if (!widget.message.isMineMessage && widget.message.messageStatusType != MessageStatus.read && widget.message.messageContentType != MessageContentType.groupAction) {
            print("called    ${widget.message.textMessage}");
            chatDetailController.sendMessageAsRead(widget.message);
            widget.message.status = 3;
          }*/
          if (!widget.message.isMineMessage && visiblePercentage > 90) {
            if (widget.message.messageStatusType != MessageStatus.read && widget.message.messageContentType != MessageContentType.groupAction && !widget.message.isDateSeparator) {
              chatDetailController.sendMessageAsRead(widget.message);
              widget.message.status = 3;
            }
          }



        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            widget.message.isStar == 1
                ? ThemeIconWidget(
                    ThemeIcon.filledStar,
                    color: AppColorConstants.themeColor,
                    size: 15,
                  ).rP4
                : Container(),
            BodyExtraSmallText(
              widget.message.messageTime,
              weight:TextWeight.medium,
              color: widget.message.isMineMessage ?   AppColorConstants.iconColor : AppColorConstants.whiteClr ,
            ),
            const SizedBox(
              width: 5,
            ),
            widget.message.isMineMessage
                ? ThemeIconWidget(
                    widget.message.messageStatusType == MessageStatus.sent
                        ? ThemeIcon.sent
                        : widget.message.messageStatusType == MessageStatus.delivered
                            ? ThemeIcon.delivered
                            : widget.message.messageStatusType == MessageStatus.read
                                ? ThemeIcon.read
                                : ThemeIcon.sending,
                    size: 15,
                    color: widget.message.messageStatusType == MessageStatus.read
                        ? Colors.blue
                        : AppColorConstants.iconColor,
                  )
                : Container(),
          ],
        ));
  }
}
