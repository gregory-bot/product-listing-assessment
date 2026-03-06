import 'package:dio/dio.dart';
import '../models/product_model.dart';

const _mockEndpoint = 'https://65b3c9e3b71048505c8ab5c1.mockapi.io/products';

class ProductService {
  final Dio _dio = Dio();

  Future<List<ProductModel>> fetchProducts() async {
    final response = await _dio.get(_mockEndpoint);
    final data = response.data as List;
    return data
        .map((json) => ProductModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
