import psycopg2
from psycopg2.extras import RealDictCursor
from contextlib import contextmanager


class Database:
    """Database connection manager"""
    
    def __init__(self, database_url: str):
        self.database_url = database_url
        self._connection = None
    
    def connect(self):
        """Establish database connection"""
        if self._connection is None or self._connection.closed:
            self._connection = psycopg2.connect(self.database_url)
        return self._connection
    
    def close(self):
        """Close database connection"""
        if self._connection and not self._connection.closed:
            self._connection.close()
            self._connection = None
    
    @contextmanager
    def get_cursor(self, commit: bool = False):
        """Context manager for database cursor"""
        conn = self.connect()
        cursor = conn.cursor(cursor_factory=RealDictCursor)
        try:
            yield cursor
            if commit:
                conn.commit()
        except Exception as e:
            conn.rollback()
            raise e
        finally:
            cursor.close()
    
    def execute(self, query: str, params: tuple = None, fetch: bool = True):
        """Execute query and optionally fetch results"""
        with self.get_cursor() as cursor:
            cursor.execute(query, params)
            if fetch:
                return cursor.fetchall()
            return None
    
    def call_procedure(self, name: str, params: tuple = None):
        """Call stored procedure and fetch results"""
        placeholders = ', '.join(['%s'] * len(params)) if params else ''
        query = f"SELECT * FROM {name}({placeholders})"
        return self.execute(query, params)


# Global database instance (initialized by app factory)
db: Database = None


def init_db(database_url: str) -> Database:
    """Initialize global database instance"""
    global db
    db = Database(database_url)
    return db


def get_db() -> Database:
    """Get global database instance"""
    if db is None:
        raise RuntimeError("Database not initialized. Call init_db() first.")
    return db
