import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Harcamalar Takibi',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HarcamalarEkrani(),
    );
  }
}

class HarcamalarEkrani extends StatefulWidget {
  @override
  _HarcamalarEkraniState createState() => _HarcamalarEkraniState();
}

class _HarcamalarEkraniState extends State<HarcamalarEkrani> {
  List<Harcama> harcamalar = [];
  double toplamHarcama = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Harcamalar'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: harcamalar.length,
              itemBuilder: (context, index) {
                final harcama = harcamalar[index];
                return Card(
                  child: ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tarih: ${_formatTarih(harcama.tarih)}',
                          style: TextStyle(
                            color: Colors.deepPurple,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Açıklama: ${harcama.aciklama}',
                          style: TextStyle(
                            color: Colors.deepPurple,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Fiyat: ${_formatFiyat(harcama.miktar)}',
                          style: TextStyle(
                            color: Colors.deepPurple,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        setState(() {
                          toplamHarcama -= harcama.miktar;
                          harcamalar.removeAt(index);
                        });
                      },
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Toplam Harcama: ${_formatFiyat(toplamHarcama)}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _harcamaEkleDialog(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  String _formatTarih(DateTime tarih) {
    return '${tarih.day}/${tarih.month}/${tarih.year} ${tarih.hour}:${tarih.minute}';
  }

  String _formatFiyat(double miktar) {
    return '${miktar.toStringAsFixed(2)} TL';
  }

  void _harcamaEkleDialog(BuildContext context) {
    TextEditingController miktarController = TextEditingController();
    TextEditingController aciklamaController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Yeni Harcama Ekle'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: miktarController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(labelText: 'Miktar'),
              ),
              TextField(
                controller: aciklamaController,
                decoration: InputDecoration(labelText: 'Açıklama'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('İptal'),
            ),
            TextButton(
              onPressed: () {
                double miktar = double.tryParse(miktarController.text) ?? 0.0;
                String aciklama = aciklamaController.text;
                setState(() {
                  harcamalar.add(Harcama(DateTime.now(), miktar, aciklama));
                  toplamHarcama += miktar;
                });
                Navigator.of(context).pop();
              },
              child: Text('Ekle'),
            ),
          ],
        );
      },
    );
  }
}

class Harcama {
  final DateTime tarih;
  final double miktar;
  final String aciklama;

  Harcama(this.tarih, this.miktar, this.aciklama);
}
