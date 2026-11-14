from flask import Blueprint, render_template, redirect, session, flash
from routes.auth import login_required
from scoring import calculate_results, top_matches

results_bp = Blueprint('results', __name__)


@results_bp.route('/results')
@login_required
def show():
    results = calculate_results(session['student_id'])
    if not results:
        flash('Please complete the interest quiz first.')
        return redirect('/assessment/interest')

    matches = top_matches(results)
    return render_template('results.html', matches=matches)