import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:typed_data';
import 'message.dart';

//Add Your API Key in .env file as
//      apiKey='your key value'

class ChatScreen extends StatefulWidget {
  const ChatScreen({
    super.key,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late final GenerativeModel _model;
  late final ChatSession _chat;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textController = TextEditingController();
  final FocusNode _textFieldFocus = FocusNode();
  final List<({Image? image, String? text, bool fromUser})> _generatedContent =
      <({Image? image, String? text, bool fromUser})>[];
  bool _loading = false;
  bool _waitingForPrompt = false;
  Image? _selectedImage;
  Uint8List? _imageBytes;

  String? _apiKey = dotenv.env['apiKey'];

  @override
  void initState() {
    super.initState();
    _model = GenerativeModel(
      model: 'gemini-1.5-flash-latest',
      apiKey: _apiKey.toString(),
    );
    _chat = _model.startChat();
  }

  void _scrollDown() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(
          milliseconds: 750,
        ),
        curve: Curves.easeOutCirc,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textFieldDecoration = InputDecoration(
      contentPadding: const EdgeInsets.all(15),
      hintText: 'Ask here......',
      border: OutlineInputBorder(
        borderRadius: const BorderRadius.all(
          Radius.circular(14),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(
          Radius.circular(14),
        ),
      ),
    );

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: _apiKey!.isNotEmpty
                ? ListView.builder(
                    controller: _scrollController,
                    itemBuilder: (context, idx) {
                      final content = _generatedContent[idx];
                      return MessageWidget(
                        text: content.text,
                        image: content.image,
                        isFromUser: content.fromUser,
                      );
                    },
                    itemCount: _generatedContent.length,
                  )
                : ListView(
                    children: const [
                      Text(
                        'No API key found error'
                        "'set api key pls",
                      ),
                    ],
                  ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 25,
              horizontal: 15,
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    autofocus: true,
                    focusNode: _textFieldFocus,
                    decoration: textFieldDecoration,
                    controller: _textController,
                    onSubmitted: _waitingForPrompt
                        ? _sendImagePromptMessage
                        : _sendChatMessage,
                  ),
                ),
                const SizedBox.square(dimension: 15),
                IconButton(
                  onPressed: !_loading && !_waitingForPrompt
                      ? _pickImageFromGallery
                      : null,
                  icon: Icon(
                    _selectedImage == null ? Icons.image : Icons.check_box,
                    color: _loading || _waitingForPrompt
                        ? Theme.of(context).colorScheme.secondary
                        : Theme.of(context).colorScheme.primary,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    _sendChatMessage;
                  },
                  icon: Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickImageFromGallery() async {
    setState(() {
      _loading = true;
    });

    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final File imageFile = File(pickedFile.path);
      final Uint8List imageBytes = await imageFile.readAsBytes();

      setState(() {
        _loading = false;
        _waitingForPrompt = true;
        _selectedImage = Image.memory(imageBytes);
        _imageBytes = imageBytes;
      });
    } else {
      setState(() {
        _loading = false;
      });
    }
  }

  Future<void> _sendImagePromptMessage(String message) async {
    if (message.isEmpty || _imageBytes == null) {
      return;
    }

    setState(() {
      _loading = true;
    });

    try {
      final content = [
        Content.multi([
          TextPart(message),
          DataPart('image/jpeg', _imageBytes!),
        ])
      ];

      _generatedContent.add((
        image: _selectedImage,
        text: message,
        fromUser: true,
      ));

      var response = await _model.generateContent(content);
      var text = response.text;
      _generatedContent.add((image: null, text: text, fromUser: false));

      if (text == null) {
        _showError('No response from API.');
        return;
      } else {
        setState(() {
          _loading = false;
          _selectedImage = null;
          _waitingForPrompt = false;
          _scrollDown();
        });
      }
    } catch (e) {
      _showError(e.toString());
      setState(() {
        _loading = false;
        _waitingForPrompt = false;
      });
    } finally {
      _textController.clear();
      setState(() {
        _loading = false;
      });
      _textFieldFocus.requestFocus();
    }
  }

  Future<void> _sendChatMessage(String message) async {
    setState(() {
      _loading = true;
    });

    try {
      _generatedContent.add((image: null, text: message, fromUser: true));

      final response = await _chat.sendMessage(
        Content.text(message),
      );

      final text = response.text;

      _generatedContent.add((image: null, text: text, fromUser: false));

      setState(() {
        _loading = false;
        _scrollDown();
      });
    } catch (e) {
      _showError(e.toString());
      setState(() {
        _loading = false;
      });
    } finally {
      _textController.clear();
      setState(() {
        _loading = false;
      });
      _textFieldFocus.requestFocus();
    }
  }

  void _showError(String message) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Something went wrong'),
          content: SingleChildScrollView(
            child: SelectableText(message),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            )
          ],
        );
      },
    );
  }
}
