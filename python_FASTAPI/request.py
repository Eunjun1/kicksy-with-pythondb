from fastapi import APIRouter, Form
from pydantic import BaseModel
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

class request(BaseModel) :
    user_email : str
    product_prod_code : int
    store_str_code : int
    req_type : int
    req_count : int
    reason : str

@router.get("/{user_email}")
async def selectAll(user_email : str):

    conn = connect()
    curs = conn.cursor()

    curs.execute("select * from request where user_email = %s",(user_email,))
    rows = curs.fetchall()
    conn.close()

    result = [{"req_num":row[0],"user_email":row[1],"product_prod_code":row[2],"store_str_code":row[3],"req_type":row[4],"req_date":row[5],"req_count":row[6],"reason":row[7]} for row in rows]
    return {'results':result}

@router.post("/insert")
async def insert(request : request):
    conn = connect()
    curs = conn.cursor()

    try : 
        sql='insert into request(user_email,product_prod_code,store_str_code,req_type,req_date,req_count,reason) values (%s,%s,%s,%s,now(),%s,%s)'
        curs.execute(sql,(request.user_email,request.product_prod_code,request.store_str_code,request.req_type,request.req_count,request.reason))
        conn.commit()
        conn.close()
        return {'result' : 'OK'}
    except Exception as ex :
        conn.close()
        print("Error : ", ex)
        return {'result' : 'Error'}