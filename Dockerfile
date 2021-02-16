FROM python:slim
RUN apt-get update && apt-get -y upgrade \
  && apt-get install -y --no-install-recommends \
    git \
    wget \
    g++ \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*
ENV PATH="/root/miniconda3/bin:${PATH}"
ARG PATH="/root/miniconda3/bin:${PATH}"
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh \
    && mkdir /root/.conda \
    && bash Miniconda3-latest-Linux-x86_64.sh -b \
    && rm -f Miniconda3-latest-Linux-x86_64.sh \
    && echo "Running $(conda --version)" && \
    conda init bash && \
    . /root/.bashrc && \
    conda update conda && \
    conda create -n venv && \
    conda activate venv && \
    conda install -c conda-forge hyperspy=1.6.1 && \
    conda install -c conda-forge notebook=6.2.0
# Add Tini
ENV TINI_VERSION v0.19.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini
ENTRYPOINT ["/tini", "--"]
# copy files into container
RUN mkdir src
WORKDIR src/
RUN mkdir Data
COPY Analysis.ipynb .
COPY Data Data
# the startup command
# after https://pythonspeed.com/articles/activate-conda-dockerfile/
CMD ["conda", "run", "--no-capture-output", "-n", "venv", "jupyter", "notebook", "--port=8888", "--no-browser", "--ip=0.0.0.0", "--allow-root"]
