input "../../packages/Macaulay2Doc/test/crash-2.m2"
end

iiiii13 : -- now we have a segmentation fault:
          g(C)
M2: /home/dan/src/M2/1.2/BUILD/dan/../../Macaulay2/e/array.hpp:70: const T& array<T>::operator[](int) const [with T = int*]: Assertion `i < max' failed.
Aborted

Process M2<2> exited abnormally with code 134

    #0  0x4001a430 in __kernel_vsyscall ()
    #1  0x40a2a880 in raise () from /lib/tls/i686/cmov/libc.so.6
    #2  0x40a2c248 in abort () from /lib/tls/i686/cmov/libc.so.6
    #3  0x40a2372e in __assert_fail () from /lib/tls/i686/cmov/libc.so.6
    #4  0x081ff16c in Ring::vec_multi_degree (this=0xe0dcb28, F=0xb97d718, f=0xd52bc98, degf=0xe304590)
	at /home/dan/src/M2/1.2/BUILD/dan/../../Macaulay2/e/array.hpp:70
    #5  0x081d9b1a in MatrixConstructor::append (this=0xbfa4055c, v=0xd52bc98) at /home/dan/src/M2/1.2/BUILD/dan/../../Macaulay2/e/matrix-con.cpp:48
    #6  0x081f22dc in RingMap::eval (this=0xdafcf98, F=0xb97d718, m=0xd806e18) at /home/dan/src/M2/1.2/BUILD/dan/../../Macaulay2/e/ringmap.cpp:239
    #7  0x08218245 in IM2_RingMap_eval_matrix (F=0xdafcf98, newTarget=0xb97d718, M=0xd806e18)
	at /home/dan/src/M2/1.2/BUILD/dan/../../Macaulay2/e/x-ringmap.cpp:57
    #8  0x0807f2ac in interface_rawRingMapEval (e_161=<value optimized out>) at /home/dan/src/M2/1.2/BUILD/dan/../../Macaulay2/d/interface.d:2628
    #9  0x080d0e6a in evaluate_eval (c_15={type_ = 30, ptr_ = 0xaf25678}) at /home/dan/src/M2/1.2/BUILD/dan/../../Macaulay2/d/evaluate.d:1315
    #10 0x080d6530 in evaluate_evalSequence (v_1=0xaf258a8) at /home/dan/src/M2/1.2/BUILD/dan/../../Macaulay2/d/evaluate.d:429
    #11 0x080d10d6 in evaluate_eval (c_15={type_ = 17, ptr_ = 0xbd99350}) at /home/dan/src/M2/1.2/BUILD/dan/../../Macaulay2/d/evaluate.d:1428
    #12 0x080d0d06 in evaluate_eval (c_15={type_ = 30, ptr_ = 0xaf25628}) at /home/dan/src/M2/1.2/BUILD/dan/../../Macaulay2/d/evaluate.d:1321
    #13 0x080d6420 in evaluate_evalSequence (v_1=0xbd94bd8) at /home/dan/src/M2/1.2/BUILD/dan/../../Macaulay2/d/evaluate.d:439
    #14 0x080d10d6 in evaluate_eval (c_15={type_ = 17, ptr_ = 0xbd9ad70}) at /home/dan/src/M2/1.2/BUILD/dan/../../Macaulay2/d/evaluate.d:1428
    #15 0x080d0d06 in evaluate_eval (c_15={type_ = 30, ptr_ = 0xaf25538}) at /home/dan/src/M2/1.2/BUILD/dan/../../Macaulay2/d/evaluate.d:1321
    #16 0x080d1ae7 in evaluate_eval (c_15={type_ = 20, ptr_ = 0xbd9ac98}) at /home/dan/src/M2/1.2/BUILD/dan/../../Macaulay2/d/evaluate.d:1422
    #17 0x080d4300 in evaluate_applyEEE (g=<value optimized out>, e0={type_ = 13, ptr_ = 0xbea6038}, e1={type_ = 13, ptr_ = 0xc30b6c0})
	at /home/dan/src/M2/1.2/BUILD/dan/../../Macaulay2/d/evaluate.d:946
    #18 0x080d609e in evaluate_binarymethod (left_2={type_ = 13, ptr_ = 0xbea6038}, rhs_9={type_ = 13, ptr_ = 0xc23ecf0}, methodkey_2=0xa94c740)
	at /home/dan/src/M2/1.2/BUILD/dan/../../Macaulay2/d/evaluate.d:1077
    #19 0x080d0e06 in evaluate_eval (c_15={type_ = 30, ptr_ = 0xc23b948}) at /home/dan/src/M2/1.2/BUILD/dan/../../Macaulay2/d/evaluate.d:1325
    #20 0x080d6420 in evaluate_evalSequence (v_1=0xc23eea8) at /home/dan/src/M2/1.2/BUILD/dan/../../Macaulay2/d/evaluate.d:439
    #21 0x080d10d6 in evaluate_eval (c_15={type_ = 17, ptr_ = 0xc23f2c0}) at /home/dan/src/M2/1.2/BUILD/dan/../../Macaulay2/d/evaluate.d:1428
    #22 0x080d0d06 in evaluate_eval (c_15={type_ = 30, ptr_ = 0xc23b8f8}) at /home/dan/src/M2/1.2/BUILD/dan/../../Macaulay2/d/evaluate.d:1321
    #23 0x080d87ec in assignelemfun (lhsarray={type_ = 13, ptr_ = 0xc23ef00}, lhsindex={type_ = 6, ptr_ = 0xc23fb30}, rhs_3={type_ = 30, ptr_ = 0xc23b8f8})
	at /home/dan/src/M2/1.2/BUILD/dan/../../Macaulay2/d/evaluate.d:86
    #24 0x080cfff4 in evaluate_eval (c_15={type_ = 14, ptr_ = 0xc23ce78}) at /home/dan/src/M2/1.2/BUILD/dan/../../Macaulay2/d/evaluate.d:1384
    #25 0x080b3c3c in scan_1 (a_12=0xbf6dfb0, f_7=<value optimized out>) at /home/dan/src/M2/1.2/BUILD/dan/../../Macaulay2/d/actors3.d:1752
    #26 0x080b6ea8 in scan_5 (e_47=<value optimized out>) at /home/dan/src/M2/1.2/BUILD/dan/../../Macaulay2/d/actors3.d:2052
    #27 0x080d0e6a in evaluate_eval (c_15={type_ = 30, ptr_ = 0xc23b858}) at /home/dan/src/M2/1.2/BUILD/dan/../../Macaulay2/d/evaluate.d:1315
    #28 0x080d1ae7 in evaluate_eval (c_15={type_ = 20, ptr_ = 0xc23f038}) at /home/dan/src/M2/1.2/BUILD/dan/../../Macaulay2/d/evaluate.d:1422
    #29 0x080d4300 in evaluate_applyEEE (g=<value optimized out>, e0={type_ = 13, ptr_ = 0xbea6038}, e1={type_ = 13, ptr_ = 0xbc31f00})
	at /home/dan/src/M2/1.2/BUILD/dan/../../Macaulay2/d/evaluate.d:946
    #30 0x080d609e in evaluate_binarymethod (left_2={type_ = 13, ptr_ = 0xbea6038}, rhs_9={type_ = 5, ptr_ = 0xdbdc620}, methodkey_2=0xa94c740)
	at /home/dan/src/M2/1.2/BUILD/dan/../../Macaulay2/d/evaluate.d:1077
    #31 0x080d0e06 in evaluate_eval (c_15={type_ = 30, ptr_ = 0xdcc8628}) at /home/dan/src/M2/1.2/BUILD/dan/../../Macaulay2/d/evaluate.d:1325
    #32 0x080d24e8 in evaluate_evalexcept (c_28={type_ = 30, ptr_ = 0xdcc8628}) at /home/dan/src/M2/1.2/BUILD/dan/../../Macaulay2/d/evaluate.d:1442
    #33 0x08068c9d in readeval3 (file_1=0xda2b620, printout_1=1 '\001', dc=0xda2b740, returnLastvalue_1=0 '\0', stopIfBreakReturnContinue_1=0 '\0', 
	returnIfError_1=1 '\001') at /home/dan/src/M2/1.2/BUILD/dan/../../Macaulay2/d/interp.d:119
    #34 0x08069f56 in loadprint (filename=0xd9fa628, dc_2=0xda2b740, returnIfError_4=<value optimized out>)
	at /home/dan/src/M2/1.2/BUILD/dan/../../Macaulay2/d/interp.d:248
    #35 0x0806a3ba in input (e_4={type_ = 39, ptr_ = 0xd9fa628}) at /home/dan/src/M2/1.2/BUILD/dan/../../Macaulay2/d/interp.d:301
    #36 0x080d0e6a in evaluate_eval (c_15={type_ = 30, ptr_ = 0xaad94e8}) at /home/dan/src/M2/1.2/BUILD/dan/../../Macaulay2/d/evaluate.d:1315
    #37 0x080d023d in evaluate_eval (c_15={type_ = 8, ptr_ = 0xaad9498}) at /home/dan/src/M2/1.2/BUILD/dan/../../Macaulay2/d/evaluate.d:1341
    #38 0x080d089d in evaluate_eval (c_15={type_ = 20, ptr_ = 0xaa2d860}) at /home/dan/src/M2/1.2/BUILD/dan/../../Macaulay2/d/evaluate.d:1409
    #39 0x080d09ed in evaluate_eval (c_15={type_ = 28, ptr_ = 0xab53770}) at /home/dan/src/M2/1.2/BUILD/dan/../../Macaulay2/d/evaluate.d:1360
    #40 0x080d0e38 in evaluate_eval (c_15={type_ = 20, ptr_ = 0xaa2d788}) at /home/dan/src/M2/1.2/BUILD/dan/../../Macaulay2/d/evaluate.d:1412
    #41 0x080b3c3c in scan_1 (a_12=0xda2b938, f_7=<value optimized out>) at /home/dan/src/M2/1.2/BUILD/dan/../../Macaulay2/d/actors3.d:1752
    #42 0x080b6ea8 in scan_5 (e_47=<value optimized out>) at /home/dan/src/M2/1.2/BUILD/dan/../../Macaulay2/d/actors3.d:2052
    #43 0x080d0e6a in evaluate_eval (c_15={type_ = 30, ptr_ = 0xaad90d8}) at /home/dan/src/M2/1.2/BUILD/dan/../../Macaulay2/d/evaluate.d:1315
    #44 0x080c8cb1 in EqualEqualEqualfun (lhs_16={type_ = 5, ptr_ = 0xab2ee90}, rhs_20={type_ = 30, ptr_ = 0xaad90d8})
	at /home/dan/src/M2/1.2/BUILD/dan/../../Macaulay2/d/actors.d:732
    #45 0x080cffad in evaluate_eval (c_15={type_ = 13, ptr_ = 0xab53718}) at /home/dan/src/M2/1.2/BUILD/dan/../../Macaulay2/d/evaluate.d:1307
    #46 0x080d03f5 in evaluate_eval (c_15={type_ = 28, ptr_ = 0xab53508}) at /home/dan/src/M2/1.2/BUILD/dan/../../Macaulay2/d/evaluate.d:1366
    #47 0x080d0f09 in evaluate_eval (c_15={type_ = 20, ptr_ = 0xaa2ebc0}) at /home/dan/src/M2/1.2/BUILD/dan/../../Macaulay2/d/evaluate.d:1415
    #48 0x080d68af in evaluate_applyFCCS (c_8=0xaa2eb30, cs_2=0xaab4098) at /home/dan/src/M2/1.2/BUILD/dan/../../Macaulay2/d/evaluate.d:843
    #49 0x080d7208 in evaluate_applyFCC (fc=0xaa2eb30, ec={type_ = 17, ptr_ = 0xab42fb0}) at /home/dan/src/M2/1.2/BUILD/dan/../../Macaulay2/d/evaluate.d:578
    #50 0x080d0d44 in evaluate_eval (c_15={type_ = 30, ptr_ = 0xaade0d8}) at /home/dan/src/M2/1.2/BUILD/dan/../../Macaulay2/d/evaluate.d:1311
    #51 0x080d68af in evaluate_applyFCCS (c_8=0xab42ed8, cs_2=0xab57458) at /home/dan/src/M2/1.2/BUILD/dan/../../Macaulay2/d/evaluate.d:843
    #52 0x080d7208 in evaluate_applyFCC (fc=0xab42ed8, ec={type_ = 17, ptr_ = 0xab42398}) at /home/dan/src/M2/1.2/BUILD/dan/../../Macaulay2/d/evaluate.d:578
    #53 0x080d0d44 in evaluate_eval (c_15={type_ = 30, ptr_ = 0xaae1588}) at /home/dan/src/M2/1.2/BUILD/dan/../../Macaulay2/d/evaluate.d:1311
    #54 0x080d6ec5 in evaluate_evalAllButTail (c=<value optimized out>) at /home/dan/src/M2/1.2/BUILD/dan/../../Macaulay2/d/evaluate.d:57
    #55 0x080d738f in evaluate_applyFCC (fc=0xab42230, ec={type_ = 3, ptr_ = 0xd9ea1f8}) at /home/dan/src/M2/1.2/BUILD/dan/../../Macaulay2/d/evaluate.d:604
    #56 0x080d0d44 in evaluate_eval (c_15={type_ = 30, ptr_ = 0xc0187b8}) at /home/dan/src/M2/1.2/BUILD/dan/../../Macaulay2/d/evaluate.d:1311
    #57 0x080d24e8 in evaluate_evalexcept (c_28={type_ = 30, ptr_ = 0xc0187b8}) at /home/dan/src/M2/1.2/BUILD/dan/../../Macaulay2/d/evaluate.d:1442
    #58 0x08068c9d in readeval3 (file_1=0xda2bc08, printout_1=1 '\001', dc=0xda2bd28, returnLastvalue_1=0 '\0', stopIfBreakReturnContinue_1=0 '\0', 
	returnIfError_1=1 '\001') at /home/dan/src/M2/1.2/BUILD/dan/../../Macaulay2/d/interp.d:119
    #59 0x08069f56 in loadprint (filename=0xda18818, dc_2=0xda2bd28, returnIfError_4=<value optimized out>)
	at /home/dan/src/M2/1.2/BUILD/dan/../../Macaulay2/d/interp.d:248
    #60 0x0806a3ba in input (e_4={type_ = 39, ptr_ = 0xda18818}) at /home/dan/src/M2/1.2/BUILD/dan/../../Macaulay2/d/interp.d:301
    #61 0x080d0e6a in evaluate_eval (c_15={type_ = 30, ptr_ = 0xaad94e8}) at /home/dan/src/M2/1.2/BUILD/dan/../../Macaulay2/d/evaluate.d:1315
    #62 0x080d023d in evaluate_eval (c_15={type_ = 8, ptr_ = 0xaad9498}) at /home/dan/src/M2/1.2/BUILD/dan/../../Macaulay2/d/evaluate.d:1341
    #63 0x080d089d in evaluate_eval (c_15={type_ = 20, ptr_ = 0xaa2d860}) at /home/dan/src/M2/1.2/BUILD/dan/../../Macaulay2/d/evaluate.d:1409
    #64 0x080d09ed in evaluate_eval (c_15={type_ = 28, ptr_ = 0xab53770}) at /home/dan/src/M2/1.2/BUILD/dan/../../Macaulay2/d/evaluate.d:1360
    #65 0x080d0e38 in evaluate_eval (c_15={type_ = 20, ptr_ = 0xaa2d788}) at /home/dan/src/M2/1.2/BUILD/dan/../../Macaulay2/d/evaluate.d:1412
    #66 0x080b3c3c in scan_1 (a_12=0xda2bed8, f_7=<value optimized out>) at /home/dan/src/M2/1.2/BUILD/dan/../../Macaulay2/d/actors3.d:1752
    #67 0x080b6ea8 in scan_5 (e_47=<value optimized out>) at /home/dan/src/M2/1.2/BUILD/dan/../../Macaulay2/d/actors3.d:2052
    #68 0x080d0e6a in evaluate_eval (c_15={type_ = 30, ptr_ = 0xaad90d8}) at /home/dan/src/M2/1.2/BUILD/dan/../../Macaulay2/d/evaluate.d:1315
    #69 0x080c8cb1 in EqualEqualEqualfun (lhs_16={type_ = 5, ptr_ = 0xab2ee90}, rhs_20={type_ = 30, ptr_ = 0xaad90d8})
	at /home/dan/src/M2/1.2/BUILD/dan/../../Macaulay2/d/actors.d:732
    #70 0x080cffad in evaluate_eval (c_15={type_ = 13, ptr_ = 0xab53718}) at /home/dan/src/M2/1.2/BUILD/dan/../../Macaulay2/d/evaluate.d:1307
    #71 0x080d03f5 in evaluate_eval (c_15={type_ = 28, ptr_ = 0xab53508}) at /home/dan/src/M2/1.2/BUILD/dan/../../Macaulay2/d/evaluate.d:1366
    #72 0x080d0f09 in evaluate_eval (c_15={type_ = 20, ptr_ = 0xaa2ebc0}) at /home/dan/src/M2/1.2/BUILD/dan/../../Macaulay2/d/evaluate.d:1415
    #73 0x080d68af in evaluate_applyFCCS (c_8=0xaa2eb30, cs_2=0xaab4098) at /home/dan/src/M2/1.2/BUILD/dan/../../Macaulay2/d/evaluate.d:843
    #74 0x080d7208 in evaluate_applyFCC (fc=0xaa2eb30, ec={type_ = 17, ptr_ = 0xab42fb0}) at /home/dan/src/M2/1.2/BUILD/dan/../../Macaulay2/d/evaluate.d:578
    #75 0x080d0d44 in evaluate_eval (c_15={type_ = 30, ptr_ = 0xaade0d8}) at /home/dan/src/M2/1.2/BUILD/dan/../../Macaulay2/d/evaluate.d:1311
    #76 0x080d68af in evaluate_applyFCCS (c_8=0xab42ed8, cs_2=0xab57458) at /home/dan/src/M2/1.2/BUILD/dan/../../Macaulay2/d/evaluate.d:843
    #77 0x080d7208 in evaluate_applyFCC (fc=0xab42ed8, ec={type_ = 17, ptr_ = 0xab42398}) at /home/dan/src/M2/1.2/BUILD/dan/../../Macaulay2/d/evaluate.d:578
    #78 0x080d0d44 in evaluate_eval (c_15={type_ = 30, ptr_ = 0xaae1588}) at /home/dan/src/M2/1.2/BUILD/dan/../../Macaulay2/d/evaluate.d:1311
    #79 0x080d6ec5 in evaluate_evalAllButTail (c=<value optimized out>) at /home/dan/src/M2/1.2/BUILD/dan/../../Macaulay2/d/evaluate.d:57
    #80 0x080d738f in evaluate_applyFCC (fc=0xab42230, ec={type_ = 3, ptr_ = 0xd9ea278}) at /home/dan/src/M2/1.2/BUILD/dan/../../Macaulay2/d/evaluate.d:604
    #81 0x080d0d44 in evaluate_eval (c_15={type_ = 30, ptr_ = 0xc003088}) at /home/dan/src/M2/1.2/BUILD/dan/../../Macaulay2/d/evaluate.d:1311
    #82 0x080d24e8 in evaluate_evalexcept (c_28={type_ = 30, ptr_ = 0xc003088}) at /home/dan/src/M2/1.2/BUILD/dan/../../Macaulay2/d/evaluate.d:1442
    #83 0x08068c9d in readeval3 (file_1=0xda2ab78, printout_1=1 '\001', dc=0xda2ac50, returnLastvalue_1=0 '\0', stopIfBreakReturnContinue_1=0 '\0', 
	returnIfError_1=0 '\0') at /home/dan/src/M2/1.2/BUILD/dan/../../Macaulay2/d/interp.d:119
    #84 0x08069f56 in loadprint (filename=0xa8ad548, dc_2=0xda2ac50, returnIfError_4=<value optimized out>)
	at /home/dan/src/M2/1.2/BUILD/dan/../../Macaulay2/d/interp.d:248
    #85 0x0806a216 in commandInterpreter_2 (e_5=<value optimized out>) at /home/dan/src/M2/1.2/BUILD/dan/../../Macaulay2/d/interp.d:364
    #86 0x080d0e6a in evaluate_eval (c_15={type_ = 30, ptr_ = 0xc7fca88}) at /home/dan/src/M2/1.2/BUILD/dan/../../Macaulay2/d/evaluate.d:1315
    #87 0x080d023d in evaluate_eval (c_15={type_ = 8, ptr_ = 0xc7fca38}) at /home/dan/src/M2/1.2/BUILD/dan/../../Macaulay2/d/evaluate.d:1341
    #88 0x080d24e8 in evaluate_evalexcept (c_28={type_ = 8, ptr_ = 0xc7fca38}) at /home/dan/src/M2/1.2/BUILD/dan/../../Macaulay2/d/evaluate.d:1442
    #89 0x08068c9d in readeval3 (file_1=0xa9e0278, printout_1=0 '\0', dc=0xa9e0158, returnLastvalue_1=0 '\0', stopIfBreakReturnContinue_1=0 '\0', 
	returnIfError_1=0 '\0') at /home/dan/src/M2/1.2/BUILD/dan/../../Macaulay2/d/interp.d:119
    #90 0x0806968a in readeval (file_2=0xa9e0278, returnLastvalue_2=<value optimized out>, returnIfError_2=0 '\0')
	at /home/dan/src/M2/1.2/BUILD/dan/../../Macaulay2/d/interp.d:203
    #91 0x0806a52e in interp_process () at /home/dan/src/M2/1.2/BUILD/dan/../../Macaulay2/d/interp.d:484
    #92 0x080652de in Macaulay2_main (argc=5, argv=0xbfa43e14) at /home/dan/src/M2/1.2/BUILD/dan/../../Macaulay2/d/M2lib.c:732
    #93 0x080660c2 in main (argc=Cannot access memory at address 0x65c3) at /home/dan/src/M2/trunk/BUILD/dan/../../Macaulay2/d/main.c:7
