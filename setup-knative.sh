#!/bin/sh

set -x

# Grab our libs
. "`dirname $0`/setup-knative.sh"

if [ -f $OURDIR/knative-done ]; then
    exit 0
fi

logtstart "knative"

kubectl apply -f https://github.com/knative/serving/releases/download/knative-v1.14.1/serving-crds.yaml

kubectl apply -f https://github.com/knative/serving/releases/download/knative-v1.14.1/serving-core.yaml

kubectl apply -f https://github.com/knative/net-kourier/releases/download/knative-v1.14.0/kourier.yaml

kubectl apply -f https://github.com/knative/net-kourier/releases/download/knative-v1.18.0/kourier.yaml

kubectl patch configmap/config-network \
  --namespace knative-serving \
  --type merge \
  --patch '{"data":{"ingress-class":"kourier.ingress.networking.knative.dev"}}'

kubectl patch -n knative-serving configmaps config-autoscaler --type strategic --patch '{"data":{"enable-scale-to-zero":"false"}}'


logtend "knative"
touch $OURDIR/knative-done
exit 0
