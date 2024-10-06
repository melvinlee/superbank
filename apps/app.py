from flask import Flask, jsonify, request

app = Flask(__name__)

# Sample account balance
balance = 1000

@app.route('/', methods=['GET'])
def get_balance():
    return jsonify({'balance': balance})

@app.route('/transaction', methods=['POST'])
def transaction():
    global balance

    data = request.get_json()
    amount = data.get('amount')
    transaction_type = data.get('type')

    if transaction_type == 'deposit':
        balance += amount
    elif transaction_type == 'withdraw':
        if amount > balance:
            return jsonify({'message': 'Insufficient balance'}), 400
        balance -= amount
    else:
        return jsonify({'message': 'Invalid transaction type'}), 400

    return jsonify({'message': 'Transaction successful'})

@app.route('/health', methods=['GET'])
def health_check():
    return jsonify({'status': 'healthy'})

if __name__ == '__main__':
      app.run(host='0.0.0.0', port=8443)