import 'package:mr_blogger/data/app_database.dart';
import 'package:mr_blogger/models/blogs.dart';
import 'package:sembast/sembast.dart';

class BlogDao {
  static const String BLOG_STORE_NAME = 'blogs';

  final _blogStore = intMapStoreFactory.store(BLOG_STORE_NAME);

  Future<Database> get _db async => AppDatabase.instance.database;

  Future insert(Blogs blog) async {
    var key = await _blogStore.add(await _db, blog.toJson());
    var record = _blogStore.record(key);
    await record.put(await _db, blog.toJson(), merge: true);
  }

  Future<List<Blogs>> getAllSortedByTImeStamp() async {
    final finder = Finder(sortOrders: [SortOrder("timeStamp", false)]);

    final snapshot = await _blogStore.find(
      await _db,
      finder: finder,
    );
    return snapshot.map((snapshot) {
      final blog = Blogs.fromJson(snapshot.value);
      return blog;
    }).toList();
  }
}
