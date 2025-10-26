import pytest
import requests

@pytest.fixture
def api_url(request):
    return request.config.getoption("--url")

def test_e2e_gazoz_lifecycle(api_url):
    payload = {
        "name": "Fanta",
        "supermarket": "Soda-licious",
        "price_ils": 9.99
    }

    # 1. Create new gazoz
    r = requests.post(f"{api_url}/gazoz", json=payload)
    assert r.status_code == 201
    new_id = r.json()["id"]

    # 2. Retrieve list and verify new gazoz is present
    r = requests.get(f"{api_url}/gazoz")
    assert r.status_code == 200
    gazozim = r.json()
    assert any(gazoz["id"] == new_id for gazoz in gazozim)

    # Delete the new gazoz
    r = requests.delete(f"{api_url}/gazoz/{new_id}")
    assert r.status_code == 200
