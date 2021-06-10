import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:cached_network_image/cached_network_image.dart';
class TableOrderOnline extends StatefulWidget {
  const TableOrderOnline({Key key}) : super(key: key);

  @override
  _TableOrderOnlineState createState() => _TableOrderOnlineState();
}

class _TableOrderOnlineState extends State<TableOrderOnline> {
  final List<String> catList = [
    'Snacks',
    'BreakFast',
    'Dinner',
    'Lunch',
    'Snacks',
    'Snacks',
    'BreakFast',
    'Dinner',
    'Lunch',
    'Snacks'
  ];
  final List<String> itemName = [
    'Chilly',
    'Bread',
    'Chicken',
    'Chilly Chicken',
    'Mutton',
    'Meals',
    'Burger',
    'Pizza',
    'Dosa',
    'Idly'
  ];

  final List<int> quantity = [ ];
  int totalValue = 0;
  String _search;
  String _button = "All Items";
  List<String> addedToCart = [];
  List<double> addedPrice = [];
  List<double> cartPrice = [];
  List<int> addedQty = [];
  bool guestUserSignInSwitch = false;
  bool paymentType = false;
  bool searchButton = false;
  Color defaultColor = Colors.blue;
  var maskFormatter = new MaskTextInputFormatter(
      mask: '+61 (##) ####-####', filter: {"#": RegExp(r'[0-9]')});
  TextEditingController _mobileController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _searchController = TextEditingController();
  var _nameKey = GlobalKey<FormState>();
  var _mobileKey = GlobalKey<FormState>();


  List<Color> _catBgColor = [
    Color(0xFFF57C00),
    Colors.white,
    Colors.white,
    Colors.white,
    Colors.white,
    Colors.white,
    Colors.white,
  ];

  List<Color> _catTextColor = [
    Colors.white,
    Color(0xFF9E9E9E),
    Color(0xFF9E9E9E),
    Color(0xFF9E9E9E),
    Color(0xFF9E9E9E),
    Color(0xFF9E9E9E),
    Color(0xFF9E9E9E),
    Color(0xFF9E9E9E),
  ];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final orientation = MediaQuery.of(context).orientation;

