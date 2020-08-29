# 使い方
## Dockerコマンド
以下、cloneしたディレクトリ直下にてコマンド実行

```
$ docker-compose build
$ docker-compose up -d
$ docker exec -it rails-docker.web /bin/bash
```

## MySQLへ接続するには
下記コマンドで接続

```
$ mysql -uroot -p -h0.0.0.0 -P3316
```

もしくは下記接続情報でWorkbench等で接続
- ホスト：0.0.0.0
- ポート：3316
- ユーザ：root
- パスワード：pasword

## ブラウザでアクセスするには

```
http://localhost:3000/
```
