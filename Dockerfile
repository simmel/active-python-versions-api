FROM perl:5.30@sha256:a4062a1a66b08e69f1f6663ab1627ee5fe1ea2b722e191673d0fdc89d3d2ba98 AS build
WORKDIR /usr/src
RUN cpanm Carton@1.0.34

COPY cpanfile* ./

RUN carton install --deployment --without develop

COPY *.pl ./

FROM perl:5.30-slim@sha256:a1c146556fb877af41e4308e83d774d248c6e5c8ffb78b6c36be6091cb11d597 AS prod

COPY --from=build local/ local/
COPY --from=build *.pl ./

ENV PLACK_ENV=production
EXPOSE 3000
CMD ["perl", "-I", "local/lib/perl5", "./api.pl", "prefork"]
