FROM python:3.12-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    FLASK_ENV=production

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

# Cloud Run injects PORT at runtime (defaults to 8080 for local `docker run`).
ENV PORT=8080
EXPOSE 8080

# Shell form so $PORT is expanded; 1 worker / multiple threads suits Cloud Run's
# single-vCPU default and its scale-by-instance model better than many workers.
CMD exec gunicorn --bind :$PORT --workers 1 --threads 8 --timeout 0 wsgi:app
