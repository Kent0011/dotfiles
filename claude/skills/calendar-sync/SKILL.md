---
name: calendar-sync
description: TimeTreeの予定をGoogleカレンダーに一方向で同期するスキル。TimeTreeはPlaywright MCPでブラウザから取得し、GoogleカレンダーはGoogle Calendar plugin（`mcp__ae799bff-f066-4794-b3bc-8b7c9f178db7__*`）から読み書きする。「カレンダー同期」「TimeTreeをGoogleカレンダーに反映」「予定を同期」「スケジュール同期」「カレンダーの予定を合わせたい」など、TimeTreeとGoogleカレンダーの同期に関連する発言があれば、このスキルを使うこと。
---

# TimeTree→Googleカレンダー同期スキル

TimeTreeの予定をGoogleカレンダーへ一方向で同期する。今日から1ヶ月先までの予定を対象とし、TimeTreeにのみ存在する予定をGoogleカレンダーに作成する。Googleカレンダー側にしかない予定はTimeTreeに反映しない（一方向同期）。

## 前提条件

- Playwright MCPが利用可能であること（TimeTree取得用）
- Google Calendar plugin（`mcp__ae799bff-f066-4794-b3bc-8b7c9f178db7__*`）が利用可能で認証済みであること
- TimeTreeにブラウザからアクセスできること

## 同期の流れ

### Step 1: Googleカレンダーから予定を取得

Google Calendar pluginを利用する。ブラウザ操作は行わない。

1. `mcp__ae799bff-f066-4794-b3bc-8b7c9f178db7__list_events` を呼び出し、`startTime` を今日（00:00）、`endTime` を1ヶ月先（23:59）に指定して予定を取得する
2. 必要に応じて `pageToken` を使い、対象期間内の全予定を取得する
3. 各予定について以下の情報を保持する：
   - タイトル（`summary`）
   - 開始日時（`start.dateTime` または `start.date`）
   - 終了日時（`end.dateTime` または `end.date`）
   - 終日かどうか（`start.date` のみ存在する場合は終日）

複数のカレンダーを横断して同期したい場合は、`list_calendars` で取得した `calendarId` ごとに `list_events` を実行する。指定が無い場合はプライマリカレンダーのみを対象とする。

### Step 2: TimeTreeから予定を取得

1. `browser_navigate` で `https://timetreeapp.com/calendars` を開く
2. `browser_snapshot` でページの状態を確認する
3. **ログインチェック**: ログイン画面が表示された場合は、ユーザーに以下を伝えて手動ログインを依頼する：
   - 「TimeTreeにログインしていません。ブラウザでログインしてください。完了したら教えてください。」
   - ユーザーが完了を報告するまで待機する
4. 全てのカレンダーを対象として予定を取得する
5. 月表示を使い、今日から1ヶ月先までの予定を収集する
6. 各予定について以下の情報を収集する：
   - タイトル
   - 開始日時
   - 終了日時
   - 終日かどうか
   - 予定の色

**色によるフィルタリング**: TimeTreeでは予定ごとに色が設定されている。同期対象は**青・紫・緑・黄色**の予定のみ。**赤・ピンク**の予定は無視して取得対象から除外すること。予定の色はDOM要素のスタイルや属性から判定する。

**効率的な取得方法**: `browser_run_code` でDOMから直接予定データを抽出するのが最も効率的。スナップショットだけでは全予定を取得しきれない場合がある。月表示でスクロールしながら段階的にデータを収集する。

### Step 3: 差分を特定する

両方の予定リストを比較し、**TimeTreeにのみ存在する予定**を特定する。これがGoogleカレンダーに作成する対象となる。

**一致判定の基準**: タイトルと日時（開始・終了）が一致する予定は「同じ予定」と判断する。

- TimeTreeにのみ存在する予定 → Googleカレンダーに作成する対象
- Googleカレンダーにのみ存在する予定 → **何もしない**（一方向同期のため、TimeTreeへの反映は行わない）

差分の一覧（Googleに作成予定の予定）をユーザーに提示し、確認を取ってから次のステップに進む。これは意図しない予定の作成を防ぐために重要。

### Step 4: Googleカレンダーに予定を作成する

各対象予定について、`mcp__ae799bff-f066-4794-b3bc-8b7c9f178db7__create_event` を呼び出して作成する。

- `summary`: TimeTreeの予定タイトル
- `startTime` / `endTime`: ISO 8601形式（例: `2026-04-25T14:00:00`）
- `timeZone`: `Asia/Tokyo`（必須項目）
- `allDay`: 終日予定の場合は `true`。終日予定の `startTime`/`endTime` は仕様上UTCの00:00を指定する

特定のカレンダーに作成したい場合は `calendarId` を指定する。指定しない場合はプライマリカレンダーに作成される。

### Step 5: 結果を報告する

同期結果をユーザーに報告する：

- Googleカレンダーから取得した予定の数
- TimeTreeから取得した予定の数（フィルタ後）
- Googleカレンダーに新規作成した予定の一覧
- Googleにのみ存在し同期しなかった予定の件数（参考情報）
- エラーがあった場合はその内容

## 注意事項

- TimeTreeのUIは変更される可能性がある。`browser_snapshot` で常に現在の状態を確認してから操作すること
- 予定の作成前に必ずユーザーに差分一覧を見せて確認を取ること
- 日時のタイムゾーンに注意する。TimeTreeから取得した時刻は `Asia/Tokyo` として扱い、`create_event` でも同タイムゾーンを指定する
- 大量の予定がある場合は `list_events` の `pageToken` やTimeTree側のスクロールで全件取得する
- 操作中にエラーが発生した場合は、その時点でユーザーに報告し、続行するか確認する
- 一方向同期のため、Googleカレンダー側で削除・編集された予定がTimeTreeに反映されることはない
