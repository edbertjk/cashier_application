import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:marquee/marquee.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: HomePage(),
  ));
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<List> ListData = [];
  int TotalPrice = 0;
  int NoTransaksi = 1;
  List<List> ListBarang = [
    ["Barang Ke 1", 100],
    ["Barang Ke 2", 200],
    ["Barang Ke 3", 300],
    ["Barang Ke 4", 400],
    ["Barang Ke 5", 500],
    ["Barang Ke 6", 600],
    ["Barang Ke 7", 700],
    ["Barang Ke 8", 800],
    ["Barang Ke 9", 900],
    ["Barang Ke 10", 1000]
  ];
  List<BluetoothDevice> devices = [];
  BluetoothDevice? selectedDevice;
  BlueThermalPrinter printer = BlueThermalPrinter.instance;

  String PrintText(String text) {
    if (text.length <= 32) {
      return text;
    }

    // Jika panjang string lebih dari 32, potong dan kembalikan substring 32 karakter pertama
    return text.substring(0, 32);
  }

  void printing(String All, int Total) async {
    if ((await printer.isConnected)!) printer.printNewLine();
    printer.printCustom(PrintText("Warunge Jeje"), 1, 1);
    printer.printCustom(PrintText("PT. Warunge Jeje Poncan"), 1, 1);
    printer.printNewLine();
    printer.printNewLine();
    printer.printNewLine();
    printer.printCustom(
        PrintText("JL. Mangga No E248, Pondok Tjandra, Sidoarjo"), 1, 1);
    printer.printCustom(PrintText("NPWP : 01.338.238.9-045.000"), 1, 1);
    printer.printCustom(
        PrintText("JL. Cendrawasih No 13, Tanjung, Brebes"), 1, 1);
    //max Line = 32
    printer.printCustom(
      PrintText("============================================="),
      1,
      1,
    );
    printer.printCustom(
      "${All}",
      1,
      0,
    );
    printer.printNewLine();
    printer.printCustom(
      "Total: ${Total}",
      1,
      2,
    );
    printer.printCustom(
      PrintText("============================================="),
      1,
      1,
    );
    printer.printCustom(
      PrintText("No Transaksi. $NoTransaksi"),
      1,
      1,
    );
    printer.printCustom(
      PrintText("Terimakasih Telah Berbelanja"),
      1,
      1,
    );
    printer.printCustom(
      PrintText("Kritik Dan Saran = 089604052552"),
      1,
      1,
    );
    printer.printNewLine();
    printer.printNewLine();
    printer.printNewLine();
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    getDevice();
  }

  void getDevice() async {
    devices = await printer.getBondedDevices();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    double screenWidth = mediaQueryData.size.width;
    double screenHeight = mediaQueryData.size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text("Aplikasi Kasir"),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              DropdownButton<BluetoothDevice>(
                hint: Text("Select Printer"),
                value: selectedDevice,
                onChanged: (value) {
                  setState(() {
                    selectedDevice = value;
                  });
                },
                items: devices
                    .map((e) => DropdownMenuItem(
                          child: Text(e.name!),
                          value: e,
                        ))
                    .toList(),
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                  onPressed: () {
                    printer.connect(selectedDevice!);
                  },
                  child: Text("Connect")),
              ElevatedButton(
                  onPressed: () {
                    printer.disconnect();
                  },
                  child: Text("Disconnect")),
            ]),
      ),
      body: Row(
        children: [
          Container(
            width: screenWidth * 0.3,
            height: double.infinity,
            decoration: BoxDecoration(color: Colors.red),
            child: Column(
              children: [
                Container(
                  width: screenWidth * 0.3,
                  height: 100,
                  color: Colors.white,
                  child: Align(
                    alignment: Alignment.center,
                    child: Text("Rp.${TotalPrice.toString()}"),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20),
                  height: 350,
                  width: screenWidth * 0.3,
                  child: ListView.builder(
                    itemCount: ListData.length,
                    itemBuilder: (context, index) {
                      return Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 14),
                            child: Text(
                                "${ListData[index][0]} Rp.${ListData[index][1]}  "),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                ListData[index][2] -= 1;
                                int dataChange = ListBarang[index][1];
                                TotalPrice -= dataChange;
                              });
                            },
                            icon: Icon(Icons.remove),
                            iconSize: 20,
                          ),
                          Text("${ListData[index][2]}"),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                ListData[index][2] += 1;
                                int dataChange = ListBarang[index][1];
                                TotalPrice += dataChange;
                              });
                            },
                            icon: Icon(Icons.add),
                            iconSize: 20,
                          ),
                        ],
                      );
                    },
                  ),
                )
              ],
            ),
          ),
          Container(
            width: screenWidth * 0.70,
            padding: EdgeInsets.symmetric(horizontal: screenHeight * 0.02),
            height: double.infinity,
            decoration: BoxDecoration(color: Colors.blue),
            child: Column(children: [
              //Pay & Search Items
              Container(
                width: screenWidth * 0.66,
                height: 60,
                padding: EdgeInsets.symmetric(horizontal: 1),
                color: Colors.amber,
                child: Row(
                  children: [
                    Container(
                      width: 130,
                      height: 50,
                      margin: EdgeInsets.symmetric(horizontal: 11),
                      child: ElevatedButton(
                          onPressed: () {
                            String AllData = "";
                            int Total = 0;
                            for (int i = 0; i < ListData.length; i++) {
                              AllData +=
                                  "${ListData[i][0]} Rp. ${ListData[i][1]} (${ListData[i][2]})\n";
                              int insert = ListData[i][1];
                              Total += insert;
                            }

                            printing(AllData, Total);
                            NoTransaksi += 1;
                          },
                          child: Text("Bayar Tunai")),
                    ),
                    Container(
                      width: 130,
                      height: 50,
                      margin: EdgeInsets.only(right: 10),
                      child: ElevatedButton(
                          onPressed: () {}, child: Text("Pembayaran Lain")),
                    ),
                    Container(
                      width: 310,
                      height: 50,
                      child: TextField(
                        style: TextStyle(fontSize: 13),
                        decoration: InputDecoration(
                          hintText: 'Search Items',
                        ),
                      ),
                    ),
                    IconButton(
                        onPressed: () {}, icon: Icon(size: 30, Icons.search))
                  ],
                ),
              ),

//List View Categories
              Container(
                margin: EdgeInsets.only(top: 10),
                width: screenWidth * 0.66,
                height: 50,
                padding: EdgeInsets.symmetric(horizontal: 1),
                color: Colors.purple,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 7,
                  itemBuilder: ((context, index) {
                    return Container(
                      width: 240,
                      height: 50,
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5)),
                      child: Align(
                        alignment: Alignment.center,
                        child: ElevatedButton(
                          style: ButtonStyle(
                              minimumSize: MaterialStateProperty.all<Size?>(
                                  Size(240, 50)),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.transparent)),
                          onPressed: () {},
                          child: Text(
                            "Ini Adalah Index Ke $index",
                            style: TextStyle(fontSize: 10),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
              //List View Product
              Container(
                width: screenWidth * 0.66,
                height: 340,
                padding: EdgeInsets.symmetric(horizontal: 1),
                margin: EdgeInsets.only(top: 5),
                child: ListView.builder(
                    itemCount: ListBarang
                        .length, // Ganti dengan jumlah total container yang Anda inginkan
                    itemBuilder: (BuildContext context, int index) {
                      // Hitung indeks baris dan kolo

                      return Container(
                        width: screenWidth * 0.66,
                        height: 55,
                        margin: EdgeInsets.symmetric(vertical: 3),
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  ListData.add([
                                    ListBarang[index][0],
                                    ListBarang[index][1],
                                    1, // Jumlah atau nilai lainnya
                                  ]);
                                  try {
                                    int dataChange = ListBarang[index][1];
                                    TotalPrice += dataChange;
                                  } catch (e) {
                                    // Handle the exception, for example, print an error message.
                                    print('Error parsing integer: $e');
                                  }
                                });
                              },
                              icon: Icon(Icons.add),
                              iconSize: 25,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 25),
                              child: Text(
                                ListBarang[index][0],
                                style: TextStyle(fontSize: 15),
                              ),
                            ),
                            Text(
                              "Rp.${ListBarang[index][1]}",
                              style: TextStyle(fontSize: 15),
                            )
                          ],
                        ),
                      );
                    }),
              ),
            ]),
          )
        ],
      ),
    );
  }
}
