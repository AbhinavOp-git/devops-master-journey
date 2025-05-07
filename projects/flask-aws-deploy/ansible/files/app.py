from flask import Flask
app = Flask(__name__)

@app.route('/')
def home():
    return "🚀 Flask is live on AWS EC2 with Ansible & Docker!"

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0')
