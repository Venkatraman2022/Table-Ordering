import 'package:flutter/material.dart';

class Checkout extends StatefulWidget {
  @override
  _CheckoutState createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
        body: Row(
      children: [
        Expanded(
          flex: 2,
          child: Container(
            padding: EdgeInsets.fromLTRB(
              screenSize.width * 0.02,
              screenSize.height * 0.02,
              0,
              screenSize.height * 0.02,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Padding(
                padding: EdgeInsets.all(screenSize.width * 0.02),
                child: Column(
                  children: [
                    Center(
                      child: Text(
                        'Your Items',
                        style: TextStyle(
                          fontSize: screenSize.width * 0.016,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: screenSize.height * 0.05),
                    Row(
                      children: [
                        Text(
                          'Chicken Burger x 2',
                          style: TextStyle(
                            fontSize: screenSize.width * 0.014,
                            // fontWeight: FontWeight.bold,
                          ),
                        ),
                        Spacer(),
                        Text(
                          '\$9.99',
                          style: TextStyle(
                            fontSize: screenSize.width * 0.014,
                            // fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: screenSize.height * 0.01),
                    SizedBox(height: screenSize.height * 0.01),
                  ],
                ),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: screenSize.width * 0.015,
              vertical: screenSize.height * 0.02,
            ),
            child: Container(
              padding: EdgeInsets.symmetric(
                vertical: screenSize.width * 0.02,
                horizontal: screenSize.width * 0.02,
              ),
              decoration: BoxDecoration(
                // color: Colors.grey[200],
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Column(
                children: [
                  // sub total
                  Row(
                    children: [
                      Text(
                        'Sub Total',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: screenSize.width * 0.018,
                        ),
                      ),
                      Spacer(),
                      Text(
                        '\$9.99',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: screenSize.width * 0.018,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: screenSize.height * 0.01),
                  // gst
                  Row(
                    children: [
                      Text(
                        'G.S.T',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: screenSize.width * 0.018,
                        ),
                      ),
                      Spacer(),
                      Text(
                        '\$0.99',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: screenSize.width * 0.018,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: screenSize.height * 0.05),
                  // Total
                  Row(
                    children: [
                      Text(
                        'Total',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: screenSize.width * 0.022,
                          color: Colors.red,
                        ),
                      ),
                      Spacer(),
                      Text(
                        '\$10.98',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: screenSize.width * 0.022,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: screenSize.height * 0.03),
                  // buttons
                  screenSize.width >= 1000
                      ? Row(
                          children: [
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.green,
                                padding: EdgeInsets.symmetric(
                                  horizontal: screenSize.width * 0.016,
                                  vertical: screenSize.height * 0.02,
                                ),
                              ),
                              onPressed: () {
                                print('Pay at Counter');
                              },
                              icon: Icon(Icons.money),
                              label: Text('Pay at Counter'),
                            ),
                            Spacer(),
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.orange[700],
                                padding: EdgeInsets.symmetric(
                                  horizontal: screenSize.width * 0.016,
                                  vertical: screenSize.height * 0.02,
                                ),
                              ),
                              onPressed: () {
                                print('Pay by Card');
                              },
                              icon: Icon(Icons.credit_card_outlined),
                              label: Text('Pay by Card'),
                            ),
                          ],
                        )
                      : Column(
                          children: [
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.green,
                                padding: EdgeInsets.symmetric(
                                  horizontal: screenSize.width * 0.06,
                                  vertical: screenSize.height * 0.02,
                                ),
                              ),
                              onPressed: () {
                                print('Pay at Counter');
                              },
                              icon: Icon(Icons.money),
                              label: Text('Pay at Counter'),
                            ),
                            SizedBox(height: screenSize.height * 0.01),
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.orange[700],
                                padding: EdgeInsets.symmetric(
                                  horizontal: screenSize.width * 0.07,
                                  vertical: screenSize.height * 0.02,
                                ),
                              ),
                              onPressed: () {
                                print('Pay by Card');
                              },
                              icon: Icon(Icons.credit_card_outlined),
                              label: Text('Pay by Card'),
                            ),
                          ],
                        ),
                  // TextFormField(
                  //   decoration: new InputDecoration(
                  //     border: InputBorder.none,
                  //     focusedBorder: InputBorder.none,
                  //     enabledBorder: InputBorder.none,
                  //     errorBorder: InputBorder.none,
                  //     disabledBorder: InputBorder.none,
                  //     contentPadding: EdgeInsets.only(
                  //         left: 15, bottom: 11, top: 11, right: 15),
                  //     hintText: "Add coupon here...",
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ),
      ],
    ));
  }
}
