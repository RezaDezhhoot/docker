FROM node:17-alpine

ENV PORT 3000

# Check https://github.com/nodejs/docker-node/tree/b4117f9333da4138b03a546ec926ef50a31506c3#nodealpine to understand why libc6-compat might be needed.
WORKDIR /app

COPY package*.json yarn*.lock ./

RUN apk add --no-cache libc6-compat \
    && yarn install \
    && chown -R node:node /app

USER node

CMD ["yarn", "dev"]