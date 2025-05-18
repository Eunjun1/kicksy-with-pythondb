from fastapi import APIRouter, Form
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


@router.get("/")
async def selectAll():

    conn = connect()
    curs = conn.cursor()

    curs.execute("select * from model")
    rows = curs.fetchall()
    conn.close()

    result = [{"mod_code":row[0],"image_num":row[1],"name":row[2],"category":row[3],"company":row[4],"color":row[5],"saleprice":row[6]} for row in rows]
    return {'results':result}

@router.get("/{mod_code}")
async def selectModel(mod_code: int):

    conn = connect()
    curs = conn.cursor()

    curs.execute("select * from model where mod_code = %s",(mod_code,))
    rows = curs.fetchall()
    conn.close()

    result = [{"mod_code":row[0],"image_num":row[1],"name":row[2],"category":row[3],"company":row[4],"color":row[5],"saleprice":row[6]} for row in rows]
    return {'results':result}