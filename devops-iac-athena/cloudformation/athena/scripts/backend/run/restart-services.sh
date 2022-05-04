#!/bin/bash

echo "==> Restarting middle service"
sudo systemctl restart middle

echo "==> Restarting backend service"
sudo systemctl restart backend

echo "==> Restarting ACDS service"
sudo systemctl restart athena-command-distributor-service

echo "==> Restarting geocodeservice service"
sudo systemctl restart geocodeservice

echo "==> Restarting plannedrollover service"
sudo systemctl restart plannedrollover

echo "==> Restarting timeattendance service"
sudo systemctl restart timeattendance

echo "==> Restarting IVIN service"
sudo systemctl restart ivin
