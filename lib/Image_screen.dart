
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';


class ImageUpload extends StatefulWidget {
  const ImageUpload({Key? key}) : super(key: key);

  @override
  State<ImageUpload> createState() => _ImageUploadState();
}


class _ImageUploadState extends State<ImageUpload> {

  File? image;
  final _picker = ImagePicker();
  bool showSpinner = false;

  Future pickImage()async{
    final pickedFile =await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);

    if (pickedFile != null){
      image = File(pickedFile.path);
      setState(() {

      });

    }else{
   print("no Image Selected.");
    }
  }

  Future uploadImage()async{
    setState(() {
      showSpinner = true;
    });
    
    var stream = http.ByteStream(image!.openRead());
    stream.cast();

    var length = await image!.length();
    var uri = Uri.parse('https://fakestoreapi.com/products');

    var request = http.MultipartRequest('POST', uri);
    request.fields['title'] = "Static Title";

    var multiport = http.MultipartFile(
      'image',
       stream,
      length,
    );

    request.files.add(multiport);

    var response = await request.send();

    if(response.statusCode == 200){
      setState(() {
        showSpinner = false;
      });
      print("Image Uploaded Successfully.");
    }
    else{
      setState(() {
        showSpinner = false;
      });
      print("Failed to Upload.");
    }
  }



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(child: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.purple,
            title: const Center(child: Text("Image Upload"),),
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: (){
                  pickImage();
                },
                child: Container(
                  child: image == null ? const Center(child: Text("Pick an Image")):Center(
                      child: Image.file(
                        File(image!.path).absolute,
                        height: 200,
                        width: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
              ),
const SizedBox(height: 30.0,),
              GestureDetector(
                onTap: (){
                  uploadImage();
                },
                child: Container(
                  height: 50.0,
                  decoration:BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
    child: const Center(child: Text("Upload", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30,),)),
    ),
              ),
            ],
          ),
        ),
      ),),
    );
  }
}
