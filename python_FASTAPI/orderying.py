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



@router.get("/{ody_num}")
async def selectAll(ody_num : int):

    conn = connect()
    curs = conn.cursor()

    curs.execute("select * from orderying where ody_num = %s",(ody_num,))
    rows = curs.fetchall()
    conn.close()

    result = [{"ody_num":row[0],"emp_code":row[1],"doc_code":row[2],"prod_code":row[3],"ody_type":row[4],"ody_date":row[5],"ody_count":row[6],"reject_reason":row[7]} for row in rows]
    return {'results':result}
