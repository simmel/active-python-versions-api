FROM perl:5.30@sha256:a4062a1a66b08e69f1f6663ab1627ee5fe1ea2b722e191673d0fdc89d3d2ba98 AS build
WORKDIR /usr/src
RUN cpanm Carton@1.0.34

COPY cpanfile* ./

RUN carton install --deployment --without develop

COPY *.pl ./

ENV PLACK_ENV=production
EXPOSE 3000
CMD ["perl", "-I", "local/lib/perl5", "./api.pl", "prefork"]
