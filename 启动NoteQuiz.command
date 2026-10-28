#!/bin/zsh
set -e
cd "$(dirname "$0")"
flutter_bin=$(command -v flutter || true)
node_bin=$(command -v node || true)
[ -n "$flutter_bin" ] || flutter_bin="$HOME/flutter/flutter/bin/flutter"
[ -n "$node_bin" ] || node_bin="$HOME/.cache/codex-runtimes/codex-primary-runtime/dependencies/node/bin/node"
if [ ! -x "$flutter_bin" ] || [ ! -x "$node_bin" ]; then
  echo '请先安装Flutter和Node.js，并加入PATH。'; read '?按回车结束'; exit 1
fi
export PATH="$(dirname "$node_bin"):$(dirname "$flutter_bin"):$PATH"
"$flutter_bin" pub get
"$flutter_bin" build web --release
cd mock_server
if command -v npm >/dev/null; then
  npm ci
elif [ -x "$HOME/.cache/codex-runtimes/codex-primary-runtime/dependencies/bin/fallback/pnpm" ]; then
  "$HOME/.cache/codex-runtimes/codex-primary-runtime/dependencies/bin/fallback/pnpm" install --frozen-lockfile
else
  echo '需要npm或pnpm安装json-server。'; read '?按回车结束'; exit 1
fi
"$node_bin" server.cjs &
server_pid=$!
trap 'kill "$server_pid" 2>/dev/null || true' EXIT INT TERM
sleep 1
open http://localhost:3000
wait "$server_pid"
