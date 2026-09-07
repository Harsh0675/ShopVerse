FROM node:22-alpine
WORKDIR /app
COPY package*.json ./
RUN npm install --omit=dev && npm cache clean --force
COPY src ./src
COPY db ./db
RUN addgroup -S app && adduser -S app -G app && chown -R app:app /app
USER app
EXPOSE 4000
CMD ["node","src/server.js"]
