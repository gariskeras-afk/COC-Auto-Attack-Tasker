#!/bin/bash

# ============================================
# COC Auto Clan Castle Request Filler - Termux
# Untuk Poco X3 NFC
# ============================================

echo "🚀 Starting COC Clan Castle Auto Request Filler..."
echo "=================================================="

# Setup folder
SCREENSHOT_DIR="/sdcard/Termux/COC_Screenshots"
LOG_DIR="/sdcard/Termux/Logs"
mkdir -p "$SCREENSHOT_DIR"
mkdir -p "$LOG_DIR"

LOG_FILE="$LOG_DIR/coc_bot_$(date +%Y%m%d_%H%M%S).log"

# Fungsi logging
log_action() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# Fungsi untuk tap screen
tap_screen() {
    local x=$1
    local y=$2
    local duration=${3:-150}
    log_action "Tap screen at X:$x Y:$y for ${duration}ms"
    input tap $x $y
    sleep 0.$(printf "%03d" $duration)
}

# Fungsi untuk swipe screen
swipe_screen() {
    local x1=$1
    local y1=$2
    local x2=$3
    local y2=$4
    local duration=${5:-500}
    log_action "Swipe from X:$x1 Y:$y1 to X:$x2 Y:$y2"
    input swipe $x1 $y1 $x2 $y2 $duration
    sleep 0.5
}

# Fungsi untuk delay
wait_delay() {
    local ms=$1
    local seconds=$(echo "scale=3; $ms / 1000" | bc)
    log_action "Wait for ${ms}ms"
    sleep $seconds
}

# Fungsi ambil screenshot
take_screenshot() {
    local filename="$1"
    log_action "Taking screenshot: $filename"
    screencap -p "$SCREENSHOT_DIR/$filename.png"
}

# Fungsi check jika app COC running
check_app_running() {
    if pgrep -f "com.supercell.clashofclans" > /dev/null; then
        log_action "✓ Clash of Clans is running"
        return 0
    else
        log_action "✗ Clash of Clans is NOT running"
        return 1
    fi
}

# ============================================
# FLOW 1: Buka menu chat clan
# ============================================
flow_open_clan_chat() {
    log_action "--- FLOW: Open Clan Chat ---"
    
    wait_delay 999
    wait_delay 999
    
    # Tap tombol clan/social (biasanya pojok kanan atas)
    tap_screen 950 200 150
    wait_delay 500
    
    take_screenshot "01_clan_menu_opened"
    
    log_action "✓ Clan chat menu opened"
}

# ============================================
# FLOW 2: Cari clan castle request
# ============================================
flow_find_request() {
    log_action "--- FLOW: Find Clan Castle Request ---"
    
    wait_delay 500
    
    # Scroll down cari request section
    swipe_screen 540 1200 540 600 500
    
    wait_delay 500
    
    # Tap tombol request (biasanya ada icon kotak/castle)
    tap_screen 540 1500 150
    
    wait_delay 999
    
    take_screenshot "02_request_menu_opened"
    
    log_action "✓ Request menu found"
}

# ============================================
# FLOW 3: Tap clan castle request
# ============================================
flow_tap_castle_request() {
    log_action "--- FLOW: Tap Clan Castle Request ---"
    
    wait_delay 500
    
    # Tap icon clan castle request (biasanya di tengah layar)
    tap_screen 540 1000 150
    
    wait_delay 999
    
    take_screenshot "03_castle_request_selected"
    
    log_action "✓ Clan castle request selected"
}

# ============================================
# FLOW 4: Pilih troop untuk request
# ============================================
flow_select_troop() {
    log_action "--- FLOW: Select Troop ---"
    
    wait_delay 500
    
    # Pilih troop yang ingin request (contoh: Dragon di posisi tertentu)
    # Anda bisa ubah koordinat sesuai troop yang diinginkan
    
    # OPSI 1: Tap Dragon (jika tersedia)
    tap_screen 200 1300 150
    wait_delay 300
    
    # OPSI 2: Increase quantity dengan tap tombol "+"
    # Tap tombol + beberapa kali
    for i in {1..3}; do
        tap_screen 600 1400 150
        wait_delay 199
    done
    
    wait_delay 500
    
    take_screenshot "04_troop_selected"
    
    log_action "✓ Troop selected"
}

# ============================================
# FLOW 5: Submit request
# ============================================
flow_submit_request() {
    log_action "--- FLOW: Submit Request ---"
    
    wait_delay 500
    
    # Tap tombol submit/request/send (biasanya di bawah layar)
    tap_screen 540 2200 150
    
    wait_delay 999
    
    take_screenshot "05_request_submitted"
    
    log_action "✓ Request submitted successfully"
}

# ============================================
# FLOW 6: Kembali ke layar utama
# ============================================
flow_return_to_home() {
    log_action "--- FLOW: Return to Home ---"
    
    wait_delay 500
    
    # Tap tombol X atau back
    tap_screen 100 200 150
    
    wait_delay 999
    
    take_screenshot "06_back_to_home"
    
    log_action "✓ Returned to home screen"
}

# ============================================
# MAIN EXECUTION
# ============================================
log_action "========== BOT STARTED =========="

# Check jika COC running
if ! check_app_running; then
    log_action "ERROR: Clash of Clans not running. Please open COC first."
    echo "❌ Clash of Clans tidak berjalan. Silakan buka aplikasi COC terlebih dahulu."
    exit 1
fi

log_action "Starting automated clan castle request filling..."

# Jalankan semua flow
flow_open_clan_chat
flow_find_request
flow_tap_castle_request
flow_select_troop
flow_submit_request
flow_return_to_home

log_action "========== BOT COMPLETED =========="
log_action "All actions completed successfully!"

echo ""
echo "✅ Bot selesai!"
echo "📸 Screenshots disimpan di: $SCREENSHOT_DIR"
echo "📋 Log disimpan di: $LOG_FILE"
echo ""
echo "Tekan Enter untuk keluar..."
read
