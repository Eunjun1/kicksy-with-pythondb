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



@router.get("/{email}")
async def selectAll(email : str):

    conn = connect()
    curs = conn.cursor()

    curs.execute("select * from user where email = %s",(email,))
    rows = curs.fetchall()
    conn.close()

    result = [{"email":row[0],"password":row[1],"phone":row[2],"address":row[3],"signupdata":row[4],"sex" : row[5]} for row in rows]
    return {'results':result}


@router.post("/insert") 
async def insertUser(email : str = Form(...), password : str = Form(...), phone : str = Form(...), address : str = Form(...), sex : str = Form(...)):
    conn = connect()
    curs = conn.cursor()

    try : 
        sql = "insert into user(email, password, phone, address, sex, signupdata) values (%s,%s,%s,%s,%s,now())"
        curs.execute(sql, (email,password,phone,address,sex))
        conn.commit()
        conn.close()
        return {'result' : 'OK'}
    except Exception as e:
        conn.close()
        print("Error : ", e)
        return {'result' : 'Error'}

@router.post("/update") 
async def updateUser(password : str = Form(...), phone : str = Form(...), sex : str= Form(...), email : str=Form(...)):
    conn = connect()
    curs = conn.cursor()
    
    try : 
        sql = "update user set password = %s, phone = %s, sex = %s where email = %s"
        curs.execute(sql, (password,phone,sex,email))
        conn.commit()
        conn.close()
        return {'result' : 'OK'}
    
    except Exception as e:
        conn.close()
        print("Error : ", e)
        return {'result' : 'Error'}