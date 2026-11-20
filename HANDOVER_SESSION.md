# HANDOVER SESSION: Water Cycle Adventure
**Dokumen Status Proyek untuk Sesi Baru Agent**
*Update Terakhir: 17 November 2026*

---

## 📌 Ringkasan & Identitas Proyek
- **Judul Game**: *Water Cycle Adventure* (Petualangan Siklus Air)
- **Mata Kuliah**: Praktikum Multimedia 2 - PTIK FKIP Universitas Sebelas Maret (UNS) 2026
- **Pengembang**: Kelompok 14B (Giga Hidro Madani, Ryan Ivan Pratama, Muhammad Ramdhani)
- **Engine**: **Godot Engine v4.7.2** (Executable di `D:\APP\Godot\Godot_v4.7.2-stable_win64_console.exe`)
- **Konfigurasi Project**: 1280x720 px, mode `canvas_items`, renderer `gl_compatibility`, main scene `res://scenes/main_menu.tscn`.
- **Autoload**: `Global` (`res://scripts/global.gd`) untuk mengelola audio, skor (`score`), dan tracking capaian 4 pilar CT (`ct_decomposition`, `ct_pattern`, `ct_abstraction`, `ct_algorithm`).
- **Filosofi Asesmen CT**: **Tidak menggunakan sistem nyawa/Game Over**. Sebagai instrumen asesmen diagnostik kemampuan berpikir komputasional, siswa tidak dihukum atau dikeluarkan saat salah. Siswa bebas bereksplorasi (*trial and error*) dan kemampuan CT diukur secara objektif melalui jumlah percobaan, kesalahan pola/langkah, dan efisiensi solusi pada layar evaluasi akhir.

---

## 🧭 Integrasi 4 Pilar Computational Thinking (CT)
1. **Level 1 (Dekomposisi)**: Evaporasi & Transpirasi (Siswa memecah kondisi alam: ubah waktu ke siang hari + naikkan suhu $\ge 45^\circ\text{C}$ agar laut menguap & pohon berkeringat).
2. **Level 2 (Pengenalan Pola)**: Kondensasi (Siswa mengenali pola bahwa suhu atmosfer dingin $< 10^\circ\text{C}$ mengubah uap menjadi embun/awan).
3. **Level 3 (Abstraksi)**: Presipitasi (Siswa memilah informasi relevan: mengumpulkan HANYA tetesan air murni ke awan, mengabaikan pengecoh daun/layangan).
4. **Level 4 (Algoritma)**: Urutan Siklus Air (Siswa menyusun urutan logis 4 proses: Evaporasi $\to$ Kondensasi $\to$ Presipitasi $\to$ Infiltrasi menggunakan Drag & Drop bebas).
5. **Evaluasi Akhir**: Layar Evaluasi CT menampilkan rekap capaian skor 4 pilar CT secara komprehensif dengan sistem rating 3 bintang.

---

## 🚀 Status Implementasi Terkini (Sudah Selesai 100%)

### 1. Visual HUD Bersih & Imersif (*Immersive HUD*, `program/scenes/ui/hud.tscn`)
- **Murni Petualangan Sains & Stealth Assessment CT**:
  - **Bebas Jargon & Distraksi CT**: Keterangan "Pilar CT" maupun panel skor angka telah dihilangkan sepenuhnya dari layar bermain di semua level. Anak tidak dibebani oleh istilah teoritis (*Dekomposisi*, *Abstraksi*, dsb.) saat bermain, melainkan murni fokus pada petualangan siklus air.
  - **Pencatatan Halus di Latar Belakang**: Logika pilar CT tetap berjalan di *backend* untuk mengukur kemampuan berpikir komputasional siswa, dan baru disajikan secara edukatif pada Layar Evaluasi Akhir.
  - **Navigasi Bersih**: Hanya memuat tombol esensial yaitu Suara (Mute/Unmute) di kanan atas, serta tombol Home dan Materi di kiri bawah.

