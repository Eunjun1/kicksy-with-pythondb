import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:kicksy/model/map.dart';
import 'package:latlong2/latlong.dart' as latlng;

class UserMapview extends StatefulWidget {
  const UserMapview({super.key});

  @override
  State<UserMapview> createState() => _UserMapviewState();
}

class _UserMapviewState extends State<UserMapview> {
  late MapController mapController;
  List<MapStoreView> maplist = [];
  double centerLat = 37.49474670867588; // 기본값
  double centerLong = 127.03002601795808; // 기본값
  bool loading = true;

  @override
  void initState() {
    super.initState();
    mapController = MapController();
    generateMapList();
    getCurrentPosition(); // 현재 위치 가져오기
  }

  generateMapList() {
    maplist.add(MapStoreView(name: '강남구', lat: 37.4966645, long: 127.0629804));
    maplist.add(
      MapStoreView(name: '강동구', lat: 37.530160973856, long: 127.12379233466),
    );
    maplist.add(
      MapStoreView(name: '강북구', lat: 37.6391856183931, long: 127.025449504014),
    );
    maplist.add(MapStoreView(name: '강서구', lat: 37.5509103, long: 126.8495742));
    maplist.add(
      MapStoreView(name: '관악구', lat: 37.4782106746327, long: 126.951501244173),
    );
    maplist.add(
      MapStoreView(name: '광진구', lat: 37.5385316143438, long: 127.081909826352),
    );
    maplist.add(
      MapStoreView(name: '구로구', lat: 37.4955054632154, long: 126.888292375229),
    );
    maplist.add(
      MapStoreView(name: '금천구', lat: 37.4570656519531, long: 126.896036850324),
    );
    maplist.add(
      MapStoreView(name: '노원구', lat: 37.6545228397157, long: 127.056268317802),
    );
    maplist.add(
      MapStoreView(name: '도봉구', lat: 37.6687161285201, long: 127.047131400119),
    );
    maplist.add(
      MapStoreView(name: '동대문구', lat: 37.5743917161622, long: 127.039896580148),
    );
    maplist.add(
      MapStoreView(name: '동작구', lat: 37.51252777344, long: 126.939942092863),
    );
    maplist.add(
      MapStoreView(name: '마포구', lat: 37.5663128370109, long: 126.901615668932),
    );
    maplist.add(
      MapStoreView(name: '서대문구', lat: 37.5791546257808, long: 126.936759175119),
    );
    maplist.add(
      MapStoreView(name: '서초구', lat: 37.4836248649455, long: 127.032683002019),
    );
    maplist.add(
      MapStoreView(name: '성동구', lat: 37.5634225092469, long: 127.036964999975),
    );
    maplist.add(
      MapStoreView(name: '성북구', lat: 37.5894551333062, long: 127.016690019544),
    );
    maplist.add(
      MapStoreView(name: '송파구', lat: 37.514477182474, long: 127.105859984389),
    );
    maplist.add(
      MapStoreView(name: '양천구', lat: 37.5170753784215, long: 126.866542541936),
    );
    maplist.add(
      MapStoreView(name: '영등포구', lat: 37.525963157053, long: 126.896367130558),
    );
    maplist.add(
      MapStoreView(name: '용산구', lat: 37.5324522944579, long: 126.990478820837),
    );
    maplist.add(
      MapStoreView(name: '은평구', lat: 37.6024574203071, long: 126.928822870137),
    );
    maplist.add(
      MapStoreView(name: '종로구', lat: 37.5735051436739, long: 126.978988255925),
    );
    maplist.add(
      MapStoreView(name: '중구', lat: 37.5641201543296, long: 126.998009728978),
    );
    maplist.add(
      MapStoreView(name: '중랑구', lat: 37.6065635856848, long: 127.09272484193),
    );
  }

  // 현재 위치 가져오기
  Future<void> getCurrentPosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print("위치 서비스 꺼짐");
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print("위치 권한 거부됨");
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      print("위치 권한 영구 거부됨");
      return;
    }

    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      centerLat = position.latitude;
      centerLong = position.longitude;
      loading = false;
      mapController.move(latlng.LatLng(centerLat, centerLong), 16.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '매장 위치',
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700),
        ),
      ),
      body: Center(child: flutterMap()),
    );
  }

  Widget flutterMap() {
    return FlutterMap(
      mapController: mapController,
      options: MapOptions(
        interactionOptions: InteractionOptions(
          flags: InteractiveFlag.drag | InteractiveFlag.pinchZoom,
        ),
        initialCenter: latlng.LatLng(centerLat, centerLong),
        initialZoom: 16.0,
      ),
      children: [
        TileLayer(
          urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
        ),
        MarkerLayer(
          markers: [
            Marker(
              width: 100,
              height: 80,
              point: latlng.LatLng(centerLat, centerLong),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.pin_drop, size: 50, color: Colors.blue),
                  Text(
                    '현재 위치',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
          ],
        ),
        MarkerLayer(
          markers:
              maplist.map((m) => setMarkers(m.name, m.lat, m.long)).toList(),
        ),
      ],
    );
  }

  Marker setMarkers(String name, double lat, double long) {
    return Marker(
      width: 100,
      height: 80,
      point: latlng.LatLng(lat, long),
      child: Column(
        children: [
          Icon(Icons.pin_drop, size: 50, color: Colors.red),
          Text(name, style: TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}
