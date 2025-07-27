from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel, Field
import joblib
import numpy as np

scaler = joblib.load("scaler.pkl")
model  = joblib.load("best_model.pkl")

app = FastAPI(
    title="CHUK Malaria Forecast API",
    description="Predict monthly malaria cases at CHUK from year & death counts",
    version="1.0"
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

enable_request = BaseModel  # noqa: F841
class PredictRequest(BaseModel):
    year: int = Field(
        ..., ge=2000, le=2030,
        description="Calendar year (2000–2030)"
    )
    deaths_median: float = Field(
        ..., ge=0, le=1e6,
        description="Median monthly death count"
    )

class PredictResponse(BaseModel):
    predicted_cases: float = Field(
        ..., description="Predicted median monthly malaria cases"
    )

@app.post("/predict", response_model=PredictResponse)
def predict(request: PredictRequest):
    # Create feature array
    X = np.array([[request.year, request.deaths_median]])
    # Scale input
    Xs = scaler.transform(X)
    # Model inference
    y_pred = model.predict(Xs)[0]
    # Validate output
    if np.isnan(y_pred) or y_pred < 0:
        raise HTTPException(
            status_code=500,
            detail="Model returned invalid prediction"
        )
    # Return result
    return PredictResponse(predicted_cases=round(float(y_pred), 2))
