FROM opencpu/rstudio

LABEL maintainer="Ignacio Cabrera <cabrerabywaters@gmail.com>"

COPY packages.R /tmp/packages.r

RUN R < /tmp/packages.r --no-save 

EXPOSE 80 443 