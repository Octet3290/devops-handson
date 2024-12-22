FROM python:3.9
WORKDIR /app
COPY main.py .
RUN apt-get update && \
    apt-get install -y 
RUN pip install boto3 pyodbc mysql.connector
CMD ["python", "main.py"]
