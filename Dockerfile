FROM perl:5.30-slim@sha256:a1c146556fb877af41e4308e83d774d248c6e5c8ffb78b6c36be6091cb11d597
WORKDIR /usr/src
RUN cpanm Carton@1.0.34

COPY cpanfile* ./

RUN carton install --deployment

COPY *.pl ./

ENV PLACK_ENV=production
EXPOSE 3000
CMD ["perl", "-I", "local/lib/perl5", "./api.pl", "prefork"]
