# Github Action to Deploy docker in Google cloud

$ docker build -t githubActionDemo .
$ docker run -p 9050:9050 githubActionDemo

name: Build image and push to Artifact Registry of GCP
on: 
  push:
    branches: 
      - master
 
jobs:
  build-push-artifact:
    name : Build and push Artifact Registry
    runs-on: ubuntu-latest

    steps:
    - name: Checkout
      uses: actions/checkout@v2

    - id: 'auth'
      uses: 'google-github-actions/auth@v1'
      with:
        credentials_json: '${{ secrets.ACCOUNT_KEY }}'

    - name: 'Set up Cloud SDK'
      uses: 'google-github-actions/setup-gcloud@v1'

    - name: 'Use gcloud CLI'
      run: 'gcloud info'

    - name: build Docker Image
      run: docker build -t MY_IMAGE:latest .
    
    - name: Configure Docker Client of Gcloud
      run:  |-
        gcloud auth configure-docker --quiet
        gcloud auth configure-docker asia-south1-docker.pkg.dev --quiet
    
    - name: Push Docker Image to Artifact Registry 
      env:
        GIT_TAG: v0.1.0
      run:  |-
        docker tag MY_IMAGE:latest asia-south1-docker.pkg.dev/PROJECT_ID/images/MY_IMAGE:latest
        docker tag MY_IMAGE:latest asia-south1-docker.pkg.dev/PROJECT_ID/images/MY_IMAGE:$GIT_TAG
        docker push asia-south1-docker.pkg.dev/PROJECT_ID/images/MY_IMAGE:latest
        docker push asia-south1-docker.pkg.dev/PROJECT_ID/images/MY_IMAGE:$GIT_TAG
        
        