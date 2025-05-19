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



@router.get("/{email}")
async def selectAll(email : str):

    conn = connect()
    curs = conn.cursor()

    curs.execute("select * from user where email = %s",(email,))
    rows = curs.fetchall()
    conn.close()

    result = [{"email":row[0],"password":row[1],"phone":row[2],"address":row[3],"signupdata":row[4],"sex" : row[5]} for row in rows]
    return {'results':result}
