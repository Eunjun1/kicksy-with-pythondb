from datetime import datetime
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

@router.post('/insert')
async def insert(prod_code : int, emp_code : int, store_str_code : int, mag_type : int, mag_date : datetime, mag_count : int):
    try:
        conn = connect()
        curs = conn.cursor()

        sql = "insert into management (prod_code, emp_code, store_str_code, mag_type, mag_date, mag_count) values (%s,%s,%s,%s,%s,%s)"
        curs.execute(sql,(prod_code, emp_code, store_str_code, mag_type, datetime.now(), mag_count))
        conn.commit()
        conn.close()

        return{'result' : 'OK'}

    except Exception as e:
        print('Error : ', e)
        return{'result' : 'Error'}
    
@router.post('/update')
async def update(mag_num : int = Form(...), mag_type : int = Form(...)):
    try:
        conn = connect()
        curs = conn.cursor()

        sql = 'update management set mag_type = %s where mag_num = %s'
        curs.execute(sql, (mag_type, mag_num))
        conn.commit()
        conn.close()
        return{'result' : 'OK'}

    except Exception as e:
        print('Error : ', e)
        return{'result' : 'Error'}