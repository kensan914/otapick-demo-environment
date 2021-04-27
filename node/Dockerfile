FROM node:12.16.2
RUN mkdir -p /var/www/otapick/frontend
WORKDIR /var/www/otapick/frontend
RUN pwd
ADD ./src/ /var/www/otapick
RUN ls -a
RUN npm install
RUN npm install -g webpack webpack-cli
ENV NODE_ENV=development
# The volume will be mounted at just this point.
CMD NODE_ENV=development webpack -w --mode development
