from flask import Flask, request, jsonify, send_file
from flask_pymongo import PyMongo, ASCENDING
from gridfs import GridFS
import re
import io

app = Flask(__name__)
app.config["MONGO_URI"] = "mongodb://localhost:27017/bookeasy"
db = PyMongo(app).db
fs = GridFS(db)

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
            "address": {"bsonType": "string"},
            "profile_image": {"bsonType": ["objectId", "null"]}
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
            "currently_booked": {"bsonType": "bool"},
            "total_services": {"bsonType": "int"},
            "charge": {"bsonType": "int"},
            "address": {"bsonType": "string"},
            "profile_image": {"bsonType": ["objectId", "null"]}
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

review_schema = {
    '$jsonSchema': {
        "bsonType": "object",
        "required": ["provider_email", "reviewer_email", "review_text", "rating"],
        "properties": {
            "provider_email": {"bsonType": "string", 'pattern': '^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$'},
            "provider_name": {"bsonType": "string"},
            "reviewer_email": {"bsonType": "string", 'pattern': '^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$'},
            "reviewer_name": {"bsonType": "string"},
            "review_text": {"bsonType": "string"},
            "rating": {"bsonType": "int", "minimum": 1, "maximum": 5}
        }
    }
}


booking_schema = {
    '$jsonSchema': {
        "bsonType": "object",
        "required": ["consumer_name", "consumer_email", "consumer_number", "consumer_address", 
                     "provider_name", "provider_email", "provider_number", "booking_id", 
                     "booking_status", "provider_charge"],
        "properties": {
            "consumer_name": {"bsonType": "string"},
            "consumer_email": {"bsonType": "string", 'pattern': '^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$'},
            "consumer_number": {"bsonType": "string"},
            "consumer_address": {"bsonType": "string"},
            "provider_name": {"bsonType": "string"},
            "provider_email": {"bsonType": "string", 'pattern': '^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$'},
            "provider_number": {"bsonType": "string"},
            "booking_id": {"bsonType": "string"},
            "booking_status": {"bsonType": "string", "enum": ["pending", "confirmed", "cancelled","completed"]},
            "provider_charge": {"bsonType": "int"}
        }
    }
}


if "reviews" not in db.list_collection_names():
    reviews = db.create_collection("reviews", validator=review_schema)
else:
    reviews = db["reviews"]

if "consumers" not in db.list_collection_names():
    consumers = db.create_collection("consumers", validator=schema1)
    consumers.create_index([('email', ASCENDING)], unique=True)
else:
    consumers = db["consumers"]
    consumers.create_index([('email', ASCENDING)], unique=True)

if "providers" not in db.list_collection_names():
    providers = db.create_collection("providers", validator=schema2)
    providers.create_index([('email', ASCENDING)], unique=True)
else:
    providers = db["providers"]
    providers.create_index([('email', ASCENDING)], unique=True)
if "bank_accounts" not in db.list_collection_names():
    bank_accounts = db.create_collection("bank_accounts", validator=bank_account_schema)
else:
    bank_accounts = db["bank_accounts"]

if "bookings" not in db.list_collection_names():
    bookings = db.create_collection("bookings", validator=booking_schema)
else:
    bookings = db["bookings"]

# def encryption(password)->str:
#     encrytpted_password= bcrypt.hashpw(password,bcrypt.gensalt())
#     return encrytpted_password

# def check_password(attempt,original)->bool:
#     if bcrypt.checkpw(attempt,original):
#         return True
#     else:
#         return False
    
def validate_email(email):
    pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'
    if re.match(pattern, email):
        return True
    else:
        return False
    


# Routings
# 1. Route for creating a user
@app.route("/consumers/signup", methods=['POST'])
def signup_user():
    data = request.form
    if data:
        if validate_email(data['email']):
            profile_image_id = None  # Initialize profile_image_id to None
            
            # Check if 'profile_image' key exists in form data
            if 'profile_image' in request.files:
                profile_image = request.files['profile_image']
                profile_image_id = fs.put(profile_image, filename=profile_image.filename)

            # Construct the document to insert into the database
            document = {
                'name': data['name'],
                'email': data['email'],
                'password': data['password'],
                'number': data['number'],
                'services_ongoing': 0,
                'total_bookings': 0,
                'address': "Street - 150",
            }

            # Add 'profile_image' field to the document if profile_image_id is not None
            if profile_image_id:
                document['profile_image'] = profile_image_id

            # Insert the document into the consumers collection
            consumers.insert_one(document)

            # Insert bank account information if provided
            if 'bankAccount' in data:
                bank_accounts.insert_one({
                    'email': data['email'],
                    'name': data['name'],
                    'bankName': data['bankAccount']['bankName'],
                    'accountNumber': data['bankAccount']['accountNumber'],
                    'ifscCode': data['bankAccount']['ifscCode'],
                    'accountType': data['bankAccount']['accountType']
                })

            return jsonify({"result": True}), 200
        else:
            return jsonify({'result': False, 'message': 'Invalid email format'}), 401
    else:
        return jsonify({'result': False, 'message': 'No data provided'}), 404

