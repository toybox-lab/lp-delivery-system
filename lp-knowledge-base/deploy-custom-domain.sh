#!/bin/bash
# 独自ドメイン納品スクリプト（ToyBox LP制作ラボ）
# 使い方: bash deploy-custom-domain.sh <repo名> <ドメイン名> <LPファイル名>
# 例:     bash deploy-custom-domain.sh toybubble toybubble.com lp_20260617_toybubble_v2.html
#
# 前提: mizukが既にドメインを購入済み。DNS設定は別途mizukが手順書③に従って行う。

set -e
REPO_NAME="$1"
DOMAIN="$2"
LP_FILE="$3"
OWNER="toybox-lab"
BASE="/c/Users/mizuk/OneDrive/Desktop/ToyBox/lp-knowledge-base"

if [ -z "$REPO_NAME" ] || [ -z "$DOMAIN" ] || [ -z "$LP_FILE" ]; then
  echo "使い方: bash deploy-custom-domain.sh <repo名> <ドメイン名> <LPファイル名>"
  exit 1
fi
if [ ! -f "$BASE/$LP_FILE" ]; then
  echo "エラー: LPファイルが見つからない: $BASE/$LP_FILE"
  exit 1
fi

TOKEN=$(cat /c/Users/mizuk/.github_token | tr -d '\r\n')

echo "① リポジトリ作成: $OWNER/$REPO_NAME"
# toybox-lab は個人アカウントのため /user/repos を使う（トークンの持ち主＝toybox-lab）
curl -s -X POST "https://api.github.com/user/repos" \
  -H "Authorization: token $TOKEN" -H "Content-Type: application/json" \
  -d "{\"name\":\"$REPO_NAME\",\"private\":false,\"description\":\"LP for $DOMAIN\"}" \
  | grep -o '"full_name":"[^"]*"' | head -1 || true

put_file () {
  local PATH_IN_REPO="$1" CONTENT_B64="$2" MSG="$3"
  printf '{"message":"%s","content":"%s"}' "$MSG" "$CONTENT_B64" > /tmp/dcd.json
  curl -s -o /dev/null -w "  $PATH_IN_REPO -> %{http_code}\n" -X PUT \
    "https://api.github.com/repos/$OWNER/$REPO_NAME/contents/$PATH_IN_REPO" \
    -H "Authorization: token $TOKEN" -H "Content-Type: application/json" --data @/tmp/dcd.json
}

echo "② LPを index.html として配置"
LP_B64=$(base64 -w 0 "$BASE/$LP_FILE")
put_file "index.html" "$LP_B64" "Deploy LP for $DOMAIN"

echo "③ CNAMEファイル配置（独自ドメイン認識用）"
CNAME_B64=$(printf '%s' "$DOMAIN" | base64 -w 0)
put_file "CNAME" "$CNAME_B64" "Add custom domain $DOMAIN"

echo "④ 画像など同梱素材があればここで追加（必要に応じて put_file を追記）"

echo "⑤ GitHub Pages 有効化"
curl -s -o /dev/null -w "  pages -> %{http_code}\n" -X POST \
  "https://api.github.com/repos/$OWNER/$REPO_NAME/pages" \
  -H "Authorization: token $TOKEN" -H "Accept: application/vnd.github+json" \
  -d '{"source":{"branch":"main","path":"/"}}' || true

echo ""
echo "=== 完了 ==="
echo "次にmizukがやること（DNS設定）:"
echo "  Aレコード @ -> 185.199.108.153 / .109.153 / .110.153 / .111.153"
echo "  CNAME    www -> $OWNER.github.io"
echo "DNS反映後、https://$DOMAIN でアクセス確認。"
