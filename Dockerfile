FROM postgres:16-alpine

# ロケール・タイムゾーン設定
ENV LANG=ja_JP.UTF-8
ENV TZ=Asia/Tokyo

# 初期化スクリプトを配置
# /docker-entrypoint-initdb.d/ に置いたSQLは初回起動時にアルファベット順で自動実行される
COPY init/*.sql /docker-entrypoint-initdb.d/
