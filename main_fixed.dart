import 'package:flutter/material.dart';

void main() {
  runApp(const SofraApp());
}

class SofraApp extends StatelessWidget {
  const SofraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'سُفرة',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFE97845)),
        scaffoldBackgroundColor: const Color(0xFFFFF9F2),
        useMaterial3: true,
        fontFamily: 'Arial',
      ),
      home: const HomeScreen(),
    );
  }
}

class Restaurant {
  final String id;
  final String name;
  final String category;
  final String imageUrl;
  final double rating;
  final int deliveryMinutes;
  final bool isOpen;

  const Restaurant({
    required this.id,
    required this.name,
    required this.category,
    required this.imageUrl,
    required this.rating,
    required this.deliveryMinutes,
    required this.isOpen,
  });
}

class FoodOrder {
  final String id;
  final Restaurant restaurant;
  final List<String> items;
  final double total;
  final String status;
  final DateTime createdAt;

  const FoodOrder({
    required this.id,
    required this.restaurant,
    required this.items,
    required this.total,
    required this.status,
    required this.createdAt,
  });
}

const restaurants = <Restaurant>[
  Restaurant(
    id: 'rest-1',
    name: 'مطبخ البيت',
    category: 'أكل بيتي',
    imageUrl: 'https://images.example.com/home-kitchen.jpg',
    rating: 4.8,
    deliveryMinutes: 35,
    isOpen: true,
  ),
  Restaurant(
    id: 'rest-2',
    name: 'بيتزا زمان',
    category: 'بيتزا',
    imageUrl: 'https://images.example.com/pizza.jpg',
    rating: 4.5,
    deliveryMinutes: 30,
    isOpen: true,
  ),
  Restaurant(
    id: 'rest-3',
    name: 'جرين بايتس',
    category: 'صحي',
    imageUrl: 'https://images.example.com/green-bites.jpg',
    rating: 4.7,
    deliveryMinutes: 25,
    isOpen: false,
  ),
];

final demoOrders = <FoodOrder>[
  FoodOrder(
    id: 'ORD-1042',
    restaurant: const Restaurant(
      id: 'rest-1',
      name: 'مطبخ البيت',
      category: 'أكل بيتي',
      imageUrl: '',
      rating: 4.8,
      deliveryMinutes: 35,
      isOpen: true,
    ),
    items: const ['وجبة فراخ مشوية', 'سلطة خضراء', 'مياه معدنية'],
    total: 185.0,
    status: 'Delivered',
    createdAt: DateTime(2026, 8, 20, 18, 30),
  ),
  FoodOrder(
    id: 'ORD-1038',
    restaurant: restaurants[1],
    items: const ['بيتزا خضار كبيرة', 'مشروب غازي'],
    total: 240.0,
    status: 'Delivered',
    createdAt: DateTime(2026, 8, 16, 20, 15),
  ),
  FoodOrder(
    id: 'ORD-1031',
    restaurant: restaurants[2],
    items: const ['سلطة كينوا', 'عصير برتقال'],
    total: 160.0,
    status: 'Cancelled',
    createdAt: DateTime(2026, 8, 10, 13, 10),
  ),
];

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedTab = 0;
  String searchText = '';

  @override
  Widget build(BuildContext context) {
    final filteredRestaurants = restaurants
        .where((restaurant) => restaurant.name.contains(searchText))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('سُفرة'),
        actions: [
          IconButton(
            tooltip: 'الإشعارات',
            onPressed: () {},
            icon: const Icon(Icons.notifications_none),
          ),
          IconButton(
            tooltip: 'الطلبات السابقة',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const OrdersScreen()),
            ),
            icon: const Icon(Icons.receipt_long_outlined),
          ),
        ],
      ),
      body: IndexedStack(
        index: selectedTab,
        children: [
          _buildRestaurantsTab(filteredRestaurants),
          const FavoritesScreen(),
          const ProfileScreen(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedTab,
        onDestinationSelected: (index) {
          setState(() => selectedTab = index);
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), label: 'الرئيسية'),
          NavigationDestination(icon: Icon(Icons.favorite_border), label: 'المفضلة'),
          NavigationDestination(icon: Icon(Icons.person_outline), label: 'حسابي'),
        ],
      ),
    );
  }

  Widget _buildRestaurantsTab(List<Restaurant> filteredRestaurants) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'أهلاً بيك في سُفرة',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 6),
        Text(
          'اختار أكلك المفضل وهيوصلك لحد البيت',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 18),
        TextField(
          decoration: InputDecoration(
            hintText: 'دور على مطعم...',
            prefixIcon: const Icon(Icons.search),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
          ),
          onChanged: (value) => setState(() => searchText = value),
        ),
        const SizedBox(height: 20),
        const Text(
          'المطاعم القريبة',
          style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        ...filteredRestaurants.map(
          (restaurant) => RestaurantCard(
            restaurant: restaurant,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => RestaurantDetailsScreen(restaurant: restaurant),
              ),
            ),
          ),
        ),
        if (filteredRestaurants.isEmpty)
          const Padding(
            padding: EdgeInsets.only(top: 40),
            child: Center(child: Text('مش لاقيين مطعم بالاسم ده')),
          ),
      ],
    );
  }
}

