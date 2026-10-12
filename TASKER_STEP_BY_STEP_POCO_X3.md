# Panduan Step-by-Step Tasker untuk Poco X3 NFC

## 📱 Konfigurasi Tasker - Clash of Clans Auto Attack

**Device**: Poco X3 NFC (1080x2400)  
**Android**: 12  
**Tasker Version**: 5.12.0+

---

## ⚙️ STEP 0: Setup Awal Tasker

### 0.1 Enable Accessibility Service
```
Pengaturan Poco X3 NFC:
1. Buka Settings → Accessibility
2. Cari "Tasker" dalam list
3. Tap Tasker → Enable "Use Tasker"
4. Izinkan semua permission
```

### 0.2 Disable Battery Optimization
```
Pengaturan Poco X3 NFC:
1. Settings → Battery and Device Care
2. Cari "Tasker" 
3. Tap → Select "Don't optimize"
```

### 0.3 Enable Developer Options
```
Pengaturan Poco X3 NFC:
1. Settings → About Phone → MIUI Version
2. Tap "MIUI Version" 7x sampai "Developer Mode Enabled"
3. Settings → Developer Options → 
   ✅ USB Debugging: ON
   ✅ Stay Awake: ON
```

### 0.4 Buat Folder di Device
```
Buka File Manager → Buat folder:
/sdcard/Tasker/
/sdcard/Tasker/COC_Screenshots/
/sdcard/Tasker/Logs/
/sdcard/Tasker/Backups/
```

---

## 📝 STEP 1: Buat Variable Global

**Buka Tasker → Preferences → Variables**

Tambahkan variable berikut:

| Variable | Value | Tipe | Keterangan |
|----------|-------|------|-----------|
| %coc_enabled | 1 | Int | 1=aktif, 0=nonaktif |
| %coc_state | idle | Text | State game saat ini |
| %coc_attacks_today | 0 | Int | Total attack hari ini |
| %coc_gold | 0 | Int | Total gold yang dikumpulkan |
| %coc_elixir | 0 | Int | Total elixir yang dikumpulkan |
| %coc_de | 0 | Int | Total DE yang dikumpulkan |
| %last_attack_time | 0 | Int | Timestamp attack terakhir |
| %screen_detected | false | Text | Screen sudah ter-screenshot |
| %army_ready | false | Text | Army siap untuk attack |

**Cara Input di Tasker:**
```
Tasker Home → Preferences (gear icon)
→ Variables tab
→ Klik "+" untuk tambah variable
→ Input nama variable (misal: %coc_enabled)
→ Input default value (misal: 1)
→ Done
```

---

## 🔧 STEP 2: Buat Profile - "COC_App_Launch"

**Membuat Profile yang trigger saat aplikasi dibuka:**

```
Tasker Home → Profile Tab
→ Klik "+" (NEW)
→ Pilih "App"
→ Search: "Clash of Clans" atau "com.supercell.clashofclans"
→ Tap aplikasi Clash of Clans
→ Save
```

**Di popup "New Task":**
```
Task Name: "COC_OnOpen"
→ Klik ikon task untuk setup task
```

---

## 📋 STEP 3: Buat Task - "COC_OnOpen"

Ini adalah task utama yang trigger saat aplikasi dibuka.

### Task: COC_OnOpen (8 action)

**Action 1: Log Entry**
```
Tap + → Misc → Log Entry
Text: [%TIME] ========== COC APP OPENED ==========
To File: /sdcard/Tasker/Logs/coc_app_launch.log
→ Done
```

**Action 2: Wait for Game Load**
```
Tap + → Task → Wait
Milliseconds: 3000 (tunggu 3 detik)
→ Done
```

**Action 3: Set Variable - coc_state = "loaded"**
```
Tap + → Variables → Variable Set
Name: %coc_state
To: loaded
→ Done
```

**Action 4: Take Screenshot**
```
Tap + → Media → Take Screenshot
File: /sdcard/Tasker/COC_Screenshots/current.png
→ Done
```

