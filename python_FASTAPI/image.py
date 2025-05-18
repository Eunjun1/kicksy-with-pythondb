from fastapi import APIRouter, UploadFile, File, Form
from fastapi.responses import Response
import pymysql


router = APIRouter()


def connect():
    return pymysql.connect(
        host="127.0.0.1",
        user = "root",
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
