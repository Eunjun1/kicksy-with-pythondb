import base64
from fastapi import FastAPI, UploadFile, File, Form
from fastapi.responses import Response
import pymysql

'''
author : 김태민
describtion: 기본 select 추가 버전
date : 2025-05-18
version : 1
'''

app = FastAPI()

# class mysql_image(BaseModel):
#     seq : int
#     name : str
#     phone : str
#     address : str
#     relation : str
#     image : 

def connect():
    return pymysql.connect(
        host = '127.0.0.1',
        user = 'root',
        password = 'qwer1234',
        database = 'kicksy',
        charset = 'utf8'
    )

# ----------<select>----------
@app.get('/select/document')
async def select():
    conn = connect()
    curs = conn.cursor()

    curs.execute('select str_code, name, tel, address from store')
    rows = curs.fetchall()
    curs.close()

    result = [{'str_code' : row[0], 'name' : row[1], 'tel' : row[2], 'address' : row[3]} for row in rows ]
    return {'results' : result}
    
@app.get('/select/employee')
async def select():
    conn = connect()
    curs = conn.cursor()

    curs.execute('select emp_code, password, division, grade from employee ')
    rows = curs.fetchall()
    curs.close()

    result = [{'emp_code' : row[0], 'password' : row[1], 'division' : row[2], 'grade' : row[3]} for row in rows ]
    return {'results' : result}
    
# @app.get('/image/{img_code}')
# async def get_image(img_code: str):
#     conn = connect()
#     curs = conn.cursor()
#     curs.execute('select image from image where img_code = %s', (img_code,))
#     row = curs.fetchone()
#     curs.close()

#     if row and row[0]:
#         return Response(content=row[0], media_type='image/jpeg',headers = {'Cache-control' : 'no-cache, no-store, must-revalidate'})
#     return {'error': 'Image not found'}

@app.get('/select/image')
async def select():
    conn = connect()
    curs = conn.cursor()

    curs.execute('select img_code, model_name, img_num, image from image')
    rows = curs.fetchall()
    curs.close()
    result = [{'img_code' : row[0], 'model_name' : row[1], 'img_num' : row[2], 'image' : row[3]} for row in rows ]
    return {'results' : result}
    
@app.get('/select/management')
async def select():
    conn = connect()
    curs = conn.cursor()

    curs.execute('select mag_num, prod_code, emp_code, store_str_code, mag_type, mag_date, mag_count from management')
    rows = curs.fetchall()
    curs.close()

    result = [{'mag_num' : row[0], 'prod_code' : row[1], 'emp_code' : row[2], 'store_str_code' : row[3], 'mag_type' : row[4], 'mag_date' : row[5], 'mag_count' : row[6]} for row in rows ]
    return {'results' : result}
    
@app.get('/select/model')
async def select():
    conn = connect()
    curs = conn.cursor()

    curs.execute('select mod_code, image_num, name, category, company, color, saleprice from model')
    rows = curs.fetchall()
    curs.close()

    result = [{'mod_code' : row[0], 'image_num' : row[1], 'name' : row[2], 'category' : row[3], 'company' : row[4], 'color' : row[5], 'saleprice' : row[6]} for row in rows ]
    return {'results' : result}
    
@app.get('/select/orderying')
async def select():
    conn = connect()
    curs = conn.cursor()

    curs.execute('select ody_num, emp_code, doc_code, prod_code, ody_type, ody_date, ody_count, reject_reason from orderying')
    rows = curs.fetchall()
    curs.close()

    result = [{'ody_num' : row[0], 'emp_code' : row[1], 'doc_code' : row[2], 'prod_code' : row[3], 'ody_type' : row[4], 'ody_date' : row[5], 'ody_count' : row[6], 'ody_count' : row[7]} for row in rows ]
    return {'results' : result}
    
@app.get('/select/product')
async def select():
    conn = connect()
    curs = conn.cursor()

    curs.execute('select prod_code, model_code, size, maxstock, registration from product')
    rows = curs.fetchall()
    curs.close()

    result = [{'prod_code' : row[0], 'model_code' : row[1], 'size' : row[2], 'maxstock' : row[3], 'resistration' : row[4]} for row in rows ]
    return {'results' : result}
    
@app.get('/select/request')
async def select():
    conn = connect()
    curs = conn.cursor()

    curs.execute('select req_num, user_email, product_prod_code, store_str_code, req_type, req_date, req_count, reason from request')
    rows = curs.fetchall()
    curs.close()

    result = [{'req_num' : row[0], 'user_email' : row[1], 'product_prod_code' : row[2], 'store_str_code' : row[3], 'req_type' : row[4], 'req_date' : row[5], 'req_count' : row[6], 'reason' : row[7]} for row in rows ]
    return {'results' : result}
    
@app.get('/select/store')
async def select():
    conn = connect()
    curs = conn.cursor()

    curs.execute('select str_code, name, tel, address from store')
    rows = curs.fetchall()
    curs.close()

    result = [{'str_code' : row[0], 'name' : row[1], 'tel' : row[2], 'address' : row[3]} for row in rows ]
    return {'results' : result}
    
@app.get('/select/user')
async def select():
    conn = connect()
    curs = conn.cursor()

    curs.execute('select email, password, phone, address, signupdata, sex from user')
    rows = curs.fetchall()
    curs.close()

    result = [{'email' : row[0], 'password' : row[1], 'phone' : row[2], 'address' : row[3], 'signupdata' : row[4], 'sex' : row[5]} for row in rows ]
    return {'results' : result}

# ----------<select/what>----------

@app.get('/view/store_num={str_code}')
async def view(str_code : int):
    try:
        conn = connect()
        curs = conn.cursor()

        curs.execute('select name from store where str_code = %s', (str_code))
        row = curs.fetchone()
        conn.close()

        if row and row[0]:
            result = [{'name' : row[0]}]
            return {'result' : result}
        else:
            return{'result' : 'no data'}
    except Exception as e:
        print('Error : ', e)
        return{'result' : 'Error'}

# ----------<insert>----------

# ----------<update>----------

# ----------<delete>----------


if __name__ == '__main__':
    import uvicorn
    uvicorn.run(app, host = '127.0.0.1', port = 8000)