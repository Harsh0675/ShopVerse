import 'core/product.dart';

const products = <Product>[
  Product(id:'1', name:'Wireless Headphones', category:'Electronics', description:'Immersive wireless audio with all-day battery.', price:2999, rating:4.6, stock:50, imageUrl:''),
  Product(id:'2', name:'Smart Watch', category:'Electronics', description:'Fitness tracking, notifications and a bright display.', price:4499, rating:4.5, stock:35, imageUrl:''),
  Product(id:'3', name:'Everyday Sneakers', category:'Fashion', description:'Lightweight sneakers for daily comfort.', price:2499, rating:4.7, stock:70, imageUrl:''),
  Product(id:'4', name:'Minimal Backpack', category:'Fashion', description:'Durable everyday backpack with smart storage.', price:1899, rating:4.4, stock:45, imageUrl:''),
  Product(id:'5', name:'Desk Lamp', category:'Home', description:'Adjustable lamp for a focused workspace.', price:1299, rating:4.3, stock:80, imageUrl:''),
  Product(id:'6', name:'Coffee Maker', category:'Home', description:'Compact coffee maker for fresh coffee at home.', price:3599, rating:4.6, stock:25, imageUrl:''),
];

Product? productsById(String id) {
  for (final product in products) {
    if (product.id == id) return product;
  }
  return null;
}
