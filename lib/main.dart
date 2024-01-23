import 'package:flutter/material.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/src/client.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Blockchain Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final String targetAddress = "0xdAC17F958D2ee523a2206206994597C13D831ec7";
  EthereumAddress? ethereumAddress;
  Web3Client? client;

  @override
  void initState() {
    super.initState();
    ethereumAddress = EthereumAddress.fromHex(targetAddress);
    connectToBlockchain();
  }

  Future<void> connectToBlockchain() async {
    String rpcUrl =
        "https://goerli.infura.io/v3/a555c4f5ab0a4baf89bcc0e4963c0b3c";
    client = Web3Client(rpcUrl, Client());
  }

  Future<String> getBalances() async {
    final EtherAmount balance = await client!.getBalance(ethereumAddress!);
    return balance.getInEther.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ETH Balance Checker"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FutureBuilder(
              future: getBalances(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text(
                    "Error: ${snapshot.error}",
                  );
                } else {
                  return Text(
                    "Balace: ${snapshot.data} ETH",
                    style: const TextStyle(
                      fontSize: 36,
                    ),
                  );
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
