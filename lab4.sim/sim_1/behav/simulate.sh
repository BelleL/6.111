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
ExecStep $xv_path/bin/xsim tb_timer_behav -key {Behavioral:sim_1:Functional:tb_timer} -tclbatch tb_timer.tcl -log simulate.log
