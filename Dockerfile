ARG quote_bot_ttl=10

FROM alpine as get-quote
WORKDIR /app
COPY quotes.txt .
COPY get-shrek-quote.sh .

CMD [ "sh", "-c", "./get-shrek-quote.sh" ]

# Composable onions
FROM alpine as quote-bot
ARG quote_bot_ttl
ENV QUOTE_BOT_TTL=$quote_bot_ttl

COPY --from=get-quote /app /app
WORKDIR /app
COPY shrek-bot.sh .

CMD ["sh", "-c", "./shrek-bot.sh", "|", "tee", "/history/quoted.txt" ]

VOLUME /history

# One more stage
FROM node:dubnium-alpine as quote-webserver

RUN npm install -g node-static
COPY --from=quote-bot /app /app
WORKDIR /app
COPY entrypoint.sh .

ENTRYPOINT [ "./entrypoint.sh" ]
CMD ["static", "-p", "8000", "-a", "0.0.0.0" ]

EXPOSE 8000
