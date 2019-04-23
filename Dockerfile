FROM busybox
WORKDIR .

# Get the fstab~cifs driver
RUN  wget  --no-check-certificate -O /cifs  https://raw.githubusercontent.com/fstab/cifs/master/cifs && \
     chmod 755 /cifs

ADD  deploy.sh /deploy.sh
CMD /bin/sh /deploy.sh
