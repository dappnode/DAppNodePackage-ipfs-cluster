FROM ipfs/ipfs-cluster:latest

ENV CLUSTER_IPFSHTTP_NODEMULTIADDRESS /dns4/ipfs.dappnode/tcp/5001
ENV CLUSTER_RESTAPI_HTTPLISTENMULTIADDRESS /ip4/0.0.0.0/tcp/9094

ADD entrypoint.sh /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/sbin/tini", "--", "/usr/local/bin/entrypoint.sh"]