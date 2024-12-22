import boto3
import pyodbc
import os
import mysql

# Retrieve AWS credentials from environment variables
aws_access_key_id = os.environ.get('AKIA5CYNUHQPY34NIV4B')
aws_secret_access_key = os.environ.get('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')
aws_region = os.environ.get('us-east-1')

bucket_name = "octet-bucket"
key = "Resume.pdf"
def read_data_from_s3(bucket_name, key):
    s3 = boto3.client('s3')
    response = s3.get_object(Bucket=bucket_name, Key=key)
    data = response['Body'].read().decode('utf-8')
    return data

def push_data_to_rds(data):
    db_host = os.environ['database1.craaqek68co3.us-east-1.rds.amazonaws.com']
    db_name = os.environ['database1']
    db_user = os.environ['octet']
    db_password = os.environ['Yoctet3290']
    
    conn = mysql.connect(host="database1.craaqek68co3.us-east-1.rds.amazonaws.com", database="database1", user="octet", password="Yoctet3290" )
    
    try:
        with conn.cursor() as cursor:
            sql = "INSERT INTO data_table (data) VALUES (%s)"
            cursor.execute(sql, (data,))
        conn.commit()
    finally:
        conn.close()

def main():
    bucket_name = 'octet-bucket'
    object_key = 'Resume.pdf' 

    data = read_data_from_s3(bucket_name,object_key)
    
    push_data_to_rds(data)
    
    print("Data successfully pushed to RDS database.")

if __name__ == "__main__":
    main()