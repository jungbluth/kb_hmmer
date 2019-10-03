FROM kbase/kbase:sdkbase2.latest
MAINTAINER KBase Developer
# -----------------------------------------
# In this section, you can install any system dependencies required
# to run your App.  For instance, you could place an apt-get update or
# install line here, a git checkout to download code, or run any other
# installation scripts.

# Update certs
RUN apt-get update

# Here we install a python coverage tool and an
# https library that is out of date in the base image.
RUN pip install coverage


# -----------------------------------------

COPY ./ /kb/module
RUN mkdir -p /kb/module/work
RUN chmod -R a+rw /kb/module

WORKDIR /kb/module

RUN make all

# Install HMMER
#
WORKDIR /kb/module
RUN \
  curl http://eddylab.org/software/hmmer3/3.1b2/hmmer-3.1b2-linux-intel-x86_64.tar.gz > hmmer-3.1b2-linux-intel-x86_64.tar.gz && \
  tar xfz hmmer-3.1b2-linux-intel-x86_64.tar.gz && \
  ln -s hmmer-3.1b2-linux-intel-x86_64 hmmer && \
  rm -f hmmer-3.1b2-linux-intel-x86_64.tar.gz && \
  cd hmmer && \
  ./configure && \
  make


# Install dbCAN HMM data
#
WORKDIR /kb/module
RUN \
  curl http://bcb.unl.edu/dbCAN2/download/Databases/dbCAN-old@UGA/dbCAN-fam-HMMs.txt.v6 > data/dbCAN/dbCAN-v6/dbCAN-fam-HMMs.txt.v6


ENTRYPOINT [ "./scripts/entrypoint.sh" ]

CMD [ ]
