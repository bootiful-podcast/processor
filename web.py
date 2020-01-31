import json
import os

from flask import Flask

app = Flask(__name__)


@app.route("/health")
def health() -> str:
    return json.dumps({"health": "OK"})


def calculate_port() -> int:
    if "PORT" in os.environ:
        port = int(os.environ["PORT"])
    else:
        port = 5050
    return port


def start():
    app.run(host="0.0.0.0", port=calculate_port())


if __name__ == "__main__":
    start()
