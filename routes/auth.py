from functools import wraps
from flask import Blueprint, render_template, request, redirect, session, flash, url_for
from werkzeug.security import generate_password_hash, check_password_hash
from database.db import get_db

auth_bp = Blueprint('auth', __name__)


def login_required(view):
    @wraps(view)
    def wrapped(*args, **kwargs):
        if 'student_id' not in session:
            flash('Please log in first.')
            return redirect(url_for('auth.login'))
        return view(*args, **kwargs)
    return wrapped


@auth_bp.route('/register', methods=['GET', 'POST'])
def register():
    if request.method == 'POST':
        name = request.form.get('full_name', '').strip()
        email = request.form.get('email', '').strip().lower()
        password = request.form.get('password', '')
        confirm = request.form.get('confirm_password', '')

        if not name or not email or not password:
            flash('Please fill in all fields.')
            return redirect(url_for('auth.register'))
        if password != confirm:
            flash('Passwords do not match.')
            return redirect(url_for('auth.register'))

        db = get_db()
        cur = db.cursor()
        cur.execute("SELECT id FROM students WHERE email = %s", (email,))
        if cur.fetchone():
            cur.close()
            db.close()
            flash('An account with this email already exists.')
            return redirect(url_for('auth.register'))

        cur.execute(
            "INSERT INTO students (full_name, email, password_hash) VALUES (%s, %s, %s)",
            (name, email, generate_password_hash(password))
        )
        db.commit()
        cur.close()
        db.close()
        flash('Account created. Please log in.')
        return redirect(url_for('auth.login'))

    return render_template('register.html')


@auth_bp.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        email = request.form.get('email', '').strip().lower()
        password = request.form.get('password', '')

        db = get_db()
        cur = db.cursor(dictionary=True)
        cur.execute("SELECT id, full_name, password_hash FROM students WHERE email = %s", (email,))
        student = cur.fetchone()
        cur.close()
        db.close()

        if student and check_password_hash(student['password_hash'], password):
            session['student_id'] = student['id']
            session['student_name'] = student['full_name']
            return redirect(url_for('index'))

        flash('Wrong email or password.')
        return redirect(url_for('auth.login'))

    return render_template('login.html')


@auth_bp.route('/logout')
def logout():
    session.clear()
    return redirect(url_for('index'))