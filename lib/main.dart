import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

const bool kLabHarness = true;

void main() => runApp(kLabHarness ? const LabHarness() : const Lab04App());

class MenuItem {
  const MenuItem({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    this.promo = false,
  });

  final String id;
  final String name;
  final String category;
  final int price;
  final bool promo;
}

const String kAppTitle = 'Warung Digital';
const String kStoreName = '$kAppTitle — Kampus Kota Makassar';
const String kStoreHours = 'Buka setiap hari · 08.00–21.00';

const List<String> kCategories = [
  'Semua',
  'Makanan',
  'Minuman',
  'Camilan',
  'Promo',
  'Paket Hemat',
];

const List<MenuItem> kMenu = [
  MenuItem(id: 'm1', name: 'Nasi Goreng Spesial', category: 'Makanan', price: 18000, promo: true),
  MenuItem(id: 'm2', name: 'Mie Ayam Bakso', category: 'Makanan', price: 15000),
  MenuItem(id: 'm3', name: 'Sate Ayam (10 tusuk)', category: 'Makanan', price: 25000),
  MenuItem(id: 'm4', name: 'Ayam Geprek Sambal Matah', category: 'Makanan', price: 20000, promo: true),
  MenuItem(id: 'm5', name: 'Pisang Goreng Keju', category: 'Camilan', price: 12000),
  MenuItem(id: 'm6', name: 'Es Teh Manis', category: 'Minuman', price: 5000),
  MenuItem(id: 'm7', name: 'Kopi Susu Gula Aren', category: 'Minuman', price: 12000),
  MenuItem(id: 'm8', name: 'Paket Hemat Ayam + Es Teh', category: 'Paket Hemat', price: 23000, promo: true),
];

const String kLongName =
    'Nasi Goreng Spesial Kampung dengan Telur Mata Sapi, Ayam Suwir Pedas, '
    'Sate Usus, Kerupuk Udang Sidoarjo, Acar Timun Segar, Sambal Matah Bali, '
    'dan Taburan Bawang Goreng Renyah Khas Kota Makassar Sulsel';

const List<MenuItem> kLongNameMenu = [
  MenuItem(id: 'long', name: kLongName, category: 'Makanan', price: 45000, promo: true),
  ...kMenu,
];

const List<String> _kinds = ['Makanan', 'Minuman', 'Camilan', 'Paket Hemat'];

final List<MenuItem> kBigMenu = List<MenuItem>.generate(
  500,
  (i) => MenuItem(
    id: 'g$i',
    name: 'Menu ${i + 1}',
    category: _kinds[i % _kinds.length],
    price: 5000 + (i % 20) * 1000,
    promo: i % 9 == 0,
  ),
);

abstract final class Gap {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
}

abstract final class AppBreakpoints {
  static const double tablet = 600;

  static const double cardTargetWidth = 360;
}

abstract final class AppTheme {
  static const Color _seed = Color(0xFF00696E);

  static ThemeData light() => _build(Brightness.light);
  static ThemeData dark() => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: _seed, brightness: brightness),
    );
  }
}

String rupiah(int value) {
  final digits = value.toString();
  final out = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) out.write('.');
    out.write(digits[i]);
  }
  return 'Rp $out';
}

IconData iconFor(String category) => switch (category) {
      'Makanan' => Icons.rice_bowl,
      'Minuman' => Icons.local_cafe,
      'Camilan' => Icons.cookie,
      'Paket Hemat' => Icons.lunch_dining,
      _ => Icons.restaurant,
    };

class Lab04App extends StatelessWidget {
  const Lab04App({
    super.key,
    this.items = kMenu,
    this.themeMode = ThemeMode.system,
  });

