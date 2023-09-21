import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:streeadmin/subcategories/Subcategorywidget.dart';

import '../Videos.dart';
import '../constants.dart';

class Categorywidget extends StatefulWidget {
  String category;
  Categorywidget({Key? key,required this.category}) : super(key: key);

  @override
  State<Categorywidget> createState() => _CategorywidgetState(category: category);
}

class _CategorywidgetState extends State<Categorywidget> {
  String category="";

  Videos? video;
  String? title,desc,link;
  TextEditingController? _link,_title,_desc;

  final _formKey = GlobalKey<FormState>();
  String key="";
  bool disable=false;
  String subcategory="";


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _link=new TextEditingController();
    _title=new TextEditingController();
    _desc=new TextEditingController();
  }

  _CategorywidgetState({required this.category});

  @override
  Widget build(BuildContext context) {
    return category=="Safetypodcasts"?DefaultTabController(
    initialIndex: 0,
    length: 9,
    child: Scaffold(
    backgroundColor: pink,
    appBar: const TabBar(
      indicatorColor:Colors.white,
      isScrollable: true,
      tabs: <Widget>[
        Tab(
          child: Text("Menstrual Health"),
        ),
        Tab(
          child: Text("Domestic Violence"),
        ),
        Tab(
          child: Text("Gender Inequality"),
        ),
        Tab(
          child: Text("Eve Teasing"),
        ),
        Tab(
          child: Text("Digital Gender Divide"),
        ),
        Tab(
          child: Text("Poor Nutrition"),
        ),
        Tab(
          child: Text("Gender Pay Gap"),
        ),
        Tab(
          child: Text("Dowry Issues"),
        ),
        Tab(
          child: Text("Child Marriage"),
        ),
      ],
    ),
    body: TabBarView(
      children: <Widget>[
        Subcategorywidget(subcategory: "Menstraulhealth",),
        Subcategorywidget(subcategory: "Domesticviolence",),
        Subcategorywidget(subcategory: "Genderinequality",),
        Subcategorywidget(subcategory: "Eveteasing",),
        Subcategorywidget(subcategory: "Digitalgenderdivide",),
        Subcategorywidget(subcategory: "Poornutrition",),
        Subcategorywidget(subcategory: "Genderpaygap",),
        Subcategorywidget(subcategory: "Dowryissues",),
        Subcategorywidget(subcategory: "Childmarriage",),
      ],
    ),
    ),
    ):Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  child: Form(
                      key: _formKey,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            edittexttitle(context),
                            SizedBox(height:15,),
                            edittextdesc(context),


                            SizedBox(height:15,),
                            edittextlink(context),


                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                Expanded(
                                    flex: 1,
                                    child: ElevatedButton(

                                      onPressed:disable?null:() async{
                                        if (_formKey.currentState!
                                            .validate()) {
                                          _formKey.currentState!.save();

                                          setState(()=>{
                                            disable=true
                                          });

                                          key=FirebaseFirestore.instance.collection("temp").doc().id;

                                          FirebaseFirestore.instance.collection(category).doc(key).set({
                                            "title":title,
                                            "description":desc,
                                            "link":link,
                                            "key":key
                                          }).then((value) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Data Saved")))).whenComplete(() => setState(()=>{
                                            _title!.clear(),
                                            _desc!.clear(),
                                            _link!.clear(),
                                            setState(()=>{ disable=false})
                                          }));


                                        }
                                      },
                                      child: Text(
                                        "Save",
                                        style: TextStyle(
                                            color: white,
                                            fontWeight: FontWeight.bold),
                                      ),

                                    ))
                              ],
                            ),


                          ]
                      )),
                ),
                StreamBuilder(
                    stream:   FirebaseFirestore.instance.collection(category).snapshots(),
                    builder: (BuildContext context,AsyncSnapshot<QuerySnapshot>snapshot){
                      if(!snapshot.hasData){
                        return Container(
                          child: CircularProgressIndicator(color: pink,),
                        );
                      }

                      if(snapshot.hasData){


                        return  Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child: Text("Videos",style: heading(),),
                              margin: EdgeInsets.all(10),),
                            snapshot.data!.docs.length==0?Center(
                              child: Container(
                                child: Text("No data"),
                              ),
                            ): ListView.builder(
                                shrinkWrap: true,
                                physics: ScrollPhysics(),
                                itemCount: snapshot.data!.docs.length,

                                itemBuilder: (_,index){
                                  return Column(
                                    children: [
                                      ListTile(
                                        title: Text(snapshot.data!.docs[index]["title"].toString(),),
                                        leading: Icon(Icons.video_call),
                                        subtitle: Container(
                                          child: Text(snapshot.data!.docs[index]["description"].toString(),maxLines: 2,overflow: TextOverflow.ellipsis,),
                                          padding: EdgeInsets.symmetric(vertical: 5),),
                                        tileColor: Colors.white,
                                        trailing: IconButton(
                                          icon: Icon(Icons.delete,color: red,),
                                          onPressed: (){
                                            FirebaseFirestore.instance.collection("Podcasts").doc("safetypodcasts").collection(subcategory).doc(snapshot.data!.docs[index]["key"].toString()).delete()
                                                .then((value) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Item Deleted"))));
                                            setState(()=>{});
                                          },
                                        ),
                                      ),
                                      Container(height: 1,
                                        color: Colors.grey,)
                                    ],
                                  );
                                }),
                          ],
                        );
                      }

                      return Container(
                        child: CircularProgressIndicator(color: pink,),
                      );

                    })
              ],

            ),
          ),
        )
    );
  }




