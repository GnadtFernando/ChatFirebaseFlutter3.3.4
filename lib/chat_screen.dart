import 'dart:io';

import 'package:chat_firebase/chat_message.dart';
import 'package:chat_firebase/text_composer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  User? _currentUser;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    FirebaseAuth.instance.authStateChanges().listen((user) {
      setState(() {
        _currentUser = user;
      });
    });
  }

  Future<User?> _getUser() async {
    if (_currentUser != null) return _currentUser;
    try {
      final GoogleSignInAccount googleSignInAccount =
          await _googleSignIn.signIn() as GoogleSignInAccount;
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken,
      );

      final UserCredential authResult =
          await FirebaseAuth.instance.signInWithCredential(credential);

      final User user = authResult.user!;
      return user;
    } catch (error) {
      return null;
    }
  }

  void _sendMessage({String? text, XFile? imgFile}) async {
    final User? user = await _getUser();

    if (user == null) {
      const snackBar = SnackBar(
        content: Text('Não foi possível fazer o login. Tente novamente!'),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    Map<String, dynamic> data = {
      'uid': user!.uid,
      'senderName': user.displayName,
      'senderPhotoUrl': user.photoURL,
      'time': Timestamp.now(),
    };
    if (imgFile != null) {
      UploadTask task = FirebaseStorage.instance
          .ref()
          .child(user.uid + DateTime.now().millisecondsSinceEpoch.toString())
          .putFile(File(imgFile.path));

      setState(() {
        _isLoading = true;
      });

      TaskSnapshot taskSnapshot = await task;
      String url = await taskSnapshot.ref.getDownloadURL();
      data['imgUrl'] = url;

      setState(() {
        _isLoading = false;
      });
    }

    if (text != null) data['text'] = text;
    FirebaseFirestore.instance.collection('messages').add(data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        title: Text(_currentUser != null
            ? 'Olá, ${_currentUser!.displayName}'
            : 'Chat App'),
        actions: [
          _currentUser != null
              ? IconButton(
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                    _googleSignIn.signOut();
                    const snackBar = SnackBar(
                      content: Text('Você saiu com sucesso!'),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  },
                  icon: const Icon(Icons.exit_to_app),
                )
              : Container(),
        ],
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('messages')
                  .orderBy('time')
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                switch (streamSnapshot.connectionState) {
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  default:
                    List<DocumentSnapshot> documents =
                        streamSnapshot.data!.docs.reversed.toList();

                    return ListView.builder(
                      itemCount: documents.length,
                      reverse: true,
                      itemBuilder: (context, index) {
                        return ChatMessage(
                          mine: (documents[index].data()
                                  as Map<String, dynamic>)['uid'] ==
                              _currentUser?.uid,
                          data: documents[index].data() as Map<String, dynamic>,
                        );
                      },
                    );
                }
              },
            ),
          ),
          _isLoading ? const LinearProgressIndicator() : Container(),
          TextComposer(
            sendMessage: _sendMessage,
          ),
        ],
      ),
    );
  }
}
