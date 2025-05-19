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



@router.get("/{req_num}")
async def selectAll(req_num : int):

    conn = connect()
    curs = conn.cursor()

    curs.execute("select * from request where req_num = %s",(req_num,))
    rows = curs.fetchall()
    conn.close()

    result = [{"req_num":row[0],"user_email":row[1],"product_prod_code":row[2],"store_str_code":row[3],"req_type":row[4],"req_date":row[5],"req_count":row[6],"reason":row[7]} for row in rows]
    return {'results':result}
