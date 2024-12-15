import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
class Repository {

  Future<Map<String,dynamic>?> fetchDataFromApi() async {   //function to fetch city name and temp
    List<String> Cities = ["New Delhi", "Mumbai", "Bangalore", "Kolkata", "Chennai", "Hyderabad", "Ahmedabad","Pune", "Jaipur", "Surat", "Lucknow", "Kanpur", "Nagpur", "Indore", "Patna", "Vadodara","Ghaziabad", "Ludhiana", "Agra", "Chandigarh", "Coimbatore", "Nashik", "Bhopal", "Ranchi", "Vijayawada", "Visakhapatnam", "Mysuru", "Madurai", "Shimla", "Trivandrum"
    ];

    var random = Random();
    int randomIndex = random.nextInt(Cities.length); //generating random no.

    String city = Cities[randomIndex];   //getting random city by random index
    final response = await http.get(Uri.parse('https://api.openweathermap.org/data/2.5/weather?units=metric&q=$city&appid=1a467bc556d33572912d2af67d2ac924'));  //fetching data for that city

    if (response.statusCode == 200) {   //statuscode 200 means its success
      Map<String,dynamic> Data=jsonDecode(response.body);
      Map<String,dynamic> tempName={
        'cityName':Data['name'],
        'temp':Data['main']['temp'].toString()
      };
      print(tempName);
      return tempName; //returning in form of map

    } else {
      throw Exception('Failed to load data');
    }
  }
}
