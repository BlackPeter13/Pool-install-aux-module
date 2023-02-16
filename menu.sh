#####################################################
# Source code https://github.com/end222/pacmenu
# Updated by afiniel-tech for yiimpool use...
#####################################################

source /etc/functions.sh

RESULT=$(dialog --stdout --nocancel --default-item 1 --title "Yiimpool v2.0" --menu "Choose one" -1 60 16 \
' ' "- Install Yiimp  -" \
1 "YiiMP Single Server" \
' ' "- Daemon Wallet Builder -" \
2 "Daemonbuilder" \
' ' "- Upgrade stratum server -" \
3 "Yiimp stratum update" \
4 Exit)
if [ $RESULT = ]
then
bash $(basename $0) && exit;
fi

if [ $RESULT = 1 ]
then
clear;
cd $HOME/yiimpool/install
source bootstrap_single.sh;
fi

if [ $RESULT = 2 ]
then
clear;
cd $HOME/yiimpool/install
source bootstrap_coin.sh;
fi

if [ $RESULT = 3 ]
then
cd $HOME/yiimpool/install
source bootstrap_upgrade.sh;
fi

if [ $RESULT = 4 ]
then
clear;
exit;
fi
