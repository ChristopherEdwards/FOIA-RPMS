BMXRPC5 ; IHS/OIT/HMW - BMX REMOTE PROCEDURE CALLS ;
 ;;4.0;BMX;;JUN 28, 2010
 ;
 ;Stolen from Mike Remillard.  If it doesn't work, it's his fault.
HS(BMXGBL,BMXDFN,BMXTYPE,BMXRDL,BMXFDL) ;EP
 ;---> Return patient's Health Summary in global array, ^BMXTEMP($J,"HS"
 ;---> Lines delimited by BMXRDL
 ;---> File delimited by BMXFDL
 ;---> Called by RPC: BMX HEALTH SUMMARY
 ;---> Parameters:
 ;     1 - BMXGBL   (ret) Name of result global containing patient's
 ;                       Health Summary, passed to Broker.
 ;     2 - BMXDFN   (req) DFN of patient.
 ;
 ;---> Delimiter to pass error with result to GUI.
 N BMX30,BMX31,BMXERR,X
 ;S BMX30=$C(30),BMX31=$C(31)_$C(31)
 S BMX30=$G(BMXRDL)
 I BMX30="" S BMX30=$C(13)_$C(10)
 S BMX31=$G(BMXFDL)
 S BMXGBL="^BMXTEMP("_$J_",""HS"")",BMXERR=""
 K ^BMXTEMP($J,"HS")
 ;
 N BMXPATH
 ;---> Should get path from a Site Parameter. For now, use MSM default.
 S BMXPATH="/usr/spool/uucppublic/"
 ;S BMXPATH="C:\MSM\" ;TODO: Change to site parameter
 ;--->Flag to test whether running as broker job:
 N BMXSOCK
 S BMXSOCK=0
 ;I $I=56 S BMXSOCK=1
 ;
 ;---> If DFN not supplied, set Error Code and quit.
 I '$G(BMXDFN) D  Q
 . S BMXERR="No Patient DFN" S ^BMXTEMP($J,"HS",I)=BMX31_BMXERR
 ;
 ;---> If patient does not exist, set Error Code and quit.
 I '$D(^AUPNPAT(BMXDFN,0)) D  Q
 . S BMXERR="Patient DFN does not exist" S ^BMXTEMP($J,"HS",I)=BMX31_BMXERR
 ;
 N APCHSPAT,APCHSTYP
 S APCHSPAT=BMXDFN
 S APCHSTYP=$G(BMXTYPE)
 S:'+APCHSTYP APCHSTYP=7
 ;S APCHSTYP=9
 ;---> Doesn't work from Device 56.
 ;D GUIR^XBLM("EN^APCHS","^TMP(""BMXHS"",$J,")
 ;
 ;---> Generate a host file name.
 N BMXFN S BMXFN="XB"_$J
 ;
 D
 .;---> Important to preserve IO variables for when $I returns to 56.
 .N IO,IOBS,IOF,IOHG,IOM,ION,IOPAR,IOS,IOSL,IOST,IOT,IOUPAR,IOXY
 .;
 .;---> Open host file to receive legacy code display.
 .S Y=$$OPEN^%ZISH(BMXPATH,BMXFN,"W")
 .;O 51:(BMXPATH_BMXFN:"W")
 .;S IO=51,IOST="P-OTHER80"
 .;K ^HW("HS")
 .;S ^HW("HS","IOST")=$G(IOST)
 .;S ^HW("HS","IO")=$G(IO)
 .;
 .;---> Call to legacy code for Health Summary display.
 .S IOSL=999,IOM=80
 .D EN^APCHS
 .;---> Write End of File (EOF) marker.
 .W $C(9)
 .;
 .;---> %ZISC doesn't close Device 51 when called from TCPIP socket?
 .;D ^%ZISC
 .;---> Buffer won't write out to file until the device is closed
 .;---> or the buffer is flushed by some other command.
 .;---> At this point, host file exists but has 0 bytes.
 .;C 51
 .;---> Now host file contains legacy code display data.
 .;
 .;---> For some reason %ZISH cannot open the host file a second time.
 .;S Y=$$OPEN^%ZISH(BMXPATH,BMXFN,"R")
 .;O 51:(BMXPATH_BMXFN:"R")
 .U 51
 .;
 .;---> Read in the host file.
 .D
 ..;---> Stop reading Host File if line contains EOF $C(9).
 ..;N I,Y F I=1:1 R Y Q:Y[$C(9)  S ^TMP("BMXHS",$J,I)=Y
 .;
 .;---> %ZISC doesn't close Device 51 when called from TCPIP socket?
 .;D ^%ZISC
 .;C 51
 ;
 ;---> At this point $I=1.  The job has "forgotten" its $I, even
 ;---> though %SS shows 56 as the current device.  $I=1 causes a
 ;---> <NOPEN> at CAPI+10^XWBBRK2.  A simple USE 56 command
 ;---> appears to "remind" the job its $I is 56, and it works.
 ;---> Possibly this is something %ZISC ordinarily does.
 I BMXSOCK U 56
 ;U 56
 ;
 ;---> Copy Health Summary to global array for passing back to GUI.
 N I,N,U,X S U="^"
 S N=0
 F I=1:1 S N=$O(^TMP("BMXHS",$J,N)) Q:'N  D
 .;---> Set null lines (line breaks) equal to one space, so that
 .;---> Windows reader will quit only at the final "null" line.
 .S X=^TMP("BMXHS",$J,N) S:X="" X=" "
 .S ^BMXTEMP($J,"HS",I)=X_BMX30
 ;
 ;---> If no Health Summary produced, report it as an error.
 D:'$O(^BMXTEMP($J,"HS",0))
 . S BMXERR="No Health Summary produced" S ^BMXTEMP($J,"HS",I)=BMX31_BMXERR
 ;
 ;---> Tack on Error Delimiter and any error.
 S ^BMXTEMP($J,"HS",I)=BMX31_BMXERR
 ;
 ;---> Delete host file.
 ;---> This doesn't work.
 S Y=$$DEL^%ZISH(BMXPATH,BMXFN)
 ;---> Call system command.
 ;S ^MIKE(1)=BMXPATH
 ;S ^MIKE(2)=BMXFN
 ;S Y=$ZOS(2,BMXPATH_BMXFN)
 K ^TMP("BMXHS",$J)
 Q
