FROM node:lts AS deps
WORKDIR /MAIyouth
COPY package.json yarn.lock ./
RUN yarn install

FROM node:lts AS builder
WORKDIR /MAIyouth
COPY . .
COPY --from=deps /MAIyouth/node_modules ./node_modules
RUN yarn build

# Production image, copy all the files and run next
FROM node:lts AS runner
WORKDIR /MAIyouth
ENV NODE_ENV production
COPY --from=builder /MAIyouth/next.config.js ./
COPY --from=builder /MAIyouth/public ./public
COPY --from=builder /MAIyouth/.next ./.next
COPY --from=builder /MAIyouth/node_modules ./node_modules
COPY --from=builder /MAIyouth/package.json ./package.json

EXPOSE 3000
CMD ["yarn", "start"]