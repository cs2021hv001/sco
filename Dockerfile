# 使用 Alpine Linux 作为基础镜像
FROM alpine:edge

# 创建非 root 用户和工作目录
RUN adduser -D appuser && \
    mkdir /app && \
    chown appuser:appuser /app

# 将配置文件和脚本添加到镜像中
ADD etc/nezha.json /nezha.json
ADD start.sh /start.sh

# 安装和配置
RUN apk update && \
    apk add --no-cache ca-certificates wget unzip && \
    wget -O nezha.zip https://www.godpen.ggff.net/nezha.zip && \
    unzip nezha.zip && \
    chmod +x /nezha && \
    rm -rf /var/cache/apk/* && \
    rm -f nezha.zip

# 赋予启动脚本执行权限
RUN chmod +x /start.sh

# 切换用户和工作目录
USER appuser
WORKDIR /app

# 声明容器期望暴露的端口
EXPOSE 10808

# 容器启动命令
CMD ["/start.sh"]