**Action 5: Notify - Game Opened**
```
Tap + → Alert → Notify
Title: ✅ COC Opened
Text: Initializing...
Icon: 🎮 (optional)
→ Done
```

**Action 6: Run Task - COC_ClosePopups**
```
Tap + → Task → Perform Task
Name: COC_ClosePopups (kita buat di step selanjutnya)
→ Done
```

**Action 7: Run Task - COC_CollectResources**
```
Tap + → Task → Perform Task
Name: COC_CollectResources (kita buat di step selanjutnya)
→ Done
```

**Action 8: Run Task - COC_StartAttack**
```
Tap + → Task → Perform Task
Name: COC_StartAttack (kita buat di step selanjutnya)
→ Done
```

---

## 🚫 STEP 4: Buat Task - "COC_ClosePopups"

Task ini untuk menutup semua popup yang muncul.

### Task: COC_ClosePopups (7 action)

**Action 1: Log**
```
Tap + → Misc → Log Entry
Text: [%TIME] Closing popups...
To File: /sdcard/Tasker/Logs/coc_app_launch.log
→ Done
```

**Action 2: Repeat - 5 times (untuk close multiple popups)**
```
Tap + → Tasker → Repeat Task
Times: 5
→ Done
```

**Action 3: Screenshot (dalam repeat)**
```
Tap + → Media → Take Screenshot
File: /sdcard/Tasker/COC_Screenshots/popup_%repeat.png
→ Done
```

**Action 4: If - Detect Update Popup**
```
Tap + → Logic → If
%screen_detected ~ "Later" OR %screen_detected ~ "Update"
→ Done
```

**Action 5: Tap - Later Button (dalam IF)**
```
Tap + → Input → Tap Screen
X: 450, Y: 2100
Duration (ms): 150
→ Done
```

**Action 6: Else - Wait**
```
Tap + → Task → Wait
Milliseconds: 1000
→ Done
```

**Action 7: End If & Repeat**
```
Tap + → Logic → End If
→ Done
```

---

## 💰 STEP 5: Buat Task - "COC_CollectResources"

Task untuk mengumpulkan resource dari collector.

### Task: COC_CollectResources (9 action)

**Action 1: Log**
```
Tap + → Misc → Log Entry
Text: [%TIME] Collecting resources...
To File: /sdcard/Tasker/Logs/coc_app_launch.log
→ Done
```

**Action 2: Wait**
```
Tap + → Task → Wait
Milliseconds: 1000
→ Done
```

**Action 3: Tap - Gold Collector**
```
Tap + → Input → Tap Screen
X: 150, Y: 350
Duration (ms): 150
→ Done
```

**Action 4: Wait**
```
Tap + → Task → Wait
Milliseconds: 300
→ Done
```

**Action 5: Tap - Elixir Collector**
```
Tap + → Input → Tap Screen
X: 930, Y: 350
Duration (ms): 150
→ Done
```

**Action 6: Wait**
```
Tap + → Task → Wait
Milliseconds: 300
→ Done
```

**Action 7: Tap - Dark Elixir Collector**
```
Tap + → Input → Tap Screen
X: 540, Y: 1500
Duration (ms): 150
→ Done
```

**Action 8: Wait**
```
Tap + → Task → Wait
Milliseconds: 500
→ Done
```

**Action 9: Log - Resources Collected**
```
Tap + → Misc → Log Entry
Text: [%TIME] Resources collected!
To File: /sdcard/Tasker/Logs/coc_app_launch.log
→ Done
```

---

## ⚔️ STEP 6: Buat Task - "COC_StartAttack"

Task untuk memulai proses auto attack.

### Task: COC_StartAttack (12 action)

**Action 1: Log**
```
Tap + → Misc → Log Entry
Text: [%TIME] Checking attack conditions...
To File: /sdcard/Tasker/Logs/coc_app_launch.log
→ Done
```

