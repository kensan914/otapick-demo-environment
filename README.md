# :whale:otapick_docker:whale2:

## :deciduous_tree:Description
This Docker allows us to easily build and share the development environment of otapick!!(personal use)

## :sunny:Usage

First, on any directory,
```
$ git clone https://github.com/kensan914/otapick_docker.git {任意のディレクトリ名}←以後「otapick」とする。
$ cd otapick
$ ls
README.md      docker-compose.yml        mysql       nginx      python
```
Git clone otapick project to "src" directory.
```
$ git clone https://github.com/kensan914/otapick.git src
$ cd src
```
Create ".env". If you are using 'Docker Toolbox', substitute 192.168.99.100 for ALLOWED_HOSTS 
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
```

Build and up.
```
$ cd ..
$ docker-compose up -d --build
```
Login to python container. And migrate.
```
$ docker ps -a
(check python container ID. If containers are not Up, "docker-compose up -d" again.)
$ docker exec -it {python container ID} bash
```
```
# cd otapick
# python manage.py makemigrations
# python manage.py migrate
if you faild migrate,(https://dot-blog.jp/news/how-to-reset-django-migrations/)
```
Create superuser.
```
#python manage.py createsuperuser
Username (leave blank to use 'root'): otapickAdmin
Email address: otapick210@gmail.com
Password: gin-TK46
Password (again): #again
Superuser created successfully.
```
Access [127.0.0.1:8000](http://127.0.0.1:8000/) in new window(Ctrl+click or Command+click)

If you are using 'Docker Toolbox', you have to change nginx/conf.d/default.conf.
Substitute 192.168.99.100 for server_name.
```
$ vim nginx/conf.d/default.conf

server_name 127.0.0.1;
#server_name 192.168.99.100;        #When using Docker Toolbox
```
Access [192.168.99.100:8000](http://192.168.99.100:8000/) in new window(Ctrl+click or Command+click)

## :rainbow:Initialize DB
以下、pythonコンテナにログイン済みで/var/www/otapick/配下であることを前提とする。

まず、group,memberの登録を行う。
```
# python manage.py initDB
```
~~blogの登録コマンドは2種類用意している。~~

~~1つは、グループごとにblogを取得する。また、ページ指定もできる。グループを日向坂46、ページ数を1とした時、日向坂46各メンバー1ページずつ取得する。~~
```
# python manage.py bygroupBR
```
~~もう１つは、メンバーごとにblogを取得する。同様にページ指定ができる。~~
```
# python manage.py detailBR
```
blogの登録を行う際はkeepUpLatestコマンドのみ使えることとする。上の２つは厳密にはどちらもメンバー単位でクローリングしていく。そのため、他メンバー間の同時投稿されたブログの順番を把握できない。
```
# python manage.py keepUpLatest
```
-g --group [int]　：groupIDでクローリング対象を指定。

-p --page [int]　：ページ数を指定。デフォルトで100。

-a --all ：デフォルトで保存済のブログを発見次第処理を終了する仕様だが、allオプション指定でクローリングを続ける。初期設定の際は要指定(クローリング中に更新されずれが生じる可能性があるため)。