### 2. Layar Evaluasi CT & Akhir (`program/scenes/ui/victory.tscn`)
- **Visual Lucu, Modern & Serba Lengkung (*Curved & Pill Shapes*)**:
  - **Bukan Tema Kayu**: Sepenuhnya menggunakan palet warna bersih dan modern (*sky blue*, *ice cream white*, *soft amber*, *mint green*).
  - **Header Melengkung (*Double Pill*)**:
    - Kapsul atas: `HASIL EVALUASI COMPUTATIONAL THINKING` (biru laut dengan outline cerah).
    - Kapsul bawah: `Materi: Siklus Air (Water Cycle)`.
  - **Papan Utama Membulat (*High Corner Radius = 26px*)**:
    - Kapsul Rangkuman Atas: `Rata-Rata Skor Keseluruhan:` + nilai persentase besar (misal: `83.2%`) + status `(Kategori: SANGAT TINGGI)`.
    - **Grid 2x2: Empat Kartu Kapsul Pilar CT**:
      - 🧩 **Dekomposisi**: Ikon puzzle kartun lucu warna-warni $\to$ `Skor: XX%` $\to$ Badge kategori.
      - 🔍 **Pengenalan Pola**: Ikon kaca pembesar kartun ungu/biru $\to$ `Skor: XX%` $\to$ Badge kategori.
      - 🎯 **Abstraksi**: Ikon sasaran panah merah-putih mini $\to$ `Skor: XX%` $\to$ Badge kategori.
      - ⚡ **Algoritma**: Ikon petir kuning ceria $\to$ `Skor: XX%` $\to$ Badge kategori.
  - **Tombol Aksi di Bawah**:
    - `BtnPlayAgain`: Menggunakan sprite aset baru `button_mainlagi.png` yang telah disesuaikan transparansinya.
    - `BtnClose`: Menggunakan sprite aset `button_close.png` untuk kembali ke Menu Utama.
    - Dilengkapi animasi kenyal (*squash & stretch bounce*) dan audio klik.
  - **Latar Bersih**: Partikel yang menyerupai salju/konfeti telah dihilangkan sehingga fokus murni pada papan evaluasi dan latar belakang pemandangan alam.
  - **Animasi Tally Count-Up**: Angka persentase berputar naik secara halus dari 0% ke nilai siswa saat layar terbuka.

### 3. Pemasangan Audio & SFX Lengkap (`program/assets/sounds/`)
- Seluruh 7 file audio telah dibuat dan terintegrasi via `Global` (`global.gd`):
  1. `sfx_klik.wav`: Efek suara klik tombol UI.
  2. `sfx_berhasil.wav`: Jingle kuis / aksi benar.
  3. `sfx_gagal.wav`: Nada kesalahan yang lembut dan ramah anak.
  4. `sfx_level_selesai.wav`: Fanfare kemenangan / akhir permainan.
  5. `sfx_hujan.wav`: Ambien suara hujan dan tetesan air saat awan presipitasi jenuh.
  6. `musik_menu.wav`: Musik BGM latar ceria untuk Menu Utama & Home.
  7. `musik_level.wav`: Musik eksplorasi edukatif saat bermain di level.

### 4. Standarisasi Tinggi Tombol (*Uniform Button Height: 72 px*)
- **Seluruh Tombol Aksi / Navigasi Utama Dibuat Seragam 72 px**:
  - `main_menu.tscn`: `BtnPlay` & `BtnClose` (tinggi 72 px, Y = 514-586).
  - `home.tscn`: `BtnHome` & `BtnMateri` (tinggi 72 px, Y = 628-700).
  - `materi.tscn`: `BtnHome`, `BtnBack`, `BtnNext`, `BtnClose` (tinggi 72 px, Y = 628-700).
  - `level_1_evaporasi.tscn`: `BtnTransisiSiang` & `BtnNext` (tinggi 72 px, Y = 628-700).
  - `level_2_kondensasi.tscn`: `BtnNext` (tinggi 72 px, Y = 628-700).
  - `level_3_presipitasi.tscn`: `BtnNext` (tinggi 72 px, Y = 628-700).
  - `level_4_algoritma.tscn`: `BtnReset`, `BtnCheck`, `BtnNext` (tinggi 72 px, Y = 628-700).
  - `hud.tscn`: `BtnHome` & `BtnMateri` di kiri bawah (tinggi 72 px, Y = 628-700).
  - `victory.tscn`: `BtnPlayAgain` & `BtnClose` (tinggi 72 px, Y = 628-700).
  - `game_over.tscn`: `BtnRetry` & `BtnMenu` (tinggi 72 px).
