FROM public.ecr.aws/docker/library/alpine:3.20
RUN apk add --no-cache bash wget jq python3 py3-docker-py
