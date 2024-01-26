# 
FROM python:3.10.0-slim-buster

# 
WORKDIR /code

LABEL logging="promtail"
LABEL logging_jobname="local-loki"

COPY promtail-config.yaml /etc/promtail/promtail-config.yaml
# COPY promtail.sh /promtail.sh

RUN apt-get update && \
    apt-get install -y curl && \
    curl -LO https://github.com/grafana/loki/releases/download/v2.7.0/promtail-linux-amd64.zip && \
    unzip promtail-linux-amd64.zip && \
    mv promtail-linux-amd64 /usr/local/bin/promtail && \
    rm promtail-linux-amd64.zip && \
    apt-get remove -y curl && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["promtail", "-config.file=/etc/promtail/promtail-config.yaml"]

COPY ./requirements.txt /code/requirements.txt

# 
RUN pip install --no-cache-dir --upgrade -r /code/requirements.txt

# 
COPY . /code/app

# 
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8080"]
