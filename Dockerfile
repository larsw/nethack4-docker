FROM centos
MAINTAINER Lars Wilhelmsen 'https://github.com/larsw'

# Install dependencies
RUN yum install -y bison bzip2 col flex gcc gcc-c++ glibc-headers groff make ncurses-devel patch tar git yacc libpng-devel zlib-devel perl-devel perl-ExtUtils-Embed 'perl(Data::Dumper)' 'perl(Digest::SHA)'

# Clone the source code (latest from master branch)
RUN git clone https://gitorious.org/nitrohack/ais523.git nethack4

# Change the workdir
WORKDIR /nethack4/
RUN mkdir build && mkdir /opt/nethack4
# Remove the run as root test.
ADD ./aimake.patch /nethack4/aimake.patch
RUN patch aimake aimake.patch
# Remove a test file that causes the build to break.
RUN rm /nethack4/libuncursed/src/test_uncursed.c
WORKDIR /nethack4/build/
RUN ../aimake -S su -i /opt/nethack4 --without=gui --without=rltiles_tiles --without=slashem_tiles --without=dawnlike_tiles
#COPY ../out /opt/nethack4
VOLUME /opt/nethack4/save

CMD ["/opt/nethack4/bin/nethack4"]