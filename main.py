from fastapi import FastAPI, Depends, HTTPException
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from sqlalchemy.orm import Session
from passlib.context import CryptContext
from jose import jwt, JWTError
from pydantic import BaseModel
from datetime import datetime, timedelta, date
from typing import List, Optional
import httpx

import models
from database import engine, SessionLocal

# ---------------- APP ----------------
app = FastAPI(title="SakhiCare Backend")
models.Base.metadata.create_all(bind=engine)

# ---------------- DATABASE ----------------
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

# ---------------- AUTH ----------------
security = HTTPBearer()
pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

SECRET_KEY = "SECRET123"
ALGORITHM = "HS256"

def hash_password(p): return pwd_context.hash(p)
def verify_password(p, h): return pwd_context.verify(p, h)

def create_access_token(data: dict):
    data["exp"] = datetime.utcnow() + timedelta(hours=1)
    return jwt.encode(data, SECRET_KEY, algorithm=ALGORITHM)

def get_current_user(
    cred: HTTPAuthorizationCredentials = Depends(security),
    db: Session = Depends(get_db)
):
    try:
        payload = jwt.decode(cred.credentials, SECRET_KEY, algorithms=[ALGORITHM])
        user = db.query(models.User).get(payload["user_id"])
        if not user:
            raise HTTPException(401)
        return user
    except JWTError:
        raise HTTPException(401)

# ---------------- OPENROUTER CHATBOT ----------------
OPENROUTER_API_KEY = "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"

async def call_openrouter(prompt: str):
    async with httpx.AsyncClient(timeout=60) as client:
        r = await client.post(
            "https://openrouter.ai/api/v1/chat/completions",
            headers={
                "Authorization": f"Bearer {OPENROUTER_API_KEY}",
                "Content-Type": "application/json"
            },
            json={
                "model": "mistralai/mistral-7b-instruct",
                "messages": [
                    {"role": "system", "content": "You are Sakhi, a caring women’s health companion."},
                    {"role": "user", "content": prompt}
                ],
                "temperature": 0.7,
                "max_tokens": 180
            }
        )
        return r.json()["choices"][0]["message"]["content"]

# ---------------- SCHEMAS ----------------
class Signup(BaseModel):
    name: str
    email: str
    password: str

class Login(BaseModel):
    email: str
    password: str

class HealthLogReq(BaseModel):
    mood: int
    physical_work_hours: float
    sleep_hours: float
    height_cm: float
    weight_kg: float
    blood_group: str

class PeriodReq(BaseModel):
    last_period_start: date
    cycle_length: int = 28
    period_length: int = 5

class CareCircleReq(BaseModel):
    name: str
    relation: str
    phone: str

class AskReq(BaseModel):
    message: str

# ---------------- AUTH ROUTES ----------------
@app.post("/signup")
def signup(data: Signup, db: Session = Depends(get_db)):
    if db.query(models.User).filter_by(email=data.email).first():
        raise HTTPException(400, "Email exists")
    user = models.User(
        name=data.name,
        email=data.email,
        password=hash_password(data.password)
    )
    db.add(user); db.commit()
    return {"message": "Registered"}

@app.post("/login")
def login(data: Login, db: Session = Depends(get_db)):
    user = db.query(models.User).filter_by(email=data.email).first()
    if not user or not verify_password(data.password, user.password):
        raise HTTPException(401)
    return {"token": create_access_token({"user_id": user.id})}

# ---------------- HEALTH LOG ----------------
@app.post("/health-log")
def health_log(data: HealthLogReq, user=Depends(get_current_user), db=Depends(get_db)):
    log = models.HealthLog(user_id=user.id, **data.dict())
    db.add(log); db.commit()
    return {"message": "Health logged"}

# ---------------- PERIOD ----------------
@app.post("/period")
def save_period(data: PeriodReq, user=Depends(get_current_user), db=Depends(get_db)):
    p = db.query(models.PeriodCycle).filter_by(user_id=user.id).first()
    if p:
        p.last_period_start = data.last_period_start
        p.cycle_length = data.cycle_length
        p.period_length = data.period_length
    else:
        p = models.PeriodCycle(user_id=user.id, **data.dict())
        db.add(p)
    db.commit()
    return {"message": "Period saved"}

@app.get("/period")
def get_period(user=Depends(get_current_user), db=Depends(get_db)):
    p = db.query(models.PeriodCycle).filter_by(user_id=user.id).first()
    if not p:
        return {"message": "No period data"}

    next_period = p.last_period_start + timedelta(days=p.cycle_length)
    days_since = (date.today() - p.last_period_start).days

    if days_since < p.period_length:
        phase = "Menstrual"
    elif days_since < 14:
        phase = "Follicular"
    elif days_since < p.cycle_length - 5:
        phase = "Ovulation"
    else:
        phase = "Luteal"

    days_remaining = (next_period - date.today()).days

    return {
     "last_period_start": p.last_period_start.isoformat(),
     "expected_next_period": next_period.isoformat(),
     "current_phase": phase,
     "days_remaining": max(days_remaining, 0)
}

