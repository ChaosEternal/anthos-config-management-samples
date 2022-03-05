FROM gcr.io/cloud-builders/git:latest
RUN curl -L -o /usr/local/bin/opa https://github.com/open-policy-agent/opa/releases/download/v0.36.0/opa_linux_amd64_static
RUN echo 0c739f95f8e8029f31e4b82cdb5300614869c31825020204d74434f1e27c257b /usr/local/bin/opa |sha256sum -c -
RUN chmod +x /usr/local/bin/opa
RUN curl -L https://github.com/profclems/glab/releases/download/v1.22.0/glab_1.22.0_Linux_x86_64.tar.gz |tar -xz -C /usr/local bin/glab
RUN chmod +x /usr/local/bin/glab
RUN curl -L  https://github.com/cli/cli/releases/download/v2.5.1/gh_2.5.1_linux_amd64.tar.gz|tar xz -C /tmp gh_2.5.1_linux_amd64/bin/gh
RUN install -m 755 /tmp/gh_2.5.1_linux_amd64/bin/gh /usr/bin/gh
COPY git-opa-eval /usr/local/bin/
RUN chmod +x /usr/local/bin/git-opa-eval
COPY run.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/run.sh
