import 'package:flutter/material.dart';
import 'package:flash_chat/components/message_bubble.dart';
import 'package:flutter_dialogflow/dialogflow_v2.dart';

class NCIBotDialogFlow extends StatefulWidget {
  NCIBotDialogFlow({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _NCIBotDialogFlowState createState() => new _NCIBotDialogFlowState();
}

class _NCIBotDialogFlowState extends State<NCIBotDialogFlow> {
  final List<MessageBubble> _messages = <MessageBubble>[];
  final TextEditingController _textController = new TextEditingController();

  Widget _queryInputWidget(BuildContext context) {
    return Container(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
        child: Row(
          children: <Widget>[
            Flexible(
              child: TextField(
                controller: _textController,
                onSubmitted: _submitQuery,
                decoration:
                    InputDecoration.collapsed(hintText: "Send a message"),
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
    MessageBubble message = MessageBubble(
      text: response.getMessage() ??
          CardDialogflow(response.getListMessage()[0]).title,
      sender: "Flutter Bot",
      isMe: false,
      isBot: true,
    );
    setState(() {
      _messages.insert(0, message);
    });
  }

  void _submitQuery(String text) {
    _textController.clear();
    MessageBubble message = new MessageBubble(
      text: text,
      sender: "Meeeee",
      isMe: true,
      isBot: false,
    );
    setState(() {
      _messages.insert(0, message);
    });
    _dialogFlowResponse(text.replaceAll("'", "\\'"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("NCI-BOT"),
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