# 2. Creating a provider account
@app.route("/providers/signup",methods=['POST'])
def signup_provider():
    data = request.form
    if data:
        if validate_email(data['email']):
            profile_image_id = None  # Initialize profile_image_id to None
            
            # Check if 'profile_image' key exists in form data
            if 'profile_image' in request.files:
                profile_image = request.files['profile_image']
                profile_image_id = fs.put(profile_image, filename=profile_image.filename)

            document={"name": data['name'],
                "email": data['email'],
                "password": data['password'],
                "number": data['number'],
                'service_type': data['service_type'],
                "currently_booked": False,
                "total_services": 0,
                "charge": data.get('charge', 500),
                "address":data.get('address',"Street - 15"),
            }    
            if profile_image_id:
                document['profile_image'] = profile_image_id

            providers.insert_one(document)

            if 'bankAccount' in data:
                bank_accounts.insert_one({
                    'email': data['email'],
                    'name': data['name'],
                    'bankName': data['bankAccount']['bankName'],
                    'accountNumber': data['bankAccount']['accountNumber'],
                    'ifscCode': data['bankAccount']['ifscCode'],
                    'accountType': data['bankAccount']['accountType']
                })
            return jsonify({"result": True}), 200,{'Content-Type': 'application/json'}
        else:
            return jsonify({'result': False, 'message': 'Invalid email format'}), 401,{'Content-Type': 'application/json'}
    else:
        return jsonify({'result': False, 'message': 'No data provided'}), 404,{'Content-Type': 'application/json'}

# 3.Route to sign in the consumer
@app.route("/consumers/signin",methods=['POST'])
def consumer_signin():
    email=request.json.get('email')
    password=request.json.get('password')

    user=consumers.find_one({'email':email})
    if user:
        original_password=user['password']
        if original_password == password:
            return jsonify({'message':'Sign-in successful'}),200,{'Content-Type': 'application/json'}
        else:
            return jsonify({'error':'Invalid password'}), 401,{'Content-Type': 'application/json'}
    else:
        return jsonify({'error':'User not found'}),404,{'Content-Type': 'application/json'}


# 4. Route for sign in of provider  
@app.route("/providers/signin",methods=['POST'])
def provider_signin():
    email=request.json.get('email')
    password=request.json.get('password')

    user=providers.find_one({'email':email})
    if user:
        original_password=user['password']
        if original_password == password:
            return jsonify({'message':'Sign-in successful'}),200,{'Content-Type': 'application/json'}
        else:
            return jsonify({'error':'Invalid password'}), 401,{'Content-Type': 'application/json'}
    else:
        return jsonify({'error':'User not found'}),404,{'Content-Type': 'application/json'}

#5. To get user data based on the email
@app.route("/consumers/get/<email>",methods=["GET"])
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
        }), 200,{'Content-Type': 'application/json'}
    else:
        return jsonify({"error": "User not found"}), 404,{'Content-Type': 'application/json'}

# 6. T0 get providers data based on email
@app.route("/providers/get/<email>",methods=["GET"])
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
        }), 200,{'Content-Type': 'application/json'}
    else:
        return jsonify({"error": "Provider not found"}), 404,{'Content-Type': 'application/json'}

# 7. To get various types of services based on the service type.
@app.route("/providers/service/<service_type>",methods=["GET"])
def get_services(service_type):
    providers_list = providers.find({"service_type": service_type})
    result = []
    for provider in providers_list:
        # profile_image_id = provider.get('profile_image')
        # profile_image_url = f"/providers/profile_image/{profile_image_id}" if profile_image_id else None

        result.append({
            "name": provider['name'],
            "email": provider['email'],
            "number": provider['number'],
            "password": provider['password'],
            'service_type': provider['service_type'],
            "currently_booked": provider["currently_booked"],
            "total_services": provider["total_services"],
            "charge": provider["charge"],
            # 'profile_image': profile_image_url
        })
    return jsonify(result), 200,{'Content-Type': 'application/json'}

