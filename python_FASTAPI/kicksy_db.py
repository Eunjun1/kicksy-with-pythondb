"""
author : 김은준,위성배,김재원,김태민
description : 신발가게앱 kicksy with python_FastApi
date : 2025-05-18
version : 1
"""




from fastapi import FastAPI
from model import router as modle_router
from image import router as image_router
from product import router as product_router
from employee import router as employee_router



app = FastAPI()

app.include_router(modle_router,prefix="/model",tags=["model"])
app.include_router(image_router,prefix="/image",tags=["image"])
app.include_router(employee_router,prefix="/employee",tags=["employee"])


if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app,host="127.0.0.1",port=8000)