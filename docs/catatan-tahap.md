# Catatan Worksheet State Management & Architecture

## Tahap 1 - Local State vs Shared State

| State atau data | Lokasi/penggunaan di Course Explorer | Kategori | Alasan |
|---|---|---|---|
| Detail pada switch Home | `HomePage._showDetail` | Local | Hanya mengubah bagian HomePage. |
| Jumlah kirim feedback | `FeedbackForm._loading` | Local | Hanya mengatur tampilan form saat submit. |
| Hasil feedback | `FeedbackForm._result` | Local | Hanya ditampilkan kembali di form tersebut. |
| Tab navigasi terpilih | `ResponsiveShell._index` | Shared dalam shell | Dipakai untuk menyelaraskan NavigationBar/NavigationRail dan IndexedStack. |
| Favorite course | Aksi pada halaman daftar dan detail | Shared lintas screen (kebutuhan) | Nilainya perlu tetap sama saat dibaca atau diubah dari beberapa screen; implementasinya akan dikerjakan pada tahap berikutnya. |
| Preferensi tema | Pengaturan tampilan aplikasi | Shared lintas aplikasi (kebutuhan) | Jika dapat diubah pengguna, nilainya perlu memengaruhi semua screen. |

Pada eksperimen Tahap 1, counter dan switch menggunakan `setState()` di
`LocalStateDemoPage`. Keduanya adalah local state karena hanya diperlukan oleh
halaman demo tersebut.

## Tahap 2 - Masalah setState() Saat Aplikasi Membesar

Demo menyimpan satu `Set<String>` favorite dan mengubahnya dengan
`setState()` di `PropDrillingDemoPage`. Parent mengirim nilai yang sama melalui
constructor ke `_FavoriteSummary` dan `_CourseList`; `_CourseList` menghitung
status tiap baris dan mengirim callback toggle ke parent.

Bagian yang berulang atau mulai sulit diikuti:

- `favoriteCodes` harus ditambahkan sebagai field, parameter constructor, dan
  argumen saat membuat kedua child.
- Callback `onToggleFavorite` harus ikut diteruskan ke daftar dan dibungkus
  dengan kode course untuk setiap baris.
- Jika child baru juga membutuhkan favorite, parent perlu menambahkan lagi
  parameter dan wiring callback. Makin dalam hierarki widget, makin banyak
  lapisan yang hanya meneruskan nilai.

## Tahap 3 - Lifting State Up dan Single Source of Truth

Setelah state dipindah ke parent (`LiftingStateDemoPage`), kartu (`CourseCard`) dan kotak switch (`_FavoriteSwitch`) selalu konsisten karena hanya ada satu variabel `_isFavorite` sebagai *single source of truth*.

Child tidak menyimpan salinan state lokal; perubahan dikirim via callback (`onFavoriteTap` dan `onChanged`) ke method parent yang memanggil `setState()`.

Kekurangannya: parent tetap harus meneruskan data dan callback secara manual ke child melalui constructor.

## Tahap 4 - ValueNotifier dan ValueListenableBuilder

Saat tombol ditekan pada `ValueNotifierDemoPage`, log `debugPrint` membuktikan bahwa hanya `ValueListenableBuilder` yang di-rebuild untuk memperbarui teks angka. Widget induk (`ValueNotifierDemoPage`) tidak mengalami rebuild sama sekali.

Perbandingan dengan `setState()`:
- `setState()` membangun ulang seluruh method `build()` pada widget pemilik state tersebut beserta seluruh subtree-nya (kecuali child const).
- `ValueNotifier` + `ValueListenableBuilder` hanya membangun ulang widget di dalam builder yang mendengarkan perubahan nilai. Pola listener ini menjadi jembatan konsep menuju `ChangeNotifier` pada tahap berikutnya.

## Tahap 5 - ChangeNotifier dan notifyListeners()

`CourseProvider` memisahkan state `favorites` dan aksinya (`toggleFavorite()`, `isFavorite()`) dari widget tree ke dalam class mandiri yang mewarisi `ChangeNotifier`.

