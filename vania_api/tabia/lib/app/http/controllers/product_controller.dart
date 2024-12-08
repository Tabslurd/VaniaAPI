import 'package:tabia/app/models/product.dart';
import 'package:vania/vania.dart';
import 'package:vania/src/exception/validation_exception.dart';

class ProductController extends Controller {
     Future<Response> index() async {
          return Response.json({'message':'Hello World'});
     }

     Future<Response> create(Request request) async {
      // memberikan validasi tidak boleh kosong
      request.validate({
        'name': 'required',
        'description': 'required',
        'price': 'required',
      },{
        'name.required': 'Nama tidak boleh kosong.',
        'description.required': 'Description tidak boleh kosong.',
        'price.required': 'Price tidak boleh kosong.',
      });
      try {
        // jika sudah mendapatkan inputan
        final requestData = request.input();

        return Response.json({
          "message": "Product berhasil ditambahkan",
          "data": requestData,
        }, 201);
      } catch (e) {
        return Response.json(
          {
            "message": "Error terjadi pada server, silakan coba lagi nanti",
          },
          500,
        );
      }
     }

     Future<Response> store(Request request) async {
      try{
        request.validate({
          'name': 'required|string|max_length:100',
          'description': 'required|string|max_length:255',
          'price': 'required|numeric|min:0',
        },{
          'name.required': 'Nama produk wajib diisi.',
          'name.string': 'Nama produk harus berupa teks.',
          'name.max_length': 'Nama produk maksimal 100 karakter.',
          'description.required': 'Deskripsi produk wajib diisi.',
          'description.string': 'Deskripsi produk harus berupa teks.',
          'description.max_length': 'Deskripsi produk maksimal 255 karakter.',
          'price.required': 'Harga produk wajib diisi.',
          'price.numeric': 'Harga produk harus berupa angka.',
          'price.min': 'Harga produk tidak boleh kurang dari 0.',
        });

        final productData = request.input();

        final existingProduct = await Product()
          .query()
          .where('name', '=', productData['name'])
          .first();

        if (existingProduct != null) {
          return Response.json(
            {'message': 'Produk dengan nama ini sudah ada.'}, 409);
        }

        productData['create_at'] = DateTime.now().toIso8601String();

        await Product().query().insert(productData);
        
        return Response.json({
          "message": "Produk berhasil ditambahkan",
          "data": productData,
        }, 201);
      } catch (e) {
        if (e is ValidationException) {
          final errorMessages = e.message;
          return Response.json({
            'errors': errorMessages,
          }, 400);
        } else {
          return Response.json({
            'message': 'Terjadi kesalahan di sisi server. Harap coba lagi nanti.',
          }, 500);
        }
      }
     }

     Future<Response> show() async {
      try {
        final listProduct = await Product().query().get();
        return Response.json({
          'message': 'Daftar produk.',
          'data': listProduct,
        }, 200);
      } catch (e) {
        return Response.json({
          'message': 'Terjadi kesalahan saat mengambil data produk.',
          'error': e.toString(),
        }, 500);
      }
     }

     Future<Response> update(Request request,int id) async {
      try {
        // Validasi input dari pengguna
        request.validate({
          'name': 'required|string|max_length:100',
          'description': 'required|string|max_length:255',
          'price': 'required|numeric|min:0',
        },{
          'name.required': 'Nama produk wajib diisi.',
          'name.string': 'Nama produk harus berupa teks.',
          'name.max_length': 'Nama produk maksimal 100 karakter.',
          'description.required': 'Deskripsi produk wajib diisi.',
          'description.string': 'Deskripsi produk harus berupa teks.',
          'description.max_length': 'Deskripsi produk maksimal 255 karakter.',
          'price.required': 'Harga produk wajib diisi.',
          'price.numeric': 'Harga produk harus berupa angka.',
          'price.min': 'Harga produk tidak boleh kurang dari 0.',
        });

        // Ambil input data produk yang akan diupdate
        final productData = request.input();
        productData['update_at'] = DateTime.now().toIso8601String();

        // Cari produk berdasarkan ID
        final product = await Product().query().where('id', '=', id).first();

        if (product == null) {
          return Response.json({
            'message': 'Produk dengan ID $id tidak ditemukan.',
          }, 404); // HTTP Status Code 404 Not Found
        }

        // Update data produk
        await Product().query().where('id', '=', id).update(productData);

        // Mengembalikan respons sukses dengan status 200 OK
        return Response.json({
          'message': 'Produk berhasil diperbarui.',
          'data': productData, // Menyertakan data produk yang diupdate
        }, 200); // HTTP Status Code 200 OK
      } catch (e) {
        // Menangani kesalahan validasi
        if (e is ValidationException) {
          final errorMessages = e.message;
          return Response.json({
            'errors': errorMessages,
          }, 400); // HTTP Status Code 400 Bad Request
        } else {
          // Menangani kesalahan tak terduga
          return Response.json({
            'message': 'Terjadi kesalahan di sisi server. Harap coba lagi nanti.',
          }, 500); // HTTP Status Code 500 Internal Server Error
        }
      }
     }

     Future<Response> destroy(int id) async {
      try {
        // Cari produk berdasarkan ID
        final product = await Product().query().where('id', '=', id).first();

        if (product == null) {
          return Response.json({
            'message': 'Produk dengan ID $id tidak ditemukan.',
          }, 404); // HTTP Status Code 404 Not Found
        }

        // Hapus produk
        await Product().query().where('id', '=', id).delete();

        return Response.json({
          'message': 'Produk berhasil dihapus.',
        }, 200);
      } catch (e) {
        return Response.json({
          'message': 'Terjadi kesalahan saat menghapus produk.',
          'error': e.toString(),
        }, 500);
      }
     }
}
final ProductController productController = ProductController();
