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


@router.get("/selectMax")
async def selectMax():

    conn = connect()
    curs = conn.cursor()

    curs.execute("select max(mod_code) from model")
    rows = curs.fetchall()
    conn.close()

    result = [{"max":row[0]} for row in rows]
    return {'results':result}

@router.get("/namecode={name}")
async def selectCode(name : str):
    conn = connect()
    curs = conn.cursor()

    curs.execute("select mod_code from model where name=%s", (name,))
    rows = curs.fetchall()
    conn.close()

    result = [{"code":row[0]} for row in rows]
    return {'results':result}


@router.get("/selectAll")
async def selectAll():

    conn = connect()
    curs = conn.cursor()

    curs.execute("select * from model")
    rows = curs.fetchall()
    conn.close()

    result = [{"mod_code":row[0],"image_num":row[1],"name":row[2],"category":row[3],"company":row[4],"color":row[5],"saleprice":row[6]} for row in rows]
    return {'results':result}


@router.get("/select/new")
async def selectNew():

    conn = connect()
    curs = conn.cursor()

    curs.execute('''SELECT category,company,name
        FROM product p, model m
        WHERE p.model_code = m.mod_code
        AND p.registration in (select max(registration)
        from product p, model m
        WHERE p.model_code = m.mod_code)''')
    rows = curs.fetchall()
    conn.close()

    result = [{"category":row[0],"company":row[1],"name":row[2]} for row in rows]
    return {'results':result}

@router.get("/where/{where}")
async def selectAll(where:str):

    conn = connect()
    curs = conn.cursor()

    curs.execute(f"select * from model {where}")
    rows = curs.fetchall()
    conn.close()

    result = [{"mod_code":row[0],"image_num":row[1],"name":row[2],"category":row[3],"company":row[4],"color":row[5],"saleprice":row[6]} for row in rows]
    return {'results':result}

@router.get("/companys")
async def selectcompany():
    conn = connect()
    curs = conn.cursor()

    curs.execute(f"select company from model group by company")
    rows = curs.fetchall()
    conn.close()

    result = [{"company":row[0]} for row in rows]
    return {'results':result}



# -- 회사별 제품 검색
@router.get("/company={company}")
async def selectModelWithCompany(company : str):

    conn = connect()
    curs = conn.cursor()

    curs.execute("select * from model where company = %s",(company,))
    rows = curs.fetchall()
    conn.close()

    result = [{"mod_code":row[0],"image_num":row[1],"name":row[2],"category":row[3],"company":row[4],"color":row[5],"saleprice":row[6]} for row in rows]
    return {'results':result}
# -- model 코드로 검색 --
@router.get("/mod_code={mod_code}")
async def selectModelcode(mod_code: int):

    conn = connect()
    curs = conn.cursor()

    curs.execute("select * from model where mod_code = %s",(mod_code,))
    rows = curs.fetchall()
    conn.close()

    result = [{"mod_code":row[0],"image_num":row[1],"name":row[2],"category":row[3],"company":row[4],"color":row[5],"saleprice":row[6]} for row in rows]
    return {'results':result}

@router.get("/modelWithImage/")
async def selectModel(where : str):

    conn = connect()
    curs = conn.cursor()
    sql = f"""select * from kicksy.model as m
    join kicksy.image as i on  i.img_num = m.image_num and m.name = i.model_name {where}"""
    curs.execute(sql)
    rows = curs.fetchall()
    conn.close()

    result = [{"mod_code":row[0],"image_num":row[1],"name":row[2],"category":row[3],"company":row[4],"color":row[5],"saleprice":row[6],"img_code":row[7],"model_name":row[8],"img_num":row[9]} for row in rows]
    return {'results':result}

# -- model데이터 삽입 --
@router.post("/insert")
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