from flask import Flask, render_template
from config import SECRET_KEY
from routes.auth import auth_bp
from routes.assessment import assessment_bp
from routes.results import results_bp
from flask import render_template, request, redirect, url_for, session
from datetime import date

app = Flask(__name__)
app.secret_key = SECRET_KEY

app.register_blueprint(auth_bp)
app.register_blueprint(assessment_bp)
app.register_blueprint(results_bp)


@app.route('/')
def index():
    return render_template('index.html')


@app.route('/careers')
def careers():

    careers = Career.query.order_by(Career.name).all()

    return render_template(
        'careers.html',
        careers=careers
    )


if __name__ == '__main__':
    app.run(debug=True)


@app.route('/roadmap', methods=['GET', 'POST'])
def roadmap():

    # Sample skills for Data Analyst career
    skills = [
        {
            "id": 1,
            "name": "Python",
            "current_level": "Beginner",
            "required_level": "Advanced"
        },
        {
            "id": 2,
            "name": "SQL",
            "current_level": "Basic",
            "required_level": "Advanced"
        },
        {
            "id": 3,
            "name": "Excel",
            "current_level": "Intermediate",
            "required_level": "Advanced"
        },
        {
            "id": 4,
            "name": "Communication",
            "current_level": "Basic",
            "required_level": "Intermediate"
        },
        {
            "id": 5,
            "name": "Data Visualization",
            "current_level": "Beginner",
            "required_level": "Advanced"
        }
    ]

    # Save target dates
    if request.method == 'POST':

        skill_id = int(request.form.get('skill_id'))
        target_date = request.form.get('target_date')

        session[f'target_{skill_id}'] = target_date

        return redirect(url_for('roadmap'))

    # Add saved target dates to skills
    for skill in skills:
        skill['target_date'] = session.get(
            f"target_{skill['id']}", ""
        )

    # Calculate skill progress
    levels = {
        "Beginner": 1,
        "Basic": 2,
        "Intermediate": 3,
        "Advanced": 4
    }

    total_skills = len(skills)

    skills_completed = sum(
        1 for skill in skills
        if levels.get(skill['current_level'], 0) >=
           levels.get(skill['required_level'], 0)
    )

    skills_to_improve = total_skills - skills_completed

    return render_template(
        'roadmap.html',
        career_name="Data Analyst",
        skills=skills,
        total_skills=total_skills,
        skills_to_improve=skills_to_improve,
        skills_completed=skills_completed,
        today=date.today().isoformat()
    )


from datetime import date

@app.route('/dashboard')
def dashboard():

    # Sample dashboard data
    user_name = "Sampada"

    top_career = "Data Analyst"
    career_match = 88

    skills_to_build = 3
    roadmap_progress = 40

    unread_notifications = 3

    # Sample learning goals
    goals = [
        {
            "name": "Learn Python Basics",
            "target_date": "15 Nov 2026",
            "status": "In Progress"
        },
        {
            "name": "Complete DSA Practice",
            "target_date": "20 Nov 2026",
            "status": "Not Started"
        },
        {
            "name": "Build a Mini Project",
            "target_date": "25 Nov 2026",
            "status": "Not Started"
        },
        {
            "name": "Improve Communication Skills",
            "target_date": "30 Nov 2026",
            "status": "Completed"
        }
    ]

    return render_template(
        'dashboard.html',
        user_name=user_name,
        top_career=top_career,
        career_match=career_match,
        skills_to_build=skills_to_build,
        roadmap_progress=roadmap_progress,
        unread_notifications=unread_notifications,
        goals=goals,
        current_date=date.today().strftime("%d %B %Y")
    )
