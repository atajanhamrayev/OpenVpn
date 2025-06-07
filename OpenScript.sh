#!/bin/bash

# Проверка, что скрипт запускается от root
if [[ $EUID -ne 0 ]]; then
   echo "Пожалуйста, запустите этот скрипт от имени root (sudo)" 
   exit 1
fi

echo "[1/5] Обновление системы и установка зависимостей..."
apt update && apt -y install ca-certificates wget net-tools gnupg

echo "[2/5] Загрузка GPG-ключа репозитория OpenVPN..."
wget https://as-repository.openvpn.net/as-repo-public.asc -qO /etc/apt/trusted.gpg.d/as-repository.asc

echo "[3/5] Добавление репозитория OpenVPN Access Server..."
echo "deb [arch=amd64 signed-by=/etc/apt/trusted.gpg.d/as-repository.asc] http://as-repository.openvpn.net/as/debian focal main" > /etc/apt/sources.list.d/openvpn-as-repo.list

echo "[4/5] Установка OpenVPN Access Server..."
apt update && apt -y install openvpn-as=2.11.2-72c0e923-Ubuntu20

echo "[5/5] Защита пакетов от обновлений..."
apt-mark hold openvpn-as openvpn-as-bundled-clients

echo ""
echo "✅ Установка завершена!"
echo "Панель администратора: https://<your-server-ip>:943/admin"
echo "Панель пользователя: https://<your-server-ip>:943/"

