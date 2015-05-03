FROM ctlc/buildstep:ubuntu13.10

ADD . /app
RUN /build/builder
CMD /start web
