#!/usr/bin/env bash

# --------------------------------------------------------
# HIREK AUTOMATION SCRIPT
# RUNS HIREK.PY + WRITING LOG
# --------------------------------------------------------

# ---  Base settings ---
BASE_DIR="/home/gdaniel1979/my_projects/hirek"
MAIN_CODE="hirek.py"
LOG_NAME="hirek_automation.log"

# ---  Setting directory ---
cd "$BASE_DIR" || exit 1

# --- Setting PATH for cron ---
export PATH=/usr/bin:/bin:/usr/local/bin

LOG_FILE="$BASE_DIR/$LOG_NAME"
DATE_STR=$(date '+%Y-%m-%d %H:%M:%S')

# --- Running Python script and saving output into variable ---
OUTPUT=$(/usr/bin/python3 "$BASE_DIR/$MAIN_CODE" 2>&1)

# --- Prepending new entry to log (newest on top) ---
TMP_LOG=$(mktemp)
{
    echo "===== $DATE_STR ====="
    echo "$OUTPUT"
    echo ""
    echo ""
    cat "$LOG_FILE" 2>/dev/null
} > "$TMP_LOG"
mv "$TMP_LOG" "$LOG_FILE"
