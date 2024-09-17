#!/bin/bash

sed -i.orig "s/openai/# openai/g" cltl-requirements/requirements.txt
echo "." > cltl-asr/requirements.txt
echo "." > cltl-vad/requirements.txt

sed -i.orig "s/matplotlib/# matplotlib/g" cltl-backend/requirements.txt

sed -i.orig "s/asr\[.+\]/asr/g" spot-woz/requirements.txt
sed -i.orig "s/vad\[.+\]/vad/g" spot-woz/requirements.txt

cp spot-woz/py-app/config/custom_chat.config custom.config
