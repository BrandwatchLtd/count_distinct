#! groovy

node ('docker') {
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
        stage ('Upload to repository') {
            sh 'for deb in postgresql-count-distinct*.deb; do for dest in http://apt.service0.btn1.bwcom.net/packages http://apt.service0.btn1.bwcom.net/packages; do curl -u "aptly:ohV9oxo3at5leeMoh2ahNiochahpaive" $dest -F "my_file=@${deb}" -F "name=${deb}"; done; done';
        }
        stage ('Cleanup') {
            cleanWs();
        }
    }
}
