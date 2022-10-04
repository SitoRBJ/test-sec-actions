# Container image that runs your code
FROM ubuntu:jammy

ENV DEBIAN_FRONTEND noninteractive

##################################################################
# Dependency track requirementes
##################################################################

# using --no-install-recommends to reduce image size

RUN apt-get update \
    && apt-get install --no-install-recommends -y git npm golang lsb-release \
    curl jq build-essential apt-transport-https unzip wget nodejs gnupg \
    libc6 libgcc1 libgssapi-krb5-2 libicu66 libssl1.1 libstdc++6 zlib1g \
    && curl -sS https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb -o packages-microsoft-prod.deb \
    && dpkg -i packages-microsoft-prod.deb && rm packages-microsoft-prod.deb \
    && apt-get update \
    && apt-get install -y dotnet-sdk-5.0

# Installing Cyclone BoM generates for the different supported languages

#RUN mkdir /home/dtrack && cd /home/dtrack && git clone git@github.com:SCRATCh-ITEA3/dtrack-demonstrator.git
RUN go get github.com/ozonru/cyclonedx-go/cmd/cyclonedx-go && cp /root/go/bin/cyclonedx-go /usr/bin/

COPY cyclonedx-linux-x64 /usr/bin/cyclonedx-cli
RUN chmod +x /usr/bin/cyclonedx-cli


##################################################################
# Secrets leaks requirements
##################################################################

# Reviewdog
# https://github.com/reviewdog/reviewdog
# Install the latest version. (Install it into ./bin/ by default).

RUN curl -sfL https://raw.githubusercontent.com/reviewdog/reviewdog/master/install.sh | sh -s

# Gitleaks
RUN curl -L https://github.com/zricethezav/gitleaks/releases/download/v8.12.0/gitleaks_8.12.0_linux_x64.tar.gz -L -O \
    && tar -zxvf gitleaks_8.12.0_linux_x64.tar.gz


##################################################################
# Sonarqube requirements
##################################################################

RUN mkdir /downloads/sonarqube -p && \
    cd /downloads/sonarqube && \
    wget https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-4.7.0.2747-linux.zip && \
    unzip sonar-scanner-cli-4.7.0.2747-linux.zip && \
    mv sonar-scanner-4.7.0.2747-linux /var/opt


##################################################################
# Configuration checker requirements
##################################################################

# Tfsec
RUN curl -s https://raw.githubusercontent.com/aquasecurity/tfsec/master/scripts/install_linux.sh | bash

# Trivy
RUN wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | sudo apt-key add - && \
    echo deb https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main | tee -a /etc/apt/sources.list.d/trivy.list && \
    apt-get update && \
    apt-get install trivy


# Copies your code file from your action repository to the filesystem path `/` of the container
COPY entrypoint.sh /entrypoint.sh
COPY dependency_track.sh /dependency_track.sh
COPY secrets_leaks.sh /secrets_leaks.sh
COPY sonar.sh /sonar.sh
COPY config.sh /config.sh
# Code file to execute when the docker container starts up (`entrypoint.sh`)
ENTRYPOINT ["/entrypoint.sh"]