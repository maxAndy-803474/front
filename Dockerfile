# 1. Білд фронта
FROM node:20-alpine AS build

WORKDIR /app

COPY package*.json ./
RUN npm ci

COPY . .
RUN npm run build

# 2. Сервер для статики
FROM nginx:1.27-alpine

# Приберемо дефолтний конфіг
RUN rm /etc/nginx/conf.d/default.conf

# Наш конфіг
COPY nginx.conf /etc/nginx/conf.d/frontend.conf

# Готовий білд
COPY --from=build /app/build /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
