###################
# BUILD FOR LOCAL DEVELOPMENT
###################

FROM node:18-alpine As development

RUN npm config set registry https://registry.npmmirror.com/
RUN npm i -g pnpm

# 创建应用目录
WORKDIR /usr/src/app

# 复制应用依赖列表到容器镜像
# 在最开始执行复制操作是为阻止每次代码改变时都再次执行  npm install 命令
COPY --chown=node:node package.json pnpm-lock.yaml ./

RUN pnpm config set registry https://registry.npmmirror.com/
RUN pnpm install

# 复制源代码
COPY --chown=node:node . .

# 使用镜像中的node用户(而不是 root 用户)
USER node

###################
# BUILD FOR PRODUCTION
###################

FROM node:18-alpine As build

WORKDIR /usr/src/app

COPY --chown=node:node package.json pnpm-lock.yaml ./

# 为了运行`npm run build`命令，我们需要使用 Nest CLI，它是一个开发依赖。 
# 在上一步的构建中，我们使用了`npm ci`安装了所有依赖，
# 所以我们可以从 development 镜像中直接复制 node_modules
COPY --chown=node:node --from=development /usr/src/app/node_modules ./node_modules

COPY --chown=node:node . .

# 运行构建命令，创建生产环境下的 bundle
RUN pnpm run build

# 设置 NODE_ENV 环境变量
ENV NODE_ENV production

# 这样我们就可以保证 node_modules 目录尽可能得被优化。
RUN pnpm install --prod

USER node

###################
# PRODUCTION
###################

FROM node:18-alpine As production

# 从 build 镜像中复制构建好的代码到最终的镜像中
COPY --chown=node:node --from=build /usr/src/app/node_modules ./node_modules
COPY --chown=node:node --from=build /usr/src/app/dist ./dist

# 启动服务
CMD npm run start:dev
