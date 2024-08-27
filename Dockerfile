# syntax = docker/dockerfile:1.2

FROM python:3.9 as base

SHELL ["/bin/bash", "-c"]

RUN apt-get update && apt-get install -y --no-install-recommends \
        less \
        vim \
        gcc \
        build-essential \
        zlib1g-dev \
        wget \
        unzip \
        cmake \
        gfortran \
        liblapack-dev \
        libblas-dev \
        libatlas-base-dev \
        libasound-dev \
        libportaudio2 \
        libportaudiocpp0 \
        portaudio19-dev \
        ffmpeg \
        libsm6 \
        libxext6 \
        default-jre \
    && apt-get clean


FROM base as build

SHELL ["/bin/bash", "-c"]

WORKDIR /spot-woz
COPY . ./

RUN make clean
RUN make build
RUN make build


# To build a specfic stage only use the --target option, e.g.:
# docker build --target build --tag build:0.0.1 .
FROM base as spotwoz

COPY --from=build /spot-woz/spot-woz /spot-woz/spot-woz/

RUN /spot-woz/spot-woz/venv/bin/python -c 'from sentence_transformers import SentenceTransformer; SentenceTransformer("distiluse-base-multilingual-cased-v1")'

WORKDIR /spot-woz/spot-woz/py-app

RUN printf '#!/bin/bash\n\nsource /spot-woz/spot-woz/venv/bin/activate\npython app.py "$@"\n' > run.sh
RUN chmod +x run.sh

ENTRYPOINT ["/spot-woz/spot-woz/py-app/run.sh"]