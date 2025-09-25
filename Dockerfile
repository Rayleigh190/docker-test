# 베이스 이미지 (경량 Python)
FROM python:3.11-slim

# 환경변수 (Python 출력 버퍼링 제거)
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# 작업 디렉토리
WORKDIR /app

# 시스템 패키지 업데이트 및 psycopg2(Postgres 드라이버) 빌드에 필요한 의존성 설치
RUN apt-get update && apt-get install -y \
    gcc \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

# requirements 복사 및 설치
COPY requirements.txt .
RUN pip install --upgrade pip && pip install -r requirements.txt

# 소스코드 복사
COPY . .

# 컨테이너 실행 시 Django 서버 실행
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "config.wsgi:application"]
