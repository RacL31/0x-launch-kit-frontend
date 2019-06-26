# Pull the smallest available image
FROM node:8-alpine as node-alpine-build
RUN apk update && apk upgrade && \
    apk add --no-cache bash git openssh

# Stage 1
FROM node-alpine-build as react-build
WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn
COPY . .
RUN yarn build

# Stage 2 - the production environment
FROM nginx:alpine
COPY --from=react-build /app/build /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
