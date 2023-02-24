from typing import Union
from datetime import datetime
from fastapi import FastAPI
from socket import gethostname
app = FastAPI()


@app.get("/")
def read_root():
    return {datetime.now(): gethostname()}
