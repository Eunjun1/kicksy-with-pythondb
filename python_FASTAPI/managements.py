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



@router.get("/{mag_num}")
async def selectAll(mag_num : int):

    conn = connect()
    curs = conn.cursor()

    curs.execute("select * from management where mag_num = %s",(mag_num,))
    rows = curs.fetchall()
    conn.close()

    result = [{"mag_num":row[0],"prod_code":row[1],"emp_code":row[2],"store_str_code":row[3],"mag_type":row[4],"mag_date":row[5],"mag_count":row[6]} for row in rows]
    return {'results':result}
