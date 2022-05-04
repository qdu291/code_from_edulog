1. Delete aws-node DaemonSet

        kubectl delete daemonset -n kube-system aws-node

2. Apply

        kubectl apply -f calico-vxlan.yml

3. Terminate all created instance and let AWS create new instances with Calico CNI applied