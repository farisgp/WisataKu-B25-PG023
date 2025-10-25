from flask import Flask, request, jsonify
import pickle
import pandas as pd

app = Flask(__name__)

# Load cosine similarity matrix
with open('assets/cosine_similarity_matrix.pkl', 'rb') as f:
    cosine_sim = pickle.load(f)

# Load dataset
df = pd.read_csv('assets/tourism_data.csv')

@app.route('/recommend', methods=['GET', 'POST'])
def recommend():
    # --- ambil input ---
    if request.method == 'GET':
        input_name = request.args.get('name')  # dari query URL
    else:
        data = request.get_json(force=True)
        input_name = data.get('name')

    # --- validasi input ---
    if not input_name:
        return jsonify({'error': 'Parameter "name" diperlukan!'}), 400
    if input_name not in df['name'].values:
        return jsonify({'error': f'Tempat "{input_name}" tidak ditemukan.'}), 404

    # --- proses rekomendasi ---
    idx = df.index[df['name'] == input_name][0]
    sim_scores = list(enumerate(cosine_sim[idx]))
    sim_scores = sorted(sim_scores, key=lambda x: x[1], reverse=True)
    top_indices = [i[0] for i in sim_scores[1:6]]  # ambil 5 teratas

    # Ambil kolom yang kamu mau tampilkan
    recommended_places = df.iloc[top_indices][
        ['name', 'rating', 'price', 'category', 'description', 'city', 'coordinate', 'lat', 'long']
    ].to_dict(orient='records')

    return jsonify({'recommendations': recommended_places})

if __name__ == '__main__':
    app.run(host='localhost', port=5000, debug=True)
