<1> Cron expression to run every working day at 7pm UTC
<2> The default restartPolicy is not allowed and must be set to OnFailure or Never
<3> Docker image with the kubectl tool
<4> Selector to match all deployments with label environment=dev
<5> Set the number of pods. Use 0 to remove all pods.
<6> Service account to run the job. Requires permission to manipulate the deployment specs.