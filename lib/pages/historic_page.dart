import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HistoricPage extends StatefulWidget {
  const HistoricPage({super.key, required this.historic});
  final List<String> historic;
  @override
  State<HistoricPage> createState() => _HistoricPageState();
}

class _HistoricPageState extends State<HistoricPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Histórico", style: GoogleFonts.urbanist(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.yellow[500],
        shadowColor: Colors.black,
        elevation: 2,
      ),
      body: widget.historic.isEmpty? Center(child: Text("Nenhum cálculo realizado", style: GoogleFonts.urbanist(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black)))
      : ListView.builder(itemCount: widget.historic.length, itemBuilder: (context, index){
        return Card(
            margin: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
            child: ListTile(
              leading: CircleAvatar(child: Text("${index+1}")),
              title: Text(widget.historic[index], style: GoogleFonts.urbanist(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black))
            )
          );
      },)
    );
  }
}