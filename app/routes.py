from flask import Blueprint, render_template, request, jsonify, Response
from app.database import get_db
import os

main = Blueprint('main', __name__)


@main.route('/favicon.ico')
def favicon():
    """Return empty favicon to prevent 404 errors"""
    return Response(status=204)


@main.route('/', methods=['GET', 'POST'])
def index():
    """Main page - generate fake users"""
    users = []
    locale = request.form.get('locale', 'en_US')
    seed = request.form.get('seed', '12345')
    batch_index = int(request.form.get('batch_index', 0))
    batch_size = int(request.form.get('batch_size', 10))
    
    try:
        seed = int(seed)
    except ValueError:
        seed = 12345
    
    if request.method == 'POST':
        action = request.form.get('action', 'generate')
        
        if action == 'generate':
            batch_index = 0
        elif action == 'goto':
            goto_batch = int(request.form.get('goto_batch', 1))
            batch_index = max(0, goto_batch - 1)
        elif action == 'next':
            batch_index += 1
        elif action == 'prev' and batch_index > 0:
            batch_index -= 1
        
        db = get_db()
        users = db.call_procedure(
            'faker.fast_generate_users',
            (locale, seed, batch_index, batch_size)
        )
    
    db = get_db()
    locales = db.execute("SELECT DISTINCT code, name FROM faker.locales ORDER BY name")
    
    return render_template(
        'index.html',
        users=users,
        locales=locales,
        current_locale=locale,
        seed=seed,
        batch_index=batch_index,
        batch_size=batch_size
    )


@main.route('/api/generate', methods=['POST'])
def api_generate():
    """API: Generate fake users batch"""
    data = request.get_json()
    
    locale = data.get('locale', 'en_US')
    seed = int(data.get('seed', 12345))
    batch_index = int(data.get('batch_index', 0))
    batch_size = int(data.get('batch_size', 10))
    
    db = get_db()
    users = db.call_procedure(
        'faker.fast_generate_users',
        (locale, seed, batch_index, batch_size)
    )
    
    return jsonify(users)


@main.route('/api/benchmark', methods=['POST'])
def api_benchmark():
    """API: Run performance benchmark"""
    import time
    
    data = request.get_json()
    locale = data.get('locale', 'en_US')
    seed = int(data.get('seed', 12345))
    count = int(data.get('count', 1000))
    
    db = get_db()
    
    start_time = time.time()
    users = db.call_procedure(
        'faker.fast_generate_users_batch',
        (locale, seed, count)
    )
    elapsed = time.time() - start_time
    
    return jsonify({
        'count': len(users) if users else 0,
        'elapsed_seconds': round(elapsed, 4),
        'users_per_second': round(count / elapsed, 2) if elapsed > 0 else 0
    })


@main.route('/api/markov', methods=['POST'])
def api_markov():
    """API: Generate Markov chain text"""
    data = request.get_json()
    locale = data.get('locale', 'en_US')
    seed = int(data.get('seed', 12345))
    min_words = int(data.get('min_words', 10))
    max_words = int(data.get('max_words', 25))
    
    db = get_db()
    
    samples = []
    for i in range(3):
        result = db.execute(
            "SELECT faker.blazing_fast_markov_text(%s, %s, %s, %s) as text",
            (locale, seed + i, min_words, max_words)
        )
        if result:
            samples.append({
                'seed': seed + i,
                'text': result[0]['text']
            })
    
    return jsonify({
        'locale': locale,
        'samples': samples
    })


@main.route('/docs')
def docs():
    """Documentation page"""
    # Get the project root directory (parent of 'app' folder)
    project_root = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    docs_path = os.path.join(project_root, 'docs', 'STORED_PROCEDURES.md')
    
    try:
        with open(docs_path, 'r', encoding='utf-8') as f:
            markdown_content = f.read()
    except FileNotFoundError:
        markdown_content = f"# Documentation\n\nDocumentation file not found.\n\nLooking for: {docs_path}"
    
    return render_template('docs.html', markdown_content=markdown_content)


@main.route('/api')
def api_docs():
    """API Reference page"""
    return render_template('api.html')
