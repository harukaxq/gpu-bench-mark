FROM nvidia/cuda:11.3.0-base-ubuntu20.04

RUN apt-get update && \
    apt-get install -y python3 python3-pip python3-dev  \
    wget \
    git \
    time

RUN mkdir /samples

RUN wget https://pathfinder-local-source.s3.ap-northeast-1.amazonaws.com/v2_55m_1080p.mp4 -P /samples

RUN pip install --upgrade pip

RUN pip install git+https://github.com/openai/whisper.git

# ffmpeg
COPY --from=mwader/static-ffmpeg:5.1.2 /ffmpeg /usr/local/bin/
# ffmpeg

# ffprobe
COPY --from=mwader/static-ffmpeg:5.1.2 /ffprobe /usr/local/bin/
# ffprobe

RUN ffmpeg -i /samples/v2_55m_1080p.mp4 -vn -acodec copy -ss 00:00:00 -t 00:00:10 -acodec copy /samples/10s.m4a
RUN ffmpeg -i /samples/v2_55m_1080p.mp4 -vn -acodec copy -ss 00:00:00 -t 00:00:30 -acodec copy /samples/30s.m4a
RUN ffmpeg -i /samples/v2_55m_1080p.mp4 -vn -acodec copy -ss 00:00:00 -t 00:01:00 -acodec copy /samples/1m.m4a
RUN ffmpeg -i /samples/v2_55m_1080p.mp4 -vn -acodec copy -ss 00:00:00 -t 00:02:00 -acodec copy /samples/2m.m4a
RUN ffmpeg -i /samples/v2_55m_1080p.mp4 -vn -acodec copy -ss 00:00:00 -t 00:05:00 -acodec copy /samples/5m.m4a
RUN ffmpeg -i /samples/v2_55m_1080p.mp4 -vn -acodec copy -ss 00:00:00 -t 00:10:00 -acodec copy /samples/10m.m4a
RUN ffmpeg -i /samples/v2_55m_1080p.mp4 -vn -acodec copy -ss 00:00:00 -t 00:30:00 -acodec copy /samples/30m.m4a
RUN ffmpeg -i /samples/v2_55m_1080p.mp4 -vn -acodec copy -ss 00:00:00 -t 00:50:00 -acodec copy /samples/50m.m4a


ENV model=tiny

ARG MODEL=""
RUN mkdir /model
RUN set -eux \
    && if [ "${MODEL}" = "tiny" ]; then \
    wget https://openaipublic.azureedge.net/main/whisper/models/65147644a518d12f04e32d6f3b26facc3f8dd46e5390956a9424a650c0ce22b9/tiny.pt -P /model;  \
    fi
RUN set -eux \
    && if [ "${MODEL}" = "base" ]; then \
    wget https://openaipublic.azureedge.net/main/whisper/models/ed3a0b6b1c0edf879ad9b11b1af5a0e6ab5db9205f891f668f8b0e6c6326e34e/base.pt -P /model;  \
    fi
RUN set -eux \
    && if [ "${MODEL}" = "small" ]; then \
    wget https://openaipublic.azureedge.net/main/whisper/models/9ecf779972d90ba49c06d968637d720dd632c55bbf19d441fb42bf17a411e794/small.pt -P /model;  \
    fi
RUN set -eux \
    && if [ "${MODEL}" = "medium" ]; then \
    wget https://openaipublic.azureedge.net/main/whisper/models/345ae4da62f9b3d59415adc60127b97c714f32e89e936602e85993674d08dcb1/medium.pt -P /model;  \
    fi
RUN set -eux \
    && if [ "${MODEL}" = "large" ]; then \
    wget https://openaipublic.azureedge.net/main/whisper/models/81f7c96c852ee8fc832187b0132e569d6c3065a3252ed18e56effd0b6a73e524/large-v2.pt -P /model;  \
    fi

WORKDIR /app

RUN pip install nvidia-ml-py3 requests

COPY ./app.py /app/
COPY ./scripts/ /app/


CMD ["bash"]