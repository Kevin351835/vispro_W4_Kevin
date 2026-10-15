A. Small Phone (320 dp) — Portrait Mode (Normal Data)
   Status: Pass
   Detail: Menggunakan CustomScrollView dan SliverList untuk memastikan konten dapat di-scroll dengan mulus di layar sempit tanpa overflow.

B. Large Phone (430 dp) — Portrait Mode (Normal Data)
   Status: Pass
   Detail: Tata letak menyesuaikan lebar layar secara proporsional tanpa ada elemen yang terpotong.

C. Tablet (800 dp) — Adaptive Layout Structure
   Status: Pass
   Detail: Menggunakan LayoutBuilder (breakpoint $\ge$ 600 dp) untuk mengubah struktur daftar dari SliverList menjadi SliverGrid.  

D. Small Phone Landscape (568 × 320 dp)
   Status: Pass
   Detail: Layar pendek tetap dapat di-scroll dengan baik, bilah pesanan (CartBar) tetap menempel di bagian bawah secara aman.

E. Large Phone Landscape (932 × 430 dp)
   Status: Pass
   Detail: Tata letak horizontal memanfaatkan ruang lebar secara efisien tanpa masalah constraint.

F. Tablet Landscape (1280 × 800 dp)
   Status: Pass
   Detail: Grid menyesuaikan jumlah kolom secara otomatis untuk mengisi ruang layar tablet yang luas.

G. Keyboard Open — Input Field Focus
   Status: Pass
   Detail: SearchBar berada di dalam scroll view sehingga bidang teks tetap terlihat dan aman saat keyboard virtual muncul.

H. Dark Mode — Color Contrast & Legibility
   Status: Pass
   Detail: Menggunakan ColorScheme dari Theme.of(context) sehingga semua teks dan ikon tetap kontras serta nyaman dibaca.

I. Notch + Gesture Bar — Safe Area Insets
   Status: Pass
   Detail: Memanfaatkan SafeArea sehingga tidak ada tombol atau konten yang tertutup oleh notch maupun bilah navigasi bawah.