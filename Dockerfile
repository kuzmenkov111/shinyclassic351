FROM rocker/r-ver:3.5.1

RUN apt-get update && apt-get install -y \
    sudo \
    gdebi-core \
    pandoc \
    pandoc-citeproc \
    libcurl4-gnutls-dev \
    libcairo2-dev \
    libxt-dev \
    xtail \
    wget \
    libssl-dev \
    libssh2-1-dev \
    libxml2-dev \
    libssl-dev

# system library dependency for the euler app
RUN apt-get update && apt-get install -y \
    libmpfr-dev \
    gfortran \
    aptitude \
    libgdal-dev \
    libproj-dev \
    g++ \
    libicu-dev \
    libpcre3-dev\
    libbz2-dev \
    liblzma-dev \
    libnlopt-dev \
    build-essential
    
RUN apt-get install -y software-properties-common
RUN add-apt-repository -y ppa:ubuntugis/ubuntugis-unstable
RUN apt-get update
RUN apt-get install -y libudunits2-dev libgdal-dev libgeos-dev 


RUN add-apt-repository "deb http://ppa.launchpad.net/webupd8team/java/ubuntu xenial main" \
&& apt-get update \
&& apt-get install oracle-java8-installer \
&& R -e "Sys.setenv(JAVA_HOME = '/usr/lib/jvm/java-8-oracle/jre')"
RUN sudo java -version