    return SafeArea(
      child: StatefulBuilder(builder: (context, StateSetter showState) {
        return MaterialApp(
          title: 'User Ordering',
          home: Scaffold(
              floatingActionButton: Container(
                margin: EdgeInsets.all(8),
                color: Colors.blue,
                height: size.height * 0.05,
                width: size.width,
                child: Center(
                  child: InkWell(
                    onTap: () {
                      totalValue != 0 ? cartPopup() : print('Empty');
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          height: size.height * 0.06,
                          width: size.width * 0.06,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black,
                                blurRadius: 2.0,
                                spreadRadius: 0.0,
                                offset: Offset(
                                    2.0, 2.0), // shadow direction: bottom right
                              )
                            ],
                          ),
                          child: Center(
                            child: Text(
                              totalValue.toString(),
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: size.height * 0.03,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        Text(
                          'Pay',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: size.height * 0.03,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${addedPrice.fold(0, (previousValue, element) => previousValue + element).toStringAsFixed(2)}',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: size.height * 0.03,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              body: Container(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              // margin: EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black,
                                    blurRadius: 2.0,
                                    spreadRadius: 0.0,
                                    offset: Offset(2.0,
                                        2.0), // shadow direction: bottom right
                                  )
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Icon(
                                  Icons.more_vert_outlined,
                                  color: Colors.black,
                                  size: size.height * 0.03,
                                ),
                              ),
                            ),
                            Container(
                              // margin: EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black,
                                    blurRadius: 2.0,
                                    spreadRadius: 0.0,
                                    offset: Offset(2.0,
                                        2.0), // shadow direction: bottom right
                                  )
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Icon(
                                  Icons.fastfood_rounded,
                                  color: Colors.black,
                                  size: size.height * 0.03,
                                ),
                              ),
                            ),
                            Container(
                              // margin: EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black,
                                      blurRadius: 2.0,
                                      spreadRadius: 0.0,
                                      offset: Offset(2.0,
                                          2.0), // shadow direction: bottom right
                                    )
                                  ],
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12))),
                              child: Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: Text(
                                    'Dine In',
                                    style: TextStyle(
                                      fontSize: size.height * 0.03,
                                    ),
                                  )),
                            ),
                            InkWell(
                              onTap: (){
                                setState(() {
                                  searchButton = !searchButton;
                                });
                              },
                              child: Container(
                                // margin: EdgeInsets.all(10.0),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black,
                                      blurRadius: 2.0,
                                      spreadRadius: 0.0,
                                      offset: Offset(2.0,
                                          2.0), // shadow direction: bottom right
                                    )
                                  ],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: Icon(
                                    Icons.search,
                                    color: Colors.black,
                                    size: size.height * 0.03,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    searchButton == true ?  Container(
                        height: size.width <= 500
                            ? size.height * 0.05
                            : size.height * 0.1,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        margin: EdgeInsets.only(
                          left: size.width * 0.012,
                          right: size.width * 0.012,
                          bottom: size.width * 0.012,
                        ),
                        child: TextFormField(
                          controller: _searchController,
                          onChanged: (val) {
                            setState(() {
                              _search = val;
                            });
                          },
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            prefixIcon: Icon(Icons.search),
                            hintText: "Search",
                          ),
                        ),
                      ) : Container(),
                      Container(
                        height: size.width <= 500
                            ? size.height * 0.05
                            : size.height * 0.1,
                        // width: size.width,
                        child: StreamBuilder(
                          stream:  FirebaseFirestore.instance
                              .collection('posshop')
                              .doc('categories')
                              .collection('category')
                              .snapshots(),
                          builder: (context,AsyncSnapshot snapshot) {
                            if (!snapshot.hasData) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            }else{

                            catList.clear();
                            catList.add('All Items');
                            // setState(() {
                            //
                            // });
                            for (var i = 0;
                            i < snapshot.data.docs.length;
                            i++) {
                              catList.add(snapshot.data.docs[i]['category']);
                              // print(catList);
                            }
                            // print(snapshot.data.docs[1]['category']);
                            return ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: catList.length  ,
                              itemBuilder: (BuildContext ctxt, int index) {

                                return Row(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        showState(() {
                                          _button = catList[index];
                                          for (var i = 0;
                                          i < catList.length - 1;
                                          i++) {
                                            if (index == i) {
                                              _catBgColor[i] =
                                                  Color(0xFFF57C00);
                                              _catTextColor[i] = Colors.white;
                                            } else {
                                              _catBgColor[i] = Colors.white;
                                              _catTextColor[i] =
                                                  Color(0xFF9E9E9E);
                                            }
                                          }
                                        });
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: size.width * 0.02,
                                          vertical: size.height * 0.01,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(10.0),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey[400],
                                              blurRadius: 2.0,
                                              spreadRadius: 0.0,
                                              offset: Offset(2.0,
                                                  2.0), // shadow direction: bottom right
                                            )
                                          ],
                                        ),
                                        child: Row(
                                          children: [
                                            Text(
                                              catList[index],
                                              style: TextStyle(
                                                fontSize: size.width * 0.03,
                                                color: Colors.black,
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 10.0),
                                  ],
                                );
                              },
                            );
                          }}
                        ),
                      ),
                      Container(
                        child: StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection(
                               'posshop')
                                .doc("itemDetails")
                                .collection('items')
                                .orderBy('name')
                                .snapshots(),
                            builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
                                  var filteredDocs = [];

                                  if (!snapshot.hasData) {
                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }

                                  else {
                                    for (int index = 0;
                                    index < snapshot.data.docs.length;
                                    index++) {
                                      quantity.add(1);
                                      List button = [];
                                      String searchs =
                                      snapshot.data.docs[index]['name'];
                                      button.add(snapshot.data.docs[index]['cat']);

                                      if (_searchController.text
                                          .toLowerCase()
                                          .isNotEmpty ||
                                          _searchController.text.toLowerCase() != '') {
                                        if (searchs.toLowerCase().contains(
                                            _searchController.text.toLowerCase())) {
                                          filteredDocs.add(snapshot.data.docs[index]);
                                        }
                                      } else {
                                        if ((_button != null &&
                                            button
                                                .toString()
                                                .toLowerCase()
                                                .contains(_button.toLowerCase())) ||
                                            _button == "All Items") {
                                          filteredDocs.add(snapshot.data.docs[index]);
                                        }
                                      }
                                    }
                                  }
                            return GridView.builder(
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount:
                                      (orientation == Orientation.portrait) ? 2 : 3),
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              itemCount: filteredDocs.length,
                              itemBuilder: (BuildContext context, int index) {
                                return SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Stack(
                                        children: [
                                          Card(
                                            color: Colors.blue,
                                            semanticContainer: true,
                                            clipBehavior: Clip.antiAliasWithSaveLayer,
                                            child: Image.network(
                                               "images/wel.png",
                                              width: size.width,
                                              height: size.height * 0.2,
                                              // fit: BoxFit.contain,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                            elevation: 5,
                                            margin: EdgeInsets.all(10),
                                          ),
                                          Positioned(
                                              bottom: size.width * 0.03,
                                              right: size.width * 0.03,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Colors.white,
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black,
                                                      blurRadius: 2.0,
                                                      spreadRadius: 0.0,
                                                      offset: Offset(2.0,
                                                          2.0), // shadow direction: bottom right
                                                    )
                                                  ],
                                                ),
                                                child: IconButton(
                                                  onPressed: () {
                                                    showState(() {
                                                      addedToCart.contains(
                                                              filteredDocs[index]['name'])
                                                          ? totalValue -= 1
                                                          : totalValue += 1;



                                                      addedToCart.contains(
                                                          filteredDocs[index]['name'])
                                                          ? addedToCart
                                                              .remove( filteredDocs[index]['name'])
                                                          : addedToCart
                                                              .add( filteredDocs[index]['name']);
                                                      //
                                                      addedToCart.contains(
                                                          filteredDocs[index]['name'])
                                                          ? addedPrice
                                                              .add(filteredDocs[index]['price'])
                                                          : addedPrice.remove(
                                                          filteredDocs[index]['price']);

                                                      addedToCart.contains(
                                                          filteredDocs[index]['name'])
                                                          ? cartPrice
                                                              .add(filteredDocs[index]['price'])
                                                          : cartPrice.remove(
                                                          filteredDocs[index]['price']);

                                                      addedToCart.contains(
                                                          filteredDocs[index]['name'])
                                                          ? addedQty
                                                              .add(quantity[index])
                                                          : addedQty.remove(
                                                              quantity[index]);

                                                      print(addedToCart);
                                                      print(addedPrice);
                                                      // print(totalValue);
                                                      print(addedQty);
                                                    });
                                                  },
                                                  icon: Icon(addedToCart
                                                          .contains(filteredDocs[index]['name'])
                                                      ? Icons.check
                                                      : Icons.add),
                                                  color: Colors.black,
                                                ),
                                              ))
                                        ],
                                      ),
                                      ListTile(
                                        title: Text(
                                          filteredDocs[index]['name'],
                                        ),
                                        subtitle: Text(
                                filteredDocs[index]['price'].toString(),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          }
                        ),
                      ),
                    ],
                  ),
                ),
              )),
        );
      }),
    );
  }

  cartPopup() {
    Size size = MediaQuery.of(context).size;
    // cartPrice = addedPrice;
    return showModalBottomSheet(
      isDismissible: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      elevation: 20,
      context: context,
      builder: (context) => Card(
        child: StatefulBuilder(builder: (context, StateSetter showState) {
          // cartPrice = [0];
          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
              height: size.height * 0.5,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        // margin: EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black,
                              blurRadius: 2.0,
                              spreadRadius: 0.0,
                              offset: Offset(
                                  2.0, 2.0), // shadow direction: bottom right
                            )
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Icon(
                            Icons.shopping_cart,
                            color: Colors.black,
                            size: size.height * 0.03,
                          ),
                        ),
                      ),
                      Container(
                        // margin: EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black,
                                blurRadius: 2.0,
                                spreadRadius: 0.0,
                                offset: Offset(
                                    2.0, 2.0), // shadow direction: bottom right
                              )
                            ],
                            borderRadius:
                                BorderRadius.all(Radius.circular(12))),
                        child: Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Text(
                              'Dine In',
                              style: TextStyle(
                                fontSize: size.height * 0.03,
                              ),
                            )),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TableOrderOnline()));
                        },
                        child: Container(
                          // margin: EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black,
                                blurRadius: 2.0,
                                spreadRadius: 0.0,
                                offset: Offset(
                                    2.0, 2.0), // shadow direction: bottom right
                              )
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Icon(
                              Icons.dangerous,
                              color: Colors.black,
                              size: size.height * 0.03,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: size.height * 0.3,
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: addedToCart.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Expanded(
                                  flex: 3,
                                  child: Text(
                                      '\$${cartPrice[index].toStringAsFixed(2)}')),
                              Expanded(
                                  flex: 3, child: Text(addedToCart[index])),
                              Expanded(
                                  flex: 3,
                                  child: Row(
                                    children: [
                                      IconButton(
                                          icon: Icon(Icons.remove),
                                          onPressed: () {
                                            showState(() {
                                              print('index$index');
                                              if (addedQty[index] > 1) {
                                                print('index$index');
                                                addedQty[index]--;
                                                cartPrice[index] =
                                                    cartPrice[index] -
                                                        addedPrice[index];
                                                print(cartPrice);
                                                print(addedQty[index]);

                                                print(cartPrice[index]);
                                                print(addedPrice[index]);
                                              }
                                            });
                                          }),
                                      Text('X${addedQty[index]}'),
                                      IconButton(
                                          icon: Icon(Icons.add),
                                          onPressed: () {
                                            showState(() {
                                              addedQty[index]++;
                                              cartPrice[index] =
                                                  addedPrice[index] *
                                                      addedQty[index];
                                              print(cartPrice[index]);
                                              print(addedPrice[index]);
                                            });
                                          }),
                                    ],
                                  )),
                              Expanded(
                                flex: 1,
                                child: IconButton(
                                    icon: Icon(Icons.delete),
                                    onPressed: () {
                                      showState(() {
                                        addedToCart.removeAt(index);
                                        addedPrice.removeAt(index);
                                        totalValue -= 1;
                                        print(totalValue);
                                        print(addedToCart);
                                        print(addedPrice);
                                      });
                                    }),
                              ),
                              // SizedBox(width: 10.0),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  Spacer(),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        'Sub Total',
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '\$${cartPrice.fold(0, (previousValue, element) => previousValue + element).toStringAsFixed(2)}',
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: () {
                      showState(() {
                        signInPopup();
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white,
                              blurRadius: 2.0,
                              spreadRadius: 0.0,
                              offset: Offset(
                                  2.0, 2.0), // shadow direction: bottom right
                            )
                          ],
                          borderRadius: BorderRadius.all(Radius.circular(12))),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Check Out'),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  signInPopup() {
    Size size = MediaQuery.of(context).size;
    return showModalBottomSheet(
        isDismissible: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        elevation: 20,
        context: context,
        builder: (context) => SizedBox(
              height: size.height * 0.5,
              child: Card(
                child:
                    StatefulBuilder(builder: (context, StateSetter showState) {
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          // margin: EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black,
                                blurRadius: 2.0,
                                spreadRadius: 0.0,
                                offset: Offset(
                                    2.0, 2.0), // shadow direction: bottom right
                              )
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Icon(
                              Icons.keyboard_arrow_down_sharp,
                              color: Colors.black,
                              size: size.height * 0.03,
                            ),
                          ),
                        ),
                        Container(
                          // margin: EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black,
                                  blurRadius: 2.0,
                                  spreadRadius: 0.0,
                                  offset: Offset(2.0,
                                      2.0), // shadow direction: bottom right
                                )
                              ],
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12))),
                          child: Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      showState(() {
                                        guestUserSignInSwitch = false;
                                        print(guestUserSignInSwitch);
                                      });
                                    },
                                    child: Text(
                                      'Guest User',
                                      style: TextStyle(
                                        fontSize: size.height * 0.03,
                                        color: guestUserSignInSwitch == false
                                            ? defaultColor
                                            : Colors.black,
                                      ),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      showState(() {
                                        guestUserSignInSwitch = true;
                                        print(guestUserSignInSwitch);
                                      });
                                    },
                                    child: Text(
                                      'Sign In',
                                      style: TextStyle(
                                        fontSize: size.height * 0.03,
                                        color: guestUserSignInSwitch == false
                                            ? Colors.black
                                            : defaultColor,
                                      ),
                                    ),
                                  ),
                                ],
                              )),
                        ),
                        guestUserSignInSwitch == false ? guestUser() : signIn(),
                      ],
                    ),
                  );
                }),
              ),
            ));
  }

  signIn() {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: _mobileKey,
                child: TextFormField(
                  validator: (String value) {
                    if (value.length < 9)
                      return " Please Enter Your Mobile Number or Sign In as Guest User";
                    else
                      return null;
                  },
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    maskFormatter,
                  ],
                  controller: _mobileController,
                  autofillHints: [AutofillHints.telephoneNumber],
                  decoration: InputDecoration(
                    border: new OutlineInputBorder(
                        borderSide: new BorderSide(color: Colors.teal)),
                    hintText: 'Mobile No.\*',
                    labelStyle: TextStyle(color: Colors.black),
                    prefixIcon: Icon(
                      Icons.phone_outlined,
                      size: size.width * 0.04,
                      color: Colors.black54,
                    ),
                  ),
                  style: TextStyle(fontSize: size.width * 0.04),
                ),
              ),
            ),
            SizedBox(
              height: size.height * 0.05,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: _nameKey,
                child: TextFormField(
                  validator: (String value) {
                    if (value.length < 3)
                      return " Please Enter Your Name";
                    else
                      return null;
                  },
                  controller: _nameController,
                  textCapitalization: TextCapitalization.words,
                  autofillHints: [AutofillHints.givenName],
                  decoration: InputDecoration(
                    hintText: 'Name\*',
                    labelStyle: TextStyle(color: Colors.black),
                    prefixIcon: Icon(
                      Icons.person_outline,
                      size: size.width * 0.04,
                      color: Colors.black54,
                    ),
                    border: new OutlineInputBorder(
                        borderSide: new BorderSide(color: Colors.teal)),
                  ),
                  style: TextStyle(fontSize: size.width * 0.04),
                ),
              ),
            ),
            SizedBox(
              height: size.height * 0.05,
            ),
            InkWell(
              onTap: () {
                _mobileKey.currentState.validate();
                _nameKey.currentState.validate();
                if (_nameKey.currentState.validate() &&
                    _mobileKey.currentState.validate()) {
                  paymentMethod();
                }
              },
              child: Card(
                elevation: 20,
                color: Colors.blue,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Continue'),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  guestUser() {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Center(
        child: Column(
          children: [
            SizedBox(
              height: size.height * 0.05,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: _nameKey,
                child: TextFormField(
                  validator: (String value) {
                    if (value.length < 3)
                      return " Please Enter Your Name";
                    else
                      return null;
                  },
                  controller: _nameController,
                  textCapitalization: TextCapitalization.words,
                  autofillHints: [AutofillHints.givenName],
                  decoration: InputDecoration(
                    hintText: 'Name\*',
                    labelStyle: TextStyle(color: Colors.black),
                    prefixIcon: Icon(
                      Icons.person_outline,
                      size: size.width * 0.04,
                      color: Colors.black54,
                    ),
                    border: new OutlineInputBorder(
                        borderSide: new BorderSide(color: Colors.teal)),
                  ),
                  style: TextStyle(fontSize: size.width * 0.04),
                ),
              ),
            ),
            SizedBox(
              height: size.height * 0.05,
            ),
            InkWell(
              onTap: () {
                _nameKey.currentState.validate();
                if (_nameKey.currentState.validate()) {
                  paymentMethod();
                }
              },
              child: Card(
                elevation: 20,
                color: Colors.blue,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Continue'),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  paymentMethod() {
    Size size = MediaQuery.of(context).size;
    return showModalBottomSheet(
        isDismissible: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        elevation: 20,
        context: context,
        builder: (context) => SizedBox(
              height: size.height * 0.5,
              child: Card(
                child:
                    StatefulBuilder(builder: (context, StateSetter showState) {
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          // margin: EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black,
                                blurRadius: 2.0,
                                spreadRadius: 0.0,
                                offset: Offset(
                                    2.0, 2.0), // shadow direction: bottom right
                              )
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Icon(
                              Icons.keyboard_arrow_down_sharp,
                              color: Colors.black,
                              size: size.height * 0.03,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.03,
                        ),
                        Container(
                          height: size.height * 0.06,
                          width: size.width * 0.4,
                          // margin: EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black,
                                  blurRadius: 2.0,
                                  spreadRadius: 0.0,
                                  offset: Offset(2.0,
                                      2.0), // shadow direction: bottom right
                                )
                              ],
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12))),
                          child: Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Center(
                                child: Text(
                                  'Pay at Counter',
                                  style: TextStyle(
                                    fontSize: size.height * 0.03,
                                    color: guestUserSignInSwitch == false
                                        ? defaultColor
                                        : Colors.black,
                                  ),
                                ),
                              )),
                        ),
                        SizedBox(
                          height: size.height * 0.03,
                        ),
                        Center(
                          child: Text(
                            'You have Elected to pay at the counter. Place the place order button to proceed',
                            textAlign: TextAlign.justify,
                            maxLines: 2,
                            style: TextStyle(fontSize: size.height * 0.04),
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.03,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            InkWell(
                              onTap: (){
                                showState(() {
                                  paymentType = true;
                                });
                              },
                              child: Card(
                                elevation: 20,
                                color:   paymentType == false ? Colors.white : Colors.blue,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text('Change Payment',style: TextStyle(color: paymentType == false ? Colors.black : Colors.white),),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: (){
                                showState(() {
                                  paymentType = false;
                                });
                              },
                              child: Card(
                                elevation: 20,
                                color:   paymentType == false ? Colors.blue : Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text('Place Order',style: TextStyle(color: paymentType == false ? Colors.white : Colors.black,),),
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  );
                }),
              ),
            ));
  }
}
