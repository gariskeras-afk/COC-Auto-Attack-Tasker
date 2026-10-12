#!/bin/bash

# ============================================
# COC Auto Clan Castle Request Filler v3
# Untuk Poco X3 NFC - Termux
# Auto isi SEMUA request sesuai permintaan clan
# ============================================

echo "🚀 COC Auto Request Filler - Fill All Requests"
echo "=============================================="

LOG_DIR="/sdcard/Termux/Logs"
mkdir -p "$LOG_DIR"

LOG_FILE="$LOG_DIR/coc_fill_all_$(date +%Y%m%d_%H%M%S).log"

log_action() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

tap_screen() {
    local x=$1
    local y=$2
    input tap $x $y
    sleep 0.1
}

wait_delay() {
    local ms=$1
    local seconds=$(echo "scale=3; $ms / 1000" | bc)
    sleep $seconds
}

check_app_running() {
    if pgrep -f "com.supercell.clashofclans" > /dev/null; then
        log_action "✓ COC running"
        return 0
    else
        log_action "✗ COC not running"
        return 1
    fi
}

# ============================================
# KOORDINAT POCO X3 NFC
# ============================================
MENU_CLAN_X=950
MENU_CLAN_Y=200
REQUEST_MENU_X=540
REQUEST_MENU_Y=1500
CASTLE_ICON_X=540
CASTLE_ICON_Y=1000

# Troop positions (9 types)
BARBARIAN_X=120
ARCHER_X=220
GIANT_X=320
GOBLIN_X=420
WALL_BREAKER_X=520
BALLOON_X=620
WIZARD_X=720
HEAL_X=820
DRAGON_X=920

TROOP_Y=1300
TROOP_INCREASE_Y=1400
SUBMIT_X=540
SUBMIT_Y=2200
BACK_X=100
BACK_Y=200
NEXT_REQUEST_X=900
NEXT_REQUEST_Y=1200

# ============================================
# TROOP MAPPING
# ============================================
declare -A TROOP_COORDS=(
    [barbarian]=$BARBARIAN_X
    [archer]=$ARCHER_X
    [giant]=$GIANT_X
    [goblin]=$GOBLIN_X
    [wall_breaker]=$WALL_BREAKER_X
    [wb]=$WALL_BREAKER_X
    [balloon]=$BALLOON_X
    [wizard]=$WIZARD_X
    [heal]=$HEAL_X
    [healing]=$HEAL_X
    [healing_spell]=$HEAL_X
    [dragon]=$DRAGON_X
)

# ============================================
# Tap troop berdasarkan nama
# ============================================
tap_troop() {
    local troop_name=$(echo "$1" | tr '[:upper:]' '[:lower:]' | sed 's/ /_/g')
    local quantity=$2
    
    # Normalize troop name
    case "$troop_name" in
        "barbarian") troop_name="barbarian" ;;
        "archer") troop_name="archer" ;;
        "giant") troop_name="giant" ;;
        "goblin") troop_name="goblin" ;;
        "wall_breaker"|"wallbreaker"|"wb") troop_name="wall_breaker" ;;
        "balloon") troop_name="balloon" ;;
        "wizard") troop_name="wizard" ;;
        "heal"|"healing"|"healing_spell") troop_name="heal" ;;
        "dragon") troop_name="dragon" ;;
        *)
            log_action "⚠ Unknown troop: $1"
            return 1
            ;;
    esac
    
    # Get X coordinate
    local x_coord=${TROOP_COORDS[$troop_name]}
    
    if [ -z "$x_coord" ]; then
        log_action "⚠ Coordinate not found for: $troop_name"
        return 1
    fi
    
    # Tap troop
    tap_screen $x_coord $TROOP_Y
    log_action "→ Selected: $1 (quantity will be set to $quantity)"
    wait_delay 200
    
    # Set quantity dengan tap tombol +
    if [ "$quantity" -gt 1 ]; then
        # Clear current quantity dulu (tap - jika perlu)
        # Untuk sekarang langsung add
        for ((i=1; i<quantity; i++)); do
            tap_screen $SUBMIT_X $TROOP_INCREASE_Y
            wait_delay 80
        done
        log_action "→ Quantity set to: $quantity"
    fi
}

