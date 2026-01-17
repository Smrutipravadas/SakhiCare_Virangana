from sqlalchemy import Column, Integer, String, Float, Date, DateTime, ForeignKey
from datetime import datetime
from database import Base

class User(Base):
    __tablename__ = "users"

    id = Column(Integer, primary_key=True, index=True)
    name = Column(String)
    email = Column(String, unique=True, index=True)
    password = Column(String)
    created_at = Column(DateTime, default=datetime.utcnow)


class HealthLog(Base):
    __tablename__ = "health_logs"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id"))
    mood = Column(Integer)
    physical_work_hours = Column(Float)
    sleep_hours = Column(Float)
    created_at = Column(DateTime, default=datetime.utcnow)
    height_cm = Column(Float)
    weight_kg = Column(Float)
    blood_group = Column(String)


class PeriodCycle(Base):
    __tablename__ = "period_cycles"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id"))
    last_period_start = Column(Date)
    cycle_length = Column(Integer, default=28)
    period_length = Column(Integer, default=5)


class CareCircle(Base):
    __tablename__ = "care_circle"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id"))
    name = Column(String)
    relation = Column(String)
    phone = Column(String)
