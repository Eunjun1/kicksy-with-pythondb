import 'package:kicksy/model/document.dart';
import 'package:kicksy/model/employee.dart';
import 'package:kicksy/model/images.dart';
import 'package:kicksy/model/management.dart';
import 'package:kicksy/model/model.dart';
import 'package:kicksy/model/model_with_image.dart';
import 'package:kicksy/model/orderying.dart';
import 'package:kicksy/model/orderying_with_document.dart';
import 'package:kicksy/model/orderying_with_document_with_employee.dart';
import 'package:kicksy/model/product.dart';
import 'package:kicksy/model/product_with_model.dart';
import 'package:kicksy/model/request.dart';
import 'package:kicksy/model/user.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHandler {
  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'kicksy.db'),
      onCreate: (db, version) async {
        // entity
        await db.execute(
          'create table user(email text primary key unique , password text, phone text, address text, signupdate date, sex text)',
        );
        await db.execute(
          'create table product(prod_code integer primary key autoincrement, model_code integer, size integer, maxstock integer, registration date, foreign key (model_code) references model(mod_code))',
        );
        await db.execute(
          'create table store(str_code integer primary key autoincrement, name text, tel text, address text)',
        );
        await db.execute(
          'create table employee(emp_code integer primary key, password text, division text, grade text)',
        );
        await db.execute(
          'create table document(doc_code integer primary key autoincrement, propser text, title text, contents text, date date)',
        );
        await db.execute(
          'create table image(img_code integer primary key autoincrement, model_name text ,img_num integer, image blob, foreign key (model_name) references model(mod_name))',
        );
        await db.execute(
          'create table model(mod_code integer primary key autoincrement, image_num integer ,name text, category text, company text, color text, saleprice integer, foreign key (image_num) references image(img_num))',
        );
        // relation
        await db.execute(
          'create table management(mag_num integer primary key autoincrement, employee_code integer, product_code integer, store_code integer ,mag_type integer, mag_date date, mag_count integer, foreign key (employee_code) references employee(emp_code), foreign key (product_code) references product(prod_code), foreign key (store_code) references store(str_code))',
        );
        await db.execute(
          'create table orderying(ody_num integer primary key autoincrement, employee_code integer, product_code integer, document_code integer, ody_type integer, ody_date date, ody_count integer, reject_reason text, foreign key (employee_code) references employee(emp_code), foreign key (product_code) references product(prod_code), foreign key (document_code) references document(doc_code))',
        );
        await db.execute(
          'create table request(req_num integer primary key autoincrement, user_email text, product_code integer, store_code integer, req_type integer, req_date date, req_count integer, reason text , foreign key (user_email) references user(email), foreign key (product_code) references product(prod_code), foreign key (store_code) references store(str_code))',
        );
      },
      version: 1,
    );
  }

  Future<List<Product>> queryProduct() async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.rawQuery(
      'select * from product',
    );
    return queryResult.map((e) => Product.fromMap(e)).toList();
  }

  Future<int> queryProductNum(String modelname) async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.rawQuery(
      'select prod_code from product p , model m where p.model_code = m.mod_code where $modelname',
    );
    if (queryResult.isNotEmpty && queryResult.first['max_code'] != null) {
      return queryResult.first['prod_code'] as int;
    } else {
      return 0; // 테이블이 비어있는 경우
    }
  }

  Future<List<Product>> querySalepriceOnModel(int modelCode) async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.rawQuery(
      'select saleprice from model where model.mod_code = $modelCode',
    );
    return queryResult.map((e) => Product.fromMap(e)).toList();
  }

  Future<List<Model>> queryModel() async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.rawQuery(
      'select * from model',
    );
    return queryResult.map((e) => Model.fromMap(e)).toList();
  }

  Future<List<Employee>> queryEmployee(int code) async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.rawQuery(
      'select * from employee where emp_code = $code',
    );
    return queryResult.map((e) => Employee.fromMap(e)).toList();
  }

  Future<List<Images>> queryImages(String mName) async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.rawQuery(
      '''select * from Image where model_name = '$mName'
      ''',
    );
    return queryResult.map((e) => Images.fromMap(e)).toList();
  }

  Future<List<Images>> queryUserRequestImages(int num) async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.rawQuery(
      '''select * from image i, product p,  model m, request r where r.product_prod_code = p.prod_code and p.model_code = m.mod_code and m.name = i.model_name  and r.req_num = $num;
      
      ''',
    );
    return queryResult.map((e) => Images.fromMap(e)).toList();
  }

  Future<List<User>> querySignUP(String email) async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.rawQuery('''
      select * from user where email like '%$email%'
      ''');
    return queryResult.map((e) => User.fromMap(e)).toList();
  }

  Future<List<User>> querySignINUser(String id) async {
    final Database db = await initializeDB();

    final List<Map<String, Object?>> queryResult = await db.rawQuery('''
      select * from user where email = '$id'
      ''');
    return queryResult.map((e) => User.fromMap(e)).toList();
  }

  Future<int> updateUser(User user) async {
    final Database db = await initializeDB();
    int result = 0;
    result = await db.rawUpdate(
      '''
      update user
      set password=?,phone=?,sex=? where email=?
      ''',
      [user.password, user.phone, user.sex, user.email],
    );
    return result;
  }

  Future<int> updateOrdertype(Orderying orderying) async {
    final Database db = await initializeDB();
    int result = 0;
    result = await db.rawUpdate(
      '''
      update orderying
      set ody_type=? where ody_num=?
      ''',
      [orderying.type, orderying.num],
    );
    return result;
  }

  Future<List<Employee>> querySignINEmp(String id) async {
    final Database db = await initializeDB();

    final List<Map<String, Object?>> queryResult = await db.rawQuery('''
      select * from employee where emp_code = '$id'
      ''');
    return queryResult.map((e) => Employee.fromMap(e)).toList();
  }

  Future<List<Request>> queryRequest(String id) async {
    final Database db = await initializeDB();

    final List<Map<String, Object?>> queryResult = await db.rawQuery('''
      select * 
      from request 
      where user_email = '$id'
      ''');
    return queryResult.map((e) => Request.fromMap(e)).toList();
  }

  Future<List<Request>> queryRequestState(int id) async {
    final Database db = await initializeDB();

    final List<Map<String, Object?>> queryResult = await db.rawQuery(
      '''
  SELECT 
    req_num, user_email, product_code, store_code, 
    req_type, req_date, req_count, reason 
  FROM request 
  WHERE product_code = ?
''',
      [id],
    );

    return queryResult.map((e) => Request.fromMap(e)).toList();
  }

  Future<List<ModelWithImage>> queryModelwithImage(String where) async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.rawQuery('''
      select * from model m 
      join image i on i.img_num = m.image_num and m.name = i.model_name $where
      ''');
    return queryResult.map((e) => ModelWithImage.fromMap(e)).toList();
  }

  Future<List<Document>> queryDocument() async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.rawQuery(
      'select * from document',
    );
    return queryResult.map((e) => Document.fromMap(e)).toList();
  }

  Future<int> insertModel(Model model) async {
    int result = 0;
    final Database db = await initializeDB();
    result = await db.rawInsert(
      'insert into model(name,image_num,category,company,color,saleprice) values(?,?,?,?,?,?)',
      [
        model.name,
        model.imageNum,
        model.category,
        model.company,
        model.color,
        model.saleprice,
      ],
    );
    return result;
  }

  Future<int> insertimage(Images images) async {
    int result = 0;
    final Database db = await initializeDB();
    result = await db.rawInsert(
      'insert into image(model_name, img_num, image) values(?,?,?)',
      [images.modelname, images.num, images.image],
    );
    return result;
  }

  Future<int> insertEmployee() async {
    int result = 0;
    final Database db = await initializeDB();
    result = await db.rawInsert(
      'insert into employee(password,division,grade) values(?,?,?)',
      [00, '본사', '회장'],
    );
    return result;
  }

  Future<List<OrderyingWithDocument>> queryOderyingWithDocument() async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.rawQuery('''
    select *
    from orderying o
    join document d ON d.doc_code = o.document_code
    ''');
    return queryResult.map((e) => OrderyingWithDocument.fromMap(e)).toList();
  }

  Future<List<String>> getModelNames() async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.rawQuery(
      'SELECT name FROM model',
    );
    return queryResult.map((e) => e['name'].toString()).toList();
  }

  Future<int> insertProduct(Product product) async {
    int result = 0;
    final Database db = await initializeDB();
    result = await db.rawInsert(
      'insert into product(model_code, size, maxstock, registration) values(?,?,?,?)',
      [product.modelCode, product.size, product.maxstock, product.registration],
    );
    return result;
  }

  Future<int> getModelNum() async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.rawQuery(
      'SELECT MAX(mod_code) as max_code FROM model',
    );
    // 결과는 하나의 row만 나오므로 첫 번째 row만 보면 됩니다
    if (queryResult.isNotEmpty && queryResult.first['max_code'] != null) {
      return queryResult.first['max_code'] as int;
    } else {
      return 0; // 테이블이 비어있는 경우
    }
  }

  Future<int> getDocumentNum() async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.rawQuery(
      'SELECT MAX(doc_code) as max_code FROM document',
    );
    // 결과는 하나의 row만 나오므로 첫 번째 row만 보면 됩니다
    if (queryResult.isNotEmpty && queryResult.first['max_code'] != null) {
      return queryResult.first['max_code'] as int;
    } else {
      return 0; // 테이블이 비어있는 경우
    }
  }

  Future<int> insertDocument(Document document) async {
    int result = 0;
    final Database db = await initializeDB();
    result = await db.rawInsert(
      'insert into document(doc_code,propser,title,contents,date) values(?,?,?,?,?)',
      [
        document.code,
        document.propser,
        document.title,
        document.contents,
        document.date,
      ],
    );
    return result;
  }

  Future<int> insertOrdering(Orderying orderying) async {
    int result = 0;
    final Database db = await initializeDB();
    result = await db.rawInsert(
      'insert into orderying(employee_code,product_code,document_code,ody_type,ody_date,ody_count,reject_reason) values(?,?,?,?,?,?,?)',
      [
        orderying.employeeCode,
        orderying.productCode,
        orderying.documentCode,
        orderying.type,
        orderying.date,
        orderying.count,
        orderying.rejectReason,
      ],
    );
    return result;
  }

  Future<List<OrderyingWithDocumentWithEmployee>>
  queryOrderyingWithDocumentWithEmployee(int code) async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.rawQuery('''
      select * 
      from orderying as ody
      join employee as emp on ody.employee_code = emp.emp_code
      join document as doc on ody.document_code = doc.doc_code
      join product as prod on ody.product_code = prod.prod_code
      where ody.document_code = $code
      ''');
    return queryResult
        .map((e) => OrderyingWithDocumentWithEmployee.fromMap(e))
        .toList();
  }

  Future<int> insertRequest(Request request) async {
    int result = 0;
    final Database db = await initializeDB();
    result = await db.rawInsert(
      'insert into request(user_email, product_code, store_code, req_type, req_date, req_count, reason) values(?,?,?,?,?,?,?)',
      [
        request.userId,
        request.productCode,
        request.storeCode,
        request.type,
        request.date,
        request.count,
        request.reason ?? '',
      ],
    );
    return result;
  }

  ///

  Future<List<Model>> queryCompany() async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.rawQuery(
      'select * from model group by company',
    );
    return queryResult.map((e) => Model.fromMap(e)).toList();
  }

  Future<List<ProductWithModel>> queryProductwithImageModel(
    String modelName,
    int modelCode,
  ) async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.rawQuery('''
         SELECT *
        FROM product p, model m
        WHERE p.model_code = m.mod_code
        AND m.name = '$modelName'
        AND p.model_code = $modelCode
      ''');
    return queryResult.map((e) => ProductWithModel.fromMap(e)).toList();
  }

  Future<List<Orderying>> queryOderying() async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.rawQuery(
      'select * from oderying,document where document.code = orderying.document_code',
    );

    return queryResult.map((e) => Orderying.fromMap(e)).toList();
  }

  Future<int> insertUser(User user) async {
    int result = 0;
    final Database db = await initializeDB();
    result = await db.rawInsert(
      'insert into user(email, password, phone, address, signupdate, sex) values(?,?,?,?,?,?)',
      [
        user.email,
        user.password,
        user.phone,
        user.address,
        user.signupdate,
        user.sex,
      ],
    );
    return result;
  }

  Future<int> insertUserfisrt() async {
    int result = 0;
    final Database db = await initializeDB();
    result = await db.rawInsert(
      'insert into user(email, password, phone, address, signupdate, sex) values(?,?,?,?,?,?)',
      ['01', '01', '01', 'user.address', DateTime.now().toString(), 'sex'],
    );
    return result;
  }
  //

  Future<List<Model>> queryModelWhereCategory(String category) async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.rawQuery(
      'SELECT * FROM model WHERE category = ?',
      [category], // ?에 대응하는 값은 리스트로 전달
    );
    return queryResult.map((e) => Model.fromMap(e)).toList();
  }

  Future<List<ProductWithModel>> queryProductNew() async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.rawQuery('''
           SELECT *
        FROM product p, model m
        WHERE p.model_code = m.mod_code
        AND p.registration in (select max(registration)
        from product p, model m
        WHERE p.model_code = m.mod_code)
      ''');
    return queryResult.map((e) => ProductWithModel.fromMap(e)).toList();
  }

  Future<List<ProductWithModel>> queryProductwithModel(String modelName) async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.rawQuery('''
         SELECT *
        FROM product p, model m
        WHERE p.model_code = m.mod_code
        AND m.name = '$modelName'
      ''');
    return queryResult.map((e) => ProductWithModel.fromMap(e)).toList();
  }

  Future<List<Management>> queryManagement() async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.rawQuery('''
      select * 
      from management as mag
      join request as req on req.store_code = mag.store_code
      join store as str on str.str_code = mag.store_code
      ''');
    return queryResult.map((e) => Management.fromMap(e)).toList();
  }

  Future<List<Request>> queryRequestWithProduct(int size) async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.rawQuery('''
        SELECT  *
        FROM request as r, product as p
        WHERE r.product_code = p.prod_code
        and p.size = $size
        
      ''');
    return queryResult.map((e) => Request.fromMap(e)).toList();
  }

  Future<List<ProductWithModel>> queryReqProductwithModel(int modelcode) async {
    final Database db = await initializeDB();

    final List<Map<String, Object?>> queryResult = await db.rawQuery('''
         SELECT *
        FROM product p, model m, request r
        WHERE r.product_code = p.prod_code
        AND p.model_code = m.mod_code
        AND r.req_num = $modelcode
      ''');

    return queryResult.map((e) => ProductWithModel.fromMap(e)).toList();
  }

  Future<int> insertManagement(Management management) async {
    int result = 0;
    final Database db = await initializeDB();
    result = await db.rawInsert(
      'insert into management(employee_code, product_code, store_code, mag_type, mag_date, mag_count) values(?,?,?,?,?,?)',
      [
        management.employeeCode,
        management.productCode,
        management.storeCode,
        management.type,
        management.date,
        management.count,
      ],
    );
    return result;
  }

  Future<List<Request>> queryRequestList(int storeCode) async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.rawQuery('''
    SELECT * 
    FROM request 
    WHERE ($storeCode = 0 OR store_code = $storeCode)
    ''');
    return queryResult.map((e) => Request.fromMap(e)).toList();
  }

  Future<List<Model>> getProductName(int productCode) async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.rawQuery('''
      select * 
      from request as r, product as p, model as m
      where r.product_code = $productCode
      and m.mod_code = $productCode
      ''');
    return queryResult.map((e) => Model.fromMap(e)).toList();
  }

  Future<List<Product>> getProductSize(int productCode) async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.rawQuery('''
      select * 
      from request as r, product as p, model as m
      where r.product_code = $productCode
      and m.mod_code = $productCode
      ''');
    return queryResult.map((e) => Product.fromMap(e)).toList();
  }

  Future<int> updateRequest(Request request) async {
    final Database db = await initializeDB();
    int result = 0;
    result = await db.rawUpdate(
      '''
      update request
      set req_type=?
      where req_num = ?
      ''',
      [request.type, request.num],
    );
    return result;
  }

  Future<int> updateManagements(User user) async {
    final Database db = await initializeDB();
    int result = 0;
    result = await db.rawUpdate(
      '''
      update management
      set password=?,phone=?,sex=? where email=?
      ''',
      [user.password, user.phone, user.sex, user.email],
    );
    return result;
  }

  // sum(req_count), prod.maxstock
  // Future<List<Document>> queryDocumentWithRequest() async {
  //   final Database db = await initializeDB();
  //   final List<Map<String, Object?>> queryResult = await db.rawQuery(
  //     '''
  //     if
  //     select sum(r.req_count)
  //     from request as r, product as p
  //     where r.product_code = p.prod_code < product.maxstock
  //     insert into document
  //     '''
  //   );
  //   return queryResult.map((e) => Document.fromMap(e)).toList();
  // }
}
