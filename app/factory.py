from flask import Flask, render_template
from config import get_config
from app.database import init_db


def create_app(config_object=None):
    """Application factory"""
    app = Flask(__name__, 
                template_folder='../templates',
                static_folder='../static')
    
    # Load configuration
    if config_object is None:
        config_object = get_config()
    
    app.config.from_object(config_object)
    
    # Initialize database
    init_db(config_object.DATABASE_URL)
    
    # Register blueprints
    from app.routes import main
    app.register_blueprint(main)
    
    # Error handlers
    @app.errorhandler(404)
    def not_found(e):
        return render_template('404.html'), 404
    
    @app.errorhandler(500)
    def server_error(e):
        return render_template('500.html'), 500
    
    return app
