<!-- converted from DAFTAR_ASET.docx -->

DAFTAR KEBUTUHAN ASET
Water Cycle Adventure
Kelompok 14B  |  Praktikum Multimedia 2  |  PTIK FKIP UNS 2026

## 1. Background
Ukuran: 1280x720px  |  Format: PNG (bukan transparan)
| No | Nama File | Keterangan |
| --- | --- | --- |
| 1 | bg_menu.png | Tampilan Menu Utama |
| 2 | bg_evaporasi.png | Level 1 - langit + laut + pantai dalam 1 gambar |
| 3 | bg_kondensasi.png | Level 2 - langit mendung |
| 4 | bg_presipitasi.png | Level 3 - langit gelap |
| 5 | bg_algoritma.png | Level 4 - suasana malam/gelap |
| 6 | bg_gameover.png | Tampilan Game Over |
| 7 | bg_victory.png | Tampilan Selesai/Victory |

## 2. Objek / Sprite
Format: PNG transparan (background transparan)
| No | Nama File | Ukuran | Keterangan |
| --- | --- | --- | --- |
| 1 | matahari.png | 256x256px | Bisa di-drag oleh pemain (Level 1) |
| 2 | uap_air.png | 128x128px | Partikel uap kecil (Level 2 & 3) |
| 3 | awan_terang.png | 256x256px | Awan putih target kondensasi (Level 2) |
| 4 | awan_gelap.png | 256x256px | Awan gelap makin hitam saat terisi (Level 3) |
| 5 | efek_hujan.png | 256x256px | Efek hujan turun saat Level 3 selesai |
| 6 | polusi.png | 128x128px | Pengecoh (Level 3) |
| 7 | daun.png | 128x128px | Pengecoh (Level 3) |
| 8 | layangan.png | 128x128px | Pengecoh (Level 3) |
| 9 | kartu_evaporasi.png | 180x120px | Kartu puzzle Level 4 |
| 10 | kartu_kondensasi.png | 180x120px | Kartu puzzle Level 4 |
| 11 | kartu_presipitasi.png | 180x120px | Kartu puzzle Level 4 |
| 12 | kartu_infiltrasi.png | 180x120px | Kartu puzzle Level 4 |
| 13 | ikon_hati.png | 64x64px | Indikator nyawa di HUD |

## 3. Button
Format: PNG transparan  |  Setiap tombol butuh 3 versi: Normal, Hover, Pressed
| No | Tombol | Normal | Hover | Pressed |
| --- | --- | --- | --- | --- |
| 1 | Mulai | btn_mulai_normal.png | btn_mulai_hover.png | btn_mulai_pressed.png |
| 2 | Keluar | btn_keluar_normal.png | btn_keluar_hover.png | btn_keluar_pressed.png |
| 3 | Lanjut | btn_lanjut_normal.png | btn_lanjut_hover.png | btn_lanjut_pressed.png |
| 4 | Reset | btn_reset_normal.png | btn_reset_hover.png | btn_reset_pressed.png |
| 5 | Periksa | btn_periksa_normal.png | btn_periksa_hover.png | btn_periksa_pressed.png |
| 6 | Bantuan | btn_bantuan_normal.png | btn_bantuan_hover.png | btn_bantuan_pressed.png |
| 7 | Menu | btn_menu_normal.png | btn_menu_hover.png | btn_menu_pressed.png |
| 8 | Ulangi | btn_ulangi_normal.png | btn_ulangi_hover.png | btn_ulangi_pressed.png |
| 9 | Main Lagi | btn_mainlagi_normal.png | btn_mainlagi_hover.png | btn_mainlagi_pressed.png |
| 10 | Level 1-4 | btn_level_normal.png | btn_level_hover.png | btn_level_pressed.png |
* Tombol Level 1-4 bisa pakai 1 desain yang sama, cukup 3 file saja.

## 4. Font
| No | Nama File | Keterangan |
| --- | --- | --- |
| 1 | font_judul.ttf | Tebal / playful, untuk judul game & teks tombol, cocok anak SD |
| 2 | font_teks.ttf | Mudah dibaca, untuk instruksi, label, dan keterangan |

## 5. Audio
Format disarankan: OGG (musik) dan WAV (efek suara)
| No | Nama File | Keterangan |
| --- | --- | --- |
| 1 | musik_menu.ogg | Musik latar Menu Utama |
| 2 | musik_level.ogg | Musik latar saat bermain (bisa 1 untuk semua level) |
| 3 | sfx_klik.wav | Efek suara klik tombol |
| 4 | sfx_berhasil.wav | Efek suara saat aksi benar |
| 5 | sfx_gagal.wav | Efek suara saat aksi salah / nyawa berkurang |
| 6 | sfx_level_selesai.wav | Efek suara saat level berhasil diselesaikan |
| 7 | sfx_hujan.wav | Efek suara hujan (Level 3 selesai) |

## 6. Ringkasan Ukuran
| Jenis | Ukuran |
| --- | --- |
| Background | 1280x720px |
| Objek utama (matahari, awan) | 256x256px |
| Objek kecil (uap, daun, pengecoh) | 128x128px |
| Kartu Level 4 | 180x120px |
| Button | Bebas (sesuai desain) |
| Ikon hati | 64x64px |

## 7. Catatan Penting
- Semua gambar harus PNG dengan background transparan (kecuali background scene).
- Aspek rasio game: 16:9 (1280x720px).
- Gaya visual: 2D flat/vector yang menarik untuk anak SD.
- Setelah aset selesai, letakkan di folder:
- Gambar  ->  program/assets/sprites/
- Audio   ->  program/assets/sounds/
- Font    ->  program/assets/fonts/