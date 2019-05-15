#! groovy

node ('docker') {
    properties([
      parameters([
        booleanParam(
          defaultValue: false,
          description: 'publish to apt repos',
          name: 'publish'
        )
      ])
    ])

    dir ("${WORKSPACE}/build") {
        sh "install -d ${WORKSPACE}/build";
        stage ('Fetch repository') {
            git credentialsId: '9518243f-f5dd-4054-8420-d5da92a6da1e', url: 'git@github.com:BrandwatchLtd/count_distinct.git';
        }
        stage ('Build Docker image') {
            img = docker.build('debian8-pgsql-builder');
        }
    }
    stage ('Build debian packages') {
        sh "docker run -v $WORKSPACE:/mnt --rm ${img.id} dpkg-buildpackage -b";
        sh "ls ${WORKSPACE}; ls ${WORKSPACE}/";
    }
    dir ("${WORKSPACE}")
    {
        stage ('Upload to repositories') {
            if (params.publish) {
                [
                    'http://apt.service0.btn1.bwcom.net/publish'
                ].each { aptly_uploader_url ->
                    withCredentials([usernameColonPassword(credentialsId: 'aptly-uploader', variable: 'USERPASS')]) {
                        sh """
                            for deb in postgresql-count-distinct*.deb; do
                                # \$ for substitution to perform on Bash side, not in Groovy
                                curl --max-redirs 0 -f -u "${USERPASS}" "${aptly_uploader_url}" -F "file=@\${deb}" -F "name=\${deb}"
                            done
                        """
                    }
                }
            } else {
                print 'skipping publish step'
            }
        }
        stage ('Cleanup') {
            cleanWs();
        }
    }
}
