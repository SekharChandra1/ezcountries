
import 'package:countries/model/country_model.dart';
import 'package:countries/provider/country_provider.dart';
import 'package:countries/screens/search_country.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CountryScreen extends StatefulWidget {


  @override
  _CountryScreenState createState() => _CountryScreenState();
}

class _CountryScreenState extends State<CountryScreen> {
  late CountryProvider countryProvider;
  List<CountryElements> _filteredCountriesList = [];

  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      await countryProvider.getCountryName();
      await countryProvider.getLanguages();
    });
  }

  @override
  Widget build(BuildContext context) {
    countryProvider = Provider.of<CountryProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('eZCountries'),
        actions: [
          _filteredCountriesList.isEmpty
              ? IconButton(
                  onPressed: () {
                    onTapFilterButton();
                  },
                  icon: Icon(Icons.filter_alt_outlined),
                )
              : IconButton(
                  onPressed: () {
                    _filteredCountriesList.clear();
                    countryProvider.refreshScreen();
                  },
                  icon: Icon(Icons.close),
                ),
        ],
      ),
      floatingActionButton: FloatingActionButton(onPressed: (){
        Route route = MaterialPageRoute(builder: (_) => CountrySearch());
        Navigator.push(context, route);
      },child: Icon(Icons.search),backgroundColor: Colors.grey[900],),
      body: Column(
        children: [
          if (_filteredCountriesList.isNotEmpty)
            Container(
                padding: EdgeInsets.symmetric(vertical: 4.0),
                child: Text('${_filteredCountriesList.length} results found')),
            Expanded(
            child: countryProvider.countries!.isEmpty
                ? Center(child: CupertinoActivityIndicator())
                : _filteredCountriesList.isEmpty
                    ? _buildCountriesList()
                    : _buildFilteredList(),
          ),
        ],
      ),
    );
  }

  Widget _buildCountriesList() {
    return ListView.builder(
        itemCount: countryProvider.countries!.length,
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.all(10.0),
        itemBuilder: (context, index) {
          final countryName = countryProvider.countries![index].countryName!;
          final countryLanguage = countryProvider.countries![index].countryLanguages!;
          return Card(
            child: ListTile(
              title: Text(countryName),
              subtitle: countryLanguage.isNotEmpty
                  ? Text(countryLanguage[0].name!)
                  : Text(""),


            ),
          );
        });
  }

  Widget _buildFilteredList() {
    return ListView.builder(
        itemCount: _filteredCountriesList.length,
        padding: EdgeInsets.all(10.0),
        itemBuilder: (context, index) {
          final countryName = _filteredCountriesList[index].countryName!;
          final countryLanguage = _filteredCountriesList[index].countryLanguages!;
          return Card(
            child: ListTile(
              title: Text(countryName),
              subtitle: countryLanguage.isNotEmpty
                  ? Text(countryLanguage[0].name!)
                  : Text(""),
            ),
          );
        });
  }

  Future filterByLanguage(languageName) async {
    List<CountryElements> _tempCountriesList = [];
    _tempCountriesList.addAll(countryProvider.countries!);
    for (var country in _tempCountriesList) {
      for (var language in country.countryLanguages!) {
        if (language.name!
            .toLowerCase()
            .contains(languageName.toLowerCase())) {
          _filteredCountriesList.add(country);
        }
      }
    }
  }

  void onTapFilterButton() {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) => Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(top: 40),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            padding:
            const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  "Filter by language",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14,color: Colors.grey[900]),
                ),
                const SizedBox(
                  height: 16,
                ),
                Expanded(
                  child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      physics: BouncingScrollPhysics(),
                      itemCount: countryProvider.languages.length,
                      itemBuilder: (context, index) {
                        final name = countryProvider.languages[index].name!;
                        return ListTile(
                          onTap: ()async {
                            await filterByLanguage(name);
                            countryProvider.refreshScreen();
                            Navigator.of(context).pop();
                          },
                          title: Text(name),);
                      }),
                ),
                const SizedBox(
                  height: 16,
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    textStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.redAccent,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Close',style: TextStyle(color: Colors.grey[900]),),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    countryProvider.countries!.clear();
    countryProvider.languages.clear();
    _filteredCountriesList.clear();
    super.dispose();
  }
}
