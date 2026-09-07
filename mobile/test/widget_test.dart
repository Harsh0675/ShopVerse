import 'package:flutter_test/flutter_test.dart';
import 'package:shopverse/main.dart';
void main(){testWidgets('app boots',(t)async{await t.pumpWidget(const ShopVerse());expect(find.text('ShopVerse'),findsOneWidget);});}
