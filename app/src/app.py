from flask import Flask, render_template
from prometheus_flask_exporter import PrometheusMetrics
from backend.routes import main_bp
from backend.database import gazoz_collection
import logging
import os

BASE_DIR = os.path.dirname(os.path.abspath(__file__))

app = Flask(
    __name__,
    template_folder=os.path.join(BASE_DIR, "frontend"),
    static_folder=os.path.join(BASE_DIR, "frontend")
)

metrics = PrometheusMetrics(app)
app.register_blueprint(main_bp)
logging.basicConfig(level=logging.INFO)

@app.route("/")
def serve_index():
    return render_template("index.html")

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=False)
