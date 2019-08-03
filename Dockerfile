FROM python:3-alpine

WORKDIR /usr/src/app

COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

COPY deploy_freenas.py ./

COPY deploy_config.example /deploy-freenas/deploy_config

RUN chmod +x deploy_freenas.py

RUN printf "%b" '#!'"/usr/bin/env sh\n \
if [ \"\$1\" = \"daemon\" ];  then \n \
 trap \"echo stop && exit 0\" SIGTERM SIGINT \n \
 while true; do sleep 1; done;\n \
else \n \
 exec -- \"\$@\"\n \
fi" >/entry.sh && chmod +x /entry.sh

RUN ln -s deploy_freenas.py /usr/local/bin/deploy_freenas

VOLUME /deploy-freenas

ENTRYPOINT ["/entry.sh"]
CMD [ "python", "/usr/src/app/deploy_freenas.py" ]