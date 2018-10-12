#!/bin/bash -f
xv_path="/var/local/xilinx-local/Vivado/2016.2"
ExecStep()
{
"$@"
RETVAL=$?
if [ $RETVAL -ne 0 ]
then
exit $RETVAL
fi
}
ExecStep $xv_path/bin/xelab -wto 6999d00fd97848e09330f70ec0bda2d5 -m64 --debug typical --relax --mt 8 -L xil_defaultlib -L unisims_ver -L unimacro_ver -L secureip --snapshot tb_timer_behav xil_defaultlib.tb_timer xil_defaultlib.glbl -log elaborate.log
