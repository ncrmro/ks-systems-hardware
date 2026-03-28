#!/usr/bin/env bash
# Tests for lfs-s3 + Cloudflare R2 configuration
# Run from within the nix devshell: bash tests/test_lfs_s3_setup.sh
set -uo pipefail

PASS=0
FAIL=0

check() {
  local name="$1"
  shift
  if "$@" >/dev/null 2>&1; then
    echo "PASS: $name"
    PASS=$((PASS + 1))
  else
    echo "FAIL: $name"
    FAIL=$((FAIL + 1))
  fi
}

# Req Task 1: lfs-s3 binary must be available in the devshell
check "lfs-s3 binary in PATH" which lfs-s3

# Req Task 2: Git LFS configured with lfs-s3 as standalone transfer agent
check "git lfs standalonetransferagent is lfs-s3" \
  test "$(git config --get lfs.standalonetransferagent)" = "lfs-s3"

# Req Task 2: Custom transfer path configured
check "git lfs custom transfer path set" \
  git config --get lfs.customtransfer.lfs-s3.path

# Req Task 3: .gitattributes tracks STL files via LFS
check ".gitattributes tracks *.stl" \
  test "$(git check-attr filter -- test.stl | awk '{print $NF}')" = "lfs"

# Req Task 3: .gitattributes tracks PNG files via LFS
check ".gitattributes tracks *.png" \
  test "$(git check-attr filter -- test.png | awk '{print $NF}')" = "lfs"

# Req Task 3: .gitattributes tracks STEP files via LFS
check ".gitattributes tracks *.step" \
  test "$(git check-attr filter -- test.step | awk '{print $NF}')" = "lfs"

# Req Task 4: .env.example documents S3_BUCKET
check ".env.example has S3_BUCKET" \
  grep -q "S3_BUCKET" .env.example

# Req Task 4: .env.example documents AWS_S3_ENDPOINT
check ".env.example has AWS_S3_ENDPOINT" \
  grep -q "AWS_S3_ENDPOINT" .env.example

echo ""
echo "Results: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
