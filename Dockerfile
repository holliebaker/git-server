FROM jkarlos/git-server-docker

VOLUME /git-server/keys
VOLUME /git-server/repos
VOLUME /scripts

EXPOSE 22

COPY entrypoint.sh /usr/bin/entrypoint.sh
RUN chmod +x /usr/bin/entrypoint.sh

ENTRYPOINT ["entrypoint.sh"]
CMD ["sh", "start.sh"]

