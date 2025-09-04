# Python Playground Template

연습용 파이썬 모놀리포 구조 템플릿.

# 1. 템플릿 압축 해제
unzip python-playground-template.zip
cd python-playground-template

# 2. 공통 venv 생성 및 도구 설치
python -m venv .venv
source .venv/bin/activate
-> bin/activate 불가시 -> py -3 -m venv .venv -> .venv/Scripts/activate
pip install -r dev-requirements.txt
pre-commit install

# 3. 새 연습 프로젝트 생성
chmod +x scripts/new_project.sh (처음 한번 실행)
mkdir projects
./scripts/new_project.sh 'test-proj' (예시)

# 4. 프로젝트 이동
cd projects/test-proj

# 5. 신규 프로젝트 가상환경 생성

python -m venv .venv
source .venv/Scripts/activate
pip install -r ../../dev-requirements.txt

# 5. 전체 테스트 실행
./scripts/test_all.sh
