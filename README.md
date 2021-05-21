# :whale:otapick-demo-environment:whale2:

## :deciduous_tree:Description

[ヲタピック](https://otapick.com)のローカル上のデモ環境を Docker(docker-compose)で提供し、本 readme ではその構築方法を記します。

デモ環境では最低限の機能のみ提供し、一部の機能(ユーザ認証等)に関してはセキュリティ上対応を見送っております。
また、Windows HOME の Docker toolbox をご使用されている環境では、127.0.0.1 にアクセスできない関係で本構築方法は未対応となっております。ご理解の程よろしくお願いいたします。

<font color="dimgray">
A local demo environment of [otapick](https://otapick.com) is provided in Docker (docker-compose), and this readme describes how to build it.

In the demo environment, only the minimum functionality is provided, and some functions (such as user authentication) are not supported for security reasons. Also, if you are using the Docker toolbox on Windows HOME, you will not be able to access 127.0.0.1, so this method is not supported. Thank you for your understanding.
</font>

## :rainbow:Directory structure

[ヲタピックのリポジトリ](https://github.com/kensan914/otapick)のディレクトリ構成を示します。

<font color="dimgray">
The directory structure of [otapick repository](https://github.com/kensan914/otapick) is shown below.
</font>

### backend

Django Rest Framework(DRF)を使用した Web API になります。

<font color="dimgray">
This is a Web API using Django Rest Framework (DRF).
</font>

```
otapick/
  ├ account/    # カスタムアカウント担当App
  ├ api/    # modelを持たないview専用App
  ├ config/    # 設定
  ├ image/    # 画像担当App
  ├ main/    # ブログ・グループ・メンバー担当App
  ├ survey/    # アンケート担当App
  ├ templates/    # Django template
  ├ manage.py
  └ otapick/
      ├ crawlers    # スクレイピング・DOMパーサ
      ├ db    # ブログクローラ・スコア計算・ORマッパー共通処理
      ├ downloaders    # 画像・テキストDL
      ├ extensions    # 拡張views・拡張serializers
      ├ image    # 画像処理
      ├ lib    # ユーティリティ・定数・URLパーサ
      └ twitter    # ヲタピックTwitter bot
```

### frontend

React を用いた SPA になります。バンドラに webpack、コンパイラに Babel、静的構文解析に ESLint、コードフォーマッタに Prettier を使用しています。一部のユーティリティ関数に対してテストコードを用意しています。また、Atomic Design に基づいたディレクトリ構成となっております。

<font color="dimgray">
This is a SPA using React. It uses webpack as a bundler, Babel as a compiler, ESLint for static parsing, and Prettier as a code formatter. Test code is provided for some utility functions. Also, the directory structure is based on Atomic Design.
</font>

```
otapick/
  └ frontend/
      ├ src
      │   ├ __test__/
      │   ├ components/
      │   │   ├ atoms/
      │   │   ├ molecules/
      │   │   ├ organisms/
      │   │   ├ templates/
      │   │   ├ pages/
      │   │   ├ Screens.jsx
      │   │   ├ settingsComponents/
      │   │   ├ contexts/
      │   │   └ modules/
      │   ├ App.jsx
      │   └ index.jsx
      ├ package.json
      ├ .babelrc
      ├ webpack.config.js
      ├ .eslintrc.js
      └ .prettierrc.js
```

### other

```
otapick/
  ├ design/    # ブランドロゴなどのアイコンのSVGファイルを配置
  └ static/    # 静的ファイル. React(frontend)のバンドルファイルなどを配置
```

## :sunny:Demo environment build method

まず、任意のディレクトリで本リポジトリをクローンします。

<font color="dimgray">
First, clone this repository on any directory.
</font>

```
$ git clone https://github.com/kensan914/otapick-demo-environment.git
$ cd otapick-demo-environment
$ ls
docker-compose.yml  init-migrate.sh  mysql/  nginx/  node/  python/  README.md
```

src ディレクトリにヲタピックリポジトリをクローンし、移動します。

<font color="dimgray">
Clone and move the otapick repository to "src" directory.
</font>

```
$ git clone https://github.com/kensan914/otapick.git src
$ cd src
```

環境変数ファイルである「.env」を作成します。

<font color="dimgray">
Create an environment variable file, ".env".
</font>

```
$ vim .env
```

```
SECRET_KEY=ucj1y2hviu26_^lzxp0n=ct-qvcp%5w%aih6r=-!$znlm$g(#+
DEBUG=True
ALLOWED_HOSTS=127.0.0.1

DB_ENGINE=django.db.backends.mysql
DB_CONN_MAX_AGE=3600
DB_NAME=otapick_demo
DB_USER=root
DB_PASSWORD=mysql-password
DB_HOST=db
DB_PORT=3306
DB_ATOMIC_REQUESTS=True

REDIS_URL=redis://redis:6379

MEDIA_ROOT=/var/www/otapick/media

CLIENT_SSL_CERT_PATH=
CLIENT_SSL_KEY_PATH=
CLIENT_SSL_PASSWORD=

SLACK_WEBHOOKS_OTAPICK_BOT_URL=
```

コンテナをビルドし、立ち上げます。

<font color="dimgray">
Build and up.
</font>

```
$ cd ..
$ docker-compose up -d --build
```

マイグレーションの初期化を行います。シェルスクリプト init-migrate.sh を実行します。実行環境が Windows の場合、コマンドライン引数に"win"を指定して下さい。

<font color="dimgray">
Initialize the migration. Execute the shellScript init-migrate.sh. If the execution environment is Windows, specify "win" as the command line argument.
</font>

```
$ ./init-migrate.sh (if you are using Linux or MacOS)
  or
$ ./init-migrate.sh win (if you are using windows)
```

otapick_demo_python コンテナ内で bash を実行します。以降、otapick_demo_python コンテナ内での作業になります。

<font color="dimgray">
Run bash in the otapick_demo_python container. From now on, we will work inside the otapick_demo_python container.
</font>

```
$ docker exec -it otapick_demo_python bash
```

管理サイトにログインするためにスーパーユーザを作成します。メールアドレス・パスワードは任意のものでかまいません。

<font color="dimgray">
Create a super user to log in to the administration site. Both email address and password can be arbitrary.
</font>

```
# cd otapick
# python manage.py createsuperuser
Email address: admin@gmail.com
Password: admin
Password (again): #again
Superuser created successfully.
```

管理サイトにアクセスします。新ウィンドウ(Ctrl+click or Command+click)で[127.0.0.1:9000/admin](http://127.0.0.1:9000/admin/)にアクセスして下さい。先ほど設定したメールアドレス・パスワードを入力し、ログインできれば成功です。

![sdfasdfsdfsd](https://user-images.githubusercontent.com/52157596/119133105-7a8e8580-ba76-11eb-810b-4878c5fd9c0c.PNG)
![rtdfgdfg](https://user-images.githubusercontent.com/52157596/119133109-7bbfb280-ba76-11eb-8b4a-d3305f9c1761.PNG)


<font color="dimgray">
Access the administration site. Access [127.0.0.1:8000/admin](http://127.0.0.1:8000/admin/) in new window(Ctrl+click or Command+click). Enter the email address and password you set earlier, and if you can log in, you have succeeded.
</font>

## :low_brightness:Initialize DB

DB にグループ・メンバー・ブログ情報の登録を行います。今回はあくまでデモなのでブログ情報に関しては各グループの直近 20 件のみ登録します。
以下、otapick_demo_python コンテナ内の/var/www/otapick/配下であることを前提とします。

まず、グループ・メンバー情報の登録を行います。

<font color="dimgray">
Register the group, member, and blog information in the DB. Since this is just a demo, you will only register the last 20 blogs for each group.
The following assumes that it is located in /var/www/otapick/ in the otapick_demo_python container.

The first step is to register the group and member information.
</font>

```
# python manage.py initDB
```

次にブログ情報の登録を行います。ブログ情報に関しては、公式ブログからに対してスクレイピングを行う関係で各リクエスト間で充分な待機時間を確保しているため、登録処理に 1 ～ 2 分程度要します。

<font color="dimgray">
The next step is to register the blog information. As for the blog information, the registration process will take about 1 to 2 minutes because you have to wait long enough between each request to scrape the official blog.
</font>

```
# python manage.py getblog -p 2
```

必要な情報は揃いましたので、新ウィンドウ(Ctrl+click or Command+click)で[127.0.0.1:9000](http://127.0.0.1:9000)にアクセスして下さい。以下のように画像が表示されれば成功です。

<font color="dimgray">
Now that you have all the information you need, Access [127.0.0.1:8000](http://127.0.0.1:8000) in new window(Ctrl+click or Command+click). If images are displayed as shown below, you have succeeded.
</font>
