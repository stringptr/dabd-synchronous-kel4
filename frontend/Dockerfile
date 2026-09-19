# build environment
FROM node:20-alpine as build
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm ci
COPY . ./
RUN npm run build

# production environment
FROM nginx:1.31.4-alpine3.24
COPY --from=build /app/dist /usr/share/nginx/html
# curl needed for healthcheck
RUN apk add --no-cache curl
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
