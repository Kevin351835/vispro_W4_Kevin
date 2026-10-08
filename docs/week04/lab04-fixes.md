Catatan Perbaikan

1. StoreHeader. Pada layar 320 dp, susunan nama toko, jam buka, dan rating yang berada dalam satu Row menyebabkan overflow di sebelah kanan sebesar __ piksel. Penyebabnya adalah Row memberikan lebar tak terbatas pada Column, sehingga Text tidak tahu di mana harus memotong baris. Saya membungkus Column dengan Expanded, menambahkan maxLines dan TextOverflow.ellipsis pada teks, serta memindahkan posisi rating ke bawah jam buka.

2. CategoryBar. Enam chip kategori terlalu lebar untuk layar kecil sehingga memicu overflow di sebelah kanan. Row tidak membatasi ukuran anak-anaknya, padahal jumlah chip tidak dapat diprediksi. Saya membungkus Row dengan SingleChildScrollView horizontal agar deretan chip dapat digulir.

3. PromoStrip. Dua kartu promo berukuran width: 200 beserta jarak di antaranya melebihi kapasitas layar 320 dp, sehingga terjadi overflow di sebelah kanan. Di sini induk telah memberikan batas 320 dp, tetapi anak memaksa ukurannya sendiri. Saya membungkus setiap kartu dengan Expanded agar lebarnya menyesuaikan sisa ruang, lalu menggunakan IntrinsicHeight agar kedua kartu memiliki tinggi yang sama.

4. PromoCard. Saat nama produk terlalu panjang, isi kartu melebihi batas tinggi 150 dp yang ditentukan, sehingga terjadi overflow di bagian bawah atau teks terpotong. Menentukan tinggi secara kaku merupakan langkah yang kurang tepat karena tinggi konten seharusnya menyesuaikan panjang teks. Saya menghapus SizedBox berukuran tetap, mengganti Spacer dengan SizedBox kecil, serta menambahkan maxLines: 2 dan ellipsis pada nama produk.

5. MenuScreen (promo). Saat data promo kosong, aplikasi mengalami crash akibat RangeError karena kode mengakses promos[0] dan promos[1] secara langsung. Hal ini merupakan kesalahan asumsi data, bukan masalah tata letak. Saya mengatasinya dengan memakai .take(2), mengubah parameter kedua menjadi nullable, serta menyembunyikan strip promo jika tidak ada promo.

6. MenuTile. Nama produk sepanjang 200 karakter menyebabkan overflow di sebelah kanan sebesar __ piksel. Column yang memuat nama produk berada di dalam Row tanpa Expanded, sehingga lebarnya menjadi tak terbatas. Saya membungkus Column tersebut dengan Expanded, menambahkan maxLines: 2 dan ellipsis, serta menghapus Spacer.

7. MenuScreen (daftar). Saat memuat 500 item, daftar menjadi lambat karena ListView(children: [...]) membangun seluruh item secara bersamaan, bukan hanya yang terlihat di layar. Daftar dengan jumlah item yang tidak terukur harus dibangun secara lazy. Saya menggantinya dengan SliverList.builder.

8. MenuScreen (grid tablet). Pada layar selebar 800 dp, kartu di dalam grid mengalami overflow di bagian bawah. Grid menggunakan crossAxisCount: 4 yang kaku dan childAspectRatio bawaan, sehingga sel terlalu pendek untuk isinya. Saya menggantinya dengan SliverGridDelegateWithMaxCrossAxisExtent agar jumlah kolom dapat menyesuaikan lebar ruang yang tersedia.

9. MenuCard. Di dalam sel grid, kartu mengalami overflow di bagian bawah karena gambar dipatok height: 110, padahal tinggi sel sepenuhnya ditentukan oleh grid. Saya membungkus area gambar dengan Expanded agar mengambil sisa ruang yang ada, serta menambahkan maxLines pada teks.

10. MenuScreen (breakpoint). Penentuan tata letak tablet sebelumnya menggunakan MediaQuery.sizeOf(context).width > 600. Keputusan tata letak seharusnya didasarkan pada batas (constraints) yang diberikan oleh induk, bukan ukuran layar keseluruhan. Saya menggantinya dengan LayoutBuilder dan menerapkan syarat constraints.maxWidth >= 600.

11. MenuScreen (body). Pada mode landscape dan saat papan ketik terbuka, terjadi overflow di bagian bawah. Column yang berisi header, pencarian, kategori, dan promo memiliki total tinggi yang melebihi ruang tersisa. Saya menyatukan semuanya ke dalam satu CustomScrollView menggunakan slivers, sehingga konten dapat digulir dan daftar tetap dimuat secara lazy.

12. CartBar. Pada layar 320 dp, bilah keranjang mengalami overflow di sebelah kanan akibat adanya height: 72 dan tombol width: 160 yang kaku, sementara teksnya tidak dibungkus Expanded. Saya membungkus teks dengan Expanded (maxLines: 2) dan menghapus ukuran tetap tersebut.

13. MenuScreen (data kosong). Saat tidak ada item (nol item), layar menjadi kosong tanpa penjelasan karena kode belum menangani kondisi data kosong. Saya menambahkan widget EmptyState yang berisi ikon, pesan penjelasan, dan tombol "Reset filter", dengan key: const Key('empty-state') agar dapat ditemukan saat pengujian.

14. CartBar dan body (area aman). Pada perangkat dengan notch dan gesture bar, tombol dapat berada di bawah gesture bar dan konten sisi kiri terpotong oleh notch saat mode landscape karena kode mengabaikan MediaQuery.padding. Saya membungkus isi CartBar dengan SafeArea (dengan warna latar tetap berlanjut ke bawah) dan membungkus body dengan SafeArea(bottom: false).

Adapun beberapa pola yang muncul berulang kali

- Teks dalam Row tanpa batasan: Row yang membungkus Text atau Column tanpa Expanded (kasus 1, 6, 12) selalu berujung overflow karena teks kehilangan acuan untuk melipat baris (text wrapping).

- Ukuran kaku (hardcoded size): Menentukan width atau height secara eksplisit (kasus 3, 4, 9, 12) sering kali bentrok dengan batas ruang dari induk.

- Konten melampaui layar: Memaksa elemen yang melebihi kapasitas ruang untuk tetap muat tanpa mekanisme scrolling (kasus 2, 11).

- Asumsi data yang kurang matang: Menganggap data akan selalu ada atau jumlahnya pasti, padahal kode harus siap menghadapi kondisi data kosong maupun data berjumlah banyak (kasus 5, 13).