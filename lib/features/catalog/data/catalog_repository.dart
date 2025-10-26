import 'dart:async';

import 'catalog_models.dart';

class CatalogRepository {
  const CatalogRepository();

  Future<List<Category>> fetchCategories() async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    return List<Category>.unmodifiable(_categories);
  }

  Future<List<Product>> fetchProducts({int? limit}) async {
    await Future<void>.delayed(const Duration(milliseconds: 350));

    final products = _products;
    if (limit == null || limit <= 0 || limit >= products.length) {
      return List<Product>.unmodifiable(products);
    }

    return List<Product>.unmodifiable(products.take(limit));
  }

  Future<Product> fetchProductById(String id) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));

    final product = _products.firstWhere(
      (item) => item.id == id,
      orElse: () => throw StateError('Product $id was not found'),
    );
    return product;
  }
}

const List<Category> _categories = <Category>[
  Category(
    id: '1',
    name: 'INPUT',
    description: 'All input peripherals hardware.',
  ),
  Category(
    id: '2',
    name: 'OUTPUT',
    description: 'Visual and audio devices that output content.',
  ),
  Category(
    id: '3',
    name: 'STORAGE',
    description: 'Storage solutions for backups and daily use.',
  ),
  Category(
    id: '4',
    name: 'NETWORK',
    description: 'Connectivity gear to keep everything linked.',
  ),
];

