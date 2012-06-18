AGELUP1 ;IHS/ASDS/EFG - UPDATE ELIGIBILITY FROM CMS FILE (MAIN) ;  
 ;;7.1;PATIENT REGISTRATION;**2**;JAN 31, 2007
 ;
 ;This is the start point, that's called from option
 ;AG TM ELI UPLOAD, on the Eligibility menu (AG TM ELIGIBILITY).
 ;
TXT ;
 ;;Before processing your eligibility file, please run 2 reports,
 ;;one in PtReg, and one in TPB:
 ;;  
 ;;     PTRG -> THR -> AGSM   Summary of 3rd Party Resources
 ;;     RPTP -> BRRP   Brief (single-line) Claim Listing
 ;;  
 ;;Run the same two reports after processing your eligibility file.
 ;;These two before/after reports will provide the data for you to
 ;;determine the effectiveness of processing these eligibility files.
 ;;  
 ;;You can still process the eligibility file, even if you haven't
 ;;run the reports...
 ;;###
 ;
START ;start
 NEW AGZERO,AGONE,AGTWO,AGPARSE,AGTYPE,AGFPVL,AGTDA,AG,AG1,AG2
 NEW AGFL,AGFILE,AGPATH,AGQUIT,AGRCNT,AGSTART,AGTHREE,AGDT
 NEW AGACT,AGCNT,AGMDOB,AGMNBR,AGMSFX,AGRUN,AGAUTO,AGINSPT
 NEW DIR
 NEW AGMATCH,AGMCDST
 KILL ^TMP($J,"AGELUP")
 D HELP^XBHELP("TXT","AGELUP1")
 Q:'$$DIR^XBDIR("E")
 D FRMT^AGELUPUT
 Q:'$D(AGTDA)!$D(DIRUT)
 D INSPT^AGELUPUT
 I $G(AGINSPT)<1 W !,"An INSURER is needed.  Sorry." Q
 D OPEN
 Q:$D(DIRUT)
 ;I POP W !,"Could not open host file",! Q
 I POP W !,"Could not open host file",! H 3 Q  ;AG*7.1*2
 S X="IORVON;IORVOFF"
 D ENDR^%ZISS,AUDS^AGELUPUT,FLOOP,AUDR^AGELUPUT,RUN1^AGELUPUT:'$D(DIRUT),KILL^%ZISS
 KILL ^TMP($J,"AGELUP")
 U IO(0)
 W !!,"D O N E",!!
 I $$DIR^XBDIR("E","Press RETURN")
 Q
