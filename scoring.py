from database.db import get_db

CATEGORIES = ['R', 'I', 'A', 'S', 'E', 'C']


def get_student_totals(student_id):
    """Each interest answer adds 2 points to its category."""
    db = get_db()
    try:
        cur = db.cursor(dictionary=True)
        cur.execute(
            "SELECT o.category, COUNT(*) AS n "
            "FROM answers a "
            "JOIN questions q ON a.question_id = q.id "
            "JOIN options o ON a.option_id = o.id "
            "WHERE a.student_id = %s AND q.quiz_type = 'interest' "
            "GROUP BY o.category",
            (student_id,)
        )
        totals = {c: 0 for c in CATEGORIES}
        for row in cur.fetchall():
            totals[row['category']] = row['n'] * 2
        cur.close()
        return totals
    finally:
        db.close()


def calculate_results(student_id):
    """Career score = sum of (category total x career weight)."""
    totals = get_student_totals(student_id)
    if sum(totals.values()) == 0:
        return []

    db = get_db()
    try:
        cur = db.cursor(dictionary=True)

        cur.execute("SELECT id, name, interest_area, description, fit_reason FROM careers")
        careers = cur.fetchall()

        cur.execute("SELECT career_id, category, weight FROM career_weights")
        weights = {}
        for w in cur.fetchall():
            weights.setdefault(w['career_id'], {})[w['category']] = w['weight']

        cur.close()

        results = []
        for c in careers:
            cw = weights.get(c['id'], {})
            score = sum(totals[cat] * cw.get(cat, 0) for cat in CATEGORIES)
            results.append({
                'name': c['name'],
                'interest_area': c['interest_area'],
                'description': c['description'],
                'fit_reason': c['fit_reason'],
                'score': score,
            })

        results.sort(key=lambda r: r['score'], reverse=True)
        return results
    finally:
        db.close()


def top_matches(results, limit=3):
    """Top matches. Careers with the same score as the last one are included, and share a rank."""
    if not results:
        return []

    selected = results[:limit]
    cutoff = selected[-1]['score']
    for r in results[limit:]:
        if r['score'] == cutoff:
            selected.append(r)
        else:
            break

    rank = 0
    last_score = None
    for position, r in enumerate(selected, start=1):
        if r['score'] != last_score:
            rank = position
            last_score = r['score']
        r['rank'] = rank

    return selected