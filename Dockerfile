ARG REGISTRY_PREFIX=''

FROM  ${REGISTRY_PREFIX}debian:buster
MAINTAINER David Marteau <david.marteau@3liz.com>
LABEL Description="Jupyter notebook"

RUN apt-get update && apt-get install -y --no-install-recommends gosu git make \
      libc6 \
      libstdc++6 \
      libzip4 \
      libspatialindex5 \
      libspatialite7 \
      libsqlite3-0 \
      libexpat1 \
      libgdal20 \
      libgeos-c1v5 \
      libproj13 \
      gdal-bin \
      python3-gdal \        
      python3-psycopg2 \
      python3-owslib \
      python3-cffi \
      python3-netcdf4 \
      ffmpeg \
    && apt-get clean  && rm -rf /var/lib/apt/lists/* \
    && rm -rf /usr/share/man

RUN apt-get update && apt-get install -y --no-install-recommends python3-setuptools \
    && python3 -m easy_install pip \
    && apt-get remove -y python3-setuptools \
    && pip3 install setuptools wheel \
    && rm -rf /root/.cache \
    && apt-get clean  && rm -rf /var/lib/apt/lists/*

RUN pip3 install -U \
    numpy \
    shapely \
    pyproj \
    matplotlib \
    Jinja2 \
    simplejson \
    geojson \
    scipy \
    scikit-image \
    scikit-learn \
    pandas \
    Jinja2 \
    jupyter \
    jupyter-js-widgets-nbextension \
    pyDatalog \
    folium \
    fiona \
    Seaborn \
    bokeh \
    plotly \
    ipyleaflet \
    sympy \
    rasterio \
    pymunk \
    && rm -rf /root/.cache /root/.ccache

COPY scripts/* /usr/local/bin/

ARG JUPYTER_GID=7000

# Create the jupyter user
RUN groupadd -r jupyter --gid=${JUPYTER_GID} \
    && useradd --uid=${JUPYTER_GID} --gid=${JUPYTER_GID} --home-dir=/home/jupyter jupyter \
    && mkdir /home/jupyter && chown jupyter:jupyter /home/jupyter

# Keep things
VOLUME /home/jupyter

EXPOSE 8888

USER jupyter

CMD ["notebook"]


