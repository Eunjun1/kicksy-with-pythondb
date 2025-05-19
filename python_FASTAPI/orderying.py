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





@router.get("/")
async def selectAll():

    conn = connect()
    curs = conn.cursor()

    curs.execute("select * from orderying")
    rows = curs.fetchall()
    conn.close()

    result = [{"ody_num":row[0],"emp_code":row[1],"doc_code":row[2],"prod_code":row[3],"ody_type":row[4],"ody_date":row[5],"ody_count":row[6],"reject_reason":row[7]} for row in rows]
    return {'results':result}


@router.get("/{ody_num}")
async def selectAll(ody_num : int):

    conn = connect()
    curs = conn.cursor()

    curs.execute("select * from orderying where ody_num = %s",(ody_num,))
    rows = curs.fetchall()
    conn.close()

    result = [{"ody_num":row[0],"emp_code":row[1],"doc_code":row[2],"prod_code":row[3],"ody_type":row[4],"ody_date":row[5],"ody_count":row[6],"reject_reason":row[7]} for row in rows]
    return {'results':result}


@router.post("/insert")
async def insert(emp_code:int=Form(...),doc_code:int=Form(...),prod_code:int=Form(...),ody_type:int=Form(...),ody_date:str=Form(...),ody_count:int=Form(...),reject_reason:str=Form(...)):
    try:
        conn = connect()
        curs = conn.cursor()
        sql = 'insert into orderying values (emp_code,doc_code,prod_code,ody_type,ody_date,ody_count,reject_reason)'
        sql = 'insert into orderying (emp_code,doc_code,prod_code,ody_type,ody_date,ody_count,reject_reason) values (%s,%s,%s,%s,%s,%s,%s)'
        curs.execute(sql,(emp_code,doc_code,prod_code,ody_type,ody_date,ody_count,reject_reason))
        conn.commit()
        conn.close()
        return {"result":"OK"}
    except Exception as e:
        print("Error : ",e)
        return {"result":"Error"}


# ======================================

