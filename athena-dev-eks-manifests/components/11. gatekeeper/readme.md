1. Install Gatekeeper
helm repo add gatekeeper https://open-policy-agent.github.io/gatekeeper/charts
helm install gatekeeper/gatekeeper --name-template=gatekeeper --namespace gatekeeper-system --create-namespace \
--set controllerManager.hostNetwork=true \
--set audit.hostNetwork=true

To upgrade Gatekeeper to newest version
helm repo add gatekeeper https://open-policy-agent.github.io/gatekeeper/charts --force-update