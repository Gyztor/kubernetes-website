# Kubernetes Website
## References: 
https://docs.bitnami.com/tutorials/secure-wordpress-kubernetes-managed-database-ssl-upgrades/ (Secure traffic with TLS and Let's Encrypt SSL certificates)
https://charts.bitnami.com/bitnami
https://charts.jetstack.io

## Prereq
make sure you have helm charts (if your using rancher go to Apps&market place):
https://charts.bitnami.com/bitnami
https://charts.jetstack.io
if you don't use rancher or don't have them there will also be code snippets for them too.


### NOTE IF YOU'RE USING RANCHER YOU ONLY NEED THE values.yaml FILE TO DO WHAT YOU NEED.


## Nginx Setup:
first install bitnami's nginx ingress controller (https://github.com/bitnami/charts/tree/master/bitnami/nginx-ingress-controller)
it is preferable not to have namespace be default (best results so far.)

### if you use digital ocean go to Networking > Load Balancers > {Load Balancer created by website} > Settings
### than change forwarding rules to http (on 80 to whatever your nginx exposes) and https (on 443 to whatever your nginx exposes) and make sure https has a certificate. (you can create one in that menu and even import one.

### you can run the sh script if you want to it basically does the same as the first one just make sure to edit it
main (for if you download the file. THE MOST RECOMENDED):
```
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
helm dependancy update
kubectl create namespace <namespace-name>
helm install <releasename> ./ --namespace <namespace>
```
main (for if you want to directly download the nginx ingress manager. EASIEST):
```
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
kubectl create namespace <namespace-name>
helm install <releasename> bitnami/nginx-ingress-controller --namespace <namespace>
```
main default (puts it in a default namespace but you change the release name. NOT RECOMENDED should have different namespace):
```
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
helm install <releasename> bitnami/nginx-ingress-controller
```
base (full default. NOT RECOMENDED should have different namespace):
```
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
helm install ingress bitnami/nginx-ingress-controller
```
code for values.yaml (based off of the rancher values.yaml):
```
addHeaders: {}
affinity: {}
args: []
autoscaling:
  enabled: false
  maxReplicas: 11
  minReplicas: 1
  targetCPU: ''
  targetMemory: ''
command: []
commonAnnotations: {}
commonLabels: {}
config: {}
configMapNamespace: ''
containerPorts:
  http: 80
  https: 443
  metrics: 10254
containerSecurityContext:
  allowPrivilegeEscalation: true
  capabilities:
    add:
      - NET_BIND_SERVICE
    drop:
      - ALL
  enabled: true
  runAsUser: 1001
customLivenessProbe: {}
customReadinessProbe: {}
customTemplate:
  configMapKey: ''
  configMapName: ''
daemonset:
  hostPorts:
    http: 80
    https: 443
  useHostPort: false
defaultBackend:
  affinity: {}
  containerPort: 8080
  containerSecurityContext:
    enabled: true
    runAsUser: 1001
  enabled: true
  extraArgs: {}
  hostAliases: []
  image:
    pullPolicy: IfNotPresent
    pullSecrets: []
    registry: docker.io
    repository: bitnami/nginx
    tag: 1.21.1-debian-10-r24
  livenessProbe:
    enabled: true
    failureThreshold: 3
    httpGet:
      path: /healthz
      port: http
      scheme: HTTP
    initialDelaySeconds: 30
    periodSeconds: 10
    successThreshold: 1
    timeoutSeconds: 5
  nodeAffinityPreset:
    key: ''
    type: ''
    values: []
  nodeSelector: {}
  pdb:
    create: false
    maxUnavailable: ''
    minAvailable: 1
  podAffinityPreset: ''
  podAnnotations: {}
  podAntiAffinityPreset: soft
  podLabels: {}
  podSecurityContext:
    enabled: true
    fsGroup: 1001
  priorityClassName: ''
  readinessProbe:
    enabled: true
    failureThreshold: 6
    httpGet:
      path: /healthz
      port: http
      scheme: HTTP
    initialDelaySeconds: 0
    periodSeconds: 5
    successThreshold: 1
    timeoutSeconds: 5
  replicaCount: 1
  resources:
    limits: {}
    requests: {}
  serverBlockConfig: |-
    location /healthz {
      return 200;
    }
    proxy_busy_buffers_size   512k;
  
    proxy_buffers   4 512k;
  
    proxy_buffer_size   256k;
  
    fastcgi_buffers 16 256k;
  
    fastcgi_buffer_size 256k;
  
  
    index index.php index.html index.htm;
  
    add_header X-Frame-Options "SAMEORIGIN" always;
  
    add_header X-XSS-Protection "1; mode=block" always;
  
    add_header X-Content-Type-Options "nosniff" always;
  
    add_header Referrer-Policy "no-referrer-when-downgrade" always;
  
    add_header Content-Security-Policy "default-src * data: 'unsafe-eval'
    'unsafe-inline'" always;
  
    add_header Strict-Transport-Security 'max-age=300; includeSubDomains; preload;
    always;';
  
  
    gzip on;
  
    gzip_vary on;
  
    gzip_proxied any;
  
    gzip_comp_level 6;
  
    gzip_buffers 16 8k;
  
    gzip_http_version 1.1;
  
    gzip_types image/svg+xml text/plain text/html text/xml text/css
    text/javascript application/xml application/xhtml+xml application/rss+xml
    application/javascript application/x-javascript application/x-font-ttf
    application/vnd.ms-fon$
  
  
    location / {
            try_files $uri $uri/ /index.php$is_args$args;
    }
  
    location ~ \.php$ {
            try_files $uri =404;
            fastcgi_split_path_info ^(.+\.php)(/.+)$;
            fastcgi_pass wordpress:9000;
            fastcgi_index index.php;
            fastcgi_param PHP_VALUE "upload_max_filesize = 2042M \n post_max_size=2045M";
            include fastcgi_params;
            fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
            fastcgi_param PATH_INFO $fastcgi_path_info;
    }
  
    location ~ /\.ht {
            deny all;
    }
  
    location = /favicon.ico {
            log_not_found off; access_log off;
    }
  
    location = /robots.txt {
            log_not_found off; access_log off; allow all;
    }
  
    location ~* \.(css|gif|ico|jpeg|jpg|js|png)$ {
            expires max;
            log_not_found off;
    }
  
    location ~ ^/\.user\.ini {
            deny all;
    }
  
    location ~* /wp-content/uploads/bb_medias/ {
            if ( $upstream_http_x_accel_redirect = "" ) {
                    return 403;
            }
            internal;
    }
  
    location ~* /wp-content/uploads/bb_videos/ {
            if ( $upstream_http_x_accel_redirect = "" ) {
                    return 403;
            }
            internal;
    }
  
    location ~* /wp-content/uploads/bb_documents/ {
            if ( $upstream_http_x_accel_redirect = "" ) {
                    return 403;
            }
            internal;
    }
  
    location ~* /wp-content/uploads/bb_medias/ {
            autoindex off;
    }
  
    location ~* /wp-content/uploads/bb_videos/ {
            autoindex off;
    }
  
    location ~* /wp-content/uploads/bb_documents/ {
            autoindex off;
    }
  service:
    port: 80
    type: ClusterIP
  tolerations: []
defaultBackendService: ''
dhParam: ''
dnsPolicy: ClusterFirst
electionID: ingress-controller-leader
extraArgs: {}
extraDeploy: []
extraEnvVars: []
extraEnvVarsCM: ''
extraEnvVarsSecret: ''
extraVolumeMounts: []
extraVolumes: []
fullnameOverride: ''
global:
  imagePullSecrets: []
  imageRegistry: ''
hostAliases: []
hostNetwork: false
image:
  pullPolicy: IfNotPresent
  pullSecrets: []
  registry: docker.io
  repository: bitnami/nginx-ingress-controller
  tag: 0.48.1-debian-10-r17
ingressClass: nginx
initContainers: []
kind: Deployment
lifecycle: {}
livenessProbe:
  enabled: true
  failureThreshold: 3
  httpGet:
    path: /healthz
    port: 10254
    scheme: HTTP
  initialDelaySeconds: 10
  periodSeconds: 10
  successThreshold: 1
  timeoutSeconds: 1
maxmindLicenseKey: ''
metrics:
  enabled: false
  prometheusRule:
    additionalLabels: {}
    enabled: false
    namespace: ''
    rules: []
  service:
    annotations:
      prometheus.io/port: '{{ .Values.metrics.service.port }}'
      prometheus.io/scrape: 'true'
    port: 9913
    type: ClusterIP
  serviceMonitor:
    enabled: false
    interval: 30s
    namespace: ''
    scrapeTimeout: ''
    selector: {}
minReadySeconds: 0
nameOverride: ''
nodeAffinityPreset:
  key: ''
  type: ''
  values: []
nodeSelector: {}
pdb:
  create: false
  maxUnavailable: ''
  minAvailable: 1
podAffinityPreset: ''
podAnnotations: {}
podAntiAffinityPreset: soft
podLabels: {}
podSecurityContext:
  enabled: true
  fsGroup: 1001
podSecurityPolicy:
  enabled: false
priorityClassName: ''
proxySetHeaders: {}
publishService:
  enabled: false
  pathOverride: ''
rbac:
  create: true
readinessProbe:
  enabled: true
  failureThreshold: 3
  httpGet:
    path: /healthz
    port: 10254
    scheme: HTTP
  initialDelaySeconds: 10
  periodSeconds: 10
  successThreshold: 1
  timeoutSeconds: 1
replicaCount: 1
reportNodeInternalIp: false
resources:
  limits: {}
  requests: {}
revisionHistoryLimit: 10
scope:
  enabled: false
service:
  annotations: {}
  clusterIP: ''
  externalIPs: []
  externalTrafficPolicy: ''
  healthCheckNodePort: 0
  labels: {}
  loadBalancerIP: ''
  loadBalancerSourceRanges: []
  nodePorts:
    http: ''
    https: ''
    tcp: {}
    udp: {}
  ports:
    http: 80
    https: 443
  targetPorts:
    http: http
    https: https
  type: LoadBalancer
serviceAccount:
  annotations: {}
  create: true
  name: ''
sidecars: []
tcp: {}
tcpConfigMapNamespace: ''
terminationGracePeriodSeconds: 60
tolerations: []
topologySpreadConstraints: []
udp: {}
udpConfigMapNamespace: ''
updateStrategy: {}
```
## Cert-Manager Setup (helps deal with wordpress issues):
after that you need to install cert-manger.
### DO NOT USE BITNAMI'S. USE https://charts.jetstack.io
everything with this can be base except for installCRDs. (installCRDs: true)
you can also run the sh script provided in the file make sure to edit it
### you can run the sh script if you want to it basically does the same as the first one just make sure to edit it
main (for if you download the file. THE MOST RECOMENDED installs CRDs automatically due to values.yaml. double check though):
```
helm repo add jetstack https://charts.jetstack.io
helm repo update
helm dependancy update
kubectl create namespace <namespace-name>
helm install <releasename> ./ --namespace <namespace>
```
main (for if you want to directly download the nginx ingress manager. EASIEST):
```
helm repo add jetstack https://charts.jetstack.io
helm repo update
kubectl create namespace <namespace-name>
kubectl apply --validate=false -f https://github.com/jetstack/cert-manager/releases/download/v1.5.0-beta.1/cert-manager.crds.yaml
helm install <releasename> jetstack/cert-manager --namespace <namespace>
```
main default (puts it in a default namespace but you change the release name. NOT RECOMENDED should have seprate name space):
```
helm repo add jetstack https://charts.jetstack.io
helm repo update
kubectl apply --validate=false -f https://github.com/jetstack/cert-manager/releases/download/v1.5.0-beta.1/cert-manager.crds.yaml
helm install <releasename> jetstack/cert-manager
```
base (NOT RECOMENDED should have seprate name space):
```
helm repo add jetstack https://charts.jetstack.io
helm repo update
kubectl apply --validate=false -f https://github.com/jetstack/cert-manager/releases/download/v1.5.0-beta.1/cert-manager.crds.yaml
helm install cert-manager jetstack/cert-manager
```
values.yaml (refernced from rancher):
```
affinity: {}
cainjector:
  affinity: {}
  containerSecurityContext: {}
  enabled: true
  extraArgs: []
  image:
    pullPolicy: IfNotPresent
    repository: quay.io/jetstack/cert-manager-cainjector
  nodeSelector: {}
  podLabels: {}
  replicaCount: 1
  resources: {}
  securityContext:
    runAsNonRoot: true
  serviceAccount:
    automountServiceAccountToken: true
    create: true
  strategy: {}
  tolerations: []
clusterResourceNamespace: ''
containerSecurityContext: {}
extraArgs: []
extraEnv: []
featureGates: ''
global:
  imagePullSecrets: []
  leaderElection:
    namespace: kube-system
  logLevel: 2
  podSecurityPolicy:
    enabled: false
    useAppArmor: true
  priorityClassName: ''
  rbac:
    create: true
image:
  pullPolicy: IfNotPresent
  repository: quay.io/jetstack/cert-manager-controller
ingressShim: {}
installCRDs: true
nodeSelector: {}
podLabels: {}
prometheus:
  enabled: true
  servicemonitor:
    enabled: false
    interval: 60s
    labels: {}
    path: /metrics
    prometheusInstance: default
    scrapeTimeout: 30s
    targetPort: 9402
replicaCount: 1
resources: {}
securityContext:
  runAsNonRoot: true
serviceAccount:
  automountServiceAccountToken: true
  create: true
strategy: {}
tolerations: []
volumeMounts: []
volumes: []
webhook:
  affinity: {}
  containerSecurityContext: {}
  extraArgs: []
  hostNetwork: false
  image:
    pullPolicy: IfNotPresent
    repository: quay.io/jetstack/cert-manager-webhook
  livenessProbe:
    failureThreshold: 3
    initialDelaySeconds: 60
    periodSeconds: 10
    successThreshold: 1
    timeoutSeconds: 1
  nodeSelector: {}
  podLabels: {}
  readinessProbe:
    failureThreshold: 3
    initialDelaySeconds: 5
    periodSeconds: 5
    successThreshold: 1
    timeoutSeconds: 1
  replicaCount: 1
  resources: {}
  securePort: 10250
  securityContext:
    runAsNonRoot: true
  serviceAccount:
    automountServiceAccountToken: true
    create: true
  serviceType: ClusterIP
  strategy: {}
  timeoutSeconds: 10
  tolerations: []
  url: {}
```
after that you need to make a ClusterIssuer make sure to change the email address to yours (it does need to be valid i believe)
```
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: letsencrypt-prod
  labels:
    name: letsencrypt-prod
spec:
  acme:
    email: <email address here>
    privateKeySecretRef:
      name: letsencrypt-prod
    server: https://acme-v02.api.letsencrypt.org/directory
    solvers:
    - http01:
        ingress:
          class: nginx
```
than do:
```
kubectl apply -f letsencrypt-prod.yaml
```
## Wordpress Setup:
after that you will now install wordpress using the bitnami charts.
this part is important so please read through everything to ensure you have changed the place holders I have placed to what you want to use
### you can run the sh script if you want to it basically does the same as the first one just make sure to edit it
main (for if you download the file. THE MOST RECOMENDED. make sure to edit values.yaml):
```
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
helm dependancy update
kubectl create namespace <namespace-name>
helm install <releasename> ./ --namespace <namespace>
```
main (for if you want to directly download the nginx ingress manager. EASIEST):
```
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
kubectl create namespace <namespace-name>
helm install <releasename> bitnami/wordpress --namespace <namespace> \
  --set service.type=ClusterIP \
  --set ingress.enabled=true \
  --set ingress.certManager=true \
  --set ingress.annotations."kubernetes\.io/ingress\.class"=nginx \
  --set ingress.annotations."cert-manager\.io/cluster-issuer"=letsencrypt-prod \
  --set ingress.hostname=<Change to your domain> \
  --set ingress.extraTls[0].hosts[0]=<Change to your domain> \
  --set ingress.extraTls[0].secretName=wordpress.local-tls
```
main default (puts it in a default namespace but you change the release name. NOT ENTIRELY RECOMENDED BUT WON'T HURT should be in a different name space):
```
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
helm install <releasename> bitnami/wordpress \
  --set service.type=ClusterIP \
  --set ingress.enabled=true \
  --set ingress.certManager=true \
  --set ingress.annotations."kubernetes\.io/ingress\.class"=nginx \
  --set ingress.annotations."cert-manager\.io/cluster-issuer"=letsencrypt-prod \
  --set ingress.hostname=<Change to your domain> \
  --set ingress.extraTls[0].hosts[0]=<Change to your domain> \
  --set ingress.extraTls[0].secretName=wordpress.local-tls
```
base (full default. NOT RECOMENDED should have a different release name at LEAST):
```
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
helm install wordpress bitnami/wordpress \
  --set service.type=ClusterIP \
  --set ingress.enabled=true \
  --set ingress.certManager=true \
  --set ingress.annotations."kubernetes\.io/ingress\.class"=nginx \
  --set ingress.annotations."cert-manager\.io/cluster-issuer"=letsencrypt-prod \
  --set ingress.hostname=<Change to your domain> \
  --set ingress.extraTls[0].hosts[0]=<Change to your domain> \
  --set ingress.extraTls[0].secretName=wordpress.local-tls
```
values.yaml (based on ranchers):
```
affinity: {}
allowEmptyPassword: true
allowOverrideNone: false
apacheConfiguration: ''
args: []
autoscaling:
  enabled: false
  maxReplicas: 11
  minReplicas: 1
  targetCPU: 50
  targetMemory: 50
clusterDomain: cluster.local
command: []
commonAnnotations: {}
commonLabels: {}
containerPorts:
  http: 8080
  https: 8443
containerSecurityContext:
  enabled: true
  runAsNonRoot: true
  runAsUser: 1001
customHTAccessCM: ''
customLivenessProbe: {}
customPostInitScripts: {}
customReadinessProbe: {}
diagnosticMode:
  args:
    - infinity
  command:
    - sleep
  enabled: false
existingApacheConfigurationConfigMap: ''
existingSecret: ''
existingWordPressConfigurationSecret: ''
externalCache:
  host: localhost
  port: 11211
externalDatabase:
  database: bitnami_wordpress
  existingSecret: ''
  host: localhost
  password: ''
  port: 3306
  user: bn_wordpress
extraDeploy: []
extraEnvVars: []
extraEnvVarsCM: ''
extraEnvVarsSecret: ''
extraVolumeMounts: []
extraVolumes: []
fullnameOverride: ''
global:
  imagePullSecrets: []
  imageRegistry: ''
  storageClass: ''
hostAliases:
  - hostnames:
      - status.localhost
    ip: 127.0.0.1
htaccessPersistenceEnabled: true
image:
  debug: false
  pullPolicy: IfNotPresent
  pullSecrets: []
  registry: docker.io
  repository: bitnami/wordpress
  tag: 5.8.0-debian-10-r6
ingress:
  annotations:
    cert-manager.io/cluster-issuer: letsencrypt-prod
    kubernetes.io/ingress.class: nginx
  apiVersion: ''
  certManager: true
  enabled: true
  extraHosts: []
  extraPaths: []
  extraTls: []
  hostname: <domain>
  ingressClassName: ''
  path: /
  pathType: ImplementationSpecific
  secrets: []
  tls: false
initContainers: []
kubeVersion: ''
livenessProbe:
  enabled: false
  failureThreshold: 6
  httpGet:
    httpHeaders: []
    path: /wp-admin/install.php
    port: http
    scheme: HTTP
  initialDelaySeconds: 120
  periodSeconds: 10
  successThreshold: 1
  timeoutSeconds: 5
mariadb:
  architecture: standalone
  auth:
    database: bitnami_wordpress
    password: ''
    rootPassword: ''
    username: bn_wordpress
  enabled: true
  primary:
    persistence:
      accessModes:
        - ReadWriteOnce
      enabled: true
      size: 50Gi
      storageClass: ''
memcached:
  enabled: false
  service:
    port: 11211
metrics:
  enabled: false
  image:
    pullPolicy: IfNotPresent
    pullSecrets: []
    registry: docker.io
    repository: bitnami/apache-exporter
    tag: 0.10.0-debian-10-r6
  resources:
    limits: {}
    requests: {}
  service:
    annotations:
      prometheus.io/port: '{{ .Values.metrics.service.port }}'
      prometheus.io/scrape: 'true'
    port: 9117
  serviceMonitor:
    additionalLabels: {}
    enabled: false
    honorLabels: false
    interval: 30s
    namespace: ''
    relabellings: []
    scrapeTimeout: ''
multisite:
  enable: false
  enableNipIoRedirect: false
  host: ''
  networkType: subdomain
nameOverride: ''
nodeAffinityPreset:
  key: ''
  type: ''
  values: []
nodeSelector: {}
pdb:
  create: false
  maxUnavailable: ''
  minAvailable: 1
persistence:
  accessMode: ReadWriteOnce
  accessModes:
    - ReadWriteOnce
  dataSource: {}
  enabled: true
  existingClaim: ''
  size: 200Gi
  storageClass: ''
podAffinityPreset: ''
podAnnotations: {}
podAntiAffinityPreset: soft
podLabels: {}
podSecurityContext:
  enabled: true
  fsGroup: 1001
readinessProbe:
  enabled: false
  failureThreshold: 6
  httpGet:
    httpHeaders: []
    path: /wp-login.php
    port: http
    scheme: HTTP
  initialDelaySeconds: 30
  periodSeconds: 10
  successThreshold: 1
  timeoutSeconds: 5
replicaCount: 1
resources:
  limits: {}
  requests:
    cpu: 1100m
    memory: 1.4Gi
schedulerName: ''
service:
  annotations: {}
  clusterIP: ''
  externalTrafficPolicy: Cluster
  extraPorts: []
  httpsPort: 443
  httpsTargetPort: https
  loadBalancerIP: ''
  loadBalancerSourceRanges: []
  nodePorts:
    http: ''
    https: ''
  port: 80
  type: ClusterIP
serviceAccountName: default
sidecars: []
smtpExistingSecret: ''
smtpHost: ''
smtpPassword: ''
smtpPort: ''
smtpProtocol: ''
smtpUser: ''
tolerations: []
updateStrategy:
  rollingUpdate: {}
  type: RollingUpdate
volumePermissions:
  enabled: false
  image:
    pullPolicy: Always
    pullSecrets: []
    registry: docker.io
    repository: bitnami/bitnami-shell
    tag: 10-debian-10-r152
  resources:
    limits: {}
    requests: {}
  securityContext:
    runAsUser: 0
wordpressAutoUpdateLevel: none
wordpressBlogName: User's Blog!
wordpressConfiguration: ''
wordpressConfigureCache: false
wordpressEmail: user@example.com
wordpressExtraConfigContent: ''
wordpressFirstName: FirstName
wordpressLastName: LastName
wordpressPassword: ''
wordpressPlugins: none
wordpressScheme: http
wordpressSkipInstall: false
wordpressTablePrefix: wp_
wordpressUsername: user

```
