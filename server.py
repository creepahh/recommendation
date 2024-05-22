from flask import Flask, jsonify, request
import pandas as pd
from sklearn.metrics.pairwise import cosine_similarity
import numpy as np

app = Flask(__name__)

# Recommendation System Functions
def load_data(ratings_path, movies_path):
    ratings = pd.read_csv(ratings_path)
    movies = pd.read_csv(ratings_path)
    return ratings, movies

def create_user_item_matrix(ratings, movies):
    data = pd.merge(ratings, movies, on='movieId')
    user_item_matrix = data.pivot_table(index='userId', columns='title', values='rating')
    return user_item_matrix

def compute_similarity(user_item_matrix):
    item_similarity = cosine_similarity(user_item_matrix.fillna(0).T)
    return item_similarity

def get_recommendations(user_id, user_item_matrix, item_similarity, num_recommendations=5):
    user_index = user_id - 1  # Adjusting for zero-based index
    user_ratings = user_item_matrix.iloc[user_index].values.reshape(1, -1)
    similarity_scores = item_similarity.dot(user_ratings.T).flatten()
    recommendations = np.argsort(-similarity_scores)[:num_recommendations]
    recommended_movies = user_item_matrix.columns[recommendations]
    return recommended_movies.tolist()

# Load data and create matrices once, when the server starts
ratings_path = 'ml-latest-small/ratings.csv'
movies_path = 'ml-latest-small/movies.csv'
ratings, movies = load_data(ratings_path, movies_path)
user_item_matrix = create_user_item_matrix(ratings, movies)
item_similarity = compute_similarity(user_item_matrix)

@app.route('/recommendations/<int:user_id>', methods=['GET'])
def recommendations(user_id):
    recommendations = get_recommendations(user_id, user_item_matrix, item_similarity)
    return jsonify({'recommendations': recommendations})

if __name__ == '__main__':
    app.run(debug=True)