class RestaurantCard extends StatelessWidget {
  final Restaurant restaurant;
  final VoidCallback onTap;

  const RestaurantCard({
    super.key,
    required this.restaurant,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            SizedBox(
              width: 105,
              height: 105,
              child: Image.network(
                restaurant.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: const Color(0xFFF3C7B5),
                  child: const Icon(Icons.restaurant, size: 34),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      restaurant.name,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 5),
                    Text(restaurant.category),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 17),
                        const SizedBox(width: 3),
                        Text('${restaurant.rating}'),
                        const SizedBox(width: 12),
                        const Icon(Icons.access_time, size: 16),
                        const SizedBox(width: 3),
                        Text('${restaurant.deliveryMinutes} دقيقة'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('طلباتي')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: demoOrders.length,
        itemBuilder: (context, index) {
          final order = demoOrders[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: const Color(0xFFF3C7B5),
                child: Text('${index + 1}'),
              ),
              title: Text(order.restaurant.name),
              subtitle: Text('${order.items.length} أصناف • ${order.total.toStringAsFixed(0)} ج.م'),
              trailing: Text(order.status),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => OrderDetailsScreen(order: order),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class OrderDetailsScreen extends StatelessWidget {
  final FoodOrder order;

  const OrderDetailsScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تفاصيل الطلب')),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          // BUG INTENTIONAL: imageUrl can be empty for ORD-1042.
          // The current implementation still passes it to Image.network.
          // The requested fix should safely show a placeholder for empty/invalid URLs.
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: _buildRestaurantImage(context),
          ),
          const SizedBox(height: 18),
          Text(
            order.restaurant.name,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(order.restaurant.category),
          const SizedBox(height: 18),
          _InfoRow(label: 'رقم الطلب', value: order.id),
          _InfoRow(label: 'الحالة', value: order.status),
          _InfoRow(label: 'عدد الأصناف', value: '${order.items.length}'),
          _InfoRow(label: 'الإجمالي', value: '${order.total.toStringAsFixed(2)} ج.م'),
          const Divider(height: 32),
          const Text('الأصناف', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ...order.items.map(
            (item) => ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.check_circle_outline),
              title: Text(item),
            ),
          ),
          const SizedBox(height: 18),
          OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.support_agent),
            label: const Text('محتاج مساعدة؟'),
          ),
        ],
      ),
    );
  }

  Widget _buildRestaurantImage(BuildContext context) {
    final imageUrl = order.restaurant.imageUrl.trim();

    if (imageUrl.isEmpty) {
      return _imagePlaceholder();
    }

    return Image.network(
      imageUrl,
      height: 190,
      width: double.infinity,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => _imagePlaceholder(),
    );
  }

  Widget _imagePlaceholder() {
    return Container(
      height: 190,
      width: double.infinity,
      color: const Color(0xFFF3C7B5),
      child: const Center(
        child: Icon(
          Icons.restaurant,
          size: 56,
          color: Colors.white,
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.black54)),
          Flexible(child: Text(value, textAlign: TextAlign.end)),
        ],
      ),
    );
  }
}

class RestaurantDetailsScreen extends StatelessWidget {
  final Restaurant restaurant;

  const RestaurantDetailsScreen({super.key, required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(restaurant.name)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          RestaurantCard(restaurant: restaurant, onTap: () {}),
          const SizedBox(height: 14),
          const Text('الأكثر طلبًا', style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          _menuItem('وجبة اليوم', 'أرز وخضار وبروتين حسب اختيارك', 120),
          _menuItem('سلطة خضراء', 'خضار طازة بصوص الليمون', 45),
          _menuItem('مشروب طبيعي', 'اختار بين البرتقال أو المانجو', 35),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: FilledButton(
          onPressed: () {},
          child: const Text('أضف طلبك للسلة'),
        ),
      ),
    );
  }

  Widget _menuItem(String name, String description, int price) {
    return Card(
      child: ListTile(
        title: Text(name),
        subtitle: Text(description),
        trailing: Text('$price ج.م'),
      ),
    );
  }
}

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('المطاعم المفضلة هتظهر هنا'));
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: const [
        CircleAvatar(radius: 42, child: Icon(Icons.person, size: 42)),
        SizedBox(height: 12),
        Center(child: Text('أحمد محمد', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
        SizedBox(height: 24),
        ListTile(leading: Icon(Icons.location_on_outlined), title: Text('العناوين المحفوظة')),
        ListTile(leading: Icon(Icons.payment_outlined), title: Text('طرق الدفع')),
        ListTile(leading: Icon(Icons.help_outline), title: Text('المساعدة والدعم')),
      ],
    );
  }
}
