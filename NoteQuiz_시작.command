#!/bin/zsh
set -e
cd "$(dirname "$0")"

flutter_bin=$(command -v flutter || true)
node_bin=$(command -v node || true)
if [ -z "$flutter_bin" ] || [ -z "$node_bin" ]; then
  echo 'Flutter와 Node.js를 설치한 뒤 PATH에 추가해 주세요.'
  read -r _
  exit 1
fi

export PATH="$(dirname "$node_bin"):$(dirname "$flutter_bin"):$PATH"
"$flutter_bin" pub get
"$flutter_bin" build web --release

cd mock_server
if ! command -v npm >/dev/null; then
  echo 'npm을 찾지 못했습니다. Node.js 설치를 확인해 주세요.'
  read -r _
  exit 1
fi
npm ci

"$node_bin" server.cjs &
server_pid=$!
trap 'kill "$server_pid" 2>/dev/null || true' EXIT INT TERM
sleep 1
open http://localhost:3000
wait "$server_pid"
