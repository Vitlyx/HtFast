from fastapi import FastAPI, HTTPException, Request, Response
from fastapi.responses import HTMLResponse
from pydantic import BaseModel
from fastapi.templating import Jinja2Templates

app = FastAPI()

templates = Jinja2Templates(directory="endpoints")

@app.get("/", response_class=HTMLResponse)
async def about(request: Request):
    return templates.TemplateResponse("main.html", {"request": request})