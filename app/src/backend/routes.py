from flask import Blueprint, request, jsonify
from bson import ObjectId
from backend.database import gazoz_collection
from backend.models import gazoz_serializer
import logging

main_bp = Blueprint("main", __name__)
logger = logging.getLogger(__name__)

@main_bp.route("/gazoz", methods=["POST"])
def create_gazoz():
    last_gazoz = gazoz_collection.find().sort("id", -1).limit(1)
    try:
        last_id = list(last_gazoz)[0]["id"]
        new_id = int(last_id) + 1
    except (IndexError, KeyError, ValueError):
        new_id = 0

    data = request.get_json()
    required_fields = {"name", "supermarket", "price_ils"}
    if not data or set(data.keys()) != required_fields: return jsonify({"msg": f"Request must contain exactly these fields: {required_fields}"}), 400
    if not isinstance(data["price_ils"], (int, float)): return jsonify({"msg": "Field 'price_ils' must be a number"}), 400

    data["id"] = new_id
    result = gazoz_collection.insert_one(data)
    logger.info(f"Created gazoz {new_id}")
    return jsonify({"msg": "Gazoz created", "id": str(result.inserted_id)}), 201

@main_bp.route("/gazoz/<int:id>", methods=["PUT"])
def update_gazoz(id):
    data = request.get_json()
    result = gazoz_collection.update_one({"id": id}, {"$set": data})
    if result.matched_count:
        logger.info(f"Updated gazoz {id}")
        return jsonify({"msg": "Gazoz updated"})
    else:
        return jsonify({"msg": "Gazoz not found"}), 404

@main_bp.route("/gazoz/<string:id>", methods=["DELETE"])
def delete_gazoz(id):
    try:
        oid = ObjectId(id)
    except InvalidId:
        return jsonify({"msg": "Invalid ID format"}), 400

    result = gazoz_collection.delete_one({"_id": oid})
    if result.deleted_count:
        logger.info(f"Deleted gazoz {id}")
        return jsonify({"msg": "Gazoz deleted"})
    else:
        return jsonify({"msg": "Gazoz not found"}), 404

@main_bp.route("/gazoz/<int:id>", methods=["GET"])
def get_gazoz(id):
    gazoz = gazoz_collection.find_one({"id": id})
    if gazoz: return jsonify(gazoz_serializer(gazoz))
    return jsonify({"msg": "Gazoz not found"}), 404

@main_bp.route("/gazoz", methods=["GET"])
def list_gazozim():
    gazozim = gazoz_collection.find({})
    return jsonify([gazoz_serializer(gazoz) for gazoz in gazozim])
