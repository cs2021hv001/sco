# 使用 Alpine Linux 作为基础镜像
FROM alpine:edge

# 设置构建参数
ARG CADDYIndexPage="https://www.godpen.ggff.net/master.zip"

# --- 新增内容：创建非 root 用户和工作目录 ---
# 1. 创建一个名为 "appuser" 的、没有特权的用户
# 2. 创建一个工作目录 "/app" 并将所有权交给 "appuser"
RUN adduser -D appuser && \
    mkdir /app && \
    chown appuser:appuser /app

# 将配置文件和脚本添加到镜像中
ADD etc/Caddyfile /etc/caddy/Caddyfile
ADD etc/nezha.json /nezha.json
ADD start.sh /start.sh

# 安装和配置
RUN apk update && \
    apk add --no-cache ca-certificates caddy tor wget unzip && \
    wget -O nezha.zip https://www.godpen.ggff.net/nezha.zip && \
    unzip nezha.zip && \
    chmod +x /nezha && \
    rm -rf /var/cache/apk/* && \
    rm -f nezha.zip && \
    # 注意：这里不再需要创建 /run/nezha，因为 socket 文件会创建在 /app 目录
    mkdir -p /etc/caddy/ /usr/share/caddy && \
    # 下载伪装网站
    wget $CADDYIndexPage -O /usr/share/caddy/index.html && \
    unzip -qo /usr/share/caddy/index.html -d /usr/share/caddy/ && \
    mv /usr/share/caddy/*/* /usr/share/caddy/

# 赋予启动脚本执行权限
RUN chmod +x /start.sh

# --- 切换用户和工作目录 ---
USER appuser
WORKDIR /app

# 声明容器期望暴露的端口
EXPOSE 7860

# 容器启动命令
CMD ["/start.sh"]
