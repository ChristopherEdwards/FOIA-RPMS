INHSYS ;SLT,JPD,WOM; 6 Dec 95 09:31;GIS system configuration compilation/installation utility 
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;CHCS TOOLS_460; GEN 3; 17-JUL-1997
 ;COPYRIGHT 1992 SAIC
 ; Supported entry points:
 ;        EN5, COMP
 Q
 ;
EN5(%RT,INCR,INASK,INDELETE,INP0) ; Called by CMS interface and ZPACK programs
 ;Returns 1 for successful run, 0 for unsuccessful
 ;Input
 ;%RT - PROGRAM TO RUN
 ;INCR - REQUIRE <CR> IF REPORTING TO PRIMARY DEVICE
 ;      IF 1 YES, ELSE NO
 ;INASK - Option control for ERROR notification
 ;      Values: 0 - Ask if user wants reporting
 ;     If user wants reporting, ask DEVICE
 ;              1 - Reporting goes to ASCII flat file, xxxx.INS file
 ;     in default directory
 ;              4 - report goes to ascii file xxxx.INS and prints error summary
 ;INDELETE - If 0 or not passed, then delete all
 ;                    IBxxxxW,IBxxxxnn routines
 ;           If 1, then leave them
 ;           If not 0/1 then ERROR
 ;INP0 - Only wants Pass 0
 ;Note: INCR=1 and INASK=1 is an error condition
 ;      INCR>1 or INASK>1 is an an error condition
 ;Note: If INASK is passed as 1 INASK will be incremented
 ;      after the first call to routine INHUT3. INASK=2 signals
 ;      INHUT3 to APPEND to the flat file.
 ;Note: If INASK is passed as 0 but the user specifies no reporting,
 ;      INASK will be set to 3 and passed to INHUT3 as a signal
 ;      to not open any devices.
 ;Note: Any string passed as INDELETE will be treated as zero (0)
 ;Note: Variable INREPRT controls whether the reports are printed.
 ;      The user is allowed to change the value of this variable
 ;      based on parameter INASK. INREPRT is referrenced in all the
 ;      INHSYS* programs.
 ;Note: If INP0=1 then INASK must equal 0
 ;
 N %SRC,%RD,%RMSEL,%UTILITY,%UCI,%SYS,%,%RTN,DWLRF,DWLB,DWL,DWLMK,DWLMK1
 N %CNT,%UT,%,Y,%TT,INREPRT,INRPTNM,INPOP K ^UTILITY($J),^UTILITY("INHSYS",$J)
 D VAR^DWUTL,^%ZIST I '($D(DT)#2) N DT S DT=$$DT^%ZTFDT() ;CMS SCOPES DT
 ;Make sure parameters passed, initialize INPOP - flag for FATAL ERROR
 S INCR=+$G(INCR),INASK=+$G(INASK),INREPRT='INASK,INDELETE=+$G(INDELETE),INP0=+$G(INP0),INPOP=0
 ; check to see if error summary needs to be printed
 K ^UTILITY("INHSYS_SUMERR",$J),^UTILITY("INHSYS_FILERR",$J) I INASK=4 S INREPRT=3,INASK=1,^UTILITY("INHSYS_FILERR",$J)=1
 I INCR=1,INASK=1 W @IOF,$$SETXY^%ZTF(7,10),"Cannot require <CR> from user when reporting goes to a flat file!!" S %RT=$$CR^UTSRD(0,IOSL-1) Q 0
 I INCR'?1N!(INCR>1)!(INASK'?1N)!(INASK>1) W @IOF,$$SETXY^%ZTF(25,10),"Invalid parameters INCR or INASK!!" S %RT=$$CR^UTSRD(0,IOSL-1) Q 0
 I INDELETE>1 W:INCR @IOF,$$SETXY^%ZTF(7,10) W "Invalid parameter INDELETE!!" S:INCR %RT=$$CR^UTSRD(0,IOSL-1) Q 0
 I %RT="" W:INCR @IOF,$$SETXY^%ZTF(30,10) W "Null Program Name!!" S:INCR %RT=$$CR^UTSRD(0,IOSL-1) Q 0
 I $E(%RT,$L(%RT))'="W"!($E(%RT,1,2)'="IB") W:INCR @IOF,$$SETXY^%ZTF(30,10) W "Invalid Program Name!!" S:INCR %RT=$$CR^UTSRD(0,IOSL-1) Q 0
 I '$$FROUT(%RT) W:INCR @IOF,$$SETXY^%ZTF(30,10) W "Routine ",%RT," not found",!!,*7 S:INCR %RT=$$CR^UTSRD(0,IOSL-1) Q 0
 I INP0=1,INASK'=0 W:INCR @IOF,$$SETXY^%ZTF(30,10) W "Invalid INP0 and INASK combination.",!!,*7 S:INCR %RT=$$CR^UTSRD(0,IOSL-1) Q 0
 S:INASK INRPTNM=$$TR^INHUT3($E(%RT,3,$L(%RT)-1))_".INS" S %TT=$T(@(%RT)+3^@(%RT)),%TT=$P(%TT,";",2,99),%CNT=1,%UT(1)=%RT_" - "_%TT,%UT(1,0)="",%RT=1
 ;
 ; If the user is allowed to specify reporting, ask about differences.
 ;       If yes do pass 0.
 ;  Ask if user wants seconde report
 ; Otherwise do pass 0. If output to flat file, force INHUT3 to
 ;       place second report in same file as pass 0.
 I 'INASK D  Q:INP0 1
 .D ZIS^INHUT3("INST^INHSYS05($P(%UT(%RT),"" -""),0,1)","%RT^%UT(^","",INASK) Q:INP0!INPOP
 .W !,"Continue" I '$$YN^%ZTF(0) S INPOP=1 Q
 .W !!,"Would you like a list of updated files and fields." S INREPRT=$$YN^%ZTF(0) S:'INREPRT INASK=3
 E  D ZIS^INHUT3("INST^INHSYS05($P(%UT(%RT),"" -""),0,INREPRT)","%RT^%UT(^","",INASK) S:INASK=1 INASK=2
 Q:INPOP 0
 ;Disable <cntrl>C
 I '$$BREAK(0)
 D ZIS^INHUT3("LOOP^INHSYS10(%UT(%RT),INREPRT,INDELETE)","%RT^%UT(^INREPRT^","",INASK)
 ;Enable <cntrl>C
 I $$BREAK(1)
 D ALLSUMER^INHSYS11(1)   ;if error summary is requested, display it on the user's current device and kill the utility summary global
 ; If INPOP=1 then fail (return 0) else return 1
 Q 'INPOP
