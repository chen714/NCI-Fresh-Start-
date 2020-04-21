import 'package:flash_chat/constants/colorAndDesignConstants.dart';
import 'package:flash_chat/constants/constants.dart';
import 'package:flash_chat/screens/home/chat_screen.dart';
import 'package:flash_chat/services/authService.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/components/message_bubble.dart';
import 'package:flutter_dialogflow/dialogflow_v2.dart';
import 'package:flash_chat/models/user.dart';
import 'package:provider/provider.dart';
import 'package:flash_chat/models/message.dart';

User user;

class NCIBotDialogFlow extends StatefulWidget {
  NCIBotDialogFlow({Key key, this.userData}) : super(key: key);
  final UserData userData;

  @override
  _NCIBotDialogFlowState createState() => new _NCIBotDialogFlowState();
}

class _NCIBotDialogFlowState extends State<NCIBotDialogFlow> {
  final List<MessageBubble> _messages = <MessageBubble>[];
  final TextEditingController _textController = new TextEditingController();
  AuthService _authService = AuthService();

  Widget _queryInputWidget(BuildContext context) {
    user = Provider.of<User>(context);
    return Container(
      decoration: kMessageContainerDecoration,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
        child: Row(
          children: <Widget>[
            Flexible(
              child: TextField(
                minLines: 1,
                maxLines: 3,
                controller: _textController,
                decoration: kTextFieldDecoration,
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4.0),
              child: IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () => _submitQuery(_textController.text)),
            ),
          ],
        ),
      ),
    );
  }

  void _dialogFlowResponse(query) async {
    _textController.clear();
    AuthGoogle authGoogle =
        await AuthGoogle(fileJson: "assets/flash-chat-483ae-15111a3d7082.json")
            .build();
    Dialogflow dialogFlow =
        Dialogflow(authGoogle: authGoogle, language: Language.english);
    AIResponse response = await dialogFlow.detectIntent(query);
    Message message = Message(
      text: response.getMessage() ??
          'Opps Something went wrong, try asking me a question again.',
      sender: "virtualassistant@ncirl.ie",
      senderDisplayName: 'NCI Help Desk',
      isMe: false,
      dateTime: DateTime.now(),
    );
    MessageBubble messageBubble = MessageBubble(msg: message);
    setState(() {
      _messages.insert(0, messageBubble);
    });
  }

  void _submitQuery(String text) {
    _textController.clear();

    Message message = new Message(
      text: text,
      sender: user.email,
      senderDisplayName: userData.name,
      isMe: true,
      dateTime: DateTime.now(),
    );
    MessageBubble msgBubble = MessageBubble(msg: message);
    setState(() {
      _messages.insert(0, msgBubble);
    });
    _dialogFlowResponse(text.replaceAll("'", "\\'"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("NCI Virtual Assistant"),
        backgroundColor: kPrimaryColourDark,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                //Implement logout functionality
                _authService.signOut();
                Navigator.popUntil(context, ModalRoute.withName('/'));
              }),
        ],
      ),
      body: Column(children: <Widget>[
        Flexible(
            child: ListView.builder(
          padding: EdgeInsets.all(8.0),
          reverse: true, //To keep the latest messages at the bottom
          itemBuilder: (_, int index) => _messages[index],
          itemCount: _messages.length,
        )),
        Divider(height: 1.0),
        Container(
          decoration: new BoxDecoration(color: Theme.of(context).cardColor),
          child: _queryInputWidget(context),
        ),
      ]),
    );
  }
}
