from fastapi import FastAPI
from pydantic import BaseModel
import requests
import numpy as np
from datetime import datetime


app = FastAPI()

GOOGLE_PLACES_KEY = "YOUR_GOOGLE_KEY"

# ------------------ MODELS ------------------

class TravelRequest(BaseModel):
    latitude: float
    longitude: float
    interest: str
    travel_type: str   # solo / family / short trip
    time_of_day: str   # morning / afternoon / evening

# ------------------ PLACE DISCOVERY ------------------

def get_nearby_places(lat, lon):
    url = "https://maps.googleapis.com/maps/api/place/nearbysearch/json"
    params = {
        "location": f"{lat},{lon}",
        "radius": 5000,
        "type": "tourist_attraction",
        "key": GOOGLE_PLACES_KEY
    }
    return requests.get(url, params=params).json()["results"]

# ------------------ CROWD PREDICTION ------------------

def crowd_score(place):
    rating = place.get("rating", 3)
    reviews = place.get("user_ratings_total", 100)
    return rating * np.log(reviews + 1)

# ------------------ RECOMMENDATION ENGINE ------------------

def rank_places(places, time_of_day):
    ranked = []
    for p in places:
        crowd = crowd_score(p)

        # Time based penalty
        if time_of_day == "evening":
            crowd *= 1.2

        ranked.append({
            "name": p["name"],
            "location": p["geometry"]["location"],
            "crowd_score": round(crowd, 2),
            "vicinity": p.get("vicinity", "")
        })

    ranked.sort(key=lambda x: x["crowd_score"])
    return ranked[:5]

# ------------------ LOCAL STORYTELLING ------------------

def local_story(place_name):
    return f"{place_name} is a hidden local gem known for its culture, calm atmosphere, and authentic experience."

# ------------------ API ------------------

@app.post("/recommend")

@app.post("/recommend")
def recommend(req: TravelRequest):
    return {
        "timestamp": datetime.now().isoformat(),
        "recommendations": [
            {
                "name": "Hidden Temple",
                "vicinity": "Local Area",
                "crowd_score": 1.1,
                "story": "A peaceful local gem away from tourist crowds.",
                "location": {"lat": 12.9718, "lng": 77.5939}
            },
            {
                "name": "Village Lake",
                "vicinity": "Rural Outskirts",
                "crowd_score": 0.9,
                "story": "A calm lakeside spot popular among locals.",
                "location": {"lat": 12.9690, "lng": 77.5900}
            },
            {
                "name": "Old Fort",
                "vicinity": "Heritage Zone",
                "crowd_score": 1.3,
                "story": "A historic fort best visited during early hours.",
                "location": {"lat": 12.9750, "lng": 77.5880}
            }
        ]
    }

