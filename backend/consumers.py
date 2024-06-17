from flask import Flask, request, jsonify, send_file
from flask_pymongo import PyMongo
from gridfs import GridFS
import re
import io

app = Flask(__name__)
app.config["MONGO_URI"] = "mongodb://localhost:27017/bookeasy"
mongo = PyMongo(app)
db = mongo.db
fs = GridFS(db)

# Schema for consumers
schema1 = {
    '$jsonSchema': {
        "bsonType": "object",
        "required": ["name", "email", "password", "number"],
        "properties": {
            "name": {"bsonType": "string"},
            "email": {"bsonType": "string", 'pattern': '^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$'},
            "password": {"bsonType": "string"},
            "number": {"bsonType": "string"},
            "services_ongoing": {"bsonType": "int"},
            "total_bookings": {"bsonType": "int"},
            "address": {"bsonType": "string", "default": "Street - 150"},
            "profile_image": {"bsonType": "objectId"}
        }
    }
}

# Schema for providers
schema2 = {
    '$jsonSchema': {
        "bsonType": "object",
        "required": ["name", "email", "password", "number", 'service_type'],
        "properties": {
            "name": {"bsonType": "string"},
            "email": {"bsonType": "string", 'pattern': '^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$'},
            "password": {"bsonType": "string"},
            "number": {"bsonType": "string"},
            'service_type': {'bsonType': 'string'},
            "currently_booked": {"bsonType": "bool", 'default': False},
            "total_services": {"bsonType": "int", 'default': 0},
            "charge": {"bsonType": "int", 'default': 500},
            "profile_image": {"bsonType": "objectId"}
        }
    }
}

# Schema for bank accounts
bank_account_schema = {
    '$jsonSchema': {
        "bsonType": "object",
        "required": ["email", "name", "bankName", "accountNumber", "ifscCode"],
        "properties": {
            "email": {"bsonType": "string", 'pattern': '^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$'},
            "name": {"bsonType": "string"},
            "bankName": {"bsonType": "string"},
            "accountNumber": {"bsonType": "string"},
            "ifscCode": {"bsonType": "string"},
            "accountType": {"bsonType": "string"}
        }
    }
}

if "consumers" not in db.list_collection_names():
    consumers = db.create_collection("consumers", validator=schema1)
else:
    consumers = db["consumers"]

if "providers" not in db.list_collection_names():
    providers = db.create_collection("providers", validator=schema2)
else:
    providers = db["providers"]

if "bank_accounts" not in db.list_collection_names():
    bank_accounts = db.create_collection("bank_accounts", validator=bank_account_schema)
else:
    bank_accounts = db["bank_accounts"]

def validate_email(email):
    pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'
    return bool(re.match(pattern, email))

@app.route("/consumers/signup", methods=['POST'])
def signup_user():
    data = request.form
    if data:
        if validate_email(data['email']):
            profile_image_id = None
            if 'profile_image' in request.files:
                profile_image = request.files['profile_image']
                profile_image_id = fs.put(profile_image, filename=profile_image.filename)

            consumers.insert_one({
                'name': data['name'],
                'email': data['email'],
                'password': data['password'],
                'number': data['number'],
                'services_ongoing': 0,
                'total_bookings': 0,
                'profile_image': profile_image_id
            })
            if 'bankAccount' in data:
                bank_accounts.insert_one({
                    'email': data['email'],
                    'name': data['name'],
                    'bankName': data['bankAccount']['bankName'],
                    'accountNumber': data['bankAccount']['accountNumber'],
                    'ifscCode': data['bankAccount']['ifscCode'],
                    'accountType': data['bankAccount']['accountType']
                })
            return jsonify({"result": True}), 200, {'Content-Type': 'application/json'}
        else:
            return jsonify({'result': False, 'message': 'Invalid email format'}), 401, {'Content-Type': 'application/json'}
    else:
        return jsonify({'result': False, 'message': 'No data provided'}), 404, {'Content-Type': 'application/json'}

