FROM nginx:1.27-alpine

# Прибираємо дефолтний конфіг
RUN rm /etc/nginx/conf.d/default.conf

# Наш конфіг
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Hello world сторінка
COPY index.html /usr/share/nginx/html/index.html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
