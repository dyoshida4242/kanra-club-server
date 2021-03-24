# kanra-club-server for docker

## 開発環境の構築

### Dockerを設定
マシンの環境に応じてDockerの実行環境をダウンロード

#### Desktop
- [Install Docker Desktop for Mac](https://docs.docker.com/docker-for-mac/install/)
- [Install Docker Desktop for Windows](https://docs.docker.com/docker-for-windows/install/)

#### Server
- [Server](https://docs.docker.com/install/): 遷移ページのServer項目を参照


- Dockerの実行環境がインストール出来ているか確認するには、以下を実行してみてください。
```bash
$ docker --version
$ docker run hello-world
```

問題なければ、`docker image ls`でイメージがダウンロードされているか確認できます。

#### 【参考】
- `~/.bashrc` などに下記のようなaliasを追加すると幸せになります(タブン)

```.bashrc
[ -s "/usr/local/bin/docker-machine" ] && docker-machine ip default > /dev/null 2>&1 && eval "$(docker-machine env default)"
alias do="docker"
alias docm="docker-compose"
alias dom="docker-machine"
alias dom-start="docker-machine start default && eval \"\$(docker-machine env default)\""
alias dom-restart="docker-machine restart default && eval \"\$(docker-machine env default)\""
alias dom-env="eval \"\$(docker-machine env default)\""
```

### 環境変数を設定
- 以下sampleファイル郡をコピーして環境変数用ファイルを作成

```bash
$ cp .env.sample .env
$ cp .config/database.yml.sample database.yml
```

## 初期設定

### 開発用・テスト用DB作成

```bash
$ cd kanra-club-server
$ sh docker/init_docker.sh
```

## 開発時のコマンド

### 開発用サーバを起動
```bash
docker-compose up
```

### 開発用サーバをブラウザで開く
```bash
open http://0.0.0.0:3000
```

### Gemfileの更新
```bash
$ docker-compose run --rm app bundle install
```

ただし、`containers/*`を更新したときは、

```bash
$ docker-compose build
```
を実行すること

### Gemfileでrubyのバージョンを変更したとき
```bash
$ docker-compose build
$ docker-compose run --rm app /bin/bash
$ gem pristine --all
```

### 開発環境のコンテナを削除
```bash
$ docker-compose rm -v
```

- 現在のバージョンを含め、これでデータが全部消えます
- Dockerのバージョン上げた時は一度消すのがオススメです

### オールテスト
```bash
$ docker-compose run -e RAILS_ENV=test --rm app bundle exec rspec
```

### テスト用データ投入
```bash
$ docker-compose run --rm app bundle exec rake db:seed
```

### Containerの中に入る
```bash
## ash
$ docker-compose run --rm app /bin/ash
## bash
$ docker-compose run --rm app /bin/bash
```

### その他実行コマンド


**【コンテナをビルドする】**

`$ docker-compose build`


**【マイグレーション関連を実行したい時】**

`$ docker-compose run --rm app bundle exec rake db:migrate`

`$ docker-compose run --rm app bundle exec rake db:migrate:reset`

**【seedを実行したい時】**

`$ docker-compose run --rm app bundle exec rake db:seed`

**【コンテナ内に入って操作をしたいとき**

`$ docker-compose run --rm app /bin/bash`

**【RSpecを走らせたいとき】**

`$ docker-compose run -e RAILS_ENV=test --rm app bundle exec rspec`

**【rails consoleを使いたい時】**
`$ docker-compose run --rm app bundle exec rails c`

**【docker環境でbinding.pryでデバッグしたい】**

**一番簡単な方法**
`$ docker-compose run --service-ports app`

**標準な方法**

- デバッグポイントにbinding.pryを埋め込む
- デバッグしたいページで処理を走らせる
- `docker-compose up`を行っているターミナルウィンドウとは別のウィンドウを開く
- `docker ps`で実行中containerのIDを確認

以下のコマンドでデバッグ対象containerにattachする
**【参考】**

`$ docker attach 17c5fbc3713c(参考)`

あとは通常通りpry-byebugのコマンドが使えます

**【docker psで表示する内容を絞り込む】**

$ docker ps --format "table {{psで表示するカラム名}}"

#### 例
$ docker ps --format "table {{.ID}} {{.Names}} {{.Ports}} {{.Size}}"


【指定できるフォーマット一覧】

https://docs.docker.com/engine/reference/commandline/ps/#formatting


**【シェルスクリプトを使って初期設定を行う】**

`$ sh docker/init_docker.sh`

**【シェルスクリプトを使って、コンテナ環境をリセットする】**

`$ sh docker/reset_docker.sh`

**【現在のコンテナサイズを確認する】**

`$ docker ps --format "table {{psで表示するカラム名}}"`

#### 例
$ docker ps --format "table {{.ID}} {{.Names}} {{.Ports}} {{.Size}}"
