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



@router.get("/req={req_num}")
async def selectAll(req_num : int):
    conn = connect()
    curs = conn.cursor()
    curs.execute("select m.name,m.saleprice from request r,  model m , product p  where r.product_prod_code = p.prod_code and p.model_code = m.mod_code and r.req_num = %s",(req_num,))
    rows = curs.fetchall()
    conn.close()
    result = [{"name" : row[0], "price" : row[1]} for row in rows]
    return {'results':result}

@router.get("/email={email}")
async def selectAll(email : str):
    conn = connect()
    curs = conn.cursor()
    curs.execute("select * from request r,  model m , product p  where r.product_prod_code = p.prod_code and p.model_code = m.mod_code and user_email = %s",(email,))
    rows = curs.fetchall()
    conn.close()

    result = [{"req_num":row[0],"user_email":row[1],"product_prod_code":row[2],"store_str_code":row[3],"req_type":row[4],"req_date":row[5],"req_count":row[6],"reason":row[7],"name":row[10],"price":row[14]} for row in rows]
    return {'results':result}

@router.post("/insert")
async def insert(prod_code :str = Form(...), product_prod_code : int = Form(...), store_str_code : int = Form(...), req_type : int = Form(...), req_count : int = Form(...), reason : str = Form(...)):
    conn = connect()
    curs = conn.cursor()

    try : 
        sql='insert into request(prod_code,product_prod_code,store_str_code,req_type,req_date,req_count,reason) values (%s,%s,%s,%s,now(),%s,%s)'
        curs.execute(sql,(prod_code,product_prod_code,store_str_code,req_type,req_count,reason))
        conn.commit()
        conn.close()
        return {'result' : 'OK'}
    except Exception as ex :
        conn.close()
        print("Error : ", ex)
        return {'result' : 'Error'}
    
@router.post('/update')
async def update(req_num : int = Form(...),req_type : int = Form(...),reason : str = Form(...)) :
    try : 
        conn = connect()
        curs = conn.cursor()
        sql = 'update request set req_type=%s, req_date=now(), reason=%s where req_num=%s'
        curs.execute(sql, (req_type, reason,req_num))
        conn.commit()
        conn.close()
        return {"result" : 'OK'}
    

    except Exception as e :
        print('Error :', e)
        return {"reslut" : "Error"}
    


@router.get("/prod_code={prod_code}")
async def selectAll(prod_code : int):

    conn = connect()
    curs = conn.cursor()

    curs.execute("select sum(req_count) from request where product_prod_code = %s",(prod_code,))
    rows = curs.fetchall()
    conn.close()

    result = [{"req_count":row[0]} for row in rows]
    return {'results':result}