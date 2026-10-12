# Panduan Tasker Android untuk COC Auto Attack Tasker

## 📋 Daftar Isi
1. [Persiapan Awal](#persiapan-awal)
2. [Instalasi & Setup](#instalasi--setup)
3. [Konfigurasi Tasker](#konfigurasi-tasker)
4. [Membuat Profile & Task](#membuat-profile--task)
5. [Setup Auto Attack](#setup-auto-attack)
6. [Testing & Debugging](#testing--debugging)
7. [Tips & Trik](#tips--trik)
8. [Troubleshooting](#troubleshooting)

---

## 🚀 Persiapan Awal

### Persyaratan Sistem
- **Android Version**: 6.0+ (API 23+)
- **RAM**: Minimum 2GB
- **Storage**: 500MB free space
- **Tasker Version**: 5.12.0+
- **Device Unlock**: Bootloader unlock (optional, tapi disarankan)

### Permissions yang Dibutuhkan
```
✅ ACCESSIBILITY_SERVICE - untuk screen tap & swipe
✅ DEVICE_ADMIN - untuk layar & device control
✅ READ_EXTERNAL_STORAGE - read config files
✅ WRITE_EXTERNAL_STORAGE - write logs & screenshots
✅ INTERNET - connect to game servers
✅ PACKAGE_USAGE_STATS - monitor app usage
```

---

## 💾 Instalasi & Setup

### 1. Download & Install Tasker
- Buka **Google Play Store** atau **APKMirror**
- Cari dan install **Tasker** (Pent House Software)
- Cost: ~$3.99 (one-time purchase)
- [Tasker Official](https://tasker.joaoapps.com/)

### 2. Aktifkan Accessibility Service
```
Settings → Accessibility → Installed Services
→ Tasker → Enable "Use Tasker"
```

### 3. Disable Battery Optimization untuk Tasker
```
Settings → Battery → Battery Optimization
→ Apps → Find "Tasker" → Don't optimize
```

### 4. Enable Developer Options (opsional tapi penting)
```
Settings → About Phone → Build Number (tap 7x)
Settings → Developer Options → 
  ✅ USB Debugging
  ✅ Stay Awake
```

### 5. Setup Storage Direktori
```bash
# Buat direktori di Android device (via ADB atau file manager):
/sdcard/Tasker/
/sdcard/Tasker/COC_Screenshots/
/sdcard/Tasker/Backups/
/sdcard/Tasker/Logs/
```

---

## ⚙️ Konfigurasi Tasker

### 1. Buka Tasker & Konfigurasi Dasar

**Menu Utama:**
```
HOME TAB (Scenes/Profiles/Tasks)
→ Preferences (gear icon)
```

**Essential Settings:**
```
General:
  ✅ Beginner Mode: OFF (agar bisa advanced settings)
  ✅ Action tab time: 800ms
  ✅ Screen off tasks: ON (penting untuk auto attack!)

Notification:
  ✅ Low Priority Notifications: ON
  ✅ Show Started Task Notification: ON

Profiles:
  ✅ Auto Apply: ON
  ✅ Automatically Retry: ON

Directories:
  - Home Dir: /sdcard/Tasker/
  - Project backup: /sdcard/Tasker/Backups/
```

### 2. Setup Global Variables
```
Preferences → Variables
Tambah variable berikut:

%coc_enabled = 1 (0=off, 1=on)
%coc_mode = farm (farm/hybrid/war)
%coc_attacks_today = 0
%coc_last_attack = 0
%coc_state = idle (idle/searching/attacking/recovering)
%coc_gold = 0
%coc_elixir = 0
%coc_de = 0
%trophies = 0
```

### 3. Import Config.json ke Tasker Variable
```
Tasker → Task → Buat task baru "LoadConfig"
→ Tambah action:
  Action: File → Read File
  File: /sdcard/Tasker/config.json
  To Variable: %json_config
```

---

## 📝 Membuat Profile & Task

### Struktur Dasar Project

```
📁 COC Auto Attack Project
├── 📂 PROFILES
│   ├── Profile: "COC_Main" (time-based)
│   ├── Profile: "COC_Screen_On" (state-based)
│   └── Profile: "COC_Maintenance" (app-based)
│
├── 📂 TASKS
│   ├── Task: "COC_Login"
│   ├── Task: "COC_CheckScreen"
│   ├── Task: "COC_FindTarget"
│   ├── Task: "COC_DeployArmy"
│   ├── Task: "COC_Attack"
│   ├── Task: "COC_Retreat"
│   ├── Task: "COC_Collect"
│   └── Task: "COC_Logger"
│
└── 📂 SCENES (Optional UI)
    ├── Scene: "COC_Dashboard"
    └── Scene: "COC_Settings"
```

### Membuat Profile Pertama

**Profile: "COC_Main" (Time-Based)**
```
1. Buka Tasker → Profile Tab
2. Klik + (New) → Time
3. Setup:
   From: 08:00
   To: 23:00
   Repeat: Every 45 minutes
   Days: All days

4. Enter Task Name: "COC_Main_Task"
5. Klik task untuk configure...
```

---

## 🎮 Setup Auto Attack

### Task: "COC_Login"
```
Action 1: App → Open App
  App: Clash of Clans
  
Action 2: Wait
  Milliseconds: 5000 (tunggu 5 detik game load)

Action 3: If %coc_enabled ~ 1
  → Continue to next action

Action 4: Log
  Text: [%TIME] COC App Opened
  To File: /sdcard/Tasker/Logs/coc_attack.log

Action 5: Variable Set
  Name: %coc_state
  To: searching
```

### Task: "COC_CheckScreen"
```
Action 1: Screen Capture
  File: /sdcard/Tasker/COC_Screenshots/current.png

Action 2: Plugin → Test OCR (opsional)
  Image: /sdcard/Tasker/COC_Screenshots/current.png
  Variable: %screen_text

Action 3: If [ %screen_text ~ "Find a Clash!" ]
  → Run: COC_FindTarget
  
Else If [ %screen_text ~ "Searching..." ]
  → Wait 10 seconds, retry
  
Else
  → Run: COC_DeployArmy
```

### Task: "COC_FindTarget"
```
Action 1: Variable Set
  Name: %coc_state
  To: searching

Action 2: Repeat 30 (max 30 kali pencarian)
  Action A: Tap screen
    X: 540 (center)
    Y: 1200
    Duration: 100ms
    
  Action B: Wait 2000ms
  
  Action C: Screen Capture
    File: /sdcard/Tasker/COC_Screenshots/target_%repeat.png
    
  Action D: If [ target match criteria ]
    → Break (exit repeat)
    → Set %target_found = 1
  
  Action E: Else
    → Wait 1000ms
    → Tap again (next opponent)
```

### Task: "COC_DeployArmy"
```
Action 1: Variable Set
  %coc_state = attacking

Action 2: Tap Troops Button
  X: 150
  Y: 2100
  
Action 3: Wait 500ms

Action 4: Deploy Barbarians (30)
  → Loop 3 times:
    Tap X: 200, Y: 500 (barbarian icon)
    
Action 5: Deploy Archers (30)
  → Loop 3 times:
    Tap X: 300, Y: 500
    
Action 6: Deploy Goblins (10)
  → Loop 1 times:
    Tap X: 400, Y: 500

Action 7: Deploy Healing Spell
  Tap X: 500, Y: 500
  
Action 8: Wait 2000ms

Action 9: Tap Attack Button
  X: 540
  Y: 1800
  
Action 10: Variable Set
  %coc_state = waiting_result
  %coc_last_attack = %TIME()
```

### Task: "COC_Collect"
```
Action 1: Wait 60000ms (tunggu 1 menit attack selesai)

Action 2: Tap Collect Loot
  X: 540
  Y: 1500
  
Action 3: Wait 2000ms

Action 4: Screenshot
  File: /sdcard/Tasker/COC_Screenshots/reward_%TIME.png

Action 5: Extract Loot Values (via OCR atau manual)
  %loot_gold = 250000
  %loot_elixir = 200000
  %loot_de = 500

Action 6: Variable Add
  %coc_gold + %loot_gold
  %coc_elixir + %loot_elixir
  %coc_de + %loot_de
  %coc_attacks_today + 1

Action 7: Log to File
  [%TIME] Attack completed! 
  Gold: %coc_gold | Elixir: %coc_elixir | DE: %coc_de
  To: /sdcard/Tasker/Logs/coc_attack.log
```

### Task: "COC_Logger"
```
Action 1: If %coc_attacks_today == 20
  → Log: "Max attacks reached today!"
  → Variable Set: %coc_enabled = 0
  
Action 2: Log to File
  Text: [%TIME] State: %coc_state | Attacks: %coc_attacks_today
  File: /sdcard/Tasker/Logs/coc_status.log
  Append: YES

Action 3: Notify
  Text: COC Auto Attack
  Subtext: Attacks: %coc_attacks_today | Gold: %coc_gold
  Icon: Clash of Clans icon
```

---

## 🧪 Testing & Debugging

### 1. Test Task Secara Manual
```
Tasker → Task Tab
→ Pilih task → Tap play button
→ Lihat hasilnya di notifikasi atau log
```

### 2. Enable Debug Mode
```
Tasker → Preferences → Misc
→ ✅ Verbose Logging
→ ✅ Action Durations
→ ✅ Enforce Tasker Import Warning: OFF
```

### 3. Monitor Log File Real-time
```bash
# Via ADB di PC:
adb shell tail -f /sdcard/Tasker/Logs/coc_attack.log

# Atau via Terminal Emulator di Android:
tail -f /sdcard/Tasker/Logs/coc_attack.log
```

### 4. Test Screenshot Detection
```
Tasker → Run task "COC_CheckScreen"
→ Check /sdcard/Tasker/COC_Screenshots/
→ Lihat screenshot untuk verify detection bekerja
```

---

## 💡 Tips & Trik

### 1. Gunakan Scene untuk Dashboard
```
Buat scene dengan:
  - Button: Start/Stop
  - Text: Current State
  - Text: Attacks Today
  - Text: Total Loot
  - Button: Force Check
  - Log viewer
```

### 2. Setup Telegram Notifications
```
Task "Send_Telegram":
  Action: HTTP GET
  URL: https://api.telegram.org/bot{BOT_TOKEN}/sendMessage
  Data:
    chat_id={YOUR_CHAT_ID}
    text=COC Attack #%coc_attacks_today completed! Loot: %coc_gold Gold
```

### 3. Batch Tap untuk Deploy Troop
```
Gunakan variable loop:
  %i = 1
  Repeat: 30
    Tap Barbarian position
    %i + 1
```

### 4. Condition dengan AND/OR
```
If [ %coc_enabled ~ 1 ] AND [ %coc_attacks_today < 20 ]
  → Run Attack Task
```

### 5. Error Handling & Retry
```
On Error:
  → Log error
  → Wait 30 seconds
  → Retry sama task (max 3x)
  → If still fail, disable & notify
```

---

## 🔧 Troubleshooting

### Masalah: Tasker tidak jalan saat screen OFF
```
✅ Solution:
  1. Disable battery optimization
  2. Settings → Developer Options → Stay Awake: ON
  3. Tasker Preferences → Action tab time: 800ms
  4. Make sure profile "Wifi Connected" atau state lain
```

### Masalah: Tap koordinat tidak akurat
```
✅ Solution:
  1. Check device resolution di config.json
  2. Hitung offset: X = screen_width/2, Y = screen_height/2
  3. Test dengan AutoInput plugin (premium)
  4. Calib ulang dengan screenshot
```

### Masalah: Crash atau force close
```
✅ Solution:
  1. Check Tasker log: cat /sdcard/Tasker/Logs/*
  2. Reduce wait time (bisa terlalu cepat)
  3. Check app permissions
  4. Clear Clash of Clans cache
  5. Restart device
```

### Masalah: Screenshot tidak terdeteksi
```
✅ Solution:
  1. Verify screenshot path correct
  2. Check storage permission
  3. Try manual screenshot via device
  4. Verify Tasker has READ_EXTERNAL_STORAGE
  5. Use OCR plugin untuk text recognition
```

### Masalah: Performance lag/slowdown
```
✅ Solution:
  1. Reduce screenshot interval
  2. Limit repeat actions
  3. Disable verbose logging saat production
  4. Use Tasker Lite mode
  5. Close background apps
```

### Masalah: Login tidak konsisten
```
✅ Solution:
  1. Increase login_timeout di config
  2. Check internet connection
  3. Use Google login method (lebih reliable)
  4. Save login session
  5. Add longer wait time setelah login
```

---

## 📚 Resource Tambahan

### Plugin Recommended
- **AutoInput** - Advanced tapping & gesture (paid)
- **SL4A** - Script execution (free)
- **Telegram** - Notifications (free)
- **TermBot** - Terminal emulator (free)

### Dokumentasi
- [Tasker Official Docs](https://tasker.joaoapps.com/userguide.html)
- [Tasker Reddit Community](https://www.reddit.com/r/tasker/)
- [Action Reference](https://tasker.joaoapps.com/net.dinglisch.android.taskerm.html)

### Setting Rekomendasi untuk COC
```json
{
  "screen_check_interval": 5000,
  "tap_duration": 150,
  "wait_after_action": 500,
  "screenshot_quality": 85,
  "max_retries": 3,
  "debug_mode": false,
  "log_level": "INFO"
}
```

---

## ⚠️ Disclaimer & Safety

⚠️ **PENTING**: 
- Gunakan bot ini untuk farming saja (tidak untuk war)
- Supercell bisa ban akun jika ketahuan bot (use at your own risk)
- Enable "Human-like behavior" di config
- Use random delays antara action
- Jangan use 24/7 (buat schedule realistis)
- Monitor akun secara berkala

---

## 📞 Support & Contact

Jika ada masalah, buat issue di repository dengan:
```
- Device info (model, Android version)
- Config.json (tanpa password)
- Tasker log (/sdcard/Tasker/Logs/)
- Error message atau screenshot
```

**Happy Tasker Automation! 🚀**
