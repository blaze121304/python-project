#!/usr/bin/env bash
set -euo pipefail

if [ $# -ne 1 ]; then
  echo "Usage: $0 <project-dir-name>"
  exit 1
fi

NAME="$1"
SRC="templates/project-skeleton"
DST="projects/$NAME"

# 0) 부모 디렉터리 보장
mkdir -p projects

# 1) 중복 방지
if [ -d "$DST" ]; then
  echo "Already exists: $DST"
  exit 1
fi

# 2) 템플릿 복사
cp -r "$SRC" "$DST"

# 3) 패키지명(소문자+언더스코어) 만들기
PKG=$(echo "$NAME" | tr '-' '_' | tr '[:upper:]' '[:lower:]')

# 4) 템플릿의 replace_me 제거 + 올바른 패키지 디렉터리 생성
rm -rf "$DST/src/replace_me"
mkdir -p "$DST/src/$PKG"

# 5) pyproject.toml에 프로젝트명 반영
sed -i.bak "s/REPLACE_ME/$NAME/g" "$DST/pyproject.toml" && rm "$DST/pyproject.toml.bak"

# 6) __init__.py에 main() 기본 함수 작성 (자바 main 느낌)
cat > "$DST/src/$PKG/__init__.py" <<'PYCODE'
def main():
    print("Hello, World!")
PYCODE

# 7) 루트 main.py 생성 (PYTHONPATH 안 건드려도 실행되도록 src 추가)
cat > "$DST/main.py" <<PYCODE
import os
import sys

# src를 import 경로에 추가
BASE_DIR = os.path.dirname(os.path.abspath(__file__))
SRC_DIR = os.path.join(BASE_DIR, "src")
if SRC_DIR not in sys.path:
    sys.path.insert(0, SRC_DIR)

from ${PKG} import main  # type: ignore  # ruff/mypy 친화

if __name__ == "__main__":
    main()
PYCODE

echo "Created $DST"
echo "Next steps:"
echo "  cd $DST"
echo "  python -m venv .venv && source .venv/bin/activate"
echo "  pip install -r ../../dev-requirements.txt"
echo "  python main.py   # Hello, World! 출력"