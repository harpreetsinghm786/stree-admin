import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


const pink=Color(0xFFEE4D9B);
const white=Color(0xFFFFFFFF);
const purpal=Color(0xFF49091D);
const red=Color(0xFFFF0000);
const lightgray=Color(0xFFC5C5C5);
const black=Color(0xFF000000);
const textblue=Color(0xFF1666A1);
const darkpink=Color(0xFFB40358);
const lightpink=Color(0xFFF18DBA);


TextStyle loginhead(double size,FontWeight w,Color c1){
  return GoogleFonts.newsreader(fontSize: size,fontWeight: w,color: c1);
}

TextStyle heading(){
  return TextStyle(
      fontSize: 18, color: black, fontWeight: FontWeight.w500);
}

TextStyle titlestyle(){
  return TextStyle(
      fontSize: 18, color: white, fontWeight: FontWeight.w500);
}
const defaultpadding= 20.0;
const defaultduration=Duration(seconds: 2);
