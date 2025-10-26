import unittest
from unittest.mock import patch, MagicMock
from app import app

class GazozTestCase(unittest.TestCase):
    def setUp(self):
        self.app = app.test_client()

    @patch("backend.routes.gazoz_collection")
    def test_list_gazozim(self, mock_collection):
        mock_collection.find.return_value = [{
            "_id": "abc123",
            "id": 0,
            "name": "Test Gazoz",
            "supermarket": "Test Supermarket",
            "price_ils": 4.99
        }]

        response = self.app.get("/gazoz")
        self.assertEqual(response.status_code, 200)
        self.assertIn("Test Gazoz", response.get_data(as_text=True))

    @patch("backend.routes.gazoz_collection")
    def test_create_gazoz(self, mock_collection):
        mock_cursor = MagicMock()
        mock_cursor.sort.return_value.limit.return_value = [{"id": 0}]
        mock_collection.find.return_value = mock_cursor

        response = self.app.post("/gazoz", json={
            "name": "New Gazoz",
            "supermarket": "New Supermarket",
            "price_ils": 1.99
        })
        self.assertEqual(response.status_code, 201)

if __name__ == "__main__":
    unittest.main()