BREAK(%) ;Inable/Disable break
 N EX S EX="U $I:"_$S(%:"",1:"NO")_"CENABLE"
 I %,$$BREAK^%ZTF(%),^DD("OS")=15 X EX
 I '%,'$$BREAK^%ZTF(%),^DD("OS")=15 X EX
 Q %
FROUT(%FIND) ;Return 1 if routine found, 0 else
 Q $$ROUTEST^%ZTF(%FIND)
COMP(INSELTT,INASK) ;compile Transaction Types into cms elements
 ; Called by tags EN1 and EN2 above
 ; Also called by $$COMP^INZTTC
 ; Input:
 ; INSELTT - Array of selected Transaction Types
 ;      INSELTT = # Selected
 ;      INSELTT(n) = IEN^0_NODE
 ; INASK - Option control for ERROR notification
 ;      Values: 0 - Ask if user wants reporting
 ;     If user wants reporting, ask DEVICE
 ;              1 - Reporting goes to ASCII flat file in the user's
 ;     default directory. The filename is based on the
 ;     UNIQUE IDENTIFIER of the INTERFACE TRANSACTION TYPE
 ;     chosen. This file has a ".GEN" extention to signify
 ;     it came from the GENERATION (export) module.
 ;              DEFAULT is 0
 ; Note: When INASK=0, if the user specifies no reporting, INASK
 ;       will be set to 3 and passed to INHUT3 as a signal to not
 ;       open any devices.
 ; Note: INPOP should be in the data space from the calling routine
 ;       and should be set to 0. This variable is a flag used
 ;       to denote FATAL ERRORS and should be checked by the calling
 ;       routine to determine successful generation. If the value is
 ;       1, this will denote failure.
 ;       Note to Note: INPOP is not the only failure condition that
 ;                     should be checked by the calling program.
 N INREPRT,INLKFLS,AA,INRPTNM K ^UTILITY($J),^UTILITY("INHSYS",$J)
 S INASK=+$G(INASK),INREPRT=1 I '($D(DT)#2) N DT S DT=$$DT^%ZTFDT() ;CMS SCOPES DT
 I '$D(INCR) N INCR S INCR=0
 I INASK'?1N!(INASK>1) W @IOF,$$SETXY^%ZTF(25,10),"Invalid parameters INASK!!" S INASK=$$CR^UTSRD(0,IOSL-1) Q
 I $D(INSELTT)'=11 W @IOF,$$SETXY^%ZTF(25,10),"No TRANSACTION TYPES available!!" S INASK=$$CR^UTSRD(0,IOSL-1) Q
 I INASK S INRPTNM=$$TR^INHUT3($$ID^INHSYS04(+INSELTT(1)))_".GEN"
 I 'INASK W !,"Do you wish to see a report" S AA=$$YN^%ZTF(1) Q:AA="^"  S:'AA INREPRT=0,INASK=3
 ; Quit if cannot lock all relevent files
 I '$$LOCKFL^INHSYSUT(.INLKFLS,0),'INPOP D ZIS^INHUT3("RUN^INHSYS10(INREPRT,.INSELTT)","INREPRT^INSELTT(^","132",INASK)
 ; Unlock files
 S AA="" F  S AA=$O(INLKFLS(AA)) Q:AA=""  D UNLK^INHSYSUT(AA)
 Q
