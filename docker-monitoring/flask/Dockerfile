FROM python:3.9
WORKDIR /app
COPY . .
RUN pip install flask prometheus-flask-exporter
CMD ["python", "app.py"]
