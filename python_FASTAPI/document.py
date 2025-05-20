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

    curs.execute("select * from document")
    rows = curs.fetchall()
    conn.close()

    result = [{"doc_code":row[0],"proposer":row[1],"title":row[2],"contents":row[3],"date":row[4]} for row in rows]
    return {'results':result}

@router.get("/doc_code")
async def selectAll():

    conn = connect()
    curs = conn.cursor()

    curs.execute("select max(doc_code) from document")
    rows = curs.fetchall()
    conn.close()

    result = [{"maxcode":row[0]} for row in rows]
    return {'results':result}

@router.get("/{doc_code}")
async def selectAll(doc_code : int):

    conn = connect()
    curs = conn.cursor()

    curs.execute("select * from document where doc_code = %s",(doc_code,))
    rows = curs.fetchall()
    conn.close()

    result = [{"doc_code":row[0],"proposer":row[1],"title":row[2],"contents":row[3],"date":row[4]} for row in rows]
    return {'results':result}

@router.post("/insert")
async def insert(proposer : str = Form(...), title : str = Form(...), contents : str = Form(...)):
    try:
        conn = connect()
        curs = conn.cursor()
        sql = 'insert into document (proposer, title, contents, date) values (%s,%s,%s,now())'
        curs.execute(sql,(proposer, title, contents))
        conn.commit()
        conn.close()
        return {"result":"OK"}
    except Exception as e:
        print("Error : ",e)
        return {"result":"Error"}