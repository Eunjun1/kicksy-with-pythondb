from fastapi import APIRouter, Form
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



@router.get("/{str_code}")
async def selectAll(str_code : int):

    conn = connect()
    curs = conn.cursor()

    curs.execute("select * from store where str_code = %s",(str_code,))
    rows = curs.fetchall()
    conn.close()

    result = [{"str_code":row[0],"name":row[1],"tel":row[2],"address":row[3]}for row in rows]
    return {'results':result}