# ---------------- CARE CIRCLE ----------------
@app.post("/care-circle")
def add_care(data: CareCircleReq, user=Depends(get_current_user), db=Depends(get_db)):
    c = models.CareCircle(user_id=user.id, **data.dict())
    db.add(c); db.commit()
    return {"message": "Care contact added"}

# ---------------- INSIGHTS + BURNOUT ----------------
# @app.get("/insights")
# def insights(user=Depends(get_current_user), db=Depends(get_db)):
#     logs = db.query(models.HealthLog).filter_by(user_id=user.id).all()
#     if not logs:
#         return {"message": "No data"}

#     avg_sleep = sum(l.sleep_hours for l in logs) / len(logs)
#     avg_work = sum(l.physical_work_hours for l in logs) / len(logs)
#     avg_mood = sum(l.mood for l in logs) / len(logs)

#     burnout = "Low"
#     alert = False
#     reason = "Healthy balance detected"
#     suggestion = "Maintain your routine"
#     diet = ["Balanced meals", "Fruits", "Hydration"]

#     if avg_work >= 8 and avg_sleep < 6:
#         burnout = "High"
#         alert = True
#         reason = "Long work hours with poor sleep"
#         suggestion = "Please rest, reduce workload, and talk to Sakhi"
#         diet = ["Warm meals", "Iron-rich food", "Protein", "Water"]
#     elif avg_work >= 7 or avg_sleep < 6:
#         burnout = "Medium"
#         reason = "Work-rest imbalance"
#         suggestion = "Take breaks and improve sleep"
#         diet = ["Light meals", "Fruits", "Nuts"]

#     return {
#         "avg_sleep": round(avg_sleep, 2),
#         "avg_work": round(avg_work, 2),
#         "avg_mood": round(avg_mood, 2),
#         "burnout": burnout,
#         "burnout_reason": reason,
#         "burnout_suggestion": suggestion,
#         "diet_suggestion": diet,
#         "alert_care_circle": alert
#     }


@app.get("/insights")
def insights(
    user=Depends(get_current_user),
    db: Session = Depends(get_db)
):
    logs = db.query(models.HealthLog)\
        .filter(models.HealthLog.user_id == user.id)\
        .all()

    if not logs:
        return {
            "avg_sleep": 0,
            "avg_physical_work_hours": 0,
            "avg_mood": 0,
            "burnout_level": "No data",
            "burnout_suggestion": "Please add health logs",
            "alert_care_circle": False
        }

    avg_sleep = sum(l.sleep_hours for l in logs) / len(logs)
    avg_work = sum(l.physical_work_hours for l in logs) / len(logs)
    avg_mood = sum(l.mood for l in logs) / len(logs)

    if avg_work >= 8 and avg_sleep < 6:
        burnout = "High"
        suggestion = "You may be experiencing burnout. Please rest and talk to SakhiCare."
        alert = True
    elif avg_work >= 7:
        burnout = "Medium"
        suggestion = "Try balancing work and rest today."
        alert = False
    else:
        burnout = "Low"
        suggestion = "You are doing well. Keep maintaining your routine."
        alert = False

    return {
        "avg_sleep": round(avg_sleep, 1),
        "avg_physical_work_hours": round(avg_work, 1),
        "avg_mood": round(avg_mood, 1),
        "burnout_level": burnout,
        "burnout_suggestion": suggestion,
        "alert_care_circle": alert
    }






# ---------------- ASK SAKHI ----------------
@app.post("/ask-sakhi")
async def ask(data: AskReq, user=Depends(get_current_user), db=Depends(get_db)):

    # ---------- FETCH PERIOD DATA ----------
    period = db.query(models.PeriodCycle)\
        .filter(models.PeriodCycle.user_id == user.id)\
        .first()

    period_phase = "unknown"

    if period:
        days_since = (date.today() - period.last_period_start).days

        if days_since < period.period_length:
            period_phase = "menstrual"
        elif days_since < 14:
            period_phase = "follicular"
        elif days_since < period.cycle_length - 5:
            period_phase = "ovulation"
        else:
            period_phase = "luteal"

    # ---------- BUILD SMART PROMPT ----------
    prompt = f"""
You are Sakhi, a caring and empathetic women’s health companion.

Context:
- Current menstrual phase: {period_phase}

Rules:
- You MAY talk about periods, cramps, mood swings, tiredness
- You MUST NOT diagnose diseases
- You MUST NOT prescribe medicines
- Suggest rest, hydration, self-care, and professional help if pain is severe

User message:
"{data.message}"

Reply gently and supportively.
"""

    reply = await call_openrouter(prompt)

    return {"reply": reply}

