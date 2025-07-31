import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Initialize Firebase
  static Future<void> initialize() async {
    await Firebase.initializeApp();
  }

  // Save post to Firestore
  Future<void> savePost({
    required String title,
    required String content,
    required String mood,
    required List<String> supportTypes,
    required bool allowComments,
    required String visibility,
    PlatformFile? file,
  }) async {
    try {
      String? fileUrl;

      // Upload file if exists and has bytes
      if (file != null && file.bytes != null) {
        final ref = _storage.ref(
          'posts/${DateTime.now().millisecondsSinceEpoch}',
        );
        await ref.putData(file.bytes!);
        fileUrl = await ref.getDownloadURL();
      }

      // Validate required fields
      if (title.isEmpty || content.isEmpty || mood.isEmpty) {
        throw Exception('Required fields are missing');
      }

      // Save post data
      await _firestore.collection('posts').add({
        'title': title,
        'content': content,
        'mood': mood,
        'supportTypes': supportTypes,
        'allowComments': allowComments,
        'visibility': visibility,
        'fileUrl': fileUrl, // can be null
        'createdAt': FieldValue.serverTimestamp(),
        'likeCount': 0,
        'commentCount': 0,
        'isAnonymous': true,
      });
    } catch (e) {
      throw Exception('Failed to save post: ${e.toString()}');
    }
  }

  // Get all posts
  Stream<QuerySnapshot> getPosts() {
    return _firestore
        .collection('posts')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // Get replies for a specific post
  Stream<QuerySnapshot> getRepliesStream(String postId) {
    return _firestore
        .collection('posts')
        .doc(postId)
        .collection('replies')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }

  // Get a single post by ID
  Future<DocumentSnapshot> getPost(String postId) {
    return _firestore.collection('posts').doc(postId).get();
  }

  // Add a reply to a post
  Future<void> addReply(String postId, Map<String, dynamic> replyData) async {
    try {
      // Add timestamp to reply data
      replyData['timestamp'] = FieldValue.serverTimestamp();

      await _firestore
          .collection('posts')
          .doc(postId)
          .collection('replies')
          .add(replyData);

      // Update reply count
      await _firestore.collection('posts').doc(postId).update({
        'commentCount': FieldValue.increment(1),
      });
    } catch (e) {
      throw Exception('Failed to add reply: $e');
    }
  }

  // Like a post
  Future<void> likePost(String postId, bool isLiked) async {
    try {
      await _firestore.collection('posts').doc(postId).update({
        'likeCount': FieldValue.increment(isLiked ? -1 : 1),
      });
    } catch (e) {
      throw Exception('Failed to like post: $e');
    }
  }
}
