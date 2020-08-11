import 'package:mr_blogger/data/app_database.dart';
import 'package:mr_blogger/models/blogs.dart';
import 'package:sembast/sembast.dart';

class BlogDao {
  static const String BLOG_STORE_NAME = 'blogs';

  final _blogStore = intMapStoreFactory.store(BLOG_STORE_NAME);

  Future<Database> get _db async => AppDatabase.instance.database;

  Future<List<Blogs>> getBlogs() async {
    print('blogsStrore $_blogStore');
    final recordSnapshot = await _blogStore.find(await _db);
    print('recordnapshot $recordSnapshot');
    return recordSnapshot.map((snapshot) {
      final blog = Blogs.fromJson(snapshot.value);
      return blog;
    }).toList();
  }
}
