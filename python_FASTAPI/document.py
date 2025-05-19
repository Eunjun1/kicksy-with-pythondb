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
async def insert(proposer:str=Form(...),title:str=Form(...),contents:str=Form(...),date:str=Form(...),):
    conn = connect()
    curs = conn.cursor()

    # SQL
    try:
        sql = 'insert into document (proposer, title, contents, date) values (%s,%s,%s,%s)'
        curs.execute(sql,(proposer,title,contents,date))
        conn.commit()
        conn.close()
        return{'result' : 'OK'}
    except Exception as ex:
        conn.close()
        print("Error :", ex)
        return{'result' : 'Error'}
