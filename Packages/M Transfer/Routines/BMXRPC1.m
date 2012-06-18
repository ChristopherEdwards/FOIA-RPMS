BMXRPC1 ; IHS/OIT/HMW - UTIL: REMOTE PROCEDURE CALLS ;
 ;;4.0;BMX;;JUN 28, 2010
 ;;* MICHAEL REMILLARD, DDS * ALASKA NATIVE MEDICAL CENTER *
 ;;  UTILITY: CODE FOR REMOTE PROCEDURE CALLS.
 ;;  RETURNS PATIENT DATA, HEALTH SUMMARY, FACE SHEET.
 ;
 ;
 ;----------
PDATA(BMXDATA,BMXDFN) ;EP
 ;---> Return Patient Data in 5 ^-delimited pieces:
 ;--->   1 - DOB in format: OCT 01,1994.
 ;--->   2 - Age in format: 35 Months.
 ;--->   3 - Text of Patient's sex.
 ;--->   4 - HRCN in the format XX-XX-XX.
 ;--->   5 - Text of ACTIVE/INACTIVE Status.
 ;---> Parameters:
 ;     1 - BMXDATA  (ret) String of patient data||error.
 ;     2 - BMXDFN   (req) DFN of patient.
 ;
 ;---> Delimiter to pass error with result to GUI.
 N BMX31,BMXERR S BMX31=$C(31)_$C(31)
 S BMXDATA="",BMXERR=""
 ;
 ;---> If DFN not supplied, set Error Code and quit.
 I '$G(BMXDFN) D  Q
 .;D ERRCD^BMXUTL2(201,.BMXERR) S BMXDATA=BMX31_BMXERR
 ;
 ;---> DOB.
 S BMXDATA=$$TXDT1^BMXUTL5($$DOB^BMXUTL1(BMXDFN))
 ;
 ;---> Age.
 S BMXDATA=BMXDATA_U_$$AGEF^BMXUTL1(BMXDFN)
 ;
 ;---> Text of sex.
 S BMXDATA=BMXDATA_U_$$SEXW^BMXUTL1(BMXDFN)
 ;
 ;---> HRCN, format XX-XX-XX.
 S BMXDATA=BMXDATA_U_$$HRCN^BMXUTL1(BMXDFN)
 ;
 ;---> Active/Inactive Status.
 ;S BMXDATA=BMXDATA_U_$$ACTIVE^BMXUTL1(BMXDFN)
 ;
 S BMXDATA=BMXDATA_BMX31
 ;
 Q
 ;
 ;
 ;----------
HS(BMXGBL,BMXDFN) ;EP
 ;---> Return patient's Health Summary in global array, ^BMXTEMP($J,"HS".
 ;---> Lines delimited by "^".
 ;---> Called by RPC: BMX IMMSERVE PT PROFILE
 ;---> Parameters:
 ;     1 - BMXGBL   (ret) Name of result global containing patient's
 ;                       Health Summary, passed to Broker.
 ;     2 - BMXDFN   (req) DFN of patient.
 ;
 ;---> Delimiter to pass error with result to GUI.
 N BMX30,BMX31,BMXERR,X
 S BMX30=$C(30),BMX31=$C(31)_$C(31)
 S BMXGBL="^BMXTEMP("_$J_",""HS"")",BMXERR=""
 K ^BMXTEMP($J,"HS")
 ;
 ;---> If DFN not supplied, set Error Code and quit.
 I '$G(BMXDFN) D  Q
 .;D ERRCD^BMXUTL2(201,.BMXERR) S ^BMXTEMP($J,"HS",I)=BMX31_BMXERR
 ;
 ;---> If patient does not exist, set Error Code and quit.
 I '$D(^AUPNPAT(BMXDFN,0)) D  Q
 .;D ERRCD^BMXUTL2(203,.BMXERR) S ^BMXTEMP($J,"HS",I)=BMX31_BMXERR
 ;
 N APCHSPAT,APCHSTYP
 S APCHSPAT=BMXDFN,APCHSTYP=7
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
 .;S Y=$$OPEN^%ZISH($$HFSPATH^BMXUTL1,BMXFN,"W")
 .;
 .;---> Call to legacy code for Health Summary display.
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
 .;S Y=$$OPEN^%ZISH($$HFSPATH^BMXUTL1,BMXFN,"R")
 .;O 51:($$HFSPATH^BMXUTL1_BMXFN:"R")
 .;U 51
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
 .;D ERRCD^BMXUTL2(407,.BMXERR) S ^BMXTEMP($J,"HS",I)=BMX31_BMXERR
 ;
 ;---> Tack on Error Delimiter and any error.
 S ^BMXTEMP($J,"HS",I)=BMX31_BMXERR
 ;
 ;---> This works; host file gets deleted.
 ;S Y=$$DEL^%ZISH($$HFSPATH^BMXUTL1,BMXFN)
 K ^TMP("BMXHS",$J)
 Q
 ;
 ;
 ;----------
