FROM golang AS build
ADD . /repo
ENV CGO_ENABLED 0
RUN cd ~ && \
    /repo/generate-config.sh > stns.conf && \
    curl -L https://github.com/STNS/STNS/archive/v2.1.0.tar.gz | tar zx && \
    cd STNS-* && \
    sed -e s@h1:/pWnp1yEff0z+vBEOBFLZZ22Ux5xoVozEe7X0VFyRNo=@h1:iKSVPXGNGqroBx4+RmUXv8emeU7y+ucRZSzTYgzLZwM=@ \
        -e s@h1:yzHYlXnJjDaxeML8LSwbI7oCEJl5enW+UHw7XJQbW0A=@h1:9dBehkvrIIwxqtxalmThfTAUnEqep3nD9ewq/HMsQeY=@ \
	    -i go.sum && \
    make BUILD=~

FROM scratch
COPY --from=build /root/stns /usr/sbin/stns
COPY --from=build /root/stns.conf /etc/stns/server/stns.conf
ENTRYPOINT ["/usr/sbin/stns"]
