import 'package:flutter/material.dart';
import 'package:kicksy/vm/database_handler.dart';

class HqOrderQuery extends StatefulWidget {
  const HqOrderQuery({super.key});

  @override
  State<HqOrderQuery> createState() => _HqOrderQueryState();
}

class _HqOrderQueryState extends State<HqOrderQuery> {
  DatabaseHandler handler = DatabaseHandler();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Row(
            children: [Text('발주 번호'), Text('기안자'), Text('날짜'), Text('결재 상태')],
          ),
          Expanded(
            child: FutureBuilder(
              future: handler.queryOderyingWithDocument(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: Row(
                          children: [
                            Text(
                              snapshot.data![index].orderying.num.toString(),
                            ),
                            Text(snapshot.data![index].document.propser),
                            Text(
                              snapshot.data![index].orderying.date.toString(),
                            ),
                            Text(
                              snapshot.data![index].orderying.type.toString(),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