- **Perbaikan Crop Aset Victory (`BtnPlayAgain` vs `BtnClose`)**:
  - File `button_mainlagi.png` sebelumnya memiliki ruang transparan kosong (*padding*) bawaan sebesar 44 px di atas dan 55 px di bawah (total 99 px), sedangkan `button_close.png` di-crop rapat 0 px.
  - Aset `button_mainlagi.png` telah di-crop rapat (*tight crop*) ke ukuran bersih $1974 \times 679\text{ px}$ (0 px padding).
  - Ukuran `custom_minimum_size` pada `victory.tscn` diselaraskan menjadi `Vector2(210, 72)` untuk `BtnPlayAgain` dan `Vector2(150, 72)` untuk `BtnClose`, sehingga kedua pil tombol memiliki tinggi fisik tampak yang **100% identik (72 px)** tanpa ada tombol yang terlihat lebih gemuk/besar.
- **Presisi Visual**: Seluruh tombol di baris bawah layar kini sejajar sempurna pada koordinat vertikal $Y \in [628, 700]$ (margin 20 px dari batas bawah layar 720p). Lebar tombol menyesuaikan rasio asli dengan `stretch_mode = 5` (*Keep Aspect Centered*) sehingga tampilan tajam dan tidak mengalami distorsi.

### 5. Penyempurnaan UI Level 4 (Algoritma, `level_4_algoritma.tscn`)
- **Penyatuan Panduan ke Box Putih Persegi Panjang Sudut Lengkung (*Rounded Rectangle Card*)**:
  - Box putih panduan diubah menjadi **`PanelContainer` dengan `StyleBoxFlat` berbentuk persegi panjang bersudut lengkung** (`corner_radius = 18px`, ukuran $780 \times 92\text{ px}$).
  - Menggunakan palet putih cerah semi-transparan dengan border cyan-blue lembut ($3\text{ px}$) dan soft drop shadow modern, serasi dengan kartu evaluasi pada layar Victory.
  - Memuat dua baris teks yang tertata presisi di tengah box tanpa pernah terpotong atau keluar garis:
    1. Instruksi utama: *"Urutkan gambar proses siklus air dengan benar!"* (font 17, navy blue).
    2. Panduan & status dinamis: *"Tarik (drag) kartu di bawah ke kotak tahapan sesuai urutan."* (font 14, biru nyaman, berubah dinamis).
  - Bar gelap di bawah kartu (`FeedbackPanel`) dihapus total.
- **Kartu dan Slot Kartu Diperbesar**:
  - Ukuran slot kartu diperbesar dari $148 \times 155$ menjadi **$170 \times 178\text{ px}$**.
  - Ukuran 4 kartu di daftar bawah diperbesar dari $145 \times 150$ menjadi **$170 \times 178\text{ px}$**.
  - Kartu yang ditaruh ke dalam slot (`CardPlaced`) kini mengisi hampir penuh kotak slot ($158 \times 166\text{ px}$) sehingga gambar siklus air terlihat besar, jelas, dan memuaskan.
- **Teks Keterangan Slot Diganti Tanda Panah Antartahap**:
  - Teks *"Tahap 1"*, *"Tahap 2"*, dst. di dalam slot telah dihapus sepenuhnya.
  - Digantikan oleh **tanda panah kartun biru cerah (`panah_tahap.png`) di antara setiap slot**: `[Slot 1]` ➔ `[Slot 2]` ➔ `[Slot 3]` ➔ `[Slot 4]`.
  - Menggambarkan alur algoritma siklus air secara visual dan alami tanpa teks yang membingungkan.
