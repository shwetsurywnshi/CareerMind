from flask import Flask, render_template
from config import SECRET_KEY
from routes.auth import auth_bp
from routes.assessment import assessment_bp
from routes.results import results_bp

app = Flask(__name__)
app.secret_key = SECRET_KEY

app.register_blueprint(auth_bp)
app.register_blueprint(assessment_bp)
app.register_blueprint(results_bp)


@app.route('/')
def index():
    return render_template('index.html')


if __name__ == '__main__':
    app.run(debug=True)