**Action 2: If - Check Enabled**
```
Tap + → Logic → If
%coc_enabled ~ 1
→ Done
```

**Action 3: If - Check Attacks Not Maxed**
```
Tap + → Logic → If
%coc_attacks_today < 20
→ Done
```

**Action 4: Wait**
```
Tap + → Task → Wait
Milliseconds: 2000
→ Done
```

**Action 5: Set Variable - coc_state = "searching"**
```
Tap + → Variables → Variable Set
Name: %coc_state
To: searching
→ Done
```

**Action 6: Tap - Find Opponent (Home Button)**
```
Tap + → Input → Tap Screen
X: 540, Y: 2330
Duration (ms): 150
→ Done
```

**Action 7: Log - Attack Started**
```
Tap + → Misc → Log Entry
Text: [%TIME] Attack started! Attacks today: %coc_attacks_today
To File: /sdcard/Tasker/Logs/coc_app_launch.log
→ Done
```

**Action 8: Notify - Attack Started**
```
Tap + → Alert → Notify
Title: ⚔️ Attack Mulai
Text: Searching opponent...
→ Done
```

**Action 9: Wait for Attack Finish**
```
Tap + → Task → Wait
Milliseconds: 180000 (3 menit max attack)
→ Done
```

**Action 10: Add Variable - Increment Attacks**
```
Tap + → Variables → Variable Add
Name: %coc_attacks_today
Value: 1
→ Done
```

**Action 11: End If (dari check attacks)**
```
Tap + → Logic → End If
→ Done
```

**Action 12: End If (dari check enabled)**
```
Tap + → Logic → End If
→ Done
```

---

## 🔄 STEP 7: Buat Profile - "COC_Scheduler" (Optional)

Untuk membuat auto attack berjalan setiap interval waktu tertentu.

```
Tasker Home → Profile Tab
→ Klik "+" (NEW)
→ Pilih "Time"
→ From: 08:00
→ To: 23:00
→ Repeat: Every 45 minutes
→ Repeat on days: All
→ Save
→ Task Name: "COC_ScheduledTask"
```

### Task: COC_ScheduledTask (3 action)

**Action 1: If - Check if App Running**
```
Tap + → Logic → If
%APPACTIVE(com.supercell.clashofclans) ~ yes
→ Done
```

**Action 2: Run Task - COC_StartAttack**
```
Tap + → Task → Perform Task
Name: COC_StartAttack
→ Done
```

**Action 3: End If**
```
Tap + → Logic → End If
→ Done
```

---

## 📊 STEP 8: Buat Scene (Dashboard) - Optional

Untuk monitoring realtime.

```
Tasker Home → Scenes Tab
→ Klik "+" (NEW)
→ Name: COC_Dashboard
→ Layout: Portrait
```

**Tambahkan Element:**

1. **Text - Status**
```
Name: txt_status
Text: Status: %coc_state
Font Size: 16
Color: White
```

2. **Text - Attacks Today**
```
Name: txt_attacks
Text: Attacks Today: %coc_attacks_today/20
Font Size: 14
```

3. **Text - Resources**
```
Name: txt_resources
Text: Gold: %coc_gold | Elixir: %coc_elixir
Font Size: 12
```

4. **Button - Start**
```
Name: btn_start
Label: ▶️ START
→ On Tap: Perform Task "COC_OnOpen"
```

5. **Button - Stop**
```
Name: btn_stop
Label: ⏹️ STOP
→ On Tap: Set Variable %coc_enabled = 0
```

6. **Text View - Log**
```
Name: log_view
Read From File: /sdcard/Tasker/Logs/coc_app_launch.log
Refresh Every: 2 seconds
```

---

## 🧪 STEP 9: Testing

### Test 1: Manual Test Profile
```
1. Buka Tasker
2. Profile Tab → COC_App_Launch
3. Tap play icon untuk test
4. Lihat notifikasi & log file
```

