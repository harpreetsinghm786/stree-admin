import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:streeadmin/Videos.dart';
import 'package:video_thumbnail_imageview/video_thumbnail_imageview.dart';

import '../constants.dart';

class Subcategorywidget extends StatefulWidget {
  String subcategory;
  Subcategorywidget({Key? key,required this.subcategory}) : super(key: key);

  @override
  State<Subcategorywidget> createState() => _SubcategorywidgetState(subcategory: subcategory);

}

class _SubcategorywidgetState extends State<Subcategorywidget> {

  Videos? video;
  String? title,desc,link;
  TextEditingController? _link,_title,_desc;

  final _formKey = GlobalKey<FormState>();
  String key="";
  bool disable=false;
  String subcategory="";
  _SubcategorywidgetState({required this.subcategory});

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _link=new TextEditingController();
    _title=new TextEditingController();
    _desc=new TextEditingController();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
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

                                          FirebaseFirestore.instance.collection("Podcasts").doc("safetypodcasts").collection(subcategory).doc(key).set({
                                            "title":title,
                                            "description":desc,
                                            "link":link,
                                            "key":key,
                                            "likes":[]
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
                    stream: FirebaseFirestore.instance.collection("Podcasts").doc("safetypodcasts").collection(subcategory).snapshots(),
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
                                    leading: Image.asset("assets/images/youtube.png",width: 50,),
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
