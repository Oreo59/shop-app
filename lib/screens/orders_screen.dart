import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/orders.dart' show Orders;
import '../widgets/order_item.dart';
import '../widgets/app_drawer.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders';

//   @override
//   _OrdersScreenState createState() => _OrdersScreenState();
// }

// class _OrdersScreenState extends State<OrdersScreen> {
  // var _isLoading = false;

  // @override
  // void initState() {
  //   Future.delayed(Duration.zero).then((_) async {
  //     //...............This ANONYMOUS FUNCTION can be async because we are not setting initState to async
  //     setState(() {
  //       _isLoading = true;
  //     });
  //     await Provider.of<Orders>(context, listen: false).fetchAndSetOrders();
  //     setState(() {
  //       _isLoading = false;
  //     });
  //   });
  //   super.initState();
  // }

  // void initState() {
  // Future.delayed(Duration.zero).then((_) async {
  //...............This ANONYMOUS FUNCTION can be async because we are not setting initState to async

  // _isLoading = true;

  // Provider.of<Orders>(context, listen: false).fetchAndSetOrders().then((_) {
  //   setState(() {
  //     _isLoading = false;
  //   });
  // });
  // // });
  // super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    print('Building Orders');
    // final orderData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      body: FutureBuilder(
        future: Provider.of<Orders>(context, listen: false).fetchAndSetOrders(),
        builder: (ctx, dataSnapshot) {

          //Loading State
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          //Finiished Loading State
          else {

            //If an error happened
            if (dataSnapshot.error != null) {
              
              //Do error handling stuff
              return Center(
                child: Text('An error occured'),
              );
            }

            //Expected behavior
            else {
              return Consumer<Orders>(
                //..............If the provider were used at the top instead, the build method would run in an infinite loop
                builder: (ctx, orderData, child) => ListView.builder(
                  itemCount: orderData.orders.length,
                  itemBuilder: (ctx, i) => OrderItem(
                    orderData.orders[i],
                  ),
                ),
              );
            }
          }
        },
      ),
      drawer: AppDrawer(),
    );
  }
}
