# CLAUDE.md

このファイルは、Claude Code (claude.ai/code) がこのリポジトリでコードを扱う際のガイダンスを提供します。

## プロジェクト概要

ダーツゲーム用のBluetooth Low Energy (BLE) 接続を提供するFlutterアプリケーションです。アプリはモバイル（Android/iOS）とWebプラットフォームの両方をサポートし、それぞれ異なるBluetooth実装を使用します。

## 主要コマンド

### 開発コマンド
- `flutter pub get` - 依存関係のインストール
- `flutter run` - 接続されたデバイス/エミュレータでアプリを実行
- `flutter run -d chrome` - Webブラウザで実行
- `flutter test` - ウィジェットテストを実行
- `flutter analyze` - 静的解析とリンティングを実行
- `flutter build apk` - Android APKをビルド
- `flutter build web` - Web版をビルド

### プラットフォーム固有のテスト
- `flutter run -d android` - Androidデバイスで実行
- `flutter run -d ios` - iOSデバイス/シミュレータで実行
- `flutter run -d web-server` - ホットリロード付きのWeb版を実行

## アーキテクチャ

### コアコンポーネント

1. **BluetoothManager** (`lib/bluetooth_manager.dart`) - プラットフォーム固有のBluetooth実装を作成する抽象ファクトリー：
   - `MobileBluetoothManager` - Android/iOS用に`flutter_bluetooth_serial`を使用
   - `WebBluetoothManager` - Webブラウザ用に`flutter_web_bluetooth`を使用

2. **メインアプリケーション** (`lib/main.dart`) - 以下を含むメインUI：
   - 接続状態の表示
   - デバイスの発見とペアリング
   - 接続されたダーツボードからのリアルタイムデータ表示
   - 自動スクロールデータフィード

3. **UIウィジェット** (`lib/widgets/bluetooth_widgets.dart`)：
   - `BluetoothDeviceList` - 利用可能/ペアリング済みデバイスを表示
   - `DataDisplayWidget` - 受信したダーツ投射データを表示
   - `ConnectionStatusWidget` - 接続状態を表示

4. **データマッピング** (`lib/data.dart`) - DartsLive Homeデバイスプロトコル用のhex-to-dart-boardマッピングを含む

### プラットフォーム検出
`universal_platform`パッケージを使用してランタイムプラットフォームを検出し、適切なBluetoothマネージャーをインスタンス化します。

### Bluetoothプロトコル
- **サービスUUID**: `6e400001-b5a3-f393-e0a9-e50e24dcca9e`
- **キャラクタリスティックUUID**: `6e40fff6-b5a3-f393-e0a9-e50e24dcca9e`
- データフォーマット: ダーツボード位置（シングル、ダブル、トリプル、ブル）にマップされたHexコード

### 主要な依存関係
- `flutter_bluetooth_serial` - モバイルBluetooth Classic/シリアル通信
- `flutter_web_bluetooth` - Web Bluetooth APIラッパー
- `permission_handler` - Android/iOS権限管理
- `universal_platform` - クロスプラットフォーム検出

## テスト

プロジェクトはFlutterの標準テストフレームワークを使用しています。`test/widget_test.dart`の既存のテストはテンプレートであり、実際のBluetooth機能をテストするように更新する必要があります。

## 開発メモ

- モバイル版はペアリング済みデバイスを使用、Web版はデバイス発見を使用
- すべての受信データはタイムスタンプ付きでリアルタイムに表示
- 接続状態はストリームと状態管理によって管理
- アプリは接続と切断の両方のシナリオを処理
- データ解析はDartsLive Homeプロトコルフォーマットに固有