- **Penyelarasan Presisi Drop & Penempatan Kartu pada Slot**:
  - **Penyebab Masalah Sebelumnya**:
    1. Aset `slot_kartu.png` memiliki margin transparan asimetris (18 px di kiri, 0 px di kanan), dan kartu-kartu memiliki margin bawah 14 px, sehingga saat ditaruh di slot, kartu tergeser ke atas-kiri dan tidak pas di dalam garis putus-putus slot.
    2. Pada fungsi `_get_drag_data` di `level_4_card.gd` dan `level_4_slot.gd`, preview drag dipasang langsung tanpa wadah offset, sehingga titik kursor mouse terkunci di pojok kiri-atas preview `(0, 0)`. Akibatnya, saat menyeret kartu, kartu menggantung ke kanan-bawah sejauh 85-90 px dari kursor mouse dan titik drop tidak sejajar dengan slot.
  - **Perbaikan yang Diterapkan**:
    1. Aset `slot_kartu.png` dan seluruh 4 kartu (`kartu_evaporasi.png`, `kartu_kondensasi.png`, `kartu_presipitasi.png`, `kartu_infiltrasi.png`) telah di-crop rapat dan dipusatkan secara simetris 100% pada kanvas standar ($211 \times 204\text{ px}$ untuk kartu, $234 \times 249\text{ px}$ untuk slot). Kartu yang masuk ke slot kini berada **presisi pas di tengah garis putus-putus slot**.
    2. Implementasi drag preview diperbarui menggunakan `preview_holder` dengan offset `-at_position`. Posisi kartu preview saat di-drag kini melekat tepat di titik mouse tempat pemain mengklik/mengambil kartu, sehingga saat kartu diarahkan ke atas slot, area drop dan target slot berada pada posisi yang 100% sejajar dan natural.

### 6. Peningkatan Tampilan Indikator & Panduan Level 3 (Presipitasi, `level_3_presipitasi.tscn`)
- **Penerapan Opsi A (Pemusatan Panduan & Progres ke Kartu Bawah)**:
  - Box putih panduan di atas (`Panduan`) telah disembunyikan (`visible = false`) sehingga pemandangan langit dan **Awan Hitam Mendung** raksasa tampil 100% utuh, luas, dan dramatis tanpa terpotong box putih.
  - Seluruh panduan aksi terpusat di kartu bawah: *"Kumpulkan tetesan air murni ke dalam awan. Abaikan elemen lain!"*.
- **Kartu Indikator Baru (`kartu_indikator_air.png`)**:
  - Dibuat kartu persegi panjang bersudut melengkung modern (*high corner radius* 18 px) dengan palet putih salju semi-transparan, border cyan lembut, dan drop shadow halus ($540 \times 104\text{ px}$ pada koordinat $X \in [370, 910], Y \in [598, 702]$).
  - Mengatasi masalah teks *"Klik tetesan air untuk mengisi awan"* yang sebelumnya meluber/keluar dari batas kartu sempit.
- **Visualisasi Tetesan Air & Progress Bar Interaktif**:
  - Ditambahkan **ikon tetesan air kartun** (`tetesan_air.png`) di dalam kartu indikator.
  - Ditambahkan **ProgressBar bertema air** dengan style capsule rounded sudut melengkung dan fill cyan/aqua cerah yang mengisi secara halus saat tetesan air berhasil diserap awan.
  - Counter uap air `"Uap Air: 0 / 5"` tampil tebal, tajam, dan kontras (warna navy `#1a4080`).
- **Peningkatan Ukuran Font Ramah Anak SD (Child-Friendly Readability)**:
  - Kartu indikator diperlebar menjadi **$570 \times 112\text{ px}$** pada koordinat $X \in [355, 925], Y \in [588, 700]$ dengan aset resolusi tinggi $1140 \times 224\text{ px}$.
  - Counter `"Uap Air: 0 / 5"` diperbesar signifikan dari 18 px menjadi **22 px** (bold navy).
  - Teks status & panduan dinamis (`LblStatus`) diperbesar dari 14 px menjadi **17 px** dengan jarak baris yang nyaman dibaca anak sekolah dasar.
  - Ikon tetesan air diperbesar menjadi $40 \times 40\text{ px}$ dan ProgressBar menjadi $298 \times 24\text{ px}$.
  - Panduan Level 4 juga diselaraskan: judul instruksi diperbesar ke **19 px** dan teks feedback ke **16 px**.

### 7. Standarisasi Tipografi Ramah Anak SD (Level 1, Level 2, dan Layar Victory)
- **Level 1 (Evaporasi, `level_1_evaporasi.tscn`)**:
  - `LblStatus`: Dinaikkan dari 16 px ke **18 px** dengan lebar kontainer diperluas ke 560 px.
  - `LblCardTitle`: Dinaikkan dari 20 px ke **22 px** (*Intensitas Matahari*).
  - `LblSuhuVal`: Dinaikkan dari 18 px ke **20 px** (*20 °C (Dingin)*).
