from fastapi import APIRouter, Form
import pymysql


router = APIRouter()

def connect():
    return pymysql.connect(
        host="127.0.0.1",
        user = "root",
        password="qwer1234",
        db="kicksy",
        charset="utf8",
    )


@router.get("/")
async def selectAll():

    conn = connect()
    curs = conn.cursor()

    curs.execute("select * from model")
    rows = curs.fetchall()
    conn.close()

    result = [{"mod_code":row[0],"image_num":row[1],"name":row[2],"category":row[3],"company":row[4],"color":row[5],"saleprice":row[6]} for row in rows]
    return {'results':result}

@router.get("/{mod_code}")
async def selectModel(mod_code: int):

    conn = connect()
    curs = conn.cursor()

    curs.execute("select * from model where mod_code = %s",(mod_code,))
    rows = curs.fetchall()
    conn.close()

    result = [{"mod_code":row[0],"image_num":row[1],"name":row[2],"category":row[3],"company":row[4],"color":row[5],"saleprice":row[6]} for row in rows]
    return {'results':result}


@router.post("/inset")
async def insert(name:str=Form(...),category:str=Form(...),company:str=Form(...),color:str=Form(...),saleprice:int=Form(...)):
    try:
        conn = connect()
        curs = conn.cursor()
        sql = 'insert into model (image_num,name,category,company,color,saleprice) values (%s,%s,%s,%s,%s,%s)'
        curs.execute(sql,(0,name,category,company,color,saleprice))
        conn.commit()
        conn.close()
        return {"result":"OK"}
    except Exception as e:
            print("Error : ",e)
            return {"result":"Error"}