@app.route("/providers/signup", methods=['POST'])
def signup_provider():
    data = request.form
    if data:
        if validate_email(data['email']):
            profile_image_id = None
            if 'profile_image' in request.files:
                profile_image = request.files['profile_image']
                profile_image_id = fs.put(profile_image, filename=profile_image.filename)

            providers.insert_one({
                "name": data['name'],
                "email": data['email'],
                "password": data['password'],
                "number": data['number'],
                'service_type': data['service_type'],
                "currently_booked": False,
                "total_services": 0,
                "charge": data['charge'] if 'charge' in data else 500,
                "profile_image": profile_image_id
            })
            return jsonify({"result": True}), 200, {'Content-Type': 'application/json'}
        else:
            return jsonify({'result': False, 'message': 'Invalid email format'}), 401, {'Content-Type': 'application/json'}
    else:
        return jsonify({'result': False, 'message': 'No data provided'}), 404, {'Content-Type': 'application/json'}

@app.route("/consumers/signin", methods=['POST'])
def consumer_signin():
    email = request.json.get('email')
    password = request.json.get('password')

    user = consumers.find_one({'email': email})
    if user:
        if user['password'] == password:
            return jsonify({'message': 'Sign-in successful'}), 200, {'Content-Type': 'application/json'}
        else:
            return jsonify({'error': 'Invalid password'}), 401, {'Content-Type': 'application/json'}
    else:
        return jsonify({'error': 'User not found'}), 404, {'Content-Type': 'application/json'}

@app.route("/providers/signin", methods=['POST'])
def provider_signin():
    email = request.json.get('email')
    password = request.json.get('password')

    user = providers.find_one({'email': email})
    if user:
        if user['password'] == password:
            return jsonify({'message': 'Sign-in successful'}), 200, {'Content-Type': 'application/json'}
        else:
            return jsonify({'error': 'Invalid password'}), 401, {'Content-Type': 'application/json'}
    else:
        return jsonify({'error': 'User not found'}), 404, {'Content-Type': 'application/json'}

@app.route("/consumers/get/<email>", methods=["GET"])
def get_user_data(email):
    user = consumers.find_one({"email": email})

    if user:
        profile_image_id = user.get('profile_image')
        profile_image_url = f"/consumers/profile_image/{profile_image_id}" if profile_image_id else None

        return jsonify({
            "name": user["name"],
            "email": user["email"],
            "password": user['password'],
            "number": user["number"],
            'services_ongoing': user["services_ongoing"],
            'total_bookings': user["total_bookings"],
            'profile_image': profile_image_url
        }), 200, {'Content-Type': 'application/json'}
    else:
        return jsonify({"error": "User not found"}), 404, {'Content-Type': 'application/json'}

@app.route("/providers/get/<email>", methods=["GET"])
def get_provider_data(email):
    provider = providers.find_one({"email": email})
    if provider:
        profile_image_id = provider.get('profile_image')
        profile_image_url = f"/providers/profile_image/{profile_image_id}" if profile_image_id else None

        return jsonify({
            "name": provider['name'],
            "email": provider['email'],
            "number": provider['number'],
            'service_type': provider['service_type'],
            "currently_booked": provider["currently_booked"],
            "total_services": provider["total_services"],
            "charge": provider["charge"],
            'profile_image': profile_image_url
        }), 200, {'Content-Type': 'application/json'}
    else:
        return jsonify({"error": "Provider not found"}), 404, {'Content-Type': 'application/json'}

@app.route("/consumers/profile_image/<image_id>", methods=["GET"])
def get_consumer_profile_image(image_id):
    image = fs.get(image_id)
    return send_file(io.BytesIO(image.read()), mimetype=image.content_type)

@app.route("/providers/profile_image/<image_id>", methods=["GET"])
def get_provider_profile_image(image_id):
    image = fs.get(image_id)
    return send_file(io.BytesIO(image.read()), mimetype=image.content_type)

@app.route("/providers/service/<service_type>", methods=["GET"])
def get_services(service_type):
    providers_list = providers.find({"service_type": service_type})
    result = []
    for provider in providers_list:
        profile_image_id = provider.get('profile_image')
        profile_image_url = f"/providers/profile_image/{profile_image_id}" if profile_image_id else None

        result.append({
            "name": provider['name'],
            "email": provider['email'],
            "number": provider['number'],
            'service_type': provider['service_type'],
            "currently_booked": provider["currently_booked"],
            "total_services": provider["total_services"],
            "charge": provider["charge"],
            'profile_image': profile_image_url
        })
    return jsonify(result), 200, {'Content-Type': 'application/json'}

if __name__ == "__main__":
    app.run(debug=True)
