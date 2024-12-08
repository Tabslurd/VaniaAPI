import 'package:tabia/app/http/controllers/product_controller.dart';
import 'package:vania/vania.dart';

class ApiRoute implements Route {
  @override
  void register() {
    Router.post('/create-product', productController.create);
    Router.post('/store-product', productController.store);
    Router.get('/show-product', productController.show);
    Router.put('/update-product/{id}', productController.update);
    Router.delete('/destroy-product/{id}', productController.destroy);
  }
}
