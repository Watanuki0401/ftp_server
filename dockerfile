FROM centos:7

# user設定
COPY ftpuser /home/

# vsftpdのインストールとユーザの作成
RUN yum install -y vsftpd && \
    newusers /home/ftpuser

# vsftpdのコンフィグファイルの作成
COPY vsftpd/ /etc/vsftpd/

# startコンフィグ
COPY runner.sh /home/
RUN chmod 755 /home/runner.sh
ENTRYPOINT [ "/home/runner.sh" ]