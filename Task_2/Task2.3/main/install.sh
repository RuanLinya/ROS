#!/bin/bash

cd /home/hzt/HCR/team_h/Task_2/Task23/deps || exit
git clone https://github.com/stepjam/PyRep.git
pip3 install -r PyRep/requirements.txt
pip3 install PyRep/.
git clone https://github.com/stepjam/RLBench.git
pip3 install -r RLBench/requirements.txt
pip3 install RLBench/.
pip3 install -r requirements.txt
#pip3 install torch==1.10.1+cu113 torchvision==0.11.2+cu113 torchaudio==0.10.1+cu113 -f https://download.pytorch.org/whl/cu113/torch_stable.html
