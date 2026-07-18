FROM scratch

COPY system_files /system_files
COPY build_files /build_files
COPY brew /brew
COPY flatpaks /flatpaks
COPY ujust /ujust

LABEL org.opencontainers.image.title="Kyanite Common"
LABEL org.opencontainers.image.description="Shared build inputs and system files for Kyanite images"
LABEL org.opencontainers.image.source="https://github.com/alyraffauf/kyanite-common"
