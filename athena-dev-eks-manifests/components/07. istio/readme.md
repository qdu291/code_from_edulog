1. Install istioctl
2. Install istio using istioctl with demo profile

        istioctl install --set profile=demo --set values.gateways.istio-ingressgateway.type=NodePort
3. Patch istiod deployment to work with Calico CNI

        kubectl patch deployment istiod -n istio-system --patch '{"spec":{"template":{"spec":{"hostNetwork": true}}}}'

After patching, delete the old replicaset of istiod
