import 'dart:async';

// Model Data
class Product {
  String productName;
  double price;
  bool inStock;

  Product(this.productName, this.price, this.inStock);
}

class User {
  String name;
  int age;
  List<Product>? products; // nullable
  Role? role;

  User(this.name, this.age);

  // Fungsi untuk menambah produk
  void addProduct(Product product) {
    products ??= []; // Inisialisasi jika null
    products!.add(product);
  }
}

// Enum Role
enum Role { Admin, Customer }

// Admin User yang bisa menambah atau menghapus produk
class AdminUser extends User {
  AdminUser(String name, int age) : super(name, age);

  void removeProduct(Product product) {
    products?.remove(product);
  }
}

// Customer User hanya bisa melihat produk
class CustomerUser extends User {
  CustomerUser(String name, int age) : super(name, age);

  void viewProducts() {
    print("Daftar Produk untuk ${this.name}:");
    products?.forEach(
        (product) => print('${product.productName}: \$${product.price}'));
  }
}

// Fungsi Asinkron untuk Mengambil Detail Produk
Future<Product> fetchProductDetails(String productName) async {
  print("Mengambil data produk $productName...");
  await Future.delayed(Duration(seconds: 2)); // simulasi waktu tunggu
  print("Data produk $productName telah diambil.");
  return Product(productName, 100.0, true);
}

void main() async {
  // Inisialisasi user admin
  late User admin;
  admin = AdminUser("Alice", 30);
  admin.role = Role.Admin;

  try {
    // Mengambil produk laptop dan menambahkannya jika tersedia
    Product laptop = await fetchProductDetails("Laptop");
    admin.addProduct(laptop);

    // Mengambil produk mouse yang tidak tersedia
    Product mouse = Product("Mouse", 25.0, false);

    // Cek ketersediaan stok sebelum menambah produk
    if (mouse.inStock) {
      admin.addProduct(mouse);
    } else {
      print(
          "Peringatan: Produk ${mouse.productName} tidak tersedia dalam stok.");
    }
  } catch (e) {
    print("Error: ${e.toString()}");
  }

  // Customer melihat daftar produk
  CustomerUser customer = CustomerUser("Bob", 22);
  customer.products = admin.products; // Salin daftar produk dari admin
  customer.viewProducts();
}
 