from flask import Flask, jsonify, request
import boto3
from botocore.exceptions import ClientError

app = Flask(__name__)

# Initialize DynamoDB client
dynamodb = boto3.resource('dynamodb', region_name='ap-southeast-1')
table_name = 'AccountBalance'
table = dynamodb.Table(table_name)

# # Ensure the table exists
# try:
#     table.load()
# except ClientError:
#     # Create the table if it does not exist
#     table = dynamodb.create_table(
#         TableName=table_name,
#         KeySchema=[
#             {
#                 'AttributeName': 'account_id',
#                 'KeyType': 'HASH'
#             }
#         ],
#         AttributeDefinitions=[
#             {
#                 'AttributeName': 'account_id',
#                 'AttributeType': 'S'
#             }
#         ],
#         ProvisionedThroughput={
#             'ReadCapacityUnits': 5,
#             'WriteCapacityUnits': 5
#         }
#     )
#     table.meta.client.get_waiter('table_exists').wait(TableName=table_name)

# Sample account ID
account_id = '1234567890'

def get_balance_from_db():
    try:
        response = table.get_item(Key={'account_id': account_id})
        return response['Item']['balance']
    except KeyError:
        return 0

def update_balance_in_db(new_balance):
    table.put_item(Item={'account_id': account_id, 'balance': new_balance})

@app.route('/', methods=['GET'])
def get_balance():
    balance = get_balance_from_db()
    return jsonify({'balance': balance})

@app.route('/transaction', methods=['POST'])
def transaction():
    data = request.get_json()
    amount = data.get('amount')
    transaction_type = data.get('type')

    balance = get_balance_from_db()

    if transaction_type == 'deposit':
        balance += amount
    elif transaction_type == 'withdraw':
        if amount > balance:
            return jsonify({'message': 'Insufficient balance'}), 400
        balance -= amount
    else:
        return jsonify({'message': 'Invalid transaction type'}), 400

    update_balance_in_db(balance)
    return jsonify({'message': 'Transaction successful'})

@app.route('/health', methods=['GET'])
def health_check():
    return jsonify({'status': 'healthy'})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8443)