# 8. To get top popular services
@app.route("/providers/popular",methods=["GET"])
def get_top_services():
    top_providers = providers.find().sort("total_services", -1).limit(10)
    result = []
    for provider in top_providers:
        # profile_image_id = provider.get('profile_image')
        # profile_image_url = f"/providers/profile_image/{profile_image_id}" if profile_image_id else None

        result.append({
            "name": provider['name'],
            "email": provider['email'],
            "number": provider['number'],
            "password":provider['password'],
            'service_type': provider['service_type'],
            "currently_booked": provider["currently_booked"],
            "total_services": provider["total_services"],
            "charge": provider["charge"],
            # 'profile_image': profile_image_url
        })
    return jsonify(result),200 ,{'Content-Type': 'application/json'}

# 9. To update the data of a user
@app.route("/consumers/update",methods=['POST'])
def update_user():
    # "http://127.0.0.1:5000/update_user?email=user@example.com&name=NewName&number=1234567890"
    email=request.args.get('email')
    new_name=request.args.get('name')
    new_number=request.args.get('number')

    if not email:
        return jsonify({"error": "Email parameter is required"}), 400,{'Content-Type': 'application/json'}
    
    update_fields={}
    if new_name:
        update_fields['name']=new_name
    if new_number:
        update_fields['number']=new_number
    
    if not update_fields:
        return jsonify({"error": "At least one of name or number parameters is required"}), 400,{'Content-Type': 'application/json'}
    
    result = consumers.update_one(
        {'email': email},
        {'$set': update_fields}
    )
    if result.matched_count==0:
        return jsonify({'error':"User with the specified email not found"}),404,{'Content-Type': 'application/json'}
    
    return jsonify({"success":"User updated successfully"}),200,{'Content-Type': 'application/json'}

# 10. To update the provider information
@app.route("/providers/update",methods=["POST"])
def update_provider():
    # "http://127.0.0.1:5000/update_provider?email=provider@example.com&name=NewName&number=1234567890&service_type=new_service&charge=1000"
    email = request.args.get('email')
    new_name = request.args.get('name')
    new_number = request.args.get('number')
    new_service_type = request.args.get('service_type')
    new_charge = request.args.get('charge')

    if not email:
        return jsonify({"error": "Email parameter is required"}), 400,{'Content-Type': 'application/json'}

    update_fields = {}
    if new_name:
        update_fields['name'] = new_name
    if new_number:
        update_fields['number'] = new_number
    if new_service_type:
        update_fields['service_type'] = new_service_type
    if new_charge:
        try:
            update_fields['charge'] = int(new_charge)
        except ValueError:
            return jsonify({"error": "Charge must be an integer"}), 400,{'Content-Type': 'application/json'}

    if not update_fields:
        return jsonify({"error": "At least one of name, number, service_type, or charge parameters is required"}), 400, {'Content-Type': 'application/json'}

    result = providers.update_one(
        {'email': email},
        {'$set': update_fields}
    )

    if result.matched_count == 0:
        return jsonify({"error": "Provider with the specified email not found"}), 404, {'Content-Type': 'application/json'}

    return jsonify({"success": "Provider updated successfully"}), 200, {'Content-Type': 'application/json'}

# 11. To add reviews for the provider
@app.route("/reviews/add", methods=['POST'])
def add_review():
    data = request.json
    if data:
        if validate_email(data['provider_email']) and validate_email(data['reviewer_email']):
            review = {
                "provider_email": data['provider_email'],
                "provider_name": data['provider_name'],
                "reviewer_email": data['reviewer_email'],
                "reviewer_name": data['reviewer_name'],
                "review_text": data['review_text'],
                "rating": data['rating']
            }
            reviews.insert_one(review)

            # Update the reviews count in the providers collection
            providers.update_one(
                {'email': data['provider_email']},
                {'$inc': {'reviews_count': 1}}
            )

            return jsonify({"result": True}), 200, {'Content-Type': 'application/json'}
        else:
            return jsonify({'result': False, 'message': 'Invalid email format'}), 401, {'Content-Type': 'application/json'}
    else:
        return jsonify({'result': False, 'message': 'No data provided'}), 404, {'Content-Type': 'application/json'}

# 12. Get reviews for the provider
@app.route("/reviews/provider/<email>", methods=["GET"])
def get_reviews_for_provider(email):
    if validate_email(email):
        provider_reviews = list(reviews.find({"provider_email": email}))
        return jsonify(provider_reviews), 200, {'Content-Type': 'application/json'}
    else:
        return jsonify({"error": "Invalid email format"}), 400, {'Content-Type': 'application/json'}



@app.route("/")
def hello_world():
    return "<p>Hello, World!</p>"

if __name__== "__main__" :
    app.run(debug=True)