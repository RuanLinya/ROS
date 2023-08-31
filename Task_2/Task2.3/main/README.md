## Team_H: 2.3. Learning - vision -based obstacle avoidance (RLBench)

### How to install
1. Set up [conda](https://www.anaconda.com/products/individual) as described in the link.
2. Create a new virtual environment
```
conda create /team_h python=3.9
``` 
3. Clone this repository in the home directory
4. Go to it `cd ~/Task23/team_h`
5. Download CoppeliaSim in this folder.
6. Unzip the file
7. Run:
```
gedit ~/.bashrc
echo "export COPPELIASIM_ROOT=~/team_h/Task23/CoppeliaSim_Edu_V4_1_0_Ubuntu20_04"
echo 'export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$COPPELIASIM_ROOT'
echo 'export QT_QPA_PLATFORM_PLUGIN_PATH=$COPPELIASIM_ROOT'
source ~/.bashrc
```
8. Run the following script, and make sure to have git set up:
```
conda activate team_h
~/team_a/Task23/install.sh
```
The `deps/requirement.txt` file works for me, if it does not for you please fix it.

### How to run
All the relevant variables and flags for training, evaluating and testing are to be found in the `SETUP SECTION` of the `robustness.py` main script. To enable rendering look for the `headless` flag and set it to True. All other instructions are found there.
1. Open a terminal
2. Run:
```
conda activate team_h
cd ~/team_h/Task23
python3 robustness.py
```
