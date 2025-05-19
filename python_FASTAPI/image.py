from fastapi import APIRouter, UploadFile, File, Form
from fastapi.responses import Response
import pymysql


router = APIRouter()


def connect():
    return pymysql.connect(
        host="192.168.50.4",
        user = "team",
        password="qwer1234",
        db="kicksy",
        charset="utf8",
    )



@router.get("/{model_name}")
async def selectAll(model_name: str):
    try: 
        conn = connect()
        curs = conn.cursor()
        curs.execute("select image from image where model_name = %s and img_num = 1",(model_name,))
        rows = curs.fetchone()
        conn.close()
        if rows:
                return Response(
                    content= rows[0],
                    media_type="image/jpeg",
                    headers={"Cache-control" : "no-cache,no-store,must-revalidate"}
                )
        else:
            return{"result":"No image found"}
    except Exception as e:
        print("Error:",e)
        return{"result":"Error"}
    

@router.post("/insert")
async def insert(model_name:str=Form(...),img_num:int=Form(...),file:UploadFile=File(...)):
    try:
        img_data = await file.read()
        conn = connect()
        curs = conn.cursor()
        sql = 'insert into image(model_name,img_num,image) values (%s,%s,%s)'
        curs.execute(sql,(model_name,img_num,img_data))
        conn.commit()
        conn.close()
        return {"result":"OK"}
    except Exception as e:
        print("Error : ",e)
        return {"result":"Error"}
    
