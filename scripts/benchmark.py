"""
Benchmark script for measuring fake user generation speed.

Usage:
    python scripts/benchmark.py [--count 1000] [--locale en_US]
"""

import time
import argparse
import sys
import os

# Add parent directory to path
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from dotenv import load_dotenv
load_dotenv()

from app.database import Database


def run_benchmark(db: Database, locale: str, seed: int, count: int) -> dict:
    """Run benchmark and return results."""
    
    print(f"\nBenchmark Configuration:")
    print(f"  Locale: {locale}")
    print(f"  Seed: {seed}")
    print(f"  Count: {count:,}")
    print("-" * 40)
    
    # Warm-up run
    print("Warming up...")
    db.call_procedure('faker.generate_users', (locale, seed, 0, 10))
    
    # Benchmark: Generate users in batches
    print(f"Generating {count:,} users...")
    
    start_time = time.perf_counter()
    
    # Use batch generation for better performance
    users = db.call_procedure('faker.generate_users_batch', (locale, seed, count))
    
    elapsed = time.perf_counter() - start_time
    
    users_per_second = count / elapsed if elapsed > 0 else 0
    
    results = {
        'count': len(users) if users else 0,
        'elapsed_seconds': round(elapsed, 4),
        'users_per_second': round(users_per_second, 2),
        'ms_per_user': round((elapsed * 1000) / count, 4) if count > 0 else 0
    }
    
    return results


def main():
    parser = argparse.ArgumentParser(description='Benchmark fake user generation')
    parser.add_argument('--count', type=int, default=1000, help='Number of users to generate')
    parser.add_argument('--locale', type=str, default='en_US', help='Locale code')
    parser.add_argument('--seed', type=int, default=12345, help='Random seed')
    parser.add_argument('--runs', type=int, default=3, help='Number of benchmark runs')
    
    args = parser.parse_args()
    
    # Connect to database
    database_url = os.getenv('DATABASE_URL', 'postgresql://postgres:postgres@localhost:5432/faker_db')
    db = Database(database_url)
    
    print("=" * 50)
    print("Fake User Generator - Benchmark")
    print("=" * 50)
    
    try:
        db.connect()
        print("Connected to database")
        
        all_results = []
        
        for run in range(args.runs):
            print(f"\n--- Run {run + 1}/{args.runs} ---")
            results = run_benchmark(db, args.locale, args.seed, args.count)
            all_results.append(results)
            
            print(f"\nResults:")
            print(f"  Users generated: {results['count']:,}")
            print(f"  Time elapsed: {results['elapsed_seconds']:.4f} seconds")
            print(f"  Speed: {results['users_per_second']:,.2f} users/second")
            print(f"  Per user: {results['ms_per_user']:.4f} ms")
        
        # Calculate averages
        if args.runs > 1:
            avg_speed = sum(r['users_per_second'] for r in all_results) / len(all_results)
            avg_time = sum(r['elapsed_seconds'] for r in all_results) / len(all_results)
            
            print("\n" + "=" * 50)
            print("AVERAGE RESULTS")
            print("=" * 50)
            print(f"  Average speed: {avg_speed:,.2f} users/second")
            print(f"  Average time: {avg_time:.4f} seconds for {args.count:,} users")
        
        print("\n" + "=" * 50)
        print("Benchmark complete!")
        print("=" * 50)
        
    except Exception as e:
        print(f"Error: {e}")
        sys.exit(1)
    finally:
        db.close()


if __name__ == '__main__':
    main()
