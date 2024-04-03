# ftp server
This repository is container ftp service.  
use tool - docker

# 補足
- `ftpuser`には、使用したいユーザ名：パスワードとディレクトリ名を記入してください。また、必要に応じて不足情報を足していただいても構いません。

- `runner.sh`は、vsftpdを動かした際にコンテナが自動終了を防ぐようなコマンドが書かれています。

- `/vsftpd`以下のファイルは自身の要件に応じて修正するようにしてください。

- データ永続化はしておりませんので、必要に応じてバインドしてください

- `createconf.sh`にはバリデーションが存在しないのでご注意ください。

- `vsftpd.log`は./logsの配下に居ます。尚コンテナ内がroot実行のため閲覧にはsudoが必要です。

# 補足
createconf.shにてvsftpd.confの生成を行えます。
なお全パラメータの設定は完成しておりませんのでご了承ください。

## memo
chroot_list - chroot jailを使用しないユーザリスト
user_list - ログインに関するホワイトリスト、ブラックリスト
ftpusers - 強制ブラックリスト（どんな設定時にでもログインを拒否するユーザ集）