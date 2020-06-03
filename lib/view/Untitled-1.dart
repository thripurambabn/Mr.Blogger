// child: FutureBuilder(
//   // future: _blog,
//   builder: (_, snapshot) {
//     if (snapshot.connectionState == ConnectionState.waiting) {
//       return Center(
//           child: Image.network(
//               'https://i.pinimg.com/originals/2c/bb/5e/2cbb5e95b97aa2b496f6eaec84b9240d.gif'));
//     } else {
//       return new ListView.builder(
//           itemCount: blogsList.length,
//           itemBuilder: (BuildContext context, int index) {
//             print('${blogsList[index].title}');
//             return ListTile(
//               title: blogsUi(
//                   blogsList[index].image,
//                   blogsList[index].uid,
//                   blogsList[index].authorname,
//                   blogsList[index].title,
//                   blogsList[index].description,
//                   blogsList[index].likes,
//                   blogsList[index].date,
//                   blogsList[index].time),
//               onTap: () => navigateToDetailPage(blogsList[index]),
//             );
//           });
//     }
//   },
// ),
