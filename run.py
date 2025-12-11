from app.factory import create_app
from config import get_config

# Create Flask application
app = create_app()
config = get_config()

if __name__ == '__main__':
    app.run(host=config.HOST, port=config.PORT, debug=config.DEBUG)
