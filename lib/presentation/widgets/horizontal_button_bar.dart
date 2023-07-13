import 'package:flutter/material.dart';

class HorizontalButtonBar extends StatelessWidget {
  HorizontalButtonBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      // appBar: AppBar(
      //   title: const Text('Page Car'),
      //   centerTitle: true,
      //   backgroundColor: Colors.black,
      // ),
      child: Row(
        children: <Widget>[
          FloatingActionButton(
            heroTag: 'add category button',
            onPressed: () {
              Navigator.of(context).pushReplacementNamed('/addCar');
            },
            child: Icon(Icons.playlist_add_rounded),
          ),
        ],
      ),

      // body: ListView.builder(
      //     // itemCount: _userList.length,
      //     itemBuilder: (context, index) {
      //   return Card(
      //     child: ListTile(
      //       onTap: () {
      //         // Navigator.push(
      //         //     context,
      //         //     MaterialPageRoute(
      //         //         builder: (context) => ViewCar(
      //         //               car: _userList[index],
      //         //             )));
      //       },
      //       leading: const Icon(Icons.person),
      //       // title: Text(_userList[index].name ?? ''),
      //       // subtitle: Text(_userList[index].police_no ?? ''),
      //       // trailing: Row(
      //       //   mainAxisSize: MainAxisSize.min,
      //       //   children: [
      //       //     IconButton(
      //       //         onPressed: () {
      //       //           Navigator.push(
      //       //               context,
      //       //               MaterialPageRoute(
      //       //                   builder: (context) => EditCar(
      //       //                         car: _userList[index],
      //       //                       ))).then((data)
      //       //                       {
      //       //             if (data != null) {
      //       //               getAllUserDetails();
      //       //               _showSuccessSnackBar(
      //       //                   'User Detail Updated Success');
      //       //             }
      //       //           });
      //       //           ;
      //       //         },
      //       //         icon: const Icon(
      //       //           Icons.edit,
      //       //           color: Colors.teal,
      //       //         )),
      //       //     IconButton(
      //       //         onPressed: () {
      //       //           _deleteFormDialog(context, _userList[index].id);
      //       //         },
      //       //         icon: const Icon(
      //       //           Icons.delete,
      //       //           color: Colors.red,
      //       //         ))
      //       //   ],
      //       // ),
      //     ),
      //   );
      // }),
    );
    // return Padding(
    //   padding: const EdgeInsets.all(8.0),
    //   child: Row(
    //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //     children: <Widget>[
    //           FloatingActionButton(
    //             heroTag: 'contacts',
    //             onPressed: () {
    //               Navigator.of(context).pushReplacementNamed('/addContactPage');
    //             },
    //             child: Icon(Icons.person_add),
    //           ),
    //           FloatingActionButton(
    //             heroTag: 'search',
    //             onPressed: () {
    //               Navigator.of(context).pushReplacementNamed('/searchPage');
    //             },
    //             child: Icon(Icons.search),
    //           ),
    //       FloatingActionButton(
    //         heroTag: 'add category button',
    //         onPressed: () {
    //           Navigator.of(context).pushReplacementNamed('/addCategoryPage');
    //         },
    //         child: Icon(Icons.playlist_add_rounded),
    //       ),
    //           FloatingActionButton(
    //             heroTag: 'search contact by category',
    //             onPressed: () {
    //               Navigator.of(context)
    //                   .pushReplacementNamed('/searchContactsByCategory');
    //             },
    //             child: Icon(Icons.list),
    //           ),
    //       FloatingActionButton(
    //         onPressed: () {
    //           Navigator.push(context,
    //                   MaterialPageRoute(builder: (context) => const AddCar()))
    //               .then((data) {
    //             if (data != null) {
    //               // getAllUserDetails();
    //               // _showSuccessSnackBar('Car Detail Added Success');
    //             }
    //           });
    //         },
    //         child: const Icon(
    //           Icons.add,
    //           color: Colors.black,
    //         ),
    //       ),
    //     ],
    //   ),
    // );
  }
}
