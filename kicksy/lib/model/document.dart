class Document {
  final int? code;
  final String propser;
  final String title;
  final String contents;
  final String date;

  Document({
    this.code,
    required this.propser,
    required this.title,
    required this.contents,
    required this.date,
  });

  Document.fromMap(Map<String, dynamic> res)
  : code = res['doc_code'],
  propser = res['propser'],
  title = res['title'],
  contents = res['contents'],
  date = res['date'];
}