OPEN ;open host file
 NEW AGLIST
 KILL AGFILE,DIR
 S AGPATH=$P($G(^AGFAC(DUZ(2),2)),U,2)
 I AGPATH="" S AGPATH=$S($P(^%ZOSF("OS"),U,1)["UNIX":"/usr/spool/uucppublic/",1:$P($G(^AUTTSITE(1,1)),U,1))
 S AGPATH=$$DIR^XBDIR("F","Enter directory containing host file. You will be asked for the filename seperately.",AGPATH,"","","",1)
 Q:$D(DIRUT)
 S AGLIST="",AG=$S("MR"[AGTYPE:"r",AGTYPE="P":"p",1:"d")
 I '$$LIST^%ZISH(AGPATH,"cms"_AG_$$LTR^AGELUP3(3)_"*",.AGLIST) D  I $G(AGFILE) S AGFILE=AGLIST(AGFILE)
 . NEW AG
 . S AG=0
 . F  S AG=$O(AGLIST(AG)) Q:'AG  W !,$J(AG,3),". ",AGLIST(AG) S:(('(AG#5))!('$D(AGLIST(AG+1)))) AGFILE=$$DIR^XBDIR("NO^1:"_AG,"Process which file (or '^' to specify file)") Q:$G(AGFILE)  I $D(DIRUT) KILL AGFILE Q
 .Q
 I '$L($G(AGFILE)) S AGFILE=$$DIR^XBDIR("F","Enter name of file","","","","",2)
 Q:$D(DIRUT)
 I $E(AGFILE,$L(AGFILE)-2,$L(AGFILE))=".gz" S DIRUT=1 W:$$DIR^XBDIR("E","Would you mind gunzip'ing this file, first? :-(") "" Q
 ;BEGIN NEW CODE. CHECK FOR FILE NAME MATCHING TEMPLATE CHOSEN AG*7.1*2 PER E-MAIL FROM ADRIAN
 I ($P(AGZERO,U)[("cmsx*")&($E($$UPPER^AGUTILS(AGFILE),1,4)'="CMSX"))!($P(AGZERO,U)[("cmsr*")&($E($$UPPER^AGUTILS(AGFILE),1,4)'="CMSR")) D  Q:'Y
 .W !,"You have chosen a file which may not be the correct"
 .W !,"format for the Template chosen."
 .K DIR S DIR("A")="DO YOU WISH TO CONTINUE?"
 .S DIR(0)="Y"
 .D ^DIR
 .S:'Y DIRUT=1
 ;END NEW CODE
 D OPEN^%ZISH("AGELFILE",AGPATH,AGFILE,"R")
 Q
FLOOP ;read through file
 KILL AGQUIT
 U IO(0)
 D WAIT^DICD
 I $D(^AGELUPLG("C",AGFILE)) S AGCNT=$P(^AGELUPLG($O(^AGELUPLG("C",AGFILE,""),-1),0),U,4) I AGCNT G FLOOP1
 W "Counting records in file..."
 S AGCNT=0
 U IO
 F  D  Q:$$STATUS^%ZISH
 . I '(AGCNT#1000) U IO(0) W $J(AGCNT,8) U IO
 . R X:DTIME
 . S AGCNT=AGCNT+1
 .Q
FLOOP1 ;
 D CLOSE^%ZISH("AGELFILE")
 U IO(0)
 W !!,AGCNT," records found in file.",!
 S AGSTART=$$DIR^XBDIR("N^1:"_AGCNT,"Start at Record",1)-1
 W !
 Q:$D(DIRUT)
 D RUN^AGELUPUT
 I '$D(AGRUN) D CLOSE^%ZISH("AGELFILE") Q
 D OPEN^%ZISH("AGELFILE",AGPATH,AGFILE,"R")
 S AGRCNT=0
 I AGSTART>1 U IO(0) D WAIT^DICD W "Positioning to record ",AGSTART U IO F I=1:1:AGSTART R X:DTIME S AGRCNT=AGRCNT+1
 F  D  Q:$G(AGQUIT)
 . KILL AG
 . U IO
 . R X:DTIME
 . I $$STATUS^%ZISH S AGQUIT=1 Q
 . U IO(0)
 . S AGRCNT=AGRCNT+1
 . I '(AGRCNT#1000) W $J(AGRCNT,8)
 . D @AGPARSE
 . Q:'AG("DFN")
 . I AGTYPE="M" S X=AG("FNBR") X $P(^DD(9000003,.03,0),U,5,99) Q:'$D(X)
 . I AGTYPE="D" S X=AG("FNBR") X $P(^DD(9000004,.03,0),U,5,99) Q:'$D(X)  I AGAUTO="A" Q:'$$MATCH^AGELUPUT
 . I AGTYPE="R" S X=AG("FNBR") X $P(^DD(9000005,.04,0),U,5,99) Q:'$D(X)
 . I AGFPVL'="",AGFPVL'=AG("FPRO") Q
 . S ^TMP($J,"AGELUP",AG("DFN"))=1
 . S AG("FNM")=AG("FLNM")_","_AG("FFNM")
 . S:AG("FMI")'="" AG("FNM")=AG("FNM")_" "_AG("FMI")
 . S AGACT=$S(AGAUTO="A":"F",1:"")
 . I AGTYPE="M" D M^AGELUP2(.AG) I AG("DFN") D:AGACT="F" FILE^AGELUP2(.AG) S:AGACT="Q"!($D(DIRUT)) AGQUIT=1
 . I AGTYPE="D" D D^AGELUP4(.AG) I AG("DFN") D:AGACT="F" FILE^AGELUP4(.AG) S:AGACT="Q"!($D(DIRUT)) AGQUIT=1
 . I AGTYPE="R" D R^AGELUP3(.AG) I AG("DFN") D:AGACT="F" FILE^AGELUP3(.AG) S:AGACT="Q"!($D(DIRUT)) AGQUIT=1
 .Q
 D CLOSE^%ZISH("AGELFILE")
 Q
F ;fixed length parse
 S AG("FSSN")=$E(X,$P(AGONE,U,8),$P(AGONE,U,9))        ; SSN
 D DFN
 Q:'AG("DFN")
 S AG("FSEX")=$E(X,$P(AGONE,U,12)) ;Sex
 S AG("FMAL1")="" ;Mail Adrs Line 1
 S AG("FMAL2")="" ;Mail Adrs Line 2
 S AG("FMAC")="" ;Mail Adrs City
 S AG("FMAST")="" ;Mail Adrs State
 S AG("FMAZ")="" ;Mail Adrs Zip
 S AG("FLNM")=$$STRIP($E(X,$P(AGONE,U,1),$P(AGONE,U,2))) ;Last Name
 S AG("FFNM")=$$STRIP($E(X,$P(AGONE,U,3),$P(AGONE,U,4))) ;First Name
 S AG("FMI")=$TR($E(X,$P(AGONE,U,5))," ")              ;Middle Initial
 S AG("FNBR")=$E(X,$P(AGONE,U,6),$P(AGONE,U,7))        ;Policy #
 S AG("FSFX")=$TR($E(X,$P(AGONE,U,10),$P(AGONE,U,11))," ") ;Policy # Suffix
 S AG("FDOB")=$$DFMT($E(X,$P(AGTWO,U,1),$P(AGTWO,U,2)),$P(AGZERO,U,5)) ;DOB
 S AG("FPRO")=$E(X,$P(AGTHREE,U,1),$P(AGTHREE,U,2)) ;Process Only
 S AGCNT=0
 F  S AGCNT=$O(^AGELUP(AGTDA,4,AGCNT)) Q:'AGCNT  D
 . S AGND=^AGELUP(AGTDA,4,AGCNT,0),AGDT1=$E(X,$P(AGND,U,1),$P(AGND,U,2))
 . Q:'+AGDT1
 . S AGDT1=$$DFMT(AGDT1,$P(AGZERO,U,5)),AGCVT=$P(AGND,U,5),AG("DT",AGDT1,AGCVT)=AGDT1,AGDT2=$E(X,$P(AGND,U,3),$P(AGND,U,4))
 . I +AGDT2 S AGDT2=$$DFMT(AGDT2,$P(AGZERO,U,5)),$P(AG("DT",AGDT1,AGCVT),U,2)=AGDT2
 . S $P(AG("DT",AGDT1,AGCVT),U,3)=AGCVT
 .Q
 Q
V ;variable length parse
 S AG("FSSN")=$P(X,AGDEL,$P(AGONE,U,8))   ;SSN
 D DFN
 Q:'AG("DFN")
 S AG("FLNM")=$P(X,AGDEL,$P(AGONE,U,1))   ;Last Name
 S AG("FFNM")=$P(X,AGDEL,$P(AGONE,U,3))   ;First Name
 S AG("FMI")=$P(X,AGDEL,$P(AGONE,U,5))    ;Middle Initial
 S AG("FNBR")=$P(X,AGDEL,$P(AGONE,U,6))   ;Policy #
 S AG("FSFX")=$P(X,AGDEL,$P(AGONE,U,10))  ;Policy # Suffix
 S AG("FDOB")=$$DFMT($E(X,AGDEL,$P(AGTWO,U,1)),$P(AGZERO,U,5)) ;DOB
 S AG("FPRO")=$E(X,AGDEL,$P(AGTHREE,U,1)) ;Process Only
 S AG("FSEX")=$P(X,AGDEL,$P(AGONE,U,12)) ;Sex
 S AG("FMAL1")=$P(X,AGDEL,$P(AGSEVEN,U,1)) ;Mail Adrs Line 1
 S AG("FMAL2")=$P(X,AGDEL,$P(AGSEVEN,U,3)) ;Mail Adrs Line 2
 S AG("FMAC")=$P(X,AGDEL,$P(AGSEVEN,U,5))  ;Mail Adrs City
 S AG("FMAST")=$P(X,AGDEL,$P(AGSEVEN,U,7)) ;Mail Adrs State
 S AG("FMAZ")=$P(X,AGDEL,$P(AGSEVEN,U,9))  ;Mail Adrs Zip
 S AGCNT=0
 F  S AGCNT=$O(^AGELUP(AGTDA,4,AGCNT)) Q:'AGCNT  D
 . S AGND=^AGELUP(AGTDA,4,AGCNT,0),AGDT=$P(X,AGDEL,$P(AGND,U,1))
 . Q:'+AGDT
 . S AGCVT=$P(X,AGDEL,$P(AGND,U,5))
 . S AGDT=$$DFMT(AGDT,$P(AGZERO,U,5)),AG("DT",AGDT,AGCVT)=AGDT,AGDT2=$P(X,AGDEL,$P(AGND,U,3))
 . S:+AGDT2 $P(AG("DT",AGDT,AGCVT),U,2)=$$DFMT(AGDT2,$P(AGZERO,U,5))
 . S $P(AG("DT",AGDT,AGCVT),U,3)=AGCVT
 .Q
 Q
STRIP(Y) ;strip trailing blanks
 NEW I
 F I=$L(Y):-1:1 I $E(Y,I)'=" " S Y=$E(Y,1,I) Q
 KILL AGQUIT
 Q Y
DFMT(A,B) ;Format date A according to B.
 I '+A Q ""
 I B=1 Q ($E(A,1,4)-1700)_$E(A,5,6)_$E(A,7,8)
 I B=2 Q ($E(A,5,8)-1700)_$E(A,1,4)
 I B=3 Q $S($E(A,5,6)>50:2,1:3)_$E(A,5,6)_$E(A,1,4)
 I B=4 Q $S($E(A,1,2)>50:2,1:3)_$E(A,1,2)_$E(A,3,6)
 I B=5 D  Q A
 . S A=$P(A," ",1)
 . F %=1,2 S $P(A,"/",%)="0"_$P(A,"/",%)
 . S A=($P(A,"/",3)-1700)_($E($P(A,"/",1),$L($P(A,"/",1))-1,$L($P(A,"/",1))))_($E($P(A,"/",2),$L($P(A,"/",2))-1,$L($P(A,"/",2))))
 .Q
 Q "????????"
DFN ;Lookup Pt using SSN.
 S AG("DFN")=0,AG("FSSN")=$TR(AG("FSSN"),"-/ ")
 Q:'AG("FSSN")
 S AG("DFN")=$O(^DPT("SSN",AG("FSSN"),0))
 Q:'AG("DFN")
 I $G(^TMP($J,"AGELUP",AG("DFN"))) S AG("DFN")=0
 Q