final List<Product> _products = List<Product>.unmodifiable(<Product>[
  const Product(
    id: '1001',
    name: 'Wireless Keyboard K580',
    price: 59.99,
    slug: 'wireless-keyboard-k580',
    description: 'Silent multitasking keyboard with low-profile keys.',
    features:
        '- Wireless connectivity for clutter-free setup.\n- Low-profile keys for quiet typing.\n- Compact design ideal for multitasking.\n- Multi-device switching with easy-access keys.\n- Long battery life for extended use.',
    imageUrl: 'https://picsum.photos/seed/wireless-keyboard-k580/400/400',
  ),
  const Product(
    id: '1002',
    name: 'Gaming Mouse G502',
    price: 89.99,
    slug: 'gaming-mouse-g502',
    description: 'High-performance wired gaming mouse with 11 buttons.',
    features:
        '- High-performance optical sensor for precision.\n- 11 programmable buttons for gaming macros.\n- Adjustable DPI settings up to 16000.\n- Tunable weights for personalized feel.\n- RGB lighting customization.',
    imageUrl: 'https://picsum.photos/seed/gaming-mouse-g502/400/400',
  ),
  const Product(
    id: '1003',
    name: 'Stylus Pen SP10',
    price: 29.99,
    slug: 'stylus-pen-sp10',
    description: 'Precision stylus for tablets and smartphones.',
    features:
        '- Precision tip for accurate input.\n- Compatible with most capacitive screens.\n- Slim, lightweight, and ergonomic.\n- Ideal for drawing, writing, and navigation.\n- No batteries or Bluetooth required.',
    imageUrl: 'https://picsum.photos/seed/stylus-pen-sp10/400/400',
  ),
  const Product(
    id: '1004',
    name: 'Barcode Scanner BS100',
    price: 119.00,
    slug: 'barcode-scanner-bs100',
    description: 'Fast laser barcode scanner for retail.',
    features:
        '- Laser scanning for high-speed barcode reading.\n- Plug-and-play via USB connection.\n- Durable and ergonomic design.\n- Ideal for retail and warehouse use.\n- Compatible with major POS systems.',
    imageUrl: 'https://picsum.photos/seed/barcode-scanner-bs100/400/400',
  ),
  const Product(
    id: '1005',
    name: 'Webcam Pro W920',
    price: 79.99,
    slug: 'webcam-pro-w920',
    description: 'HD webcam with autofocus and built-in microphone.',
    features:
        '- Full HD resolution for sharp video.\n- Autofocus for clear image adjustment.\n- Built-in noise-reducing microphone.\n- Flexible mounting clip included.\n- Plug-and-play with USB.',
    imageUrl: 'https://picsum.photos/seed/webcam-pro-w920/400/400',
  ),
  const Product(
    id: '1006',
    name: 'LED Monitor 24"',
    price: 149.99,
    slug: 'led-monitor-24',
    description: 'Full HD 24-inch LED display.',
    features:
        '- 24-inch Full HD 1080p display.\n- Slim bezels for immersive viewing.\n- HDMI and VGA input ports.\n- LED backlight for energy efficiency.\n- Tilt adjustable stand.',
    imageUrl: 'https://picsum.photos/seed/led-monitor-24/400/400',
  ),
  const Product(
    id: '1007',
    name: 'Bluetooth Speaker BX50',
    price: 89.50,
    slug: 'bluetooth-speaker-bx50',
    description: 'Portable speaker with deep bass.',
    features:
        '- Bluetooth 5.0 connectivity.\n- Deep bass and rich audio quality.\n- Up to 10 hours battery life.\n- Built-in mic for calls.\n- Compact and portable design.',
    imageUrl: 'https://picsum.photos/seed/bluetooth-speaker-bx50/400/400',
  ),
  const Product(
    id: '1008',
    name: 'Thermal Printer TP20',
    price: 199.99,
    slug: 'thermal-printer-tp20',
    description: 'Compact thermal receipt printer.',
    features:
        '- Thermal printing technology.\n- Fast receipt printing speed.\n- Compact footprint saves space.\n- Easy paper loading design.\n- USB interface for easy setup.',
    imageUrl: 'https://picsum.photos/seed/thermal-printer-tp20/400/400',
  ),
  const Product(
    id: '1009',
    name: 'Smart TV 40"',
    price: 349.00,
    slug: 'smart-tv-40',
    description: 'Smart TV with built-in apps.',
    features:
        '- 40-inch Full HD Smart TV.\n- Built-in streaming apps.\n- Multiple HDMI and USB ports.\n- Energy-efficient LED panel.\n- Remote control included.',
    imageUrl: 'https://picsum.photos/seed/smart-tv-40/400/400',
  ),
  const Product(
    id: '1010',
    name: 'Audio Dock Station',
    price: 129.00,
    slug: 'audio-dock-station',
    description: 'High-fidelity audio docking system.',
    features:
        '- High-fidelity stereo sound.\n- Multiple device docking support.\n- Remote control functionality.\n- USB and AUX input compatibility.\n- Compact and modern design.',
    imageUrl: 'https://picsum.photos/seed/audio-dock-station/400/400',
  ),
  const Product(
    id: '1011',
    name: 'External HDD 2TB',
    price: 109.50,
    slug: 'external-hdd-2tb',
    description: 'Reliable storage for large files.',
    features:
        '- 2TB of external storage capacity.\n- USB 3.0 high-speed interface.\n- Shock-resistant housing.\n- Plug-and-play compatibility.\n- Ideal for large file backups.',
    imageUrl: 'https://picsum.photos/seed/external-hdd-2tb/400/400',
  ),
  const Product(
    id: '1012',
    name: 'USB Flash Drive 64GB',
    price: 19.99,
    slug: 'usb-flash-drive-64gb',
    description: 'Portable flash drive.',
    features:
        '- 64GB of portable storage.\n- Fast data transfer via USB 3.0.\n- Lightweight and durable.\n- Plug-and-play with any OS.\n- Secure and reliable design.',
    imageUrl: 'https://picsum.photos/seed/usb-flash-drive-64gb/400/400',
  ),
  const Product(
    id: '1013',
    name: 'SSD 500GB',
    price: 89.00,
    slug: 'ssd-500gb',
    description: 'Fast internal solid-state drive.',
    features:
        '- 500GB SSD storage.\n- Fast read/write speeds.\n- Enhanced system performance.\n- Compact and lightweight.\n- Ideal for laptops and desktops.',
    imageUrl: 'https://picsum.photos/seed/ssd-500gb/400/400',
  ),
  const Product(
    id: '1014',
    name: 'Memory Card 128GB',
    price: 24.99,
    slug: 'memory-card-128gb',
    description: 'MicroSDXC memory card.',
    features:
        '- 128GB MicroSDXC capacity.\n- High-speed data transfer.\n- Compatible with phones and cameras.\n- Durable and shockproof.\n- Includes SD adapter.',
    imageUrl: 'https://picsum.photos/seed/memory-card-128gb/400/400',
  ),
  const Product(
    id: '1015',
    name: 'NAS Storage Unit',
    price: 599.99,
    slug: 'nas-storage-unit',
    description: 'Network attached storage with 4 bays.',
    features:
        '- Supports 4 hard drive bays.\n- Reliable NAS for data sharing.\n- Built-in data redundancy.\n- Remote access functionality.\n- Secure user access controls.',
    imageUrl: 'https://picsum.photos/seed/nas-storage-unit/400/400',
  ),
  const Product(
    id: '1016',
    name: 'Wi-Fi Router AX1800',
    price: 120.00,
    slug: 'wi-fi-router-ax1800',
    description: 'High-speed wireless router.',
    features:
        '- Dual-band AX1800 Wi-Fi.\n- Fast wireless speed.\n- Wide coverage and stable signal.\n- Easy mobile app setup.\n- Supports multiple devices.',
    imageUrl: 'https://picsum.photos/seed/wi-fi-router-ax1800/400/400',
  ),
  const Product(
    id: '1017',
    name: 'Ethernet Switch 8-Port',
    price: 59.00,
    slug: 'ethernet-switch-8-port',
    description: 'Unmanaged gigabit switch.',
    features:
        '- 8-port Gigabit Ethernet switch.\n- Unmanaged, plug-and-play setup.\n- Compact and fanless design.\n- Energy-efficient operation.\n- Ideal for small networks.',
    imageUrl: 'https://picsum.photos/seed/ethernet-switch-8-port/400/400',
  ),
  const Product(
    id: '1018',
    name: 'Wireless Access Point',
    price: 139.00,
    slug: 'wireless-access-point',
    description: 'Seamless Wi-Fi expansion device.',
    features:
        '- Boosts existing Wi-Fi coverage.\n- Supports dual-band connectivity.\n- Simple setup and management.\n- Wall-mountable design.\n- Stable and fast connections.',
    imageUrl: 'https://picsum.photos/seed/wireless-access-point/400/400',
  ),
  const Product(
    id: '1019',
    name: 'USB Wi-Fi Adapter',
    price: 25.00,
    slug: 'usb-wi-fi-adapter',
    description: 'Mini wireless USB adapter.',
    features:
        '- Mini USB Wi-Fi adapter.\n- Stable wireless performance.\n- Compact and low-profile design.\n- Plug-and-play installation.\n- Ideal for laptops and PCs.',
    imageUrl: 'https://picsum.photos/seed/usb-wi-fi-adapter/400/400',
  ),
  const Product(
    id: '1020',
    name: 'LAN Cable CAT6',
    price: 9.99,
    slug: 'lan-cable-cat6',
    description: 'High-speed Ethernet cable 5m.',
    features:
        '- Category 6 high-speed cable.\n- Supports up to 1Gbps transfer.\n- 5-meter length for flexible use.\n- Durable and reliable material.\n- Great for routers and modems.',
    imageUrl: 'https://picsum.photos/seed/lan-cable-cat6/400/400',
  ),
  const Product(
    id: '1021',
    name: 'Ergonomic Mouse',
    price: 23.00,
    slug: 'ergonomic-mouse',
    description:
        'Ergonomic mouse designed for long working sessions with a comfortable grip.',
    features:
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit.\nFusce dapibus lorem eu lobortis sagittis.\nNunc consequat est at nulla fermentum convallis.\nDonec ut lacus a eros malesuada vestibulum sit amet vel ipsum.\nNulla lacinia mi rhoncus elit maximus finibus.',
    imageUrl: 'https://picsum.photos/seed/ergonomic-mouse/400/400',
  ),
  const Product(
    id: '1022',
    name: 'XCD AV to HDMI Converter V2',
    price: 45.00,
    slug: 'xcd-av-to-hdmi-converter-v2',
    description: 'Converts RCA signal to HDMI and upscales to 1080p.',
    features:
        'Use: Converts RCA signal to HDMI\nCompatibility: Upscales content to 1080P\nDesign: Composite video and audio input',
    imageUrl: 'https://picsum.photos/seed/xcd-av-to-hdmi-converter-v2/400/400',
  ),
  const Product(
    id: '1023',
    name: 'Targus 65W USB-C Laptop Charger',
    price: 79.00,
    slug: 'targus-65w-usb-c-laptop-charger',
    description:
        'Compact 65W USB-C charger to keep laptops, tablets, and phones powered on the go.',
    features:
        'Compatible with USB-C laptops, tablets, and phones*\nUSB-C Power Delivery charges USB-C laptops up to 65W\nOverall Cable length 3m\nCable management tie for organisation and easy storage',
    imageUrl: 'https://picsum.photos/seed/targus-65w-usb-c-laptop-charger/400/400',
  ),
  const Product(
    id: '1024',
    name: 'Targus Dual Travel USB 3.0 & USB-C Dock',
    price: 79.00,
    slug: 'targus-dual-travel-usb-3-0-usb-c-dock',
    description: 'Compact travel dock with USB-A, USB-C, HDMI, and card slots.',
    features:
        'Aluminium enclosure design\n4K HDMI port\nUp to 100w power delivery\nSD & Micro SD ports\n1 x USB-C port\n2 x USB-A 3.0 ports\nSlim design',
    imageUrl: 'https://picsum.photos/seed/targus-dual-travel-usb-3-0-usb-c-dock/400/400',
  ),
]);
