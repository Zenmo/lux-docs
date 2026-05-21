set -ex
cd $(dirname "$0")

scp luxdocs.container root@prodpods.zenmo.com:/etc/containers/systemd/

ssh root@prodpods.zenmo.com "\
    podman pull ghcr.io/zenmo/luxdocs:latest \
    && systemctl daemon-reload \
    && systemctl restart luxdocs"