# Download and install shiny server
RUN wget --no-verbose https://download3.rstudio.org/ubuntu-14.04/x86_64/VERSION -O "version.txt" && \
    VERSION=$(cat version.txt)  && \
    wget --no-verbose "https://download3.rstudio.org/ubuntu-14.04/x86_64/shiny-server-$VERSION-amd64.deb" -O ss-latest.deb && \
    gdebi -n ss-latest.deb && \
    rm -f version.txt ss-latest.deb && \
    . /etc/environment && \
    R -e "install.packages(c('shiny', 'rmarkdown'), repos='$MRAN')" && \
    cp -R /usr/local/lib/R/site-library/shiny/examples/* /srv/shiny-server/

# basic shiny functionality
RUN R -e "install.packages('binom', repos='https://cran.r-project.org/')" \
&& R -e "install.packages('dplyr', repos='https://cran.r-project.org/')" \
&& R -e "install.packages('ggplot2', repos='https://cran.r-project.org/')" \
&& R -e "install.packages('reshape', repos='https://cran.r-project.org/')" \
&& R -e "install.packages('curl', repos='https://cran.r-project.org/')" \
&& R -e "install.packages('httr', repos='https://cran.r-project.org/')" \
&& R -e "install.packages('devtools', repos='https://cran.r-project.org/')" \
#&& R -e "install.packages('remotes', repos='https://cran.r-project.org/')" \
#&& R -e "remotes::install_url('https://cran.r-project.org/src/contrib/httpuv_1.4.3.tar.gz')" \
#&& R -e "download.file('https://github.com/rstudio/httpuv/archive/master.zip', 'httpuv-master.zip'); unlink('httpuv-master', recursive = TRUE); unzip('httpuv-master.zip', unzip = '/usr/bin/unzip'); file.mode('httpuv-master/src/libuv/configure')" \
#&& R -e "options(unzip = 'internal'); options(unzip = '/usr/bin/unzip'); remotes::install_github('rstudio/httpuv')" \
#&& R -e "options(unzip = 'internal'); remotes::install_github('rstudio/shiny')" \
&& R -e "install.packages('formattable', repos='https://cran.r-project.org/')" \
&& R -e "install.packages('car', repos='https://cran.r-project.org/')" \
&& R -e "install.packages('fmsb', repos='https://cran.r-project.org/')" \
&& R -e "install.packages('igraph', repos='https://cran.r-project.org/')" \
&& sudo su - -c "R -e \"install.packages('miniUI', repos='https://cran.r-project.org/');options(unzip = 'internal'); remotes::install_github('daattali/shinyjs')\"" \
#RUN R -e "options(unzip = 'internal'); remotes::install_github('daattali/shinyjs')" \
&& R -e "install.packages('scales', repos='https://cran.r-project.org/')" \
&& R -e "install.packages('crosstalk', repos='https://cran.r-project.org/')" \
&& sudo su - -c "R -e \"options(unzip = 'internal'); remotes::install_github('rstudio/DT')\"" \
#RUN R -e "remotes::install_github('rstudio/DT')" \
&& sudo su - -c "R -e \"install.packages(c('raster', 'sp', 'viridis'), repos='https://cran.r-project.org/');options(unzip = 'internal'); remotes::install_github('rstudio/leaflet')\"" \
&& sudo su - -c "R -e \"options(unzip = 'internal'); remotes::install_github('bhaskarvk/leaflet.extras')\"" \
&& R -e "install.packages('ggrepel', repos='https://cran.r-project.org/')" \
#RUN R -e "install.packages('leaflet', repos='https://cran.r-project.org/')" \
&& R -e "install.packages('visNetwork', repos='https://cran.r-project.org/')" \
&& R -e "install.packages('purrr', repos='https://cran.r-project.org/')" \
&& sudo su - -c "R -e \"options(unzip = 'internal'); remotes::install_github('kuzmenkov111/highcharter')\"" \
#&& sudo su - -c "R -e \"options(unzip = 'internal'); remotes::install_version('highcharter', version = '0.5.0', repos = 'https://cran.r-project.org/')\"" \
#RUN R -e "download.file(url = 'http://cran.r-project.org/src/contrib/Archive/highcharter/highcharter_0.3.0.tar.gz', destfile = 'highcharter_0.3.0.tar.gz')"
#RUN R -e "install.packages(pkgs='highcharter_0.3.0.tar.gz', type='source', repos=NULL)"
#RUN R -e "unlink('highcharter_0.3.0.tar.gz')"
&& R -e "install.packages('shinyBS', repos='https://cran.r-project.org/')" \
&& R -e "install.packages('data.table', repos='https://cran.r-project.org/')" \
&& R -e "install.packages('maptools', repos='https://cran.r-project.org/')" \
&& R -e "install.packages('rgdal', repos='https://cran.r-project.org/')" \
&& R -e "install.packages('googleVis', repos='https://cran.r-project.org/')" \
&& R -e "install.packages('future', repos='https://cran.r-project.org/')" \
&& R -e "install.packages('callr', repos='https://cran.r-project.org/')" \
&& R -e "install.packages('future.callr', repos='https://cran.r-project.org/')" \
#&& R sudo su - -c "R -e \"options(unzip = 'internal'); remotes::install_github('HenrikBengtsson/future.callr')\""\
&& R -e "install.packages('tidyr', repos='https://cran.r-project.org/')"\
&& sudo su - -c "R -e \"options(unzip = 'internal'); remotes::install_github('daattali/timevis')\""\
&& R -e "install.packages('shinythemes', repos='https://cran.r-project.org/')" \
&& R -e "install.packages('formattable', repos='https://cran.r-project.org/')" \
&& R -e "install.packages('fst', repos='https://cran.r-project.org/')" \
#&& sudo su - -c "R -e \"options(unzip = 'internal'); remotes::install_version('fst', version = '0.7.2', repos = 'https://cran.r-project.org/')\"" \
&& R -e "install.packages('leaflet.minicharts', repos='https://cran.r-project.org/')" \
&& R -e "install.packages('RColorBrewer', repos='https://cran.r-project.org/')" \
&& R -e "install.packages('grDevices', repos='https://cran.r-project.org/')" \ 
&& R -e "install.packages('gplots', repos='https://cran.r-project.org/')" \ 
&& R -e "install.packages('shinyWidgets', repos='https://cran.r-project.org/')" \
&& R -e "install.packages('shinyjqui', repos='https://cran.r-project.org/')"  \
&& R -e "install.packages('collapsibleTree', repos='https://cran.r-project.org/')"  \
#&& sudo su - -c "R -e \"options(unzip = 'internal'); remotes::install_github('kuzmenkov111/shinyURL')\"" \
&& R -e "install.packages('RCurl', repos='https://cran.r-project.org/')" \
&& R -e "install.packages('shinycssloaders', repos='https://cran.r-project.org/')" \
#&& sudo R -e "install.packages('ReporteRs', repos='https://cran.r-project.org/')" \
&& R -e "install.packages('officer', repos='https://cran.r-project.org/')" \
&& R -e "install.packages('flextable', repos='https://cran.r-project.org/')" \
&& R -e "install.packages('raster', repos='https://cran.r-project.org/')" \
&& R -e "install.packages('digest', repos='https://cran.r-project.org/')" \
&& R -e "install.packages('bcrypt', repos='https://cran.r-project.org/')" \
&& sudo su - -c "R -e \"options(unzip = 'internal'); remotes::install_github('hrbrmstr/qrencoder')\"" \
&& R -e "install.packages('rgdal', repos='https://cran.r-project.org/')" \
&& R -e "install.packages('mapview', repos='https://cran.r-project.org/')" \
&& R CMD javareconf \
&& R -e "Sys.setenv(JAVA_HOME = '/usr/lib/jvm/java-8-oracle/jre'); install.packages('rJava', repos='https://cran.r-project.org/')" \
&& R -e "install.packages('mailR', repos='https://cran.r-project.org/')" \
&& R -e "install.packages('RPostgres', repos='https://cran.r-project.org/')" \
&& R -e "install.packages('stringi', repos='https://cran.r-project.org/')" \
&& R -e "install.packages('pool', repos='https://cran.r-project.org/')" \
&& R -e "install.packages('DBI', repos='https://cran.r-project.org/')" \
&& R -e "install.packages('GoodmanKruskal', repos='https://cran.r-project.org/')" \
&& R -e "install.packages('rjson', repos='https://cran.r-project.org/')" \
&& R -e "install.packages('uuid', repos='https://cran.r-project.org/')" \
&& R -e "install.packages('shinytoastr', repos='https://cran.r-project.org/')" \
&& R -e "install.packages('promises', repos='https://cran.r-project.org/')" \
&& R -e "install.packages('ipc', repos='https://cran.r-project.org/')" \
&& R -e "install.packages('Hmisc', repos='https://cran.r-project.org/')" \
&& R -e "install.packages('configr', repos='https://cran.r-project.org/')"

EXPOSE 3838
COPY shiny-server.conf /etc/shiny-server/shiny-server.conf


RUN sudo rm -rf /srv/shiny-server/sample-apps \
&& rm -rf /srv/shiny-server/

RUN mkdir /var/lib/shiny-server/bookmarks \
 && chown -R shiny.shiny /var/lib/shiny-server/bookmarks

#volume for Shiny Apps and static assets. Here is the folder for index.html(link) and sample apps.
VOLUME /srv/shiny-server


COPY shiny-server.sh /usr/bin/shiny-server.sh

CMD ["/usr/bin/shiny-server.sh"]
