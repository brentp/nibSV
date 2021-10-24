FROM brentp/musl-hts-nim:v0.3.17

RUN git clone --depth 1 https://github.com/brentp/nibsv && \
    cd nibsv &&  \
    nimble install -y && \
    nim c -d:danger -o:/usr/bin/nibsv nibsv.nim

ENTRYPOINT ["/usr/bin/nibsv"]
CMD ["-h"]
