import 'dart:io';

import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


import 'package:http/http.dart' as http;

import 'package:markdown_widget/markdown_widget.dart';

import 'package:hadwin/utilities/display_error_alert.dart';
import 'package:hadwin/utilities/url_external_launcher.dart';

class HadWinMarkdownViewer extends StatefulWidget {
  final String screenName;
  final String urlRequested;
  const HadWinMarkdownViewer(
      {Key? key, required this.screenName, required this.urlRequested});
  @override
  HadWinMarkdownViewerState createState() => HadWinMarkdownViewerState();
}

class HadWinMarkdownViewerState extends State<HadWinMarkdownViewer> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            widget.screenName,
            style: TextStyle(fontSize: 24),
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          foregroundColor: Color(0xff243656),
          elevation: 0,
        ),
        body: Column(
      
            children: [
              Expanded(
                child: Container(
                  height: 100,
                  width: MediaQuery.of(context).size.width - 20,
                  padding: EdgeInsets.only(
                      left: 16.18, right: 16.18, bottom: 16.18, top: 6.18),
                  child: FutureBuilder(
                      future: getTextData(widget.urlRequested),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return MarkdownWidget(
                            data: '''${snapshot.data}''',
                            config: MarkdownConfig.darkConfig
                          );
                        }
                        return docsLoading();
                      }),
                ),
              )
            ]));
  }

  Future<String> getTextData(String url) async {
    var response;
    try {
      response = await http.get(Uri.parse(url));
    } on SocketException {
      showErrorAlert(
          context, {'internetConnectionError': 'no internet connection'});
    } catch (e) {
      showErrorAlert(context, {'error': "something went wrong"});
    }
    return response.body;
  }

  Widget docsLoading() {
    return ListView.separated(
        itemBuilder: (context, index) {
          return Column(
          
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: FadeShimmer(
                  height: 27,
                  width: 100,
              
                  radius: 7.2,
                  highlightColor: Color(0xffced4da),
                  baseColor: Color(0xffe9ecef),
                ),
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 1.618),
              ),
              ...List.generate(
                  4,
                  (i) => Container(
                        child: FadeShimmer(
                          height: 21,
                          width: MediaQuery.of(context).size.width - 24,
                       
                          radius: 7.2,
                          highlightColor: Color(0xffced4da),
                          baseColor: Color(0xffe9ecef),
                        ),
                        padding: EdgeInsets.symmetric(
                            horizontal: 5, vertical: 1.618),
                      )).toList(),
            ],
          );
        },
        separatorBuilder: (_, b) => SizedBox(
              height: 10,
            ),
        itemCount: 5);
  }
}
