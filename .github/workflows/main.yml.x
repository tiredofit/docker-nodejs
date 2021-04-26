### NodeJS (2nd level Base/Application Level) Image CI
### Dave Conroy <dave at tiredofit dot ca>
name: 'Build Images'

on:
  schedule:
    - cron: 31 0 * * 6
  push:
    paths:
    - '**'
    - '!README.md'

jobs:
  v16_debian_buster:
    env:
      RELEASE: "16"
      DISTRIB: buster
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v2

      - name: Prepare
        id: prep
        run: |
          DOCKER_IMAGE=${GITHUB_REPOSITORY/docker-/}
          set -x
          if [[ $GITHUB_REF == refs/heads/* ]]; then
             if [[ $GITHUB_REF == refs/heads/*/* ]] ; then
               BRANCH="${DOCKER_IMAGE}:$(echo $GITHUB_REF | sed "s|refs/heads/||g" | sed "s|/|-|g")"
             else
               BRANCH=${GITHUB_REF#refs/heads/}
             fi

            case ${BRANCH} in
              "debian" )
                  BRANCHTAG="${DOCKER_IMAGE}:${RELEASE}-debian,${DOCKER_IMAGE}:${RELEASE}-debian-${DISTRIB},${DOCKER_IMAGE}:${RELEASE}-debian-latest,${DOCKER_IMAGE}:debian"
                ;;
              * )
                  BRANCHTAG="${DOCKER_IMAGE}:${RELEASE}-debian,${DOCKER_IMAGE}:${RELEASE}-debian-${DISTRIB},${DOCKER_IMAGE}:${RELEASE}-debian-latest,${DOCKER_IMAGE}:debian"
                ;;
            esac
          fi

          if [[ $GITHUB_REF == refs/tags/* ]]; then
               GITTAG="${DOCKER_IMAGE}:${RELEASE}-debian-${DISTRIB}-$(echo $GITHUB_REF | sed 's|refs/tags/||g')"
          fi

          if [ -n "${BRANCHTAG}" ] && [ -n "${GITTAG}" ]; then
            TAGS=${BRANCHTAG},${GITTAG}
          else
            TAGS="${BRANCHTAG}${GITTAG}"
          fi

          echo ::set-output name=tags::${TAGS}
          echo ::set-output name=docker_image::${DOCKER_IMAGE}

      - name: Set up QEMU
        uses: docker/setup-qemu-action@v1
        with:
          platforms: all

      - name: Set up Docker Buildx
        id: buildx
        uses: docker/setup-buildx-action@v1

      - name: Login to DockerHub
        if: github.event_name != 'pull_request'
        uses: docker/login-action@v1
        with:
          username: ${{ secrets.DOCKER_USERNAME }}
          password: ${{ secrets.DOCKER_PASSWORD }}

      - name: Label
        id: Label
        run: |
          if [ -f "Dockerfile.debian" ] ; then
            sed -i "/FROM .*/a LABEL tiredofit.nodejs.git_repository=\"https://github.com/${GITHUB_REPOSITORY}\"" Dockerfile.debian
            sed -i "/FROM .*/a LABEL tiredofit.nodejs.git_commit=\"${GITHUB_SHA}\"" Dockerfile.debian
            sed -i "/FROM .*/a LABEL tiredofit.nodejs.git_committed_by=\"${GITHUB_ACTOR}\"" Dockerfile.debian
            sed -i "/FROM .*/a LABEL tiredofit.nodejs.image_build_date=\"$(date +'%Y-%m-%d %H:%M:%S')\"" Dockerfile.debian
            if [ -f "CHANGELOG.md" ] ; then
              sed -i "/FROM .*/a LABEL tiredofit.nodejs.git_changelog_version=\"$(head -n1 ./CHANGELOG.md | awk '{print $2}')\"" Dockerfile.debian
            fi

            if [[ $GITHUB_REF == refs/tags/* ]]; then
              sed -i "/FROM .*/a LABEL tiredofit.nodejs.git_tag=\"${GITHUB_REF#refs/tags/v}\"" Dockerfile.debian
            fi

            if [[ $GITHUB_REF == refs/heads/* ]]; then
              sed -i "/FROM .*/a LABEL tiredofit.nodejs.git_branch=\"${GITHUB_REF#refs/heads/}\"" Dockerfile.debian
            fi
          fi

      - name: Switch
        id: Switch
        run: |
          sed -i "s|FROM tiredofit/debian.*|FROM tiredofit/debian:${DISTRIB}|g" Dockerfile.debian

      - name: Build
        uses: docker/build-push-action@v2
        with:
          builder: ${{ steps.buildx.outputs.name }}
          context: .
          file: ./Dockerfile.debian
          platforms: linux/amd64,linux/arm/v7,linux/arm64
          push: true
          tags: ${{ steps.prep.outputs.tags }}
          build-args: |
             NODE_VERSION=${{ env.RELEASE }}

  v14_debian_buster:
    env:
      RELEASE: "14"
      DISTRIB: buster
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v2

      - name: Prepare
        id: prep
        run: |
          DOCKER_IMAGE=${GITHUB_REPOSITORY/docker-/}
          set -x
          if [[ $GITHUB_REF == refs/heads/* ]]; then
             if [[ $GITHUB_REF == refs/heads/*/* ]] ; then
               BRANCH="${DOCKER_IMAGE}:$(echo $GITHUB_REF | sed "s|refs/heads/||g" | sed "s|/|-|g")"
             else
               BRANCH=${GITHUB_REF#refs/heads/}
             fi

            case ${BRANCH} in
              * )
                  BRANCHTAG="${DOCKER_IMAGE}:${RELEASE}-debian,${DOCKER_IMAGE}:${RELEASE}-debian-${DISTRIB},${DOCKER_IMAGE}:${RELEASE}-debian-latest"
                ;;
            esac
          fi

          if [[ $GITHUB_REF == refs/tags/* ]]; then
               GITTAG="${DOCKER_IMAGE}:${RELEASE}-debian-${DISTRIB}-$(echo $GITHUB_REF | sed 's|refs/tags/||g')"
          fi

          if [ -n "${BRANCHTAG}" ] && [ -n "${GITTAG}" ]; then
            TAGS=${BRANCHTAG},${GITTAG}
          else
            TAGS="${BRANCHTAG}${GITTAG}"
          fi

          echo ::set-output name=tags::${TAGS}
          echo ::set-output name=docker_image::${DOCKER_IMAGE}

      - name: Set up QEMU
        uses: docker/setup-qemu-action@v1
        with:
          platforms: all

      - name: Set up Docker Buildx
        id: buildx
        uses: docker/setup-buildx-action@v1

      - name: Login to DockerHub
        if: github.event_name != 'pull_request'
        uses: docker/login-action@v1
        with:
          username: ${{ secrets.DOCKER_USERNAME }}
          password: ${{ secrets.DOCKER_PASSWORD }}

      - name: Label
        id: Label
        run: |
          if [ -f "Dockerfile.debian" ] ; then
            sed -i "/FROM .*/a LABEL tiredofit.nodejs.git_repository=\"https://github.com/${GITHUB_REPOSITORY}\"" Dockerfile.debian
            sed -i "/FROM .*/a LABEL tiredofit.nodejs.git_commit=\"${GITHUB_SHA}\"" Dockerfile.debian
            sed -i "/FROM .*/a LABEL tiredofit.nodejs.git_committed_by=\"${GITHUB_ACTOR}\"" Dockerfile.debian
            sed -i "/FROM .*/a LABEL tiredofit.nodejs.image_build_date=\"$(date +'%Y-%m-%d %H:%M:%S')\"" Dockerfile.debian
            if [ -f "CHANGELOG.md" ] ; then
              sed -i "/FROM .*/a LABEL tiredofit.nodejs.git_changelog_version=\"$(head -n1 ./CHANGELOG.md | awk '{print $2}')\"" Dockerfile.debian
            fi

            if [[ $GITHUB_REF == refs/tags/* ]]; then
              sed -i "/FROM .*/a LABEL tiredofit.nodejs.git_tag=\"${GITHUB_REF#refs/tags/v}\"" Dockerfile.debian
            fi

            if [[ $GITHUB_REF == refs/heads/* ]]; then
              sed -i "/FROM .*/a LABEL tiredofit.nodejs.git_branch=\"${GITHUB_REF#refs/heads/}\"" Dockerfile.debian
            fi
          fi

      - name: Switch
        id: Switch
        run: |
          sed -i "s|FROM tiredofit/debian.*|FROM tiredofit/debian:${DISTRIB}|g" Dockerfile.debian

      - name: Build
        uses: docker/build-push-action@v2
        with:
          builder: ${{ steps.buildx.outputs.name }}
          context: .
          file: ./Dockerfile.debian
          platforms: linux/amd64,linux/arm/v7,linux/arm64
          push: true
          tags: ${{ steps.prep.outputs.tags }}
          build-args: |
             NODE_VERSION=${{ env.RELEASE }}

  v12_debian_buster:
    env:
      RELEASE: "12"
      DISTRIB: buster
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v2

      - name: Prepare
        id: prep
        run: |
          DOCKER_IMAGE=${GITHUB_REPOSITORY/docker-/}
          set -x
          if [[ $GITHUB_REF == refs/heads/* ]]; then
             if [[ $GITHUB_REF == refs/heads/*/* ]] ; then
               BRANCH="${DOCKER_IMAGE}:$(echo $GITHUB_REF | sed "s|refs/heads/||g" | sed "s|/|-|g")"
             else
               BRANCH=${GITHUB_REF#refs/heads/}
             fi

            case ${BRANCH} in
              * )
                  BRANCHTAG="${DOCKER_IMAGE}:${RELEASE}-debian,${DOCKER_IMAGE}:${RELEASE}-debian-${DISTRIB},${DOCKER_IMAGE}:${RELEASE}-debian-latest"
                ;;
            esac
          fi

          if [[ $GITHUB_REF == refs/tags/* ]]; then
               GITTAG="${DOCKER_IMAGE}:${RELEASE}-debian-${DISTRIB}-$(echo $GITHUB_REF | sed 's|refs/tags/||g')"
          fi

          if [ -n "${BRANCHTAG}" ] && [ -n "${GITTAG}" ]; then
            TAGS=${BRANCHTAG},${GITTAG}
          else
            TAGS="${BRANCHTAG}${GITTAG}"
          fi

          echo ::set-output name=tags::${TAGS}
          echo ::set-output name=docker_image::${DOCKER_IMAGE}

      - name: Set up QEMU
        uses: docker/setup-qemu-action@v1
        with:
          platforms: all

      - name: Set up Docker Buildx
        id: buildx
        uses: docker/setup-buildx-action@v1

      - name: Login to DockerHub
        if: github.event_name != 'pull_request'
        uses: docker/login-action@v1
        with:
          username: ${{ secrets.DOCKER_USERNAME }}
          password: ${{ secrets.DOCKER_PASSWORD }}

      - name: Label
        id: Label
        run: |
          if [ -f "Dockerfile.debian" ] ; then
            sed -i "/FROM .*/a LABEL tiredofit.nodejs.git_repository=\"https://github.com/${GITHUB_REPOSITORY}\"" Dockerfile.debian
            sed -i "/FROM .*/a LABEL tiredofit.nodejs.git_commit=\"${GITHUB_SHA}\"" Dockerfile.debian
            sed -i "/FROM .*/a LABEL tiredofit.nodejs.git_committed_by=\"${GITHUB_ACTOR}\"" Dockerfile.debian
            sed -i "/FROM .*/a LABEL tiredofit.nodejs.image_build_date=\"$(date +'%Y-%m-%d %H:%M:%S')\"" Dockerfile.debian
            if [ -f "CHANGELOG.md" ] ; then
              sed -i "/FROM .*/a LABEL tiredofit.nodejs.git_changelog_version=\"$(head -n1 ./CHANGELOG.md | awk '{print $2}')\"" Dockerfile.debian
            fi

            if [[ $GITHUB_REF == refs/tags/* ]]; then
              sed -i "/FROM .*/a LABEL tiredofit.nodejs.git_tag=\"${GITHUB_REF#refs/tags/v}\"" Dockerfile.debian
            fi

            if [[ $GITHUB_REF == refs/heads/* ]]; then
              sed -i "/FROM .*/a LABEL tiredofit.nodejs.git_branch=\"${GITHUB_REF#refs/heads/}\"" Dockerfile.debian
            fi
          fi

      - name: Switch
        id: Switch
        run: |
          sed -i "s|FROM tiredofit/debian.*|FROM tiredofit/debian:${DISTRIB}|g" Dockerfile.debian

      - name: Build
        uses: docker/build-push-action@v2
        with:
          builder: ${{ steps.buildx.outputs.name }}
          context: .
          file: ./Dockerfile.debian
          platforms: linux/amd64,linux/arm/v7,linux/arm64
          push: true
          tags: ${{ steps.prep.outputs.tags }}
          build-args: |
             NODE_VERSION=${{ env.RELEASE }}

  v10_debian_buster:
    env:
      RELEASE: "10"
      DISTRIB: buster
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v2

      - name: Prepare
        id: prep
        run: |
          DOCKER_IMAGE=${GITHUB_REPOSITORY/docker-/}
          set -x
          if [[ $GITHUB_REF == refs/heads/* ]]; then
             if [[ $GITHUB_REF == refs/heads/*/* ]] ; then
               BRANCH="${DOCKER_IMAGE}:$(echo $GITHUB_REF | sed "s|refs/heads/||g" | sed "s|/|-|g")"
             else
               BRANCH=${GITHUB_REF#refs/heads/}
             fi

            case ${BRANCH} in
              * )
                  BRANCHTAG="${DOCKER_IMAGE}:${RELEASE}-debian,${DOCKER_IMAGE}:${RELEASE}-debian-${DISTRIB},${DOCKER_IMAGE}:${RELEASE}-debian-latest"
                ;;
            esac
          fi

          if [[ $GITHUB_REF == refs/tags/* ]]; then
               GITTAG="${DOCKER_IMAGE}:${RELEASE}-debian-${DISTRIB}-$(echo $GITHUB_REF | sed 's|refs/tags/||g')"
          fi

          if [ -n "${BRANCHTAG}" ] && [ -n "${GITTAG}" ]; then
            TAGS=${BRANCHTAG},${GITTAG}
          else
            TAGS="${BRANCHTAG}${GITTAG}"
          fi

          echo ::set-output name=tags::${TAGS}
          echo ::set-output name=docker_image::${DOCKER_IMAGE}

      - name: Set up QEMU
        uses: docker/setup-qemu-action@v1
        with:
          platforms: all

      - name: Set up Docker Buildx
        id: buildx
        uses: docker/setup-buildx-action@v1

      - name: Login to DockerHub
        if: github.event_name != 'pull_request'
        uses: docker/login-action@v1
        with:
          username: ${{ secrets.DOCKER_USERNAME }}
          password: ${{ secrets.DOCKER_PASSWORD }}

      - name: Label
        id: Label
        run: |
          if [ -f "Dockerfile.debian" ] ; then
            sed -i "/FROM .*/a LABEL tiredofit.nodejs.git_repository=\"https://github.com/${GITHUB_REPOSITORY}\"" Dockerfile.debian
            sed -i "/FROM .*/a LABEL tiredofit.nodejs.git_commit=\"${GITHUB_SHA}\"" Dockerfile.debian
            sed -i "/FROM .*/a LABEL tiredofit.nodejs.git_committed_by=\"${GITHUB_ACTOR}\"" Dockerfile.debian
            sed -i "/FROM .*/a LABEL tiredofit.nodejs.image_build_date=\"$(date +'%Y-%m-%d %H:%M:%S')\"" Dockerfile.debian
            if [ -f "CHANGELOG.md" ] ; then
              sed -i "/FROM .*/a LABEL tiredofit.nodejs.git_changelog_version=\"$(head -n1 ./CHANGELOG.md | awk '{print $2}')\"" Dockerfile.debian
            fi

            if [[ $GITHUB_REF == refs/tags/* ]]; then
              sed -i "/FROM .*/a LABEL tiredofit.nodejs.git_tag=\"${GITHUB_REF#refs/tags/v}\"" Dockerfile.debian
            fi

            if [[ $GITHUB_REF == refs/heads/* ]]; then
              sed -i "/FROM .*/a LABEL tiredofit.nodejs.git_branch=\"${GITHUB_REF#refs/heads/}\"" Dockerfile.debian
            fi
          fi

      - name: Switch
        id: Switch
        run: |
          sed -i "s|FROM tiredofit/debian.*|FROM tiredofit/debian:${DISTRIB}|g" Dockerfile.debian

      - name: Build
        uses: docker/build-push-action@v2
        with:
          builder: ${{ steps.buildx.outputs.name }}
          context: .
          file: ./Dockerfile.debian
          platforms: linux/amd64,linux/arm/v7,linux/arm64
          push: true
          tags: ${{ steps.prep.outputs.tags }}
          build-args: |
             NODE_VERSION=${{ env.RELEASE }}

  v16_alpine:
    env:
      RELEASE: "16"
      DISTRIB: "3.13"
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v2
      - name: Prepare
        id: prep
        run: |
          git clone "https://github.com/nodejs/node"  ; cd node
          NODE_VERSION=$(git tag | grep v${RELEASE} | sort -V | tail -1)
          cd ..
          rm -rf node
          sed -i "s|ENV NODE_VERSION=.*|ENV NODE_VERSION=${NODE_VERSION}|g" Dockerfile.alpine

          DOCKER_IMAGE=${GITHUB_REPOSITORY/docker-/}
          set -x
          if [[ $GITHUB_REF == refs/heads/* ]]; then
             if [[ $GITHUB_REF == refs/heads/*/* ]] ; then
               BRANCH="${DOCKER_IMAGE}:$(echo $GITHUB_REF | sed "s|refs/heads/||g" | sed "s|/|-|g")"
             else
               BRANCH=${GITHUB_REF#refs/heads/}
             fi

            case ${BRANCH} in
              * )
                  BRANCHTAG="${DOCKER_IMAGE}:${RELEASE}-alpine,${DOCKER_IMAGE}:${RELEASE}-alpine-${NODE_VERSION},${DOCKER_IMAGE}:${RELEASE}-latest,${DOCKER_IMAGE}:latest"
                ;;
            esac
          fi

          if [[ $GITHUB_REF == refs/tags/* ]]; then
               GITTAG="${DOCKER_IMAGE}:${RELEASE}-alpine-${DISTRIB}-$(echo $GITHUB_REF | sed 's|refs/tags/||g')"
          fi

          if [ -n "${BRANCHTAG}" ] && [ -n "${GITTAG}" ]; then
            TAGS=${BRANCHTAG},${GITTAG}
          else
            TAGS="${BRANCHTAG}${GITTAG}"
          fi

          echo ::set-output name=tags::${TAGS}
          echo ::set-output name=docker_image::${DOCKER_IMAGE}

      - name: Set up QEMU
        uses: docker/setup-qemu-action@v1
        with:
          platforms: all

      - name: Set up Docker Buildx
        id: buildx
        uses: docker/setup-buildx-action@v1

      - name: Login to DockerHub
        if: github.event_name != 'pull_request'
        uses: docker/login-action@v1
        with:
          username: ${{ secrets.DOCKER_USERNAME }}
          password: ${{ secrets.DOCKER_PASSWORD }}

      - name: Label
        id: Label
        run: |
          if [ -f "Dockerfile.alpine" ] ; then
            sed -i "/FROM .*/a LABEL tiredofit.nodejs.git_repository=\"https://github.com/${GITHUB_REPOSITORY}\"" Dockerfile.alpine
            sed -i "/FROM .*/a LABEL tiredofit.nodejs.git_commit=\"${GITHUB_SHA}\"" Dockerfile.alpine
            sed -i "/FROM .*/a LABEL tiredofit.nodejs.git_committed_by=\"${GITHUB_ACTOR}\"" Dockerfile.alpine
            sed -i "/FROM .*/a LABEL tiredofit.nodejs.image_build_date=\"$(date +'%Y-%m-%d %H:%M:%S')\"" Dockerfile.alpine
            if [ -f "CHANGELOG.md" ] ; then
              sed -i "/FROM .*/a LABEL tiredofit.nodejs.git_changelog_version=\"$(head -n1 ./CHANGELOG.md | awk '{print $2}')\"" Dockerfile.alpine
            fi

            if [[ $GITHUB_REF == refs/tags/* ]]; then
              sed -i "/FROM .*/a LABEL tiredofit.nodejs.git_tag=\"${GITHUB_REF#refs/tags/v}\"" Dockerfile.alpine
            fi

            if [[ $GITHUB_REF == refs/heads/* ]]; then
              sed -i "/FROM .*/a LABEL tiredofit.nodejs.git_branch=\"${GITHUB_REF#refs/heads/}\"" Dockerfile.alpine
            fi
          fi

      - name: Switch
        id: Switch
        run: |
          sed -i "s|FROM tiredofit/alpine.*|FROM tiredofit/alpine:${DISTRIB}|g" Dockerfile.alpine

      - name: Build
        uses: docker/build-push-action@v2
        with:
          builder: ${{ steps.buildx.outputs.name }}
          context: .
          file: ./Dockerfile.alpine
          platforms: linux/amd64,linux/arm/v6,linux/arm/v7,linux/arm64
          push: true
          tags: ${{ steps.prep.outputs.tags }}
  v15_alpine:
    env:
      RELEASE: "15"
      DISTRIB: "3.13"
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v2
      - name: Prepare
        id: prep
        run: |
          git clone "https://github.com/nodejs/node"  ; cd node
          NODE_VERSION=$(git tag | grep v${RELEASE} | sort -V | tail -1)
          cd ..
          rm -rf node
          sed -i "s|ENV NODE_VERSION=.*|ENV NODE_VERSION=${NODE_VERSION}|g" Dockerfile.alpine

          DOCKER_IMAGE=${GITHUB_REPOSITORY/docker-/}
          set -x
          if [[ $GITHUB_REF == refs/heads/* ]]; then
             if [[ $GITHUB_REF == refs/heads/*/* ]] ; then
               BRANCH="${DOCKER_IMAGE}:$(echo $GITHUB_REF | sed "s|refs/heads/||g" | sed "s|/|-|g")"
             else
               BRANCH=${GITHUB_REF#refs/heads/}
             fi

            case ${BRANCH} in
              * )
                  BRANCHTAG="${DOCKER_IMAGE}:${RELEASE}-alpine,${DOCKER_IMAGE}:${RELEASE}-alpine-${NODE_VERSION},${DOCKER_IMAGE}:${RELEASE}-latest"
                ;;
            esac
          fi

          if [[ $GITHUB_REF == refs/tags/* ]]; then
               GITTAG="${DOCKER_IMAGE}:${RELEASE}-alpine-${DISTRIB}-$(echo $GITHUB_REF | sed 's|refs/tags/||g')"
          fi

          if [ -n "${BRANCHTAG}" ] && [ -n "${GITTAG}" ]; then
            TAGS=${BRANCHTAG},${GITTAG}
          else
            TAGS="${BRANCHTAG}${GITTAG}"
          fi

          echo ::set-output name=tags::${TAGS}
          echo ::set-output name=docker_image::${DOCKER_IMAGE}

      - name: Set up QEMU
        uses: docker/setup-qemu-action@v1
        with:
          platforms: all

      - name: Set up Docker Buildx
        id: buildx
        uses: docker/setup-buildx-action@v1

      - name: Login to DockerHub
        if: github.event_name != 'pull_request'
        uses: docker/login-action@v1
        with:
          username: ${{ secrets.DOCKER_USERNAME }}
          password: ${{ secrets.DOCKER_PASSWORD }}

      - name: Label
        id: Label
        run: |
          if [ -f "Dockerfile.alpine" ] ; then
            sed -i "/FROM .*/a LABEL tiredofit.nodejs.git_repository=\"https://github.com/${GITHUB_REPOSITORY}\"" Dockerfile.alpine
            sed -i "/FROM .*/a LABEL tiredofit.nodejs.git_commit=\"${GITHUB_SHA}\"" Dockerfile.alpine
            sed -i "/FROM .*/a LABEL tiredofit.nodejs.git_committed_by=\"${GITHUB_ACTOR}\"" Dockerfile.alpine
            sed -i "/FROM .*/a LABEL tiredofit.nodejs.image_build_date=\"$(date +'%Y-%m-%d %H:%M:%S')\"" Dockerfile.alpine
            if [ -f "CHANGELOG.md" ] ; then
              sed -i "/FROM .*/a LABEL tiredofit.nodejs.git_changelog_version=\"$(head -n1 ./CHANGELOG.md | awk '{print $2}')\"" Dockerfile.alpine
            fi

            if [[ $GITHUB_REF == refs/tags/* ]]; then
              sed -i "/FROM .*/a LABEL tiredofit.nodejs.git_tag=\"${GITHUB_REF#refs/tags/v}\"" Dockerfile.alpine
            fi

            if [[ $GITHUB_REF == refs/heads/* ]]; then
              sed -i "/FROM .*/a LABEL tiredofit.nodejs.git_branch=\"${GITHUB_REF#refs/heads/}\"" Dockerfile.alpine
            fi
          fi

      - name: Switch
        id: Switch
        run: |
          sed -i "s|FROM tiredofit/alpine.*|FROM tiredofit/alpine:${DISTRIB}|g" Dockerfile.alpine

      - name: Build
        uses: docker/build-push-action@v2
        with:
          builder: ${{ steps.buildx.outputs.name }}
          context: .
          file: ./Dockerfile.alpine
          platforms: linux/amd64,linux/arm/v6,linux/arm/v7,linux/arm64
          push: true
          tags: ${{ steps.prep.outputs.tags }}
  v14_alpine:
    env:
      RELEASE: "14"
      DISTRIB: "3.13"
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v2
      - name: Prepare
        id: prep
        run: |
          git clone "https://github.com/nodejs/node"  ; cd node
          NODE_VERSION=$(git tag | grep v${RELEASE} | sort -V | tail -1)
          cd ..
          rm -rf node
          sed -i "s|ENV NODE_VERSION=.*|ENV NODE_VERSION=${NODE_VERSION}|g" Dockerfile.alpine

          DOCKER_IMAGE=${GITHUB_REPOSITORY/docker-/}
          set -x
          if [[ $GITHUB_REF == refs/heads/* ]]; then
             if [[ $GITHUB_REF == refs/heads/*/* ]] ; then
               BRANCH="${DOCKER_IMAGE}:$(echo $GITHUB_REF | sed "s|refs/heads/||g" | sed "s|/|-|g")"
             else
               BRANCH=${GITHUB_REF#refs/heads/}
             fi

            case ${BRANCH} in
              * )
                  BRANCHTAG="${DOCKER_IMAGE}:${RELEASE}-alpine,${DOCKER_IMAGE}:${RELEASE}-alpine-${NODE_VERSION},${DOCKER_IMAGE}:${RELEASE}-latest"
                ;;
            esac
          fi

          if [[ $GITHUB_REF == refs/tags/* ]]; then
               GITTAG="${DOCKER_IMAGE}:${RELEASE}-alpine-${DISTRIB}-$(echo $GITHUB_REF | sed 's|refs/tags/||g')"
          fi

          if [ -n "${BRANCHTAG}" ] && [ -n "${GITTAG}" ]; then
            TAGS=${BRANCHTAG},${GITTAG}
          else
            TAGS="${BRANCHTAG}${GITTAG}"
          fi

          echo ::set-output name=tags::${TAGS}
          echo ::set-output name=docker_image::${DOCKER_IMAGE}

      - name: Set up QEMU
        uses: docker/setup-qemu-action@v1
        with:
          platforms: all

      - name: Set up Docker Buildx
        id: buildx
        uses: docker/setup-buildx-action@v1

      - name: Login to DockerHub
        if: github.event_name != 'pull_request'
        uses: docker/login-action@v1
        with:
          username: ${{ secrets.DOCKER_USERNAME }}
          password: ${{ secrets.DOCKER_PASSWORD }}

      - name: Label
        id: Label
        run: |
          if [ -f "Dockerfile.alpine" ] ; then
            sed -i "/FROM .*/a LABEL tiredofit.nodejs.git_repository=\"https://github.com/${GITHUB_REPOSITORY}\"" Dockerfile.alpine
            sed -i "/FROM .*/a LABEL tiredofit.nodejs.git_commit=\"${GITHUB_SHA}\"" Dockerfile.alpine
            sed -i "/FROM .*/a LABEL tiredofit.nodejs.git_committed_by=\"${GITHUB_ACTOR}\"" Dockerfile.alpine
            sed -i "/FROM .*/a LABEL tiredofit.nodejs.image_build_date=\"$(date +'%Y-%m-%d %H:%M:%S')\"" Dockerfile.alpine
            if [ -f "CHANGELOG.md" ] ; then
              sed -i "/FROM .*/a LABEL tiredofit.nodejs.git_changelog_version=\"$(head -n1 ./CHANGELOG.md | awk '{print $2}')\"" Dockerfile.alpine
            fi

            if [[ $GITHUB_REF == refs/tags/* ]]; then
              sed -i "/FROM .*/a LABEL tiredofit.nodejs.git_tag=\"${GITHUB_REF#refs/tags/v}\"" Dockerfile.alpine
            fi

            if [[ $GITHUB_REF == refs/heads/* ]]; then
              sed -i "/FROM .*/a LABEL tiredofit.nodejs.git_branch=\"${GITHUB_REF#refs/heads/}\"" Dockerfile.alpine
            fi
          fi

      - name: Switch
        id: Switch
        run: |
          sed -i "s|FROM tiredofit/alpine.*|FROM tiredofit/alpine:${DISTRIB}|g" Dockerfile.alpine

      - name: Build
        uses: docker/build-push-action@v2
        with:
          builder: ${{ steps.buildx.outputs.name }}
          context: .
          file: ./Dockerfile.alpine
          platforms: linux/amd64,linux/arm/v6,linux/arm/v7,linux/arm64
          push: true
          tags: ${{ steps.prep.outputs.tags }}
  v12_alpine:
    env:
      RELEASE: "12"
      DISTRIB: "3.13"
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v2
      - name: Prepare
        id: prep
        run: |
          git clone "https://github.com/nodejs/node"  ; cd node
          NODE_VERSION=$(git tag | grep v${RELEASE} | sort -V | tail -1)
          cd ..
          rm -rf node
          sed -i "s|ENV NODE_VERSION=.*|ENV NODE_VERSION=${NODE_VERSION}|g" Dockerfile.alpine

          DOCKER_IMAGE=${GITHUB_REPOSITORY/docker-/}
          set -x
          if [[ $GITHUB_REF == refs/heads/* ]]; then
             if [[ $GITHUB_REF == refs/heads/*/* ]] ; then
               BRANCH="${DOCKER_IMAGE}:$(echo $GITHUB_REF | sed "s|refs/heads/||g" | sed "s|/|-|g")"
             else
               BRANCH=${GITHUB_REF#refs/heads/}
             fi

            case ${BRANCH} in
              * )
                  BRANCHTAG="${DOCKER_IMAGE}:${RELEASE}-alpine,${DOCKER_IMAGE}:${RELEASE}-alpine-${NODE_VERSION},${DOCKER_IMAGE}:${RELEASE}-latest"
                ;;
            esac
          fi

          if [[ $GITHUB_REF == refs/tags/* ]]; then
               GITTAG="${DOCKER_IMAGE}:${RELEASE}-alpine-${DISTRIB}-$(echo $GITHUB_REF | sed 's|refs/tags/||g')"
          fi

          if [ -n "${BRANCHTAG}" ] && [ -n "${GITTAG}" ]; then
            TAGS=${BRANCHTAG},${GITTAG}
          else
            TAGS="${BRANCHTAG}${GITTAG}"
          fi

          echo ::set-output name=tags::${TAGS}
          echo ::set-output name=docker_image::${DOCKER_IMAGE}

      - name: Set up QEMU
        uses: docker/setup-qemu-action@v1
        with:
          platforms: all

      - name: Set up Docker Buildx
        id: buildx
        uses: docker/setup-buildx-action@v1

      - name: Login to DockerHub
        if: github.event_name != 'pull_request'
        uses: docker/login-action@v1
        with:
          username: ${{ secrets.DOCKER_USERNAME }}
          password: ${{ secrets.DOCKER_PASSWORD }}

      - name: Label
        id: Label
        run: |
          if [ -f "Dockerfile.alpine" ] ; then
            sed -i "/FROM .*/a LABEL tiredofit.nodejs.git_repository=\"https://github.com/${GITHUB_REPOSITORY}\"" Dockerfile.alpine
            sed -i "/FROM .*/a LABEL tiredofit.nodejs.git_commit=\"${GITHUB_SHA}\"" Dockerfile.alpine
            sed -i "/FROM .*/a LABEL tiredofit.nodejs.git_committed_by=\"${GITHUB_ACTOR}\"" Dockerfile.alpine
            sed -i "/FROM .*/a LABEL tiredofit.nodejs.image_build_date=\"$(date +'%Y-%m-%d %H:%M:%S')\"" Dockerfile.alpine
            if [ -f "CHANGELOG.md" ] ; then
              sed -i "/FROM .*/a LABEL tiredofit.nodejs.git_changelog_version=\"$(head -n1 ./CHANGELOG.md | awk '{print $2}')\"" Dockerfile.alpine
            fi

            if [[ $GITHUB_REF == refs/tags/* ]]; then
              sed -i "/FROM .*/a LABEL tiredofit.nodejs.git_tag=\"${GITHUB_REF#refs/tags/v}\"" Dockerfile.alpine
            fi

            if [[ $GITHUB_REF == refs/heads/* ]]; then
              sed -i "/FROM .*/a LABEL tiredofit.nodejs.git_branch=\"${GITHUB_REF#refs/heads/}\"" Dockerfile.alpine
            fi
          fi

      - name: Switch
        id: Switch
        run: |
          sed -i "s|FROM tiredofit/alpine.*|FROM tiredofit/alpine:${DISTRIB}|g" Dockerfile.alpine

      - name: Build
        uses: docker/build-push-action@v2
        with:
          builder: ${{ steps.buildx.outputs.name }}
          context: .
          file: ./Dockerfile.alpine
          platforms: linux/amd64,linux/arm/v6,linux/arm/v7,linux/arm64
          push: true
          tags: ${{ steps.prep.outputs.tags }}
  v10_alpine:
    env:
      RELEASE: "10"
      DISTRIB: "3.13"
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v2
      - name: Prepare
        id: prep
        run: |
          git clone "https://github.com/nodejs/node"  ; cd node
          NODE_VERSION=$(git tag | grep v${RELEASE} | sort -V | tail -1)
          cd ..
          rm -rf node
          sed -i "s|ENV NODE_VERSION=.*|ENV NODE_VERSION=${NODE_VERSION}|g" Dockerfile.alpine

          DOCKER_IMAGE=${GITHUB_REPOSITORY/docker-/}
          set -x
          if [[ $GITHUB_REF == refs/heads/* ]]; then
             if [[ $GITHUB_REF == refs/heads/*/* ]] ; then
               BRANCH="${DOCKER_IMAGE}:$(echo $GITHUB_REF | sed "s|refs/heads/||g" | sed "s|/|-|g")"
             else
               BRANCH=${GITHUB_REF#refs/heads/}
             fi

            case ${BRANCH} in
              * )
                  BRANCHTAG="${DOCKER_IMAGE}:${RELEASE}-alpine,${DOCKER_IMAGE}:${RELEASE}-alpine-${NODE_VERSION},${DOCKER_IMAGE}:${RELEASE}-latest"
                ;;
            esac
          fi

          if [[ $GITHUB_REF == refs/tags/* ]]; then
               GITTAG="${DOCKER_IMAGE}:${RELEASE}-alpine-${DISTRIB}-$(echo $GITHUB_REF | sed 's|refs/tags/||g')"
          fi

          if [ -n "${BRANCHTAG}" ] && [ -n "${GITTAG}" ]; then
            TAGS=${BRANCHTAG},${GITTAG}
          else
            TAGS="${BRANCHTAG}${GITTAG}"
          fi

          echo ::set-output name=tags::${TAGS}
          echo ::set-output name=docker_image::${DOCKER_IMAGE}

      - name: Set up QEMU
        uses: docker/setup-qemu-action@v1
        with:
          platforms: all

      - name: Set up Docker Buildx
        id: buildx
        uses: docker/setup-buildx-action@v1

      - name: Login to DockerHub
        if: github.event_name != 'pull_request'
        uses: docker/login-action@v1
        with:
          username: ${{ secrets.DOCKER_USERNAME }}
          password: ${{ secrets.DOCKER_PASSWORD }}

      - name: Label
        id: Label
        run: |
          if [ -f "Dockerfile.alpine" ] ; then
            sed -i "/FROM .*/a LABEL tiredofit.nodejs.git_repository=\"https://github.com/${GITHUB_REPOSITORY}\"" Dockerfile.alpine
            sed -i "/FROM .*/a LABEL tiredofit.nodejs.git_commit=\"${GITHUB_SHA}\"" Dockerfile.alpine
            sed -i "/FROM .*/a LABEL tiredofit.nodejs.git_committed_by=\"${GITHUB_ACTOR}\"" Dockerfile.alpine
            sed -i "/FROM .*/a LABEL tiredofit.nodejs.image_build_date=\"$(date +'%Y-%m-%d %H:%M:%S')\"" Dockerfile.alpine
            if [ -f "CHANGELOG.md" ] ; then
              sed -i "/FROM .*/a LABEL tiredofit.nodejs.git_changelog_version=\"$(head -n1 ./CHANGELOG.md | awk '{print $2}')\"" Dockerfile.alpine
            fi

            if [[ $GITHUB_REF == refs/tags/* ]]; then
              sed -i "/FROM .*/a LABEL tiredofit.nodejs.git_tag=\"${GITHUB_REF#refs/tags/v}\"" Dockerfile.alpine
            fi

            if [[ $GITHUB_REF == refs/heads/* ]]; then
              sed -i "/FROM .*/a LABEL tiredofit.nodejs.git_branch=\"${GITHUB_REF#refs/heads/}\"" Dockerfile.alpine
            fi
          fi

      - name: Switch
        id: Switch
        run: |
          sed -i "s|FROM tiredofit/alpine.*|FROM tiredofit/alpine:${DISTRIB}|g" Dockerfile.alpine

      - name: Build
        uses: docker/build-push-action@v2
        with:
          builder: ${{ steps.buildx.outputs.name }}
          context: .
          file: ./Dockerfile.alpine
          platforms: linux/amd64,linux/arm/v6,linux/arm/v7,linux/arm64
          push: true
          tags: ${{ steps.prep.outputs.tags }}

