.PHONY:com sim debug cov clean

comsim:com sim
comsimdebug: com sim debug

OUTPUT = pingpang


#ALL_DEFINE = +define+DUMP_VPD

#VPD_NAME = +vpdfile+${OUTPUT}.vpd


VCS = vcs -sverilog +v2k -timescale=1ns/1ns             																							\
					-LDFLAGS																																										\
					-rdynamic																																										\
					-P ${LD_LIBRARY_PATH}/novas.tab ${LD_LIBRARY_PATH}/pli.a  \
          -debug_pp																																										\
					-full64																																											\
			    -o ${OUTPUT}                         																												\
					-l compile.log                        				
		#		  ${VPD_NAME}			                           		\
		      ${ALL_DEFINE}

SIM = ./${OUTPUT} -l run.log



com:
	${VCS} -f verilog_file.f


sim:
	${SIM} 

debug:
	verdi -f verilog_file.f -ssf pingpang.fsdb

cov:
	dve -covdir *.vdb &

clean:
	rm -rf ./csrc *.daidir *.log simv* *.key *.vpd ./DVEfiles *.fsdb *.rc *.dat *.conf ./verdiLog ${OUTPUT}
