import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/product_detail_screen.dart';
import '../providers/product.dart';
import '../providers/cart.dart';

class ProductItem extends StatelessWidget {
  // final String id;
  // final String title;
  // final String imageUrl;

  // ProductItem(this.id, this.title, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(
        context); //whole build method will run when the data changes
    //return Consumer<Product>(       //Consumer only runs the encased code when data changes.  It doesn't matter here, but it could in some cases
    // builder: (ctx, product, child) => ClipRRect(
    final cart = Provider.of<Cart>(context, listen: false);
    // final prodId = product.id;
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              ProductDetailScreen.routeName,
              arguments: product.id,
            );
          },
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: Consumer<Product>(
            builder: (ctx, product, child) => IconButton(
              icon: Icon(
                product.isFavorite
                    ? Icons.favorite
                    : Icons.favorite_border,
              ),
              onPressed: () {
                try {
                  product.toggleFavoriteStatus();
                } catch (error) {
                  Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text(
                      'Could not add to favorites',
                      textAlign: TextAlign.center,
                    ),
                  ));
                }
              },
              color: Theme.of(context).accentColor,
            ),
            child: Text('Never Changes!'),
            //The child argument in Consumer allows you to define a constant part of the widget to use inside Consumer.
            //This way you can have parts that don't have to rebuild inside Consumer, saving time.
          ),
          trailing: IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              cart.addItem(product.id, product.price, product.title);
              Scaffold.of(context)
                  .hideCurrentSnackBar(); //removes a snackbar if one is present when another one comes up
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text(
                  'Added item to cart',
                ),
                duration: Duration(seconds: 2),
                action: SnackBarAction(
                    label: 'UNDO',
                    onPressed: () => cart.removeSingleItem(product.id)),
              ));
            },
            color: Theme.of(context).accentColor,
          ),
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
