import pandas as pd
from sklearn.metrics.pairwise import cosine_similarity
import numpy as np

def load_data(ratings_path, movies_path):
    ratings = pd.read_csv(ratings_path)
    movies = pd.read_csv(movies_path)
    return ratings, movies

def create_user_item_matrix(ratings, movies):
    data = pd.merge(ratings, movies, on='movieId')
    user_item_matrix = data.pivot_table(index='userId', columns='title', values='rating')
    return user_item_matrix

def compute_similarity(user_item_matrix):
    item_similarity = cosine_similarity(user_item_matrix.fillna(0).T)
    return item_similarity

def get_recommendations(user_id, user_item_matrix, item_similarity, num_recommendations=5):
    user_index = user_id - 1
    user_ratings = user_item_matrix.iloc[user_index].values.reshape(1, -1)
    similarity_scores = item_similarity.dot(user_ratings.T).flatten()
    recommendations = np.argsort(-similarity_scores)[:num_recommendations]
    recommended_movies = user_item_matrix.columns[recommendations]
    return recommended_movies

def main():
    ratings_path = '/home/kripa/Documents/projects/reco/ml-latest-small/ratings.csv'
    movies_path = '/home/kripa/Documents/projects/reco/ml-latest-small/movies.csv'
    ratings, movies = load_data(ratings_path, movies_path)

    user_item_matrix = create_user_item_matrix(ratings, movies)
    item_similarity = compute_similarity(user_item_matrix)

    user_id = 1
    recommendations = get_recommendations(user_id, user_item_matrix, item_similarity)
    print(f"Recommended movies for user {user_id}: {recommendations}")

if __name__ == "__main__":
    main()
