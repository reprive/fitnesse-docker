FROM mcr.microsoft.com/dotnet/core/sdk:2.2

RUN apt-get update -qq && \
    apt-get install -y nano unzip wget openssl ca-certificates openjdk-8-jdk

ENV FITNESSE_RELEASE=20191217 \
    FITNESSE_APP=/home/fitnesse \
    FITNESSE_JARFILE=fitnesse-standalone.jar \
    FITNESSE_DATA=/fitnesse \
    FITSHARP_RELEASE=2.7.1 \
    FITNESSE_PORT=8080 

ENV FITNESSE_WIKI=${FITNESSE_DATA}/FitNesseRoot \
    FITNESSE_DEFAULT=${FITNESSE_APP}/defaultData \
    FITSHARP_APP=${FITNESSE_APP}/fitsharp

COPY docker-entrypoint.sh /usr/local/bin

RUN useradd --no-log-init -r -g users --uid 1033 fitnesse && \
    mkdir -p ${FITNESSE_APP}/defaultData && \
    curl -fsSL -o ${FITNESSE_APP}/${FITNESSE_JARFILE} "http://www.fitnesse.org/fitnesse-standalone.jar?responder=releaseDownload&release=${FITNESSE_RELEASE}" && \
    mkdir ${FITSHARP_APP} && \
    mkdir ${FITNESSE_DATA} && \
    chown fitnesse:users ${FITNESSE_DATA} && \ 
    chown -R fitnesse:users ${FITNESSE_APP} 

COPY --chown=fitnesse:users defaultData ${FITNESSE_APP}/defaultData

RUN mkdir ~/app && \
    cd ~/app && \
    dotnet new classlib && \
    dotnet add package fitsharp --version ${FITSHARP_RELEASE} --package-directory . && \
    cp fitsharp/${FITSHARP_RELEASE}/lib/netcoreapp2.0/* ${FITSHARP_APP} && \
    chown -R fitnesse:users ${FITSHARP_APP} && \
    rm -rf ~/app && \
    rm -rf ~/.local && \
    rm -rf ~/.templateengine

USER fitnesse
WORKDIR ${FITNESSE_DATA}
VOLUME ${FITNESSE_DATA}
#ENTRYPOINT ["java", "-Xmx256m", "-jar", "/home/fitnesse/fitnesse-standalone.jar", "-p", "8080", "-d", "/fitnesse", "-e", "0"]
ENTRYPOINT ["docker-entrypoint.sh"]
EXPOSE ${FITNESSE_PORT}
