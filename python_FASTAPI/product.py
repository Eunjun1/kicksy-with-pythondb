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


@router.get("/{model_code}")
async def selectAll(model_code : int):

    conn = connect()
    curs = conn.cursor()

    curs.execute("select * from product where model_code = %s",(model_code,))
    rows = curs.fetchall()
    conn.close()

    result = [{"prod_code":row[0],"model_code":row[1],"size":row[2],"maxstock":row[3],"registration":row[4]} for row in rows]
    return {'results':result}
