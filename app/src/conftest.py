def pytest_addoption(parser):
    parser.addoption(
        "--url",
        action="store",
        default="http://localhost",
        help="Base URL for the API"
    )
