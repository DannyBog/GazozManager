def gazoz_serializer(gazoz):
    return {
        "id": str(gazoz["_id"]),
        "name": gazoz["name"],
        "supermarket": gazoz["supermarket"],
        "price_ils": gazoz["price_ils"],
    }
