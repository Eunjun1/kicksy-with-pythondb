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
from model import router as model_router
from orderying import router as orderying_router
from request import router as request_router
from store import router as store_router
from user import router as user_router
from managements import router as management_router



app = FastAPI()

app.include_router(modle_router,prefix="/document",tags=["document"])
app.include_router(employee_router,prefix="/employee",tags=["employee"])
app.include_router(image_router,prefix="/image",tags=["image"])
app.include_router(management_router,prefix="/management",tags=["management"])
app.include_router(model_router,prefix="/model",tags=["model"])
app.include_router(orderying_router,prefix="/orderying",tags=["orderying"])
app.include_router(product_router,prefix="/product",tags=["product"])
app.include_router(request_router,prefix="/request",tags=["request"])
app.include_router(store_router,prefix="/store",tags=["store"])
app.include_router(user_router,prefix="/user",tags=["user"])


if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app,host="127.0.0.1",port=8000)