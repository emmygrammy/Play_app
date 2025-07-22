import 'package:flutter/material.dart';

class DownloadPage extends StatefulWidget {
  const DownloadPage({super.key});

  @override
  State<DownloadPage> createState() => _DownloadPageState();
}

class _DownloadPageState extends State<DownloadPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Download Page'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Center(
        child: Text(
          'Download functionality will be implemented here.',
          style: TextStyle(fontSize: 20, color: Colors.grey[700]),
        ),
      ),
    );
  }
}