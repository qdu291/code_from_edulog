#!/bin/bash -xe

echo "==> Restarting middle service"
sudo systemctl restart middle

echo "==> Restarting backend service"
sudo systemctl restart backend

echo "==> Restarting plannedrollover service"
sudo systemctl restart plannedrollover

# echo "==> Restarting timeattendance service"
# sudo systemctl restart timeattendance

# echo "==> Restarting ivin service"
# sudo systemctl restart ivin