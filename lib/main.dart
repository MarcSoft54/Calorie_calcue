import 'package:calorie_calcul/class.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calorie Maker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Calcul de Calorie'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  Color couleurFemme = Colors.pinkAccent;
  Color couleurHomme = Colors.blue;
  bool choixHommeEtFemme = false;
  int sliderValue = 0;
  int? age ;
  double? realYears;
  double? Poids;
  var RadioSelectionner;
  var ResultatCalcul;
  var metaBolisme;

  Map dict = {
    0: "Faible",
    1: "moderer",
    2: "Forte"
  };
//1.725
  //1.55
//1.2
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: (choixHommeEtFemme)? couleurHomme: couleurFemme,
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            padding(),
            customText("Calcul des apports en calorie pour un homme et une femme", Color: Colors.black,factor: 1.3,),
            padding(),
            Card(
              elevation: 25,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      customText("Femme", Color: couleurFemme,),
                      Switch(
                          value: choixHommeEtFemme,
                          activeColor: Colors.blue,
                          inactiveTrackColor: couleurFemme,
                          activeTrackColor: couleurHomme,
                          onChanged: (bool b){
                            setState(() {
                              choixHommeEtFemme = b;
                            });
                          }),
                      customText("Homme", Color: Colors.blue,)
                    ],
                  ),
                  padding(),
                  ElevatedButton(
                      onPressed: datePicker,
                      style: ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll<Color>((choixHommeEtFemme)? couleurHomme:couleurFemme)
                      ),
                      child: customText((age == null)?"Appuyer pour entrer votre age.":"votre age est de : $age ans")),
                  padding(),
                  customText((sliderValue == 0)?"Faite entre votre taille":"Vous avez $sliderValue cm", Color: (choixHommeEtFemme)? couleurHomme:couleurFemme,),
                  padding(),
                  Slider(
                      value: sliderValue.toDouble(),
                      min: 0,
                      max: 200,
                      activeColor: (choixHommeEtFemme)? couleurHomme:couleurFemme,
                      onChanged: (double d){
                        setState(() {
                          sliderValue = (d).floor();
                        });
                      }),
                  padding(),
                  TextField(
                    textAlign: TextAlign.start,
                    keyboardType: TextInputType.number,
                    onSubmitted: (String poids){
                      setState(() {
                        Poids = double.tryParse(poids);
                      });
                    },
                    decoration: InputDecoration(
                        labelText: "Veuillez entrez votre poids en kilo..."),
                  ),
                  padding(),
                  customText("Comment est votre activiter sportive ?", Color: (choixHommeEtFemme)? couleurHomme: couleurFemme,factor: 1.3,),
                  padding(),
                  checkList(),
                  padding()
                ],
              ),
            ),
            padding(),
            ElevatedButton(
              onPressed: Calculer,
              child: customText('Calculer',),
              style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll<Color>((choixHommeEtFemme)? couleurHomme: couleurFemme)
              ),)
          ],
        ),
      ),
    );
  }


  Padding padding(){
    return Padding(padding: EdgeInsets.only(top: 20));
  }


  Future<void> datePicker() async{
    DateTime? ages = await showDatePicker(
        context: context,
        initialDatePickerMode: DatePickerMode.year,
        initialDate:DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime.now());
    DateTime? anneeActuel = await DateTime.now();
    if (ages != null){
      setState(() {
        age = anneeActuel.year - ages.year;
      });
    }
  }

  Row checkList() {
    List<Widget> l = [];
    dict.forEach((k, valeur) {
      Column colonne = Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Radio(
                value: k,
                activeColor: (choixHommeEtFemme)? couleurHomme: couleurFemme,
                groupValue: RadioSelectionner,
                onChanged: (var i) {
                  setState(() {
                    RadioSelectionner = i;
                  });
                }),
            customText(valeur, Color: (choixHommeEtFemme)? couleurHomme: couleurFemme,),
          ]);
      l.add(colonne);
    });
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: l
    );
  }

  void Calculer(){
    if(Poids != null && sliderValue!= null && age != null){
      setState(() {
        var poid = (9.740 * Poids!);
        var tail = (172.9 * sliderValue);
        var arge = (4.737 * age!);

        ResultatCalcul = poid + tail - arge;

        if(choixHommeEtFemme){
        ResultatCalcul += 667.051;
        metaBolisme = ResultatCalcul;
        metaBolisme = choix(metaBolisme);
        }else{
          ResultatCalcul += 77.607;
          metaBolisme = ResultatCalcul;
          metaBolisme = choix(metaBolisme);
        }
        AlertCalcul( ResultatCalcul, metaBolisme);
      });
    }else{
      setState(() {
        Alert();
      });
    }
  }

  Future<void> Alert() async{
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: customText("Erreur", Color: Colors.red,),
            contentPadding: EdgeInsets.all(20),
            content: Text("Veuillez renseigner toute les champs"),
            actions: [
              TextButton(onPressed:() {
                Navigator.pop(context);
              },
                  child: customText("Cancel", Color: Colors.redAccent,))
            ],
          );
        });
  }

  Future<void> AlertCalcul(double resultat, double metablismeAuRepos) async{
    return showDialog(context: context,
        barrierDismissible: false,
        builder: (BuildContext context){
          return AlertDialog(
            title: customText("Resultat du calcul", Color: Colors.black,),
            content: customText("il vous faut pas jour\n\n\t ${resultat.toInt()} calories \nau repos  Et\n\n\t ${metablismeAuRepos.toInt()} calories \nquand vous etes en Activiter.", Color: Colors.black,),
            actions: [
              TextButton(onPressed: (){
                Navigator.pop(context);
              },
                child: customText("Ok", Color: Colors.blue,),
              ),
            ],
          );
        });
  }
double choix(var nombre){
  switch(RadioSelectionner){
    case 0:
      nombre *= 1.2;
      break;
    case 1:
      nombre *= 1.55;
      break;
    case 2:
      nombre *= 1.725;
      break;
  }
  return nombre;
}

}

// return showDialog(
// context: context,
// builder: (BuildContext context){
// return SimpleDialog(
// contentPadding: EdgeInsets.all(25),
// title: customText("Resultat", Color: (choixHommeEtFemme)? couleurHomme: couleurFemme,),
// children: [
// customText("Votre apport en calorie journaliere est de : ", Color: (choixHommeEtFemme)? couleurHomme:couleurFemme,),
// TextButton(
// onPressed: (){
// setState(() {
// Navigator.pop(context);
// });
// },
// child: customText("Fermer", Color: (choixHommeEtFemme)? couleurHomme: couleurFemme,))
// ],
// );
// });