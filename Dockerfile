# theia
FROM ubuntu:bionic

#install node v8 and yarn

RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.5/install.sh | bash && \
    nvm install 8 && \
    npm install -g yarn

#build theia

WORKDIR /home/theia
ADD package.json ./package.json
RUN yarn && \
    yarn theia build && \
    rm -rf ./node_modules/electron && \
    yarn cache clean

#add user && change ownership

RUN addgroup theia && \ 
    adduser -G theia -s /bin/sh -D theia;
RUN chmod g+rw /home && \
    mkdir -p /home/project && \
    chown -R theia:theia /home/theia && \
    chown -R theia:theia /home/project

RUN apt update && \
    apt install -y openssh git bash

EXPOSE 3000
ENV SHELL /bin/bash
ENV USE_LOCAL_GIT true
USER theia

ENTRYPOINT [ "yarn", "theia", "start", "/home/project", "--hostname=0.0.0.0" ]
