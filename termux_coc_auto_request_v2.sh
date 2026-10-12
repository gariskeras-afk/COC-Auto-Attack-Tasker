#!/bin/bash

# ============================================
# COC Auto Clan Castle Request Filler v2
# Untuk Poco X3 NFC - Termux
# Isi sesuai permintaan anggota clan, tanpa screenshot
# ============================================

echo "🚀 Starting COC Clan Castle Auto Request Filler..."

# Setup folder
LOG_DIR="/sdcard/Termux/Logs"
mkdir -p "$LOG_DIR"

LOG_FILE="$LOG_DIR/coc_request_$(date +%Y%m%d_%H%M%S).log"

# Fungsi logging
log_action() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# Fungsi untuk tap screen
tap_screen() {
    local x=$1
    local y=$2
    input tap $x $y
    sleep 0.1
}

# Fungsi untuk delay
wait_delay() {
    local ms=$1
    local seconds=$(echo "scale=3; $ms / 1000" | bc)
    sleep $seconds
}

# Fungsi check jika app COC running
check_app_running() {
    if pgrep -f "com.supercell.clashofclans" > /dev/null; then
        log_action "✓ Clash of Clans running"
        return 0
    else
        log_action "✗ Clash of Clans not running"
        return 1
    fi
}

# ============================================
# KOORDINAT UNTUK POCO X3 NFC
# ============================================
# Menu button
MENU_CLAN_X=950
MENU_CLAN_Y=200

# Request menu
REQUEST_MENU_X=540
REQUEST_MENU_Y=1500

# Clan castle icon
CASTLE_ICON_X=540
CASTLE_ICON_Y=1000

# Troop positions (X coordinate)
BARBARIAN_X=150
ARCHER_X=250
GIANT_X=350
GOBLIN_X=450
WALL_BREAKER_X=550
BALLOON_X=650
WIZARD_X=750
HEAL_X=850
DRAGON_X=950

# Troop Y coordinate (tetap sama untuk semua)
TROOP_Y=1300
TROOP_INCREASE_Y=1400
SUBMIT_X=540
SUBMIT_Y=2200
BACK_X=100
BACK_Y=200

# ============================================
# FUNGSI: Tap troop berdasarkan nama
# ============================================
tap_troop() {
    local troop_name=$1
    local quantity=$2
    
    case "$troop_name" in
        "Barbarian"|"barbarian"|"BARBARIAN")
            tap_screen $BARBARIAN_X $TROOP_Y
            ;;
        "Archer"|"archer"|"ARCHER")
            tap_screen $ARCHER_X $TROOP_Y
            ;;
        "Giant"|"giant"|"GIANT")
            tap_screen $GIANT_X $TROOP_Y
            ;;
        "Goblin"|"goblin"|"GOBLIN")
            tap_screen $GOBLIN_X $TROOP_Y
            ;;
        "Wall Breaker"|"wall breaker"|"WALL BREAKER"|"wb")
            tap_screen $WALL_BREAKER_X $TROOP_Y
            ;;
        "Balloon"|"balloon"|"BALLOON")
            tap_screen $BALLOON_X $TROOP_Y
            ;;
        "Wizard"|"wizard"|"WIZARD")
            tap_screen $WIZARD_X $TROOP_Y
            ;;
        "Healing Spell"|"heal"|"HEAL"|"healing")
            tap_screen $HEAL_X $TROOP_Y
            ;;
        "Dragon"|"dragon"|"DRAGON")
            tap_screen $DRAGON_X $TROOP_Y
            ;;
        *)
            log_action "⚠ Unknown troop: $troop_name"
            return 1
            ;;
    esac
    
    log_action "→ Selected: $troop_name"
    wait_delay 200
    
    # Increase quantity dengan tap tombol +
    if [ "$quantity" -gt 1 ]; then
        for ((i=1; i<quantity; i++)); do
            tap_screen $SUBMIT_X $TROOP_INCREASE_Y
            wait_delay 100
        done
        log_action "→ Quantity: $quantity"
    fi
}

# ============================================
# FLOW: Buka clan chat & cari request
# ============================================
open_clan_request() {
    log_action "--- Opening clan request menu ---"
    
    wait_delay 999
    
    # Tap clan menu button
    tap_screen $MENU_CLAN_X $MENU_CLAN_Y
    log_action "Tapped clan menu"
    wait_delay 500
    
    # Tap request menu
    tap_screen $REQUEST_MENU_X $REQUEST_MENU_Y
    log_action "Tapped request menu"
    wait_delay 999
}

# ============================================
# FLOW: Tap clan castle request
# ============================================
select_castle_request() {
    log_action "--- Selecting clan castle request ---"
    
    wait_delay 300
    
    # Tap castle icon
    tap_screen $CASTLE_ICON_X $CASTLE_ICON_Y
    log_action "Tapped clan castle icon"
    wait_delay 999
}

# ============================================
# FLOW: Pilih troop & submit
# ============================================
fill_request() {
    local troop=$1
    local qty=$2
    
    log_action "--- Filling request: $qty x $troop ---"
    
    wait_delay 300
    
    # Select troop
    tap_troop "$troop" "$qty"
    
    wait_delay 300
    
    # Submit request
    tap_screen $SUBMIT_X $SUBMIT_Y
    log_action "✓ Request submitted: $qty x $troop"
    wait_delay 999
}

# ============================================
# FLOW: Kembali ke home
# ============================================
return_home() {
    log_action "--- Returning to home ---"
    
    wait_delay 300
    tap_screen $BACK_X $BACK_Y
    log_action "✓ Returned to home screen"
    wait_delay 999
}

# ============================================
# MAIN EXECUTION
# ============================================
log_action "========== BOT STARTED =========="

if ! check_app_running; then
    echo "❌ Buka Clash of Clans terlebih dahulu!"
    exit 1
fi

# Contoh: Isi sesuai permintaan anggota
# Format: troop_name quantity

log_action "Membuka menu request..."
open_clan_request

log_action "Memilih clan castle request..."
select_castle_request

# INPUT PERMINTAAN DARI USER
read -p "Masukkan permintaan (contoh: Dragon 2, Barbarian 10, Wizard 5): " request_input

# Parse input
IFS=',' read -ra REQUESTS <<< "$request_input"

for req in "${REQUESTS[@]}"; do
    # Trim whitespace
    req=$(echo "$req" | xargs)
    
    # Split troop name dan quantity
    if [[ $req =~ ([A-Za-z\ ]+)[[:space:]]+([0-9]+) ]]; then
        troop="${BASH_REMATCH[1]}"
        quantity="${BASH_REMATCH[2]}"
        
        fill_request "$troop" "$quantity"
    else
        log_action "⚠ Format salah: $req (gunakan: NamaTroop Jumlah)"
    fi
    
    wait_delay 500
done

log_action "Kembali ke home..."
return_home

log_action "========== BOT COMPLETED =========="
echo ""
echo "✅ Semua request selesai!"
echo "📋 Log: $LOG_FILE"