Saat state berubah di `toggleFavorite()`, pemanggilan `notifyListeners()` wajib dilakukan agar semua listener yang mendengarkan provider ini diberitahu untuk membangun ulang UI mereka. Pengujian unit pada `test/course_provider_test.dart` membuktikan bahwa listener terpanggil tepat 2 kali untuk 2 kali toggle dan data favorit tersimpan dengan benar.

## Tahap 6 - Memasang Provider pada Widget Tree

Dependency `provider` berhasil ditambahkan ke `pubspec.yaml` dan perintah `flutter pub get` dijalankan.

`ChangeNotifierProvider` dipasang membungkus root aplikasi (`CourseExplorerApp`) di dalam fungsi `main()` pada `lib/main.dart`. Dengan posisi di atas root `MaterialApp`, seluruh widget dan screen di bawahnya (termasuk yang dibuka via `Navigator.push`) dapat mengakses `CourseProvider` melalui `BuildContext`. Aplikasi tetap berjalan normal.

## Tahap 7 - context.watch(), context.read(), dan Consumer

Pengamatan rebuild pada `ProviderDemoPage`:
- Saat tombol ikon favorit ditekan, halaman induk `ProviderDemoPage` dan widget `_CourseTile` tidak mengalami rebuild.
- Yang di-rebuild secara spesifik hanyalah:
  1. `_FavoriteCount` (karena menggunakan `context.watch<CourseProvider>()` untuk mendengarkan perubahan data panjang favorites).
  2. Widget ikon di dalam `Consumer<CourseProvider>` pada item yang bersangkutan.

Pertanyaan: Mengapa `onPressed` lebih cocok memakai `read()` daripada `watch()`?
Jawaban: `onPressed` dijalankan saat event callback tombol ditekan, bukan saat proses rendering widget (`build()`). `watch()` mendaftarkan widget sebagai listener dan hanya boleh dipanggil di dalam method `build()`; memanggilnya di callback dapat menimbulkan runtime error dan memicu rebuild yang tidak perlu. Sementara itu, `read()` mengambil objek provider satu kali tanpa berlangganan (tidak listen), sehingga tepat dan efisien untuk memanggil method aksi seperti `toggleFavorite()`.

## Tahap 8 - Model Course

Model `Course` dibuat dengan atribut: `code`, `title`, `credits`, dan `status`. Factory `Course.fromJson()` memusatkan parsing struktur Map/JSON menjadi objek bertipe statis kuat (*strongly typed*).

UI pada `ModelDemoPage` membaca nilai melalui properti objek yang jelas seperti `course.title` dan `course.credits`, bukan `map['title']` atau `map['credits']`. Hal ini menghilangkan risiko typo key pada UI dan memusatkan validasi data di satu tempat.

## Tahap 9 - Service / Data Source

`CourseService.loadCourses()` membaca `assets/data/student_data.json` melalui
`rootBundle`, mengurai JSON, lalu mengembalikan data sebagai `List<Course>`.
Dengan demikian, detail pemuatan asset dan parsing tidak perlu dilakukan oleh
screen. Test `test/course_service_test.dart` memastikan service mengembalikan
daftar model Course dengan field utama yang terisi.

## Tahap 10 - Repository Pattern

`CourseRepository` menerima `CourseService` melalui constructor dan menyediakan
`getCourses()` untuk layer Provider. Provider bergantung pada repository yang
wajib diinjeksi, bukan membaca asset atau mem-parsing JSON sendiri. Test
`test/course_repository_test.dart` menggunakan data source palsu untuk
memastikan repository meneruskan permintaan dan hasilnya dengan benar.

Jika sumber data diganti dari JSON lokal menjadi API, perubahan detail jaringan
dapat ditempatkan di service. Provider dan screen tetap memakai kontrak
repository yang sama sehingga tidak perlu mengetahui cara data diambil.

