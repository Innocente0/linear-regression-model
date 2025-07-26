from fastapi import FastAPI, HTTPException
from pydantic import BaseModel, Field
from fastapi.middleware.cors import CORSMiddleware
import joblib
import numpy as np

scaler = joblib.load("scaler.pkl")
model  = joblib.load("best_model.pkl")

app = FastAPI(
    title="CHUK Malaria Forecast API",
    description="Predict monthly malaria cases at CHUK from year & death counts",
    version="1.0",
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["POST", "GET"],
    allow_headers=["*"],
)

class PredictRequest(BaseModel):
    year: int = Field(..., ge=2000, le=2030, description="Calendar year (e.g. 2021)")
    deaths_median: float = Field(
        ...,
        ge=0,
        le=1e6,
        description="Median monthly death count (must be ≥ 0)"
    )

class PredictResponse(BaseModel):
    predicted_cases: float = Field(..., description="Predicted median monthly malaria cases")

@app.post("/predict", response_model=PredictResponse)
def predict(request: PredictRequest):
    
    X = np.array([[request.year, request.deaths_median]])
    Xs = scaler.transform(X)

    y_pred = model.predict(Xs)[0]

    if np.isnan(y_pred) or y_pred < 0:
        raise HTTPException(status_code=500, detail="Model returned invalid prediction")

    return PredictResponse(predicted_cases=round(float(y_pred), 2))
