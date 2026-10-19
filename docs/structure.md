lib/
├── core/
│   ├── app_theme.dart         # Konfigurasi ThemeData Material 3 (Light & Dark Mode)
│   └── empty_state.dart       # Widget reusable untuk tampilan pencarian/data kosong
├── data/
│   ├── drama_model.dart       # Model data utama DramaModel
│   ├── xianxia_data.dart      # Mock dataset sub-genre Xianxia / Fantasy
│   ├── wuxia_data.dart        # Mock dataset sub-genre Wuxia / Martial Arts
│   ├── palace_data.dart       # Mock dataset sub-genre Historical / Palace
│   └── drama_repository.dart  # Data layer & manajemen state bookmark sementara
├── screens/
│   ├── discovery_screen.dart  # Halaman utama (Katalog, Search, & Filter Genre)
│   ├── detail_screen.dart     # Halaman detail drama & statistik pemain
│   └── bookmark_screen.dart   # Halaman daftar drama favorit
├── widgets/
│   ├── drama_card.dart        # Widget komponen kartu drama
│   └── category_bar.dart      # Widget filter horizontal genre
├── app.dart                   # Root widget MaterialApp & konfigurasi tema
└── main.dart                  # Entry point utama aplikasi