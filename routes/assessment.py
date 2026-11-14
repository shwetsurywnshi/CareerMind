from flask import Blueprint, render_template, request, redirect, session, flash
from database.db import get_db
from routes.auth import login_required

assessment_bp = Blueprint('assessment', __name__, url_prefix='/assessment')


def load_questions(cur, quiz_type):
    cur.execute(
        "SELECT id, question_text, skill_id FROM questions "
        "WHERE quiz_type = %s ORDER BY q_order",
        (quiz_type,)
    )
    questions = cur.fetchall()

    cur.execute(
        "SELECT o.id, o.question_id, o.option_text, o.category, o.rating "
        "FROM options o JOIN questions q ON o.question_id = q.id "
        "WHERE q.quiz_type = %s",
        (quiz_type,)
    )
    options_by_q = {}
    for o in cur.fetchall():
        options_by_q.setdefault(o['question_id'], []).append(o)

    return questions, options_by_q


def run_quiz(quiz_type, title, subtitle, this_url, next_url):
    student_id = session['student_id']
    db = get_db()
    try:
        cur = db.cursor(dictionary=True)
        questions, options_by_q = load_questions(cur, quiz_type)

        if request.method == 'POST':
            chosen = []
            for number, q in enumerate(questions, start=1):
                value = request.form.get(f"q{q['id']}")
                valid = {str(o['id']): o for o in options_by_q.get(q['id'], [])}
                if value not in valid:
                    flash(f"Question {number} is not answered yet.")
                    return redirect(this_url)
                chosen.append((q, valid[value]))

            for q, o in chosen:
                cur.execute(
                    "INSERT INTO answers (student_id, question_id, option_id) "
                    "VALUES (%s, %s, %s) "
                    "ON DUPLICATE KEY UPDATE option_id = VALUES(option_id)",
                    (student_id, q['id'], o['id'])
                )
                if quiz_type == 'skill':
                    cur.execute(
                        "INSERT INTO student_skills (student_id, skill_id, rating) "
                        "VALUES (%s, %s, %s) "
                        "ON DUPLICATE KEY UPDATE rating = VALUES(rating)",
                        (student_id, q['skill_id'], o['rating'])
                    )

            db.commit()
            flash(f"{title} saved.")
            return redirect(next_url)

        return render_template('assessment_quiz.html',
                               title=title,
                               subtitle=subtitle,
                               action=this_url,
                               questions=questions,
                               options_by_q=options_by_q)

    except Exception:
        db.rollback()
        raise

    finally:
        db.close()


@assessment_bp.route('/interest', methods=['GET', 'POST'])
@login_required
def interest():
    return run_quiz(
        'interest',
        'Interest Quiz',
        'Choose the option that describes you best.',
        '/assessment/interest',
        '/assessment/skill'
    )


@assessment_bp.route('/skill', methods=['GET', 'POST'])
@login_required
def skill():
    return run_quiz(
        'skill',
        'Skill Quiz',
        'Be honest. This shows where you need to improve, and it is guidance, not a final decision.',
        '/assessment/skill',
        '/results'
    )