  final List<MenuItem> items;
  final ThemeMode themeMode;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: kAppTitle,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: themeMode,
      scrollBehavior: const MaterialScrollBehavior()
          .copyWith(dragDevices: PointerDeviceKind.values.toSet()),
      home: MenuScreen(items: items),
    );
  }
}

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key, required this.items});

  final List<MenuItem> items;

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final TextEditingController _search = TextEditingController();
  String _query = '';
  String _category = kCategories.first;
  final Map<String, int> _qty = {};

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  List<MenuItem> get _visible => widget.items.where((item) {
        final matchesQuery =
            _query.isEmpty || item.name.toLowerCase().contains(_query.toLowerCase());
        final matchesCategory = switch (_category) {
          'Semua' => true,
          'Promo' => item.promo,
          _ => item.category == _category,
        };
        return matchesQuery && matchesCategory;
      }).toList();

  int get _count => _qty.values.fold(0, (sum, n) => sum + n);

  int get _total {
    var total = 0;
    for (final item in widget.items) {
      total += (_qty[item.id] ?? 0) * item.price;
    }
    return total;
  }

  void _add(MenuItem item) {
    setState(() => _qty[item.id] = (_qty[item.id] ?? 0) + 1);
  }

  void _order() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Pesanan dikirim: $_count item')),
    );
    setState(() => _qty.clear());
  }

  void _resetFilters() {
    _search.clear();
    setState(() {
      _query = '';
      _category = kCategories.first;
    });
  }

  Widget _card(MenuItem item) => MenuCard(
        key: ValueKey(item.id),
        item: item,
        quantity: _qty[item.id] ?? 0,
        onAdd: () => _add(item),
      );

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final visible = _visible;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(title: const Text(kAppTitle)),
      body: SafeArea(
        bottom: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final wide = constraints.maxWidth >= AppBreakpoints.tablet;
            final available = constraints.maxWidth - Gap.md * 2;
            final columns = (available / AppBreakpoints.cardTargetWidth)
                .floor()
                .clamp(1, visible.isEmpty ? 1 : visible.length);
            final rows = (visible.length / columns).ceil();

            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(Gap.md, Gap.md, Gap.md, Gap.sm),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          kStoreName,
                          style: text.titleLarge,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: Gap.xs),
                        Text(
                          kStoreHours,
                          style: text.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Gap.md),
                    child: TextField(
                      key: const Key('search-field'),
                      controller: _search,
                      onChanged: (v) => setState(() => _query = v),
                      decoration: InputDecoration(
                        hintText: 'Cari menu',
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: _query.isEmpty
                            ? null
                            : IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  _search.clear();
                                  setState(() => _query = '');
                                },
                              ),
                        border: const OutlineInputBorder(),
                        isDense: true,
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(
                      horizontal: Gap.md,
                      vertical: Gap.sm,
                    ),
                    child: Row(
                      children: [
                        for (final c in kCategories)
                          Padding(
                            padding: const EdgeInsets.only(right: Gap.sm),
                            child: ChoiceChip(
                              label: Text(c, maxLines: 1, overflow: TextOverflow.ellipsis),
                              selected: _category == c,
                              onSelected: (_) => setState(() => _category = c),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                if (visible.isEmpty)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: EmptyState(
                      key: const Key('empty-state'),
                      onReset: _resetFilters,
                    ),
                  )
                else if (wide)
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(Gap.md, Gap.xs, Gap.md, Gap.md),
                    sliver: SliverList.separated(
                      itemCount: rows,
                      separatorBuilder: (_, __) => const SizedBox(height: Gap.sm),
                      itemBuilder: (context, row) {
                        return IntrinsicHeight(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              for (var col = 0; col < columns; col++) ...[
                                if (col > 0) const SizedBox(width: Gap.sm),
                                Expanded(
                                  child: row * columns + col < visible.length
                                      ? _card(visible[row * columns + col])
                                      : const SizedBox.shrink(),
                                ),
                              ],
                            ],
                          ),
                        );
                      },
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(Gap.md, Gap.xs, Gap.md, Gap.md),
                    sliver: SliverList.separated(
                      itemCount: visible.length,
                      separatorBuilder: (_, __) => const SizedBox(height: Gap.sm),
                      itemBuilder: (context, i) => _card(visible[i]),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: CartBar(
        count: _count,
        total: _total,
        onOrder: _order,
      ),
    );
  }
}

class MenuCard extends StatelessWidget {
  const MenuCard({
    super.key,
    required this.item,
    required this.quantity,
    required this.onAdd,
  });

