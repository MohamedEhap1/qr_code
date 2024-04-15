import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

String? scanResult;

class ResultScan extends StatefulWidget {
  const ResultScan({super.key, this.result});
  final String? result;
  @override
  State<ResultScan> createState() => _ResultScanState();
}

class _ResultScanState extends State<ResultScan> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 4, 85, 9),
        foregroundColor: Colors.white,
        title: const Text(
          'Result',
          style: TextStyle(fontSize: 30),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: SelectionArea(
                child: widget.result!.isNotEmpty
                    ? Text(
                        '${widget.result}',
                        style:
                            const TextStyle(color: Colors.black, fontSize: 20),
                      )
                    : const Text(
                        'is Empty',
                        style: TextStyle(color: Colors.black, fontSize: 20),
                      ),
              ),
            ),
            ListTile(
              leading: const Icon(
                Icons.search,
                size: 25,
              ),
              title: const Text(
                'Search on website',
                style: TextStyle(fontSize: 20),
              ),
              splashColor: const Color.fromARGB(255, 4, 85, 9),
              onTap: () async {
                try {
                  // ignore: deprecated_member_use
                  await launch(widget.result!);
                } catch (e) {
                  // ignore: use_build_context_synchronously
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      duration: const Duration(days: 1),
                      content: const Text('can\'t search for this Uri!!!'),
                      action: SnackBarAction(label: "close", onPressed: () {}),
                    ),
                  );
                  // ignore: deprecated_member_use
                  //  launch('https://www.google.com/index.html');
                }
                setState(() {});
              },
            ),
          ],
        ),
      ),
    );
  }
}
