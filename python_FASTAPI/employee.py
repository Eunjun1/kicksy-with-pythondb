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



@router.get("/{emp_code}")
async def selectAll(emp_code : int):
    conn = connect()
    curs = conn.cursor()

    curs.execute("select * from employee where emp_code = %s",(emp_code,))
    rows = curs.fetchall()
    conn.close()

    result = [{"emp_code":row[0],"password":row[1],"division":row[2],"grade":row[3]} for row in rows]
    return {'results':result}

@router.get("/")
async def selectAll():

    conn = connect()
    curs = conn.cursor()

    curs.execute("select * from employee")
    rows = curs.fetchall()
    conn.close()

    result = [{"emp_code":row[0],"password":row[1],"division":row[2],"grade":row[3]} for row in rows]
    return {'results':result}