Widget edittexttitle(context) {
  return TextFormField(
    keyboardType: TextInputType.text,
    controller: _title,
    onSaved: (val) => title = val!,
    cursorColor: Colors.grey,
    decoration: InputDecoration(
      border: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey)),
      focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey)),
      labelText: 'Title',
      floatingLabelStyle:
      MaterialStateTextStyle.resolveWith((Set<MaterialState> states) {
        final Color color = states.contains(MaterialState.error)
            ? Theme.of(context).colorScheme.error
            : Colors.orange;
        return TextStyle(color: Colors.black, letterSpacing: 1.3);
      }),
    ),
    validator: (String? value) {

      if (value == null || value == '') {
        return 'Title is Required';
      }
      return null;
    },
  );
}

Widget edittextdesc(context) {
  return TextFormField(
    keyboardType: TextInputType.text,
    controller: _desc,
    onSaved: (val) => desc = val!,
    cursorColor: Colors.grey,
    decoration: InputDecoration(
      border: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey)),
      focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey)),
      labelText: 'Description',
      floatingLabelStyle:
      MaterialStateTextStyle.resolveWith((Set<MaterialState> states) {
        final Color color = states.contains(MaterialState.error)
            ? Theme.of(context).colorScheme.error
            : Colors.orange;
        return TextStyle(color: Colors.black, letterSpacing: 1.3);
      }),
    ),
    validator: (String? value) {

      if (value == null || value == '') {
        return 'Description is Required';
      }
      return null;
    },
  );
}

Widget edittextlink(context) {
  return TextFormField(
    keyboardType: TextInputType.text,
    controller: _link,
    onSaved: (val) => link = val!,
    cursorColor: Colors.grey,
    decoration: InputDecoration(
      border: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey)),
      focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey)),
      labelText: 'Youtube Link',
      floatingLabelStyle:
      MaterialStateTextStyle.resolveWith((Set<MaterialState> states) {
        final Color color = states.contains(MaterialState.error)
            ? Theme.of(context).colorScheme.error
            : Colors.orange;
        return TextStyle(color: Colors.black, letterSpacing: 1.3);
      }),
    ),
    validator: (String? value) {

      if (value == null || value == '') {
        return 'Link is Required';
      }
      return null;
    },
  );
}
}
