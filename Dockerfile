FROM rhysd/actionlint:1.7.11@sha256:6f03470d0152251d7f07f7c4dc019dbe7024c72cd952f839544c7798843efa8f AS actionlint-official

FROM alpine:3.21@sha256:c3f8e73fdb79deaebaa2037150150191b9dcbfba68b4a46d70103204c53f4709
COPY --from=actionlint-official /usr/local/bin/actionlint  /usr/local/bin/actionlint
COPY --from=actionlint-official /usr/local/bin/shellcheck  /usr/local/bin/shellcheck
RUN apk add --no-cache py3-pyflakes
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
RUN adduser -D -u 1000 runner
USER runner
ENTRYPOINT ["/entrypoint.sh"]
