FROM node:12
WORKDIR /usr/src/app
RUN npm install mysql
COPY . .
EXPOSE 8080
CMD ["node", "web-app.js"]