### Test 2: Real Test
```
1. Tutup Tasker
2. Buka Clash of Clans secara manual
3. Amati apakah popup tertutup otomatis
4. Lihat di log file: /sdcard/Tasker/Logs/coc_app_launch.log
5. Check screenshot di: /sdcard/Tasker/COC_Screenshots/
```

### Test 3: Monitor Log
```
Buka Terminal Emulator atau via ADB:
tail -f /sdcard/Tasker/Logs/coc_app_launch.log
```

---

## 🛠️ STEP 10: Optimize & Fine-Tune

### Jika Popup Tidak Tertutup:
```
1. Ubah koordinat di Action Tap
2. Ambil screenshot manual untuk cek lokasi button
3. Adjust X,Y coordinates
```

### Jika Tidak Detect Game Loaded:
```
1. Naikkan wait time di Action 2: COC_OnOpen
   dari 3000ms menjadi 5000ms
2. Cek apakah screen off saat app launch
```

### Jika Tap Koordinat Salah:
```
Gunakan Tool Accessibility di Tasker:
Tasker → Preferences → Misc
→ Cari "Coordinate Testing"
→ Tap screen untuk tahu koordinat X,Y
```

### Jika Attack Tidak Start:
```
1. Check condition di Action 2 & 3 COC_StartAttack
2. Pastikan variable %coc_enabled = 1
3. Pastikan %coc_attacks_today < 20
```

---

## 📋 QUICK REFERENCE - Action Summary

| Step | Task | Fungsi |
|------|------|--------|
| 1 | COC_OnOpen | Main task saat app dibuka |
| 2 | COC_ClosePopups | Tutup semua popup |
| 3 | COC_CollectResources | Kumpulkan resource |
| 4 | COC_StartAttack | Mulai attack otomatis |
| 5 | COC_Scheduler | Auto attack setiap interval |
| 6 | COC_Dashboard | Monitor dashboard |

---

## 🎯 KOORDINAT POCO X3 NFC (1080x2400)

```
Buttons:
- Home/Battle: (540, 2330)
- Next Opponent: (990, 1200)
- Collect Gold: (150, 350)
- Collect Elixir: (930, 350)
- Collect DE: (540, 1500)
- Close Popup: (1000, 150)
- OK Button: (540, 1800)
- Later Button: (450, 2100)
```

---

## ⚠️ Important Notes

1. **Backup Config**: Sebelum export, backup di Tasker Preferences
2. **Test Dulu**: Jangan langsung 24/7, test dulu beberapa jam
3. **Monitor**: Check log file secara berkala
4. **Safety**: Gunakan random delay untuk avoid ban
5. **Battery**: Device akan panas, pastikan ada pendingin

---

## 🚀 Export & Import Project

### Export ke Backup:
```
Tasker → Preferences → Misc
→ Backup Now
→ Save as: COC_Auto_Attack_Backup.xml
```

### Import dari Backup:
```
Tasker → Preferences → Misc
→ Restore dari file
→ Pilih: COC_Auto_Attack_Backup.xml
```

---

## 📞 Troubleshooting

| Masalah | Solusi |
|---------|--------|
| Tasker tidak berjalan saat screen OFF | Disable battery optimization + stay awake |
| Tap koordinat salah | Gunakan accessibility coordinate tool |
| Screenshot blank | Check storage permission & path |
| Attack tidak start | Verify %coc_enabled = 1 & condition checked |
| Popup tidak tertutup | Adjust tap coordinates + increase wait time |
| App crash | Check Tasker log → clear cache |

---

## 💾 File yang Dihasilkan

Setelah selesai, cek file:
```
/sdcard/Tasker/Logs/coc_app_launch.log        ← Main log
/sdcard/Tasker/COC_Screenshots/current.png    ← Screenshot terbaru
/sdcard/Tasker/Backups/...                    ← Backup otomatis
```

---

**Happy Automation! 🚀**

Jika ada pertanyaan saat setup, check log file terlebih dahulu untuk diagnose masalah.
