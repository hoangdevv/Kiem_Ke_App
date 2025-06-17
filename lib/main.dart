import 'package:flutter/material.dart';
import 'package:ftpconnect/ftpconnect.dart';
import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kiểm Kê App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Kiểm Kê Hàng'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController _barcodeController = TextEditingController();
  TextEditingController _quantityController = TextEditingController();
  bool _isSyncing = false;

  Future<void> _saveToLocal() async {
    final prefs = await SharedPreferences.getInstance();
    final data = '${_barcodeController.text},${_quantityController.text}';
    final existingData = prefs.getStringList('inventory_data') ?? [];
    existingData.add(data);
    await prefs.setStringList('inventory_data', existingData);
  }

  Future<void> _syncToFTP() async {
    setState(() {
      _isSyncing = true;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final data = prefs.getStringList('inventory_data') ?? [];
      final content = data.join('\n');

      // Tạo file tạm thời để upload
      final tempDir = await Directory.systemTemp.createTemp();
      final tempFile = File('${tempDir.path}/inventory_data.txt');
      await tempFile.writeAsString(content);

      final ftpClient = FTPConnect(
        'your_ftp_server',
        user: 'username',
        pass: 'password',
        port: 21,
      );

      await ftpClient.connect();
      await ftpClient.uploadFile(tempFile);
      await ftpClient.disconnect();

      // Xóa file tạm sau khi upload xong
      await tempFile.delete();
      await tempDir.delete();

      // Xóa dữ liệu đã đồng bộ
      await prefs.setStringList('inventory_data', []);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi đồng bộ: $e')),
      );
    } finally {
      setState(() {
        _isSyncing = false;
      });
    }
  }

  void _onConfirmPressed() async {
    if (_barcodeController.text.isEmpty || _quantityController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Vui lòng nhập đầy đủ thông tin')),
      );
      return;
    }

    await _saveToLocal();

    // Clear textboxes
    _barcodeController.clear();
    _quantityController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Đã lưu thành công')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: _isSyncing
                ? CircularProgressIndicator(color: Colors.white)
                : Icon(Icons.sync),
            onPressed: _isSyncing ? null : _syncToFTP,
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: _barcodeController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Mã sản phẩm',
                ),
              ),
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: _quantityController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Số lượng',
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _onConfirmPressed,
              child: Text('Xác nhận'),
            ),
          ],
        ),
      ),
    );
  }
}
