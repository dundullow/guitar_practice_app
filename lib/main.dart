
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Guitar Practice',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Guitar Practice'),
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
  // 入力欄のコントローラ（破棄忘れ防止のためStateのメンバに）
  final TextEditingController practiceMinutesController =
      TextEditingController();

  // 今日の練習分数（UI表示用の状態）
  int todayPracticeMinutes = 0;

  // 保存ボタン押下時の処理
  void _saveTodayPracticeMinutes() {
    final inputText = practiceMinutesController.text.trim();

    // 数値以外や負数をはじく（分かりやすいバリデーション）
    final parsed = int.tryParse(inputText);
    final validMinutes = (parsed != null && parsed >= 0) ? parsed : 0;

    // キーボードを閉じる
    FocusScope.of(context).unfocus();

    setState(() {
      todayPracticeMinutes = validMinutes;
    });
  }

  @override
  void dispose() {
    // メモリリーク防止
    practiceMinutesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentDate = DateTime.now();
    final formattedDate = DateFormat('yyyy年MM月dd日').format(currentDate);

    // 仮の開始日
    final startDate = DateTime(2025, 9, 10);

    // 年月日のみ比較するよう日付を揃える
    final currentDateCompare =
        DateTime(currentDate.year, currentDate.month, currentDate.day);
    final startDateCompare =
        DateTime(startDate.year, startDate.month, startDate.day);
    // 練習日数（開始日を1日目として数える）
    final practiceDayCount =
        currentDateCompare.difference(startDateCompare).inDays + 1;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: SingleChildScrollView(
          // 小さい端末でも崩れないように
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text('ようこそ！ギター練習管理アプリへ'),
              const SizedBox(
                height: 8,
              ),
              Text(
                formattedDate,
                style: const TextStyle(fontSize: 20),
              ),
              Text(
                '練習開始から $practiceDayCount 日目',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(
                height: 20,
              ), // 余白を追加
              // 今日の練習時間表示
              Text('今日の練習時間: $todayPracticeMinutes 分', style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 12),

              // 入力欄
              SizedBox(
                width: 220,
                child: TextField(
                  controller: practiceMinutesController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: '練習時間（分）',
                    hintText: '例: 30',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // 保存ボタン
              ElevatedButton(
                onPressed: _saveTodayPracticeMinutes,
                child: const Text('保存'),
              ),

              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(onPressed: () {}, child: const Text('練習開始')),
                  ElevatedButton(onPressed: () {}, child: const Text('記録確認')),
                  OutlinedButton(onPressed: () {}, child: const Text('設定')),
                ],
              ),
            ],
          ),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
