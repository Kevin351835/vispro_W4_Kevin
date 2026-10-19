1. Which structural decision from Week 1 helped you most by Week 5?
Keputusan struktural yang paling membantu adalah pemisahan data model dan pengelompokan tema terpusat (`app_theme.dart`). Dengan memisahkan `DramaModel` dan `DramaRepository` sejak awal, penambahan fitur Bookmark dan Filter Category di Minggu ke-5 menjadi sangat mudah dilakukan tanpa perlu merombak ulang struktur halaman UI. Selain itu, penggunaan tema terpusat memastikan Dark Mode dan Light Mode langsung bekerja secara konsisten di seluruh layar baru.

2. Which one cost you time, and what would you do differently?
Keputusan yang sempat menyita waktu adalah penggabungan seluruh mock data dalam satu berkas di awal pengerjaan. Hal tersebut menyebabkan jumlah baris berkas membengkak dan mendekati batas aturan 200 baris, sehingga saya harus melakukan refactoring dengan memecah mock data menjadi berkas terpisah per sub-genre (`xianxia_data.dart`, `wuxia_data.dart`, `palace_data.dart`). Ke depannya, saya akan memecah dataset berdasarkan kategori domain sejak awal pembuatan struktur folder.

3. Where is your app's state right now, and what will be hard about moving it in Module 2?
Saat ini state aplikasi dikelola menggunakan ephemeral/local state (`setState`) yang dipadukan dengan pola Singleton pada `DramaRepository` untuk menyimpan status bookmark.

Tantangan saat berpindah ke Module 2:
Ketika berpindah ke State Management tingkat lanjut (seperti Provider, BLoC, atau Riverpod) yang terhubung dengan API/Database di Module 2, tantangan utamanya adalah mengelola reactive state synchronization. Status *bookmark* yang diubah di `DetailScreen` harus langsung memperbarui tampilan di `DiscoveryScreen` dan `BookmarkScreen` secara real-time tanpa perlu pemanggilan `setState()` manual atau navigasi berulang.