FACE(BMXGBL,BMXDFN) ;EP
 ;---> Return patient's Face Sheet in global array, ^BMXTEMP($J,"FACE".
 ;---> Lines delimited by "^".
 ;---> Called by RPC: BMX IMMSERVE PT PROFILE
 ;---> Parameters:
 ;     1 - BMXGBL   (ret) Name of result global containing patient's
 ;                       Face Sheet, passed to Broker.
 ;     2 - BMXDFN   (req) DFN of patient.
 ;
 ;---> Delimiter to pass error with result to GUI.
 N BMX30,BMX31,BMXERR,X
 S BMX30=$C(30),BMX31=$C(31)_$C(31)
 S BMXGBL="^BMXTEMP("_$J_",""FACE"")",BMXERR=""
 K ^BMXTEMP($J,"FACE")
 ;
 ;---> If DFN not supplied, set Error Code and quit.
 I '$G(BMXDFN) D  Q
 .;D ERRCD^BMXUTL2(201,.BMXERR) S ^BMXTEMP($J,"FACE",I)=BMX31_BMXERR
 ;
 ;---> If patient does not exist, set Error Code and quit.
 I '$D(^AUPNPAT(BMXDFN,0)) D  Q
 .;D ERRCD^BMXUTL2(203,.BMXERR) S ^BMXTEMP($J,"FACE",I)=BMX31_BMXERR
 ;
 N DFN S DFN=BMXDFN
 ;---> Doesn't work from Device 56.
 ;---> Generate a host file name.
 N BMXFN S BMXFN="XB"_$J
 ;
 D
 .;---> Important to preserve IO variables for when $I returns to 56.
 .N IO,IOBS,IOF,IOHG,IOM,ION,IOPAR,IOS,IOSL,IOST,IOT,IOUPAR,IOXY
 .;
 .;---> Open host file to receive legacy code display.
 .;S Y=$$OPEN^%ZISH($$HFSPATH^BMXUTL1,BMXFN,"W")
 .;
 .;---> Call to legacy code for Face Sheet display.
 .U 51
 .;D ^BMXFACE
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
 .;S Y=$$OPEN^%ZISH($$HFSPATH^BMXUTL1,BMXFN,"R")
 .;O 51:($$HFSPATH^BMXUTL1_BMXFN:"R")
 .U 51
 .;
 .;---> Read in the host file.
 .D
 ..;---> Need some way to mark the end of legacy code output.
 ..;---> Stop reading Host File if line contains EOF $C(9).
 ..;---> (I added $C(9) above, after ^BMXFACE completed.)
 ..;N I,Y F I=1:1 R Y Q:Y[$C(9)  S ^TMP("BMXFACE",$J,I)=Y
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
 U 56
 ;
 ;---> Copy Face Sheet to global array for passing back to GUI.
 N I,N,U,X S U="^"
 S N=0
 F I=1:1 S N=$O(^TMP("BMXFACE",$J,N)) Q:'N  D
 .;---> Set null lines (line breaks) equal to one space, so that
 .;---> Windows reader will quit only at the final "null" line.
 .S X=^TMP("BMXFACE",$J,N) S:X="" X=" "
 .;---> Remove Carriage Return (13)_Formfeed (12) characters.
 .I X[$C(13)_$C(12) S X=$P(X,$C(13)_$C(12),2)
 .;
 .S ^BMXTEMP($J,"FACE",I)=X_BMX30
 ;
 ;---> If no Health Summary produced, report it as an error.
 D:'$O(^BMXTEMP($J,"FACE",0))
 .;D ERRCD^BMXUTL2(408,.BMXERR) S ^BMXTEMP($J,"FACE",I)=BMX31_BMXERR
 ;
 ;---> Tack on Error Delimiter and any error.
 S ^BMXTEMP($J,"FACE",I)=BMX31_BMXERR
 ;
 ;---> This works; host file gets deleted.
 ;S Y=$$DEL^%ZISH($$HFSPATH^BMXUTL1,BMXFN)
 K ^TMP("BMXFACE",$J)
 Q
