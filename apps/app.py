from flask import Flask, jsonify, request
import boto3
from botocore.exceptions import ClientError

app = Flask(__name__)

# Initialize DynamoDB client
dynamodb = boto3.resource('dynamodb', region_name='ap-southeast-1')
table_name = 'AccountBalance'
table = dynamodb.Table(table_name)

# Ensure the table exists
try:
    table.load()
except ClientError:
    # Create the table if it does not exist
    table = dynamodb.create_table(
        TableName=table_name,
        KeySchema=[
            {
                'AttributeName': 'account_id',
                'KeyType': 'HASH'
            }
        ],
        AttributeDefinitions=[
            {
                'AttributeName': 'account_id',
                'AttributeType': 'S'
            }
        ],
        ProvisionedThroughput={
            'ReadCapacityUnits': 5,
            'WriteCapacityUnits': 5
        }
    )
    table.meta.client.get_waiter('table_exists').wait(TableName=table_name)

def get_balance_from_db(account_id):
    try:
        response = table.get_item(Key={'account_id': account_id})
        return response['Item']['balance']
    except KeyError:
        return 0

def update_balance_in_db(account_id, new_balance):
    table.update_item(
        Key={'account_id': account_id},
        UpdateExpression='SET balance = :val',
        ExpressionAttributeValues={':val': new_balance}
    )

@app.route('/balance/<account_id>', methods=['GET'])
def get_balance(account_id):
    balance = get_balance_from_db(account_id)
    return jsonify({'account_id': account_id, 'balance': balance})

@app.route('/balance/<account_id>', methods=['POST'])
def update_balance(account_id):
    data = request.get_json()
    new_balance = data.get('balance')
    if new_balance is None:
        return jsonify({'error': 'Balance is required'}), 400
    update_balance_in_db(account_id, new_balance)
    return jsonify({'account_id': account_id, 'balance': new_balance})

if __name__ == '__main__':
    app.run(debug=True)