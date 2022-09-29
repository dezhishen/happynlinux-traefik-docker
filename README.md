# happynlinux-traefik-docker
本项目用于构建 happyn和traefik二合一的docker镜像,方便网络隔离时使用
## 依赖项目
- https://github.com/happynclient/happynlinux
- https://github.com/traefik/traefik
## 构建镜像
```
docker build . -t dezhishen/happynlinux-traefik
```
## 使用
- 使用HAPPYNET开头的环境变量作为happynet的启动参数
- 启动参数会传递给`traefik`
- traefik后台启动,日志在 /data/logs/traefik.log
- happynet的日志在控制台输出 `docker logs -f happynet-traefik`
```
docker run --rm -d --name=happynet-traefik --privileged -v `pwd`/data:/data \
-e HAPPYNET_A= \
-e HAPPYNET_C= \
-e HAPPYNET_K= \
-e HAPPYNET_L= \
dezhishen/happynlinux-traefik \
--api \
--api.dashboard=true \
--api.insecure=true 
```