- **Level 2 (Kondensasi, `level_2_kondensasi.tscn`)**:
  - `LblStatus`: Dinaikkan dari 16 px ke **18 px** dengan lebar kontainer diperluas ke 560 px (*Suhu masih hangat (35°C). Kenali polanya: turunkan suhu!*).
  - `LblCardTitle`: Dinaikkan dari 20 px ke **22 px** (*Suhu Atmosfer*).
  - `LblSuhuVal`: Dinaikkan dari 18 px ke **20 px** (*35 °C (Hangat)*).
- **Layar Victory / Evaluasi CT (`victory.tscn`)**:
  - `LblSubtitle`: Dinaikkan dari 14 px ke **16 px** (*Materi: Siklus Air (Water Cycle)*).
  - `LblAvgText`: Dinaikkan dari 17 px ke **18 px**.
  - `LblAvgValue`: Dinaikkan dari 23 px ke **26 px** (angka persentase rata-rata lebih besar & mencolok).
  - `LblAvgCategory`: Dinaikkan dari 18 px ke **20 px**.
  - **4 Kartu Kapsul CT (`CardDecomp`, `CardPattern`, `CardAbstract`, `CardAlgo`)**:
    - Judul pilar CT (`Title`): Dinaikkan dari 15 px ke **17 px**.
    - Label skor (`RowScore/Lbl`): Dinaikkan dari 17 px ke **18 px**.
    - Nilai skor (`RowScore/Val`): Dinaikkan dari 23 px ke **26 px**.
    - Label kategori (`RowCategory/Lbl`): Dinaikkan dari 15 px ke **16 px**.
    - Badge kategori (`RowCategory/Badge`): Dinaikkan dari 15 px ke **17 px** (*bold*).

### 8. Penyelarasan Proporsi Visual Halaman Home (`scenes/home.tscn`)
- **Banner Judul (`ElementMenu`)**:
  - Disesuaikan dari ukuran raksasa $1030 \times 164\text{ px}$ (yang sebelumnya memakan 80% lebar layar dan menabrak tombol suara) menjadi **$720 \times 116\text{ px}$** ($X \in [280, 1000], Y \in [22, 138]$), terpusat rapi di tengah layar dengan margin lega.
- **Kartu Tombol Level (`BtnLevel1` - `BtnLevel4`)**:
  - Disesuaikan dari ukuran sebelumnya yang terlampau besar ($285 \times 400\text{ px}$, memakan 56% tinggi layar) menjadi **$224 \times 315\text{ px}$** per kartu.
  - Wadah `LevelButtons` berukuran $968 \times 320\text{ px}$ terpusat rapi pada koordinat $X \in [156, 1124], Y \in [180, 500]$ dengan jarak antarkartu 24 px.
  - Memberi ruang nafas (*breathing room*) yang lapang: 41 px ke banner atas dan 128 px ke tombol bawah, serta memberi ruang gerak saat animasi hover ($\times 1.06$) tanpa saling menabrak kartu tetangga.
  - Pemandangan alam latar belakang (`bg_home.png`) kini terlihat indah, asri, dan tidak lagi tenggelam/tertutup penuh oleh elemen kartu.
- **Tombol Suara (`BtnSoundOrange`)**:
  - Diselaraskan ke ukuran standar HUD $65 \times 65\text{ px}$ pada $X = 1185, Y = 20$.

### 9. Sistem Pembukaan Level Bertahap (*Progressive Level Locking*)
- **Aturan Progresi**:
  - Saat game baru dibuka atau di-reset (`Global.reset_game()`), **hanya Level 1 yang terbuka** (`max_unlocked_level = 1`).
  - Level 2, 3, dan 4 terkunci secara berurutan. Menyelesaikan Level 1 akan membuka Level 2, menyelesaikan Level 2 membuka Level 3, dan menyelesaikan Level 3 membuka Level 4.
