import 'package:vania/vania.dart';

class CreateProductTable extends Migration {

  @override
  Future<void> up() async{
   super.up();
   await createTableNotExists('product', () {
      id();
      string('name', length: 100);
      text('description');
      decimal('price', precision: 10, scale: 2);
      timeStamps();
    });
  }
  
  @override
  Future<void> down() async {
    super.down();
    await dropIfExists('product');
  }
}
