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



@router.get("/mod_code={model_code}")
async def selectAll(model_code : int):

    conn = connect()
    curs = conn.cursor()

    curs.execute("select * from product where model_code = %s",(model_code,))
    rows = curs.fetchall()
    conn.close()

    result = [{"prod_code":row[0],"model_code":row[1],"size":row[2],"maxstock":row[3],"registration":row[4]} for row in rows]
    return {'results':result}


@router.post('/insert')
async def insert( model_code: int= Form(...), size: int=Form(...),maxstock: int= Form(...), registration:str=Form(...)):
    try:
        conn = connect()
        curs = conn.cursor()
        sql = 'insert into product(model_code, size, maxstock, registration) values (%s, %s, %s, %s)'
        curs.execute(sql, (model_code, size, maxstock, registration))
        conn.commit()
        conn.close()
        return {"result":"OK"}
    except Exception as ex:
        print("Error", ex)
        return {"restult" : "Error"}




