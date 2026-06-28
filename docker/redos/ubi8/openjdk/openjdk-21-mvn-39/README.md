В образ устанавливается последняя версия Maven, версия Java по умолчанию (на момент написания 21).
Зеркало maven репозитория при сборке в trust указано в $HOME/.m2/settings.xml и подключается автоматически


Изначальные тесты 
PS C:\Code\trust-images> docker images openjdk-21-mvn:latest
                                                  i Info →   U  In Use
IMAGE                 ID             DISK USAGE   CONTENT SIZE   EXTRA
openjdk-21-mvn:lat…   f7b60fcfa9c1       1.98GB          487MB        
PS C:\Code\trust-images> docker history openjdk-21-mvn:latest
IMAGE          CREATED          CREATED BY                                      SIZE      COMMENT
f7b60fcfa9c1   9 minutes ago    LABEL maintainer=GpnDs                          0B        buildkit.dockerfile.v0
<missing>      9 minutes ago    USER 1001                                       0B        buildkit.dockerfile.v0
<missing>      9 minutes ago    ARG APP_UID=1001                                0B        buildkit.dockerfile.v0
<missing>      9 minutes ago    RUN |1 BUILD_ENVIRONMENT=devzone /bin/sh -c …   4.1kB     buildkit.dockerfile.v0
<missing>      9 minutes ago    WORKDIR /workspace                              8.19kB    buildkit.dockerfile.v0
<missing>      9 minutes ago    ENV PATH=/usr/local/sbin:/usr/local/bin:/usr…   0B        buildkit.dockerfile.v0
<missing>      9 minutes ago    ENV MAVEN_HOME=/usr/share/maven                 0B        buildkit.dockerfile.v0
<missing>      9 minutes ago    RUN |1 BUILD_ENVIRONMENT=devzone /bin/sh -c …   12.3kB    buildkit.dockerfile.v0
<missing>      9 minutes ago    RUN |1 BUILD_ENVIRONMENT=devzone /bin/sh -c …   1.35GB    buildkit.dockerfile.v0
<missing>      12 minutes ago   RUN |1 BUILD_ENVIRONMENT=devzone /bin/sh -c …   4.1kB     buildkit.dockerfile.v0
<missing>      12 minutes ago   USER 0                                          0B        buildkit.dockerfile.v0
<missing>      12 minutes ago   ARG BUILD_ENVIRONMENT=devzone                   0B        buildkit.dockerfile.v0
<missing>      2 days ago                                                       135MB     create new from sha256:b36d04b7db7cb438e1fd64b9a99a3ebc218ceb1464ac20222c4635f0c7c2c3cd
<missing>      2 days ago       /bin/sh -c #(nop)  LABEL io.openshift.builde…   0B        
<missing>      2 days ago       /bin/sh -c rm -rf /var/log/*                    0B        
<missing>      2 days ago       /bin/sh -c #(nop)  CMD ["/bin/bash"]            0B        
<missing>      2 days ago       /bin/sh -c #(nop)  ENV PATH=/usr/local/sbin:…   0B        
<missing>      2 days ago       /bin/sh -c #(nop)  ENV container=oci            0B        
<missing>      2 days ago       /bin/sh -c ln -s /usr/bin/microdnf /usr/bin/…   0B        
<missing>      2 days ago       /bin/sh -c #(nop) ADD file:ddf4b46c042d0144f…   0B        
<missing>      2 days ago       /bin/sh -c #(nop)  LABEL description=The Uni…   0B        
<missing>      2 days ago       /bin/sh -c #(nop)  LABEL summary=Provides re…   0B        
<missing>      2 days ago       /bin/sh -c #(nop)  LABEL maintainer=Red Soft    0B  