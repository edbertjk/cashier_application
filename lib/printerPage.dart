import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/material.dart';

void main(){
  runApp(PrinterPage());
}

class PrinterPage extends StatefulWidget {
  const PrinterPage({super.key});

  @override
  State<PrinterPage> createState() => _PrinterPageState();
}

class _PrinterPageState extends State<PrinterPage> {
  List<BluetoothDevice> devices = [];
  BluetoothDevice? selectedDevice;
  BlueThermalPrinter printer = BlueThermalPrinter.instance;

  @override
  void initState() {
    super.initState();
    getDevice();
  }

  void getDevice() async {
    devices = await printer.getBondedDevices();
    setState(() {});
  }

  String PrintText(String text) {
    if (text.length <= 32) {
      return text;
    }

    // Jika panjang string lebih dari 32, potong dan kembalikan substring 32 karakter pertama
    return text.substring(0, 32);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Aplikasi Kasir"),
        ),
        body: Column(children: [
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
          ElevatedButton(
              onPressed: () async {
                if ((await printer.isConnected)!) printer.printNewLine();
                printer.printCustom(PrintText("Warunge Jeje"), 1, 1);
                printer.printCustom(PrintText("PT. Warunge Jeje Poncan"), 1, 1);
                printer.printNewLine();
                printer.printNewLine();
                printer.printNewLine();
                printer.printCustom(
                    PrintText("JL. Mangga No E248, Pondok Tjandra, Sidoarjo"),
                    1,
                    1);
                printer.printCustom(
                    PrintText("NPWP : 01.338.238.9-045.000"), 1, 1);
                printer.printCustom(
                    PrintText("JL. Cendrawasih No 13, Tanjung, Brebes"), 1, 1);
                //max Line = 32
                printer.printCustom(
                  PrintText("============================================="),
                  1,
                  1,
                );
                printer.printNewLine();
                printer.printNewLine();
                printer.printNewLine();
                printer.printNewLine();
              },
              child: Text("Print")),
        ]),
      ),
    );
  }
}
