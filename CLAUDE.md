# CLAUDE.md

このファイルは、Claude Code (claude.ai/code) がこのリポジトリでコードを扱う際のガイダンスを提供します。

## プロジェクト概要

ダーツゲーム用のBluetooth Low Energy (BLE) 接続を提供するFlutterアプリケーションです。アプリはモバイル（Android/iOS）とWebプラットフォームの両方をサポートし、それぞれ異なるBluetooth実装を使用します。

RiverpodとFreezedを使用したfeature-based architectureで構築されています。

## 主要コマンド

### 開発コマンド
- `flutter pub get` - 依存関係のインストール
- `flutter packages pub run build_runner build` - FreezedとRiverpodのコード生成
- `flutter packages pub run build_runner build --delete-conflicting-outputs` - コンフリクト解決付きコード生成
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

### Feature-Based Directory Structure
```
lib/
├── features/
│   ├── bluetooth/
│   │   ├── data/           # BluetoothNotifier (Riverpod)
│   │   ├── domain/         # BluetoothState, BluetoothDevice (Freezed)
│   │   └── presentation/   # UI Components
│   └── count_up/
│       ├── data/           # CountUpGameNotifier (Riverpod)
│       ├── domain/         # CountUpGame (Freezed)
│       └── presentation/   # UI Components
├── shared/
│   ├── models/            # 共通モデル (DartThrow)
│   ├── providers/         # 共通プロバイダー
│   └── utils/             # ユーティリティ
└── core/                  # アプリケーションコア設定
```

### 状態管理 (Riverpod)
- **BluetoothNotifier** (`lib/features/bluetooth/data/bluetooth_provider.dart`) - Bluetooth接続状態管理
- **CountUpGameNotifier** (`lib/features/count_up/data/count_up_provider.dart`) - カウントアップゲーム状態管理

### データモデル (Freezed)
- **BluetoothState** - 接続状態、デバイス一覧、受信データ
- **BluetoothDeviceInfo** - デバイス情報
- **CountUpGame** - ゲーム状態（ラウンド、投射、スコア）
- **DartThrow** - ダーツ投射データ

### UI コンポーネント
- **BluetoothScreen** - メインBluetooth接続画面
- **GameScreen** - ゲーム選択画面
- **CountUpGameScreen** - カウントアップゲーム画面
- **各種ウィジェット** - 再利用可能なUIコンポーネント

### プラットフォーム検出
`universal_platform`パッケージを使用してランタイムプラットフォームを検出し、適切なBluetoothマネージャーをインスタンス化します。

### Bluetoothプロトコル
- **サービスUUID**: `6e400001-b5a3-f393-e0a9-e50e24dcca9e`
- **キャラクタリスティックUUID**: `6e40fff6-b5a3-f393-e0a9-e50e24dcca9e`
- データフォーマット: ダーツボード位置（シングル、ダブル、トリプル、ブル）にマップされたHexコード

### 主要な依存関係
- `flutter_riverpod` - 状態管理
- `riverpod_annotation` - Riverpodアノテーション
- `freezed` - イミュータブルなデータクラス
- `flutter_bluetooth_serial` - モバイルBluetooth Classic/シリアル通信
- `flutter_web_bluetooth` - Web Bluetooth APIラッパー
- `permission_handler` - Android/iOS権限管理
- `universal_platform` - クロスプラットフォーム検出

## テスト

プロジェクトはFlutterの標準テストフレームワークを使用し、RiverpodのProviderScopeでラップされています。

## 開発メモ

- モバイル版はペアリング済みデバイスを使用、Web版はデバイス発見を使用
- すべての受信データはタイムスタンプ付きでリアルタイムに表示
- 状態管理はRiverpodでリアクティブに管理
- データモデルはFreezedで型安全に定義
- Feature-based architectureで機能ごとに分離
- アプリは接続と切断の両方のシナリオを処理
- データ解析はDartsLive Homeプロトコルフォーマットに固有