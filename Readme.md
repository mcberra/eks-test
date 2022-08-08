1. Add cluster credentials values to the following variables in the ~/.bashrc file
  - AWS_ACCESS_KEY_ID
  - AWS_SECRET_ACCESS_KEY
  - AWS_DEFAULT_REGION
  - EKS_CLUSTER_NAME
2. Run 'source ~/.bashrc' so this changes are loaded
3. Run '$update_kubeconfig' to add a ~/.kube/config file with credentials for the macb-eks cluster, you should recieve an output like the following
  - Added new context arn:aws:eks:eu-west-1:<aws_account_id>:cluster/<cluster_name> to /home/ec2-user/.kube/config
4. Run 'sh /home/ec2-user/eks-test/scripts/aws_cli_istioctl_install.sh' to upgrade AWS CLI version from 1.18 to 1.25 and install istio CLI
5. Run 'source /home/ec2-user/.bash_profile' so this changes are loaded
6. From /home/ec2-user/eks-test directory, run '$init' to initialize terraform
7. Uncomment the files k8_resources.tf and helm_installed_resources.tf by removing the "/*" at the top and the "*/" at the end of the file
8. Run '$plan' to see all the resources that will be created
9. Run '$apply' to create all the resources
10. If you recieve any errors while creating this resources such as the following, just run '$update_kubeconfig' again, and '$apply' right after
   - Error: Kubernetes cluster unreachable: exec plugin: invalid apiVersion "client.authentication.k8s.io/v1alpha1"
11. To expose the addons (kiali,grafana,prometheus,jaeger), run 'sh /home/ec2-user/eks-test/scripts/expose_addons_http.sh'