# ============================================
# FLOW: Buka menu request
# ============================================
open_request_menu() {
    log_action "--- Opening clan request menu ---"
    
    wait_delay 999
    wait_delay 500
    
    tap_screen $MENU_CLAN_X $MENU_CLAN_Y
    log_action "Tapped clan menu"
    wait_delay 600
    
    tap_screen $REQUEST_MENU_X $REQUEST_MENU_Y
    log_action "Tapped request menu"
    wait_delay 999
}

# ============================================
# FLOW: Pilih clan castle & isi request
# ============================================
fill_castle_request() {
    local troop=$1
    local qty=$2
    
    log_action "--- Filling: $qty x $troop ---"
    
    wait_delay 300
    
    # Tap clan castle icon
    tap_screen $CASTLE_ICON_X $CASTLE_ICON_Y
    log_action "Tapped clan castle"
    wait_delay 999
    
    wait_delay 300
    
    # Select & set troop
    tap_troop "$troop" "$qty"
    
    wait_delay 300
    
    # Submit
    tap_screen $SUBMIT_X $SUBMIT_Y
    log_action "✓ Submitted: $qty x $troop"
    wait_delay 999
}

# ============================================
# FLOW: Scroll ke request berikutnya
# ============================================
next_request() {
    log_action "--- Moving to next request ---"
    
    wait_delay 500
    
    # Swipe kanan untuk scroll ke request berikutnya
    input swipe 200 1200 900 1200 300
    log_action "Scrolled to next request"
    wait_delay 800
}

# ============================================
# FLOW: Kembali ke home
# ============================================
return_home() {
    log_action "--- Returning to home ---"
    
    wait_delay 300
    tap_screen $BACK_X $BACK_Y
    log_action "✓ Returned to home"
    wait_delay 999
}

# ============================================
# MAIN - Input permintaan clan
# ============================================
log_action "========== BOT STARTED =========="

if ! check_app_running; then
    echo "❌ Buka Clash of Clans terlebih dahulu!"
    exit 1
fi

echo ""
echo "Format input:"
echo "============"
echo "Dragon 2, Barbarian 10, Wizard 5, Giant 3"
echo ""
echo "Jenis troop yang tersedia:"
echo "- Barbarian"
echo "- Archer"
echo "- Giant"
echo "- Goblin"
echo "- Wall Breaker (atau WB)"
echo "- Balloon"
echo "- Wizard"
echo "- Heal (Healing Spell)"
echo "- Dragon"
echo ""
read -p "Masukkan permintaan clan (pisahkan dengan koma): " clan_requests

if [ -z "$clan_requests" ]; then
    echo "❌ Input kosong!"
    exit 1
fi

log_action "Input received: $clan_requests"

# Buka menu request
open_request_menu

# Parse dan isi semua request
IFS=',' read -ra REQUESTS <<< "$clan_requests"
REQUEST_COUNT=${#REQUESTS[@]}

log_action "Total requests: $REQUEST_COUNT"

for ((i=0; i<REQUEST_COUNT; i++)); do
    req=$(echo "${REQUESTS[$i]}" | xargs)
    
    # Parse: NamaTroop Jumlah
    if [[ $req =~ ([A-Za-z\ ]+)[[:space:]]+([0-9]+) ]]; then
        troop="${BASH_REMATCH[1]}"
        quantity="${BASH_REMATCH[2]}"
        
        log_action "Request $((i+1))/$REQUEST_COUNT: $troop x$quantity"
        
        fill_castle_request "$troop" "$quantity"
        
        # Jika bukan request terakhir, scroll ke request berikutnya
        if [ $i -lt $((REQUEST_COUNT - 1)) ]; then
            next_request
        fi
    else
        log_action "⚠ Format salah: $req"
    fi
    
    wait_delay 500
done

# Kembali ke home
return_home

log_action "========== BOT COMPLETED =========="
echo ""
echo "✅ Semua request selesai diisi!"
echo "📊 Total: $REQUEST_COUNT request"
echo "📋 Log: $LOG_FILE"
