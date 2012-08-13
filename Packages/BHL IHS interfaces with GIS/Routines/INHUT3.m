INHUT3 ;WFH,JPD; 27 Nov 95 11:42; Tools Interface ZIS front-end function 
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;
ZIS(INRTN,INZVARS,INZIOM,INASK) ; Ask op for device, do ZTRTN.
 ; INRTN(req)=Name of routine does report output."^rou" or "label^rou".
 ; INZVARS(op)=Names of variables to pass ZTRTN. Separate names
 ;  with "^". Example: "INBEG^INHEAD(^INTYPE". Or can be array by
 ;  ref. like the ZTSAVE taskman array.
 ; INZIOM(op)=Width. Def 80. Avoids(disregards)interaction about width
 ; INASK = If 0, ask for device
 ;         If 1, overwrite flatfile INHSYS.RPT with new data
 ;         If 2, append output to INHSYS.RPT
 ;         If 3, no output
 ;
 S INASK=+$G(INASK) S:'$G(INZIOM) INZIOM=80
 F  Q:$$ZISASK  W !?5,"Try again.",!
 Q
 ; Query device.  False to ask again.
ZISASK() N %,%ZIS,IO,IOP,POP S %ZIS="NP"
 S (INZLIM("POP"),INZLIM("ZTSK"))=0
 ; If user needs to define a device, call ^%ZIS w/o open.
 ; If timeout or "^", reset to terminal & quit
 I 'INASK D ^%ZIS I POP S IOP="",%ZIS="" D ^%ZIS K DTOUT Q 1
 I INASK,INASK'=3 S IO=$G(INRPTNM) I IO="" W *7,!,?5,"Invalid Flat File Name!" Q 0
 ; force to specified length, even if user said otherwise
 S IOM=INZIOM
 ; user said slave, but not allowed
 I $D(IO("S")) D  Q 0
 .W *7,!?5,"Sorry, this report cannot be sent to slave."
 ; user said queue to something - should not occur from value
 ; of %ZIS above
 I $D(IO("Q")) W *7,!?5,"This report cannot be queued!" Q 0
 ; user input "passed muster"; do variable setup
 S IOP=ION_";"_IOM_";"_IOSL
 ; not queing: open device, do report, close, & quit
 I INASK'=3 D OPENIT Q:POP 0
 N INZDEF,INZIOM,INZOPTN,INZLIM,INZPRMPT,INZVARS
 D:INRTN]"" @INRTN I $E(IOST)="C",IOM>80,$D(IOA(80)) W @IOA(80)
 ; Close Flat File or device
 Q:INASK=3 1 I INASK D
 .I $$CLOSESEQ^%ZTFS1(IO)
 E  D ^%ZISC
 Q 1
 ;
RUNTSK U IO D @INRTN D:$G(ZTSK) CLNUP^%ZTLOAD(ZTSK) D ^%ZISC Q
 ;
 ; Internal routine to open device
OPENIT I INASK N RNAME S RNAME=$$OPENSEQ^%ZTFS1(IO,"W"_$S(INASK=1:"B",1:"A")),POP=0 U IO Q
 S POP=0,%ZIS="" D ^%ZIS
 I POP S IOP="" D ^%ZIS W *7,!?5,"Device busy."
 U IO I $E(IOST)="C",IOM>80,$D(IOA(132)) W @IOA(132)
 Q
RMRTN(%FIND) ;Clean up IB routines used
 ; INPUT: %FIND - Prefix of routines to remove
 ;        i.e., IBxxxx
 Q:$E(%FIND,1,2)'="IB"  N I,X,EX S I=0,EX=^%ZOSF("DEL")
 F  S I=$$HEXUP^INHSYS04(I),X=%FIND_$S($L(I)<2:"0"_I,1:I) Q:'$$ROUTEST^%ZTF(X)  X EX
 S X=%FIND_"W" I $$ROUTEST^%ZTF(X) X EX
 Q
 ; Internal routine to setup taskman array
ZTSAVE N I K ZTSAVE
 I $D(INZVARS)<10 S INZVARS=$G(INZVARS) D  Q
 .F I=1:1 S %=$P(INZVARS,U,I) Q:%=""  S ZTSAVE(%)=""
 S I="" F  S I=$O(INZVARS(I)) Q:I=""  S ZTSAVE(I)=INZVARS(I)
 Q
ORDER(GL,VAR,ST,END,EX) ;MOVE TO %ZTF
 ; Perform indirect $Order and execute line for each
 ; Inputs:
 ;    GL - Global name  VAR - Variable to use for $O
 ;    ST - Starting place in Global
 ;    END - Ending condition EX - Excutable code for each node
 Q:$G(EX)=""!($G(END)="")!($G(ST)="")!($G(VAR)="")!($G(GL)="")
 N @VAR,C S @VAR=ST,C=$E(GL,$L(GL)) Q:C=")"
 I C'=",",C'="(" S GL=GL_"("
 S GL=GL_VAR_")"
 ;S GL=GL_"("_VAR_")"
12 S @VAR=$O(@GL) I @END Q
 X EX G 12
 ;===========================================
TR(X) ; Calculate Valid VMS filename for TRANSACTION TYPE by translating
 ; " " to "_", all other invalid characters to "-"
 ; Input should be the TRANSACTION TYPE NAME field
 ; Extention must be added by calling routine
 Q $TR(X," .;()/*#@^&%<>,?[]{}|\`~':""","_--------------------------")
