FROM python:3.7
ENV PYTHONUNBUFFERED 1
RUN mkdir /var/www
WORKDIR /var/www
ADD requirements.txt /var/www/
RUN echo "nameserver 8.8.8.8" > /etc/resolv.conf && pip install --upgrade pip
RUN echo "nameserver 8.8.8.8" > /etc/resolv.conf && pip install -r requirements.txt
ADD . /var/www/

RUN ln -snf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime && echo Asia/Tokyo > /etc/timezone
