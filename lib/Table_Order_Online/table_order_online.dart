import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

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
  final List<double> itemPrice = [
    12.12,
    10.11,
    15.12,
    5.12,
    10.12,
    15.12,
    11.11,
    12.11,
    4.11,
    3.11
  ];
  final List<int> quantity = [
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
  ];
  int totalValue = 0;
  List<String> addedToCart = [];
  List<double> addedPrice = [];
  List<double> cartPrice = [];
  List<int> addedQty = [];
  bool guestUserSignInSwitch = false;
  bool paymentType = false;
  Color defaultColor = Colors.blue;
  var maskFormatter = new MaskTextInputFormatter(
      mask: '+61 (##) ####-####', filter: {"#": RegExp(r'[0-9]')});
  TextEditingController _mobileController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  var _nameKey = GlobalKey<FormState>();
  var _mobileKey = GlobalKey<FormState>();
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
                                  Icons.search,
                                  color: Colors.black,
                                  size: size.height * 0.03,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        height: size.width <= 500
                            ? size.height * 0.05
                            : size.height * 0.1,
                        // width: size.width,
                        child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: catList.length,
                          itemBuilder: (BuildContext ctxt, int index) {
                            return Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    showState(() {
                                      print(size.width);
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
                        ),
                      ),
                      GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount:
                                (orientation == Orientation.portrait) ? 2 : 3),
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount: itemName.length,
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
                                                        itemName[index])
                                                    ? totalValue -= 1
                                                    : totalValue += 1;

                                                addedToCart.contains(
                                                        itemName[index])
                                                    ? addedToCart
                                                        .remove(itemName[index])
                                                    : addedToCart
                                                        .add(itemName[index]);

                                                addedToCart.contains(
                                                        itemName[index])
                                                    ? addedPrice
                                                        .add(itemPrice[index])
                                                    : addedPrice.remove(
                                                        itemPrice[index]);

                                                addedToCart.contains(
                                                        itemName[index])
                                                    ? cartPrice
                                                        .add(itemPrice[index])
                                                    : cartPrice.remove(
                                                        itemPrice[index]);

                                                addedToCart.contains(
                                                        itemName[index])
                                                    ? addedQty
                                                        .add(quantity[index])
                                                    : addedQty.remove(
                                                        quantity[index]);

                                                print(addedToCart);
                                                print(addedPrice);
                                                print(totalValue);
                                                print(addedQty);
                                              });
                                            },
                                            icon: Icon(addedToCart
                                                    .contains(itemName[index])
                                                ? Icons.check
                                                : Icons.add),
                                            color: Colors.black,
                                          ),
                                        ))
                                  ],
                                ),
                                ListTile(
                                  title: Text(
                                    itemName[index],
                                  ),
                                  subtitle: Text(
                                    itemPrice[index].toString(),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
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
    print(itemPrice);
    print(itemName);
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
