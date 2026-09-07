class Product {
  final String id,name,category,description,imageUrl;
  final double price,rating;
  final int stock;
  const Product({required this.id,required this.name,required this.category,required this.description,required this.price,required this.rating,required this.stock,required this.imageUrl});
  factory Product.fromJson(Map<String,dynamic> j)=>Product(
    id:'${j['id']}',name:'${j['name']}',category:'${j['category']}',description:'${j['description']??''}',
    price:double.tryParse('${j['price']}')??0,rating:double.tryParse('${j['rating']}')??0,
    stock:int.tryParse('${j['stock']}')??0,imageUrl:'${j['image_url']??''}');
}