RESTORE(%UT,%RT) ;
 ; Input:
 ; %UT - global to store routine that is being restored
 ; %RT - selected node from global
 D:$$QUERY() ZIS^INHUT3("INST^INHSYS05($P(%UT(%RT),"" -""),0,1)","%RT^%UT(^")
 W !!,"Do you wish to proceed with installation" I '$$YN^%ZTF(0) Q
 W !!,"Would you like a list of updated files and fields" S INREPRT=$$YN^%ZTF(0)
 ;Disable <cntrl>C
 I '$$BREAK^%ZTF(0),^DD("OS")=15 U $I:NOCENABLE
 D ZIS^INHUT3("LOOP^INHSYS10(%UT(%RT),INREPRT)","%RT^%UT(^INREPRT^")
 ;Enable <cntrl>C
 I $$BREAK^%ZTF(1),^DD("OS")=15 U $I:CENABLE
 Q
QUERY() W !!,"Would you like a report of related files that exist ",!,"and do not exist in the environment"
 Q $$YN^%ZTF(0)
Q Q
ROUT(%UTILITY) ;Get available routines
 ;N %RTN
 ;S %RTN="IB" F  S %RTN=$O(^ (%RTN)) Q:$E(%RTN,1,2)'="IB"  D
 ;.I %RTN["FAIL"!($E(%RTN,$L(%RTN))'["W") Q
 ;.S %UTILITY(%RTN)=""
 ;D ORDER^INHUT3("^ ","%RTN","IB","$E(%RTN,1,2)'=""IB""","I %RTN'[""FAIL"",$E(%RTN,$L(%RTN))[""W"" S %UTILITY(%RTN)=""""")
 D ORDER^INHUT3("^ ","%RTN","IB","$E(%RTN,1,2)'=""IB""","I $E(%RTN,$L(%RTN))[""W"" S %UTILITY(%RTN)=""""")
 Q $D(%UTILITY)
