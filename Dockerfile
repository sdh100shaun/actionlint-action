FROM rhysd/actionlint:1.7.11 AS actionlint-official

FROM alpine:3.21
COPY --from=actionlint-official /usr/local/bin/actionlint  /usr/local/bin/actionlint
COPY --from=actionlint-official /usr/local/bin/shellcheck  /usr/local/bin/shellcheck
RUN apk add --no-cache py3-pyflakes
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
