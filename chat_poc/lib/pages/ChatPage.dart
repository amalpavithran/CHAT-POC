import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:chat_poc/models/User.dart';
import 'package:chat_poc/models/Message.dart';
import 'package:chat_poc/models/Group.dart';
import 'package:chat_poc/models/ChatModel.dart';

class ChatPage extends StatefulWidget {
  final User contact;
  final Group group;

  ChatPage({this.contact, this.group});

  @override
  _ChatPageState createState() =>
      _ChatPageState(contact: this.contact, group: this.group);
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController myController = TextEditingController();
  final User contact;
  final Group group;

  _ChatPageState({this.contact, this.group});

  @override
  Widget build(BuildContext context) {
    print(group);
    return SafeArea(
      child: Column(
        children: [
          Flexible(
            fit: FlexFit.tight,
            child: getMessagesInChat(),
          ),
          buildChatArea(),
        ],
      ),
    );
  }

  Widget generateMessage(Message message) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            top: 10.0,
          ),
          child: Icon(
            Icons.account_circle,
            size: 40,
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.7,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
              bottomRight: Radius.circular(15),
            ),
            color: message.senderID == this.contact.userID
                ? const Color(0x0f1f6b9c)
                : const Color(0xee0a6da8),
          ),
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.all(10),
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    message.senderID == contact.userID
                        ? Text(
                            'You',
                            style: TextStyle(color: const Color(0xee0a6da8)),
                          )
                        : Text(
                            message.senderID,
                            style: TextStyle(color: Colors.amber[800]),
                          ),
                    Text(message.time),
                  ],
                ),
                SizedBox(
                  height: 6,
                ),
                Text(message.content)
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget getMessagesInChat() {
    return ScopedModelDescendant<ChatModel>(
      builder: (context, child, model) {
        List<Message> messages = (group == null)
            ? model.getMessagesForUserID(this.contact.userID)
            : model.getMessagesForUserID(this.group.groupID);

        return Container(
          height: MediaQuery.of(context).size.height * 0.75,
          child: ListView.builder(
            itemBuilder: (BuildContext context, int index) =>
                generateMessage(messages[index]),
            itemCount: messages.length,
          ),
        );
      },
    );
  }

  Widget buildChatArea() {
    return ScopedModelDescendant<ChatModel>(
      builder: (context, child, model) {
        return Container(
          color: Colors.white,
          child: Row(
            children: [
              Icon(Icons.attach_file),
              Container(
                width: MediaQuery.of(context).size.width * 0.8,
                child: TextField(
                  controller: myController,
                ),
              ),
              Icon(Icons.mic_none),
              Icon(Icons.send),
            ],
          ),
        );
      },
    );
  }
}