  final MenuItem item;
  final int quantity;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(Gap.md),
        child: Row(
          children: [
            DecoratedBox(
              decoration: ShapeDecoration(
                color: cs.secondaryContainer,
                shape: const CircleBorder(),
              ),
              child: Padding(
                padding: const EdgeInsets.all(Gap.md),
                child: Icon(iconFor(item.category), color: cs.onSecondaryContainer),
              ),
            ),
            const SizedBox(width: Gap.md),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: text.titleSmall,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: Gap.xs),
                  Wrap(
                    spacing: Gap.sm,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        rupiah(item.price),
                        style: text.bodyMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (item.promo)
                        Chip(
                          label: const Text('Promo'),
                          backgroundColor: cs.tertiaryContainer,
                          labelStyle: text.labelSmall
                              ?.copyWith(color: cs.onTertiaryContainer),
                          visualDensity: VisualDensity.compact,
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          side: BorderSide.none,
                        ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: Gap.sm),
            Badge(
              isLabelVisible: quantity > 0,
              label: Text('$quantity'),
              child: IconButton.filledTonal(
                onPressed: onAdd,
                tooltip: 'Tambah',
                icon: const Icon(Icons.add),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CartBar extends StatelessWidget {
  const CartBar({
    super.key,
    required this.count,
    required this.total,
    required this.onOrder,
  });

  final int count;
  final int total;
  final VoidCallback onOrder;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return Container(
      color: cs.surfaceContainerHigh,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Gap.md, vertical: Gap.sm),
          child: Row(
            children: [
              Icon(Icons.shopping_bag_outlined, color: cs.onSurfaceVariant),
              const SizedBox(width: Gap.sm),
              Expanded(
                child: Text(
                  'Pesanan: $count item · Total ${rupiah(total)}',
                  style: text.titleSmall,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: Gap.md),
              FilledButton(
                key: const Key('order-button'),
                onPressed: count == 0 ? null : onOrder,
                child: const Text('Pesan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EmptyState extends StatelessWidget {
  const EmptyState({super.key, required this.onReset});

  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.all(Gap.lg),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.search_off, size: Gap.xl * 2, color: cs.onSurfaceVariant),
            const SizedBox(height: Gap.md),
            Text(
              'Menu tidak ditemukan',
              style: text.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: Gap.xs),
            Text(
              'Coba kata kunci atau kategori lain.',
              style: text.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: Gap.md),
            FilledButton.tonal(
              onPressed: onReset,
              child: const Text('Reset filter'),
            ),
          ],
        ),
      ),
    );
  }
}

enum _Device {
  small('Small phone', Size(320, 568)),
  large('Large phone', Size(430, 932)),
  tablet('Tablet', Size(800, 1280));

  const _Device(this.label, this.size);

  final String label;
  final Size size;
}

enum _Data {
  normal('Normal'),
  longName('200-char name'),
  empty('Zero items'),
  big('500 items');

  const _Data(this.label);

  final String label;

  List<MenuItem> get items => switch (this) {
        _Data.normal => kMenu,
        _Data.longName => kLongNameMenu,
        _Data.empty => const <MenuItem>[],
        _Data.big => kBigMenu,
      };
}

class LabHarness extends StatefulWidget {
  const LabHarness({super.key});

  @override
  State<LabHarness> createState() => _LabHarnessState();
}

class _LabHarnessState extends State<LabHarness> {
  _Device _device = _Device.small;
  _Data _data = _Data.normal;
  bool _landscape = false;
  bool _keyboard = false;
  bool _dark = false;
  bool _insets = false;

  Size get _screen => _landscape ? _device.size.flipped : _device.size;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab 04 · device harness',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: const Color(0xFF455A64)),
      home: Builder(
        builder: (context) => Scaffold(
          body: SafeArea(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(width: 280, child: _panel(context)),
                const VerticalDivider(width: 1),
                Expanded(child: _stage(context)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _panel(BuildContext context) {
    final text = Theme.of(context).textTheme;

    Widget group(String title, List<Widget> chips) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: text.labelLarge),
            const SizedBox(height: 8),
            Wrap(spacing: 8, runSpacing: 8, children: chips),
          ],
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('Lab 04 · device harness', style: text.titleMedium),
        const SizedBox(height: 4),
        Text(
          'Try every combination. Keep the debug console open: '
          '"A RenderFlex overflowed by … pixels" names the widget, the axis and the amount.',
          style: text.bodySmall,
        ),
        const SizedBox(height: 20),
        group('Screen', [
          for (final d in _Device.values)
            ChoiceChip(
              label: Text(d.label),
              selected: _device == d,
              onSelected: (_) => setState(() => _device = d),
            ),
        ]),
        group('Orientation', [
          ChoiceChip(
            label: const Text('Portrait'),
            selected: !_landscape,
            onSelected: (_) => setState(() => _landscape = false),
          ),
          ChoiceChip(
            label: const Text('Landscape'),
            selected: _landscape,
            onSelected: (_) => setState(() => _landscape = true),
          ),
        ]),
        group('Data', [
          for (final d in _Data.values)
            ChoiceChip(
              label: Text(d.label),
              selected: _data == d,
              onSelected: (_) => setState(() => _data = d),
            ),
        ]),
        group('Conditions', [
          FilterChip(
            label: const Text('Keyboard open'),
            selected: _keyboard,
            onSelected: (v) => setState(() => _keyboard = v),
          ),
          FilterChip(
            label: const Text('Dark mode'),
            selected: _dark,
            onSelected: (v) => setState(() => _dark = v),
          ),
          FilterChip(
            label: const Text('Notch + gesture bar'),
            selected: _insets,
            onSelected: (v) => setState(() => _insets = v),
          ),
        ]),
        Text(
          'Screen: ${_screen.width.toInt()} × ${_screen.height.toInt()} dp',
          style: text.bodySmall,
        ),
      ],
    );
  }

  Widget _stage(BuildContext context) {
    final size = _screen;
    final keyboard = _keyboard ? (_landscape ? 180.0 : 260.0) : 0.0;
    final padding = !_insets
        ? EdgeInsets.zero
        : _landscape
            ? const EdgeInsets.only(left: 32, bottom: 20)
            : const EdgeInsets.only(top: 32, bottom: 20);
    final safe = keyboard > 0 ? padding.copyWith(bottom: 0) : padding;
    final media = MediaQuery.of(context).copyWith(
      size: size,
      padding: safe,
      viewPadding: safe,
      viewInsets: EdgeInsets.only(bottom: keyboard),
    );

    return ColoredBox(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFF1B1D1F),
                borderRadius: BorderRadius.circular(30),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: SizedBox.fromSize(
                  size: size,
                  child: MediaQuery(
                    data: media,
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: Lab04App(
                            key: ValueKey(_data),
                            items: _data.items,
                            themeMode: _dark ? ThemeMode.dark : ThemeMode.light,
                          ),
                        ),
                        if (padding.top > 0)
                          Positioned(
                            left: 0,
                            right: 0,
                            top: 0,
                            height: padding.top,
                            child: const IgnorePointer(child: _FakeStatusBar()),
                          ),
                        if (padding.left > 0)
                          Positioned(
                            left: 0,
                            top: 0,
                            bottom: 0,
                            width: padding.left,
                            child: const IgnorePointer(
                              child: ColoredBox(color: Color(0xFF000000)),
                            ),
                          ),
                        if (safe.bottom > 0)
                          Positioned(
                            left: 0,
                            right: 0,
                            bottom: 0,
                            height: safe.bottom,
                            child: const IgnorePointer(child: _FakeGestureBar()),
                          ),
                        if (keyboard > 0)
                          Positioned(
                            left: 0,
                            right: 0,
                            bottom: 0,
                            height: keyboard,
                            child: const IgnorePointer(child: _FakeKeyboard()),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FakeStatusBar extends StatelessWidget {
  const _FakeStatusBar();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text('9:41', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
          ),
        ),
        Center(
          child: Container(
            width: 84,
            height: 22,
            decoration: BoxDecoration(
              color: const Color(0xFF000000),
              borderRadius: BorderRadius.circular(11),
            ),
          ),
        ),
      ],
    );
  }
}

class _FakeGestureBar extends StatelessWidget {
  const _FakeGestureBar();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 120,
        height: 5,
        decoration: BoxDecoration(
          color: const Color(0x99000000),
          borderRadius: BorderRadius.circular(3),
        ),
      ),
    );
  }
}

class _FakeKeyboard extends StatelessWidget {
  const _FakeKeyboard();

  static const List<String> _rows = ['qwertyuiop', 'asdfghjkl', 'zxcvbnm'];

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: const Color(0xFF2B2F33),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Column(
          children: [
            for (final row in _rows)
              Expanded(
                child: Row(
                  children: [
                    for (final letter in row.split('')) Expanded(child: _Key(letter)),
                  ],
                ),
              ),
            const Expanded(
              child: Row(
                children: [
                  Expanded(flex: 2, child: _Key('123')),
                  Expanded(flex: 6, child: _Key('spasi')),
                  Expanded(flex: 2, child: _Key('⏎')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Key extends StatelessWidget {
  const _Key(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: const Color(0xFF4A4F55),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Center(
          child: FittedBox(
            child: Padding(
              padding: const EdgeInsets.all(2),
              child: Text(
                label,
                style: const TextStyle(color: Color(0xCCFFFFFF), fontSize: 14),
              ),
            ),
          ),
        ),
      ),
    );
  }
}