- **Visualisasi Gembok & Feedback Interaktif**:
  - Dibuat ikon gembok kartun emas lucu [`ikon_gembok.png`](program/assets/sprites/element/ikon_gembok.png) ($128 \times 128\text{ px}$).
  - Level yang terkunci memiliki overlay gembok di tengah kartu, tampil sedikit redup (`modulate = Color(0.55, 0.58, 0.65, 0.8)`), dan efek hover perbesaran dinonaktifkan.
  - Jika anak SD mengklik level yang masih terkunci, sistem memainkan suara `sfx_gagal` dan animasi getar halus (*shake feedback*), memberi tahu secara ramah bahwa level tersebut belum terbuka.

### 10. Sistem Audio & Musik Terintegrasi Penuh (Full Audio & BGM Architecture)
- **Pengelolaan BGM Otomatis & Seamless Looping**:
  - `musik_utama.mp3`: Musik utama milik pengembang (dikonversi dari `musik_utama.mpeg`), diputar otomatis saat berada di Menu Utama, Home, dan Materi (dengan loop mulus `AudioStreamMP3.loop = true`). Transisi antar-menu tidak memutus atau mengulang lagu.
  - `musik_level.mp3`: Musik level milik pengembang (dikonversi dari `musik_level.mpeg`), diputar otomatis saat pemain masuk ke dalam level (Level 1, Level 2, Level 3, Level 4).
  - `musik_victory.wav`: Lagu perayaan kemenangan ceria (12.0s, loopable) saat melihat papan evaluasi CT di Layar Victory.
- **Aset SFX Baru Ramah Anak (Sintesis Kualitas Tinggi 44.1 kHz)**:
  - `sfx_bubble.wav`: Pop gelembung uap air kartun saat klik tetesan uap air di Level 3.
  - `sfx_card_snap.wav`: Snap/klik kartu renyah saat drop kartu ke slot di Level 4.
  - `sfx_card_grab.wav`: Suara angkat lembut saat mulai drag kartu di Level 4.
  - `sfx_guntur.wav`: Gemuruh kartun hangat saat awan jenuh sebelum hujan di Level 3.
  - `sfx_siang.wav`: Chime matahari cerah saat klik "Ubah ke Siang Hari" di Level 1.
  - `sfx_tick.wav`: Suara ticking halus saat angka skor berputar naik di Layar Victory.
- **Multi-Channel SFX Player**:
  - `Global` menggunakan 6 pool channel `AudioStreamPlayer` agar suara klik, gelembung, dan jingle tidak saling memotong.
- **Penyambungan SFX Lengkap**:
  - `sfx_berhasil.wav`: Terpasang di Level 1 (evaporasi sukses), Level 2 (kondensasi sukses), Level 3 (presipitasi sukses), dan Level 4 (urutan algoritma benar).
  - `hujan_sound_baru.mp3`: Suara hujan alami baru beresolusi tinggi pilihan pengembang, terpasang otomatis saat partikel hujan turun di Level 3 (dengan mode loop aktif) dan dimatikan saat keluar level.
  - `sfx_gagal.wav`: Terpasang saat salah waktu di Level 1 dan klik pengecoh di Level 3.
  - `sfx_klik.wav`: Terpasang di seluruh tombol interaksi di game.

### 11. Hasil Pengujian Otomatis (*Automated Test Suite*)
Semua 10 pengujian otomatis di `program/tests/` berstatus **100% PASSED**:
1. `test_audio_system.tscn` ➔ PASS (14 audio streams, looping, multi-channel SFX)
2. `test_home_scene.tscn` ➔ PASS (termasuk verifikasi lock progression)
3. `test_hud_scene.tscn` ➔ PASS
4. `test_level_1_scene.tscn` ➔ PASS
5. `test_level_2_scene.tscn` ➔ PASS
6. `test_level_3_scene.tscn` ➔ PASS
7. `test_level_4_scene.tscn` ➔ PASS
8. `test_materi_context.tscn` ➔ PASS
9. `test_materi_scene.tscn` ➔ PASS
10. `test_victory_gameover.tscn` ➔ PASS

Cara menjalankan test headless via PowerShell:
```powershell
& "D:\APP\Godot\Godot_v4.7.2-stable_win64_console.exe" --headless --path "program" "res://tests/test_audio_system.tscn"
```
