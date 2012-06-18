AGELUPNM ;IHS/SET/GTH - INITIAL PROCESS OF NM MEDICAID FILE ; 
 ;;7.1;PATIENT REGISTRATION;**2**;JAN 31, 2007
 ;
 ;This is the start point, that's called from option
 ;AG TM ELI UPLOAD, on the Eligibility menu (AG TM ELIGIBILITY).
 ;
TXT ;
 ;;This process takes the State of New Mexico's data file for Medicaid
 ;;and reformats it into single eligibility records for distribution
 ;;to specific sites in the State.
 ;;  
 ;;This process only exists at Albuquerque.  For now....
 ;;  
 ;;This processing is specific to the format of Medicaid data provided
 ;;by the State of New Mexico.
 ;;###
 ;
START ;start
 NEW AG,AGFILE,AGPATH,AGCNT,DIR
 KILL ^TMP($J,"AGELUPNM")
 D HELP^XBHELP("TXT","AGELUPNM")
 Q:'$$DIR^XBDIR("E")
 D OPEN
 Q:$D(DIRUT)
 ;I POP W !,"Could not open host file",! Q
 I POP W !,"Could not open host file",! H 3 Q  ;AG*7.1*2
 D CLOSE^%ZISH("AGNMFILE")
 D READIN,WRITEOUT
 KILL ^TMP($J,"AGELUPNM")
 U IO(0)
 W !!,"D O N E",!!
 I $$DIR^XBDIR("E","Press RETURN")
 Q
OPEN ;open host file
 NEW AGLIST
 KILL AGFILE,DIR
 S AGPATH=$P($G(^AGFAC(DUZ(2),2)),U,2)
 I AGPATH="" S AGPATH=$S($P(^%ZOSF("OS"),U,1)["UNIX":"/usr/spool/uucppublic/",1:$P($G(^AUTTSITE(1,1)),U,1))
 S AGPATH=$$DIR^XBDIR("F","Enter directory containing file with NM Medicaid info",AGPATH,"","","",1)
 Q:$D(DIRUT)
 I '$$LIST^%ZISH(AGPATH,"IHS"_"*",.AGLIST) D  I $G(AGFILE) S AGFILE=AGLIST(AGFILE)
 . NEW AG
 . S AG=0
 . F  S AG=$O(AGLIST(AG)) Q:'AG  D  I $D(DIRUT) KILL AGFILE Q
 .. W !,$J(AG,3),". ",AGLIST(AG)
 .. S:(('(AG#5))!('$D(AGLIST(AG+1)))) AGFILE=$$DIR^XBDIR("NO^1:"_AG,"Process which file (or '^' to specify file)")
 .. Q:$G(AGFILE)
 ..Q
 .Q
 I '$L($G(AGFILE)) S AGFILE=$$DIR^XBDIR("F","Enter name of file","","","","",2)
 Q:$D(DIRUT)
 D OPEN^%ZISH("AGNMFILE",AGPATH,AGFILE,"R")
 Q
READIN ;read through file
 U IO(0)
 W !,"Processing NM Medicaid file..."
 D WAIT^DICD
 W !
 S AGCNT=0
 F %=1:1:5 S AGCNT(%)=0
 D OPEN^%ZISH("AGNMFILE",AGPATH,AGFILE,"R")
 U IO
 KILL P
 F  R X:DTIME Q:$$STATUS^%ZISH  D
 . I '(AGCNT#1000) U IO(0) W $J(AGCNT,8) U IO
 . S AGCNT=AGCNT+1,AGCNT(+X)=AGCNT(+X)+1
 . Q:'("12"[$E(X))
 . ;remove leading "0"s
 . F  S P=$F(X,"^0") Q:'P  S X=$E(X,1,P-2)_$E(X,P,$L(X))
 . ;remove trailing blanks
 . F  S P=$F(X," ^") Q:'P  S X=$E(X,1,P-3)_$E(X,P-1,$L(X))
 . ;remove insignifant times
 . F  S P=$F(X," 0:00:00") Q:'P  S X=$E(X,1,P-9)_$E(X,P,$L(X))
 . ;remove open-ended end dates
 . F  S P=$F(X,"12/31/9999") Q:'P  S X=$E(X,1,P-11)_$E(X,P,$L(X))
 . ;Keep all eligibility records (2) at the same node.
 . I $E(X)="2" S X=$P(X,U,1,5) I $D(^TMP($J,"AGELUPNM",$P(X,U,2),2)) S ^(2)=^(2)_U_$P(X,U,3,5) Q
 . S ^TMP($J,"AGELUPNM",$P(X,U,2),$P(X,U,1))=$P(X,U,3,999)
 .Q
 KILL P
 D CLOSE^%ZISH("AGNMFILE")
 U IO(0)
 W !!,AGCNT," records found in file:",!
 F %=1:1:5 W !?5,%,". :  ",AGCNT(%)
 Q
WRITEOUT ;
 NEW AGSYSID
 S AGFILE="cmsd"_$$LTR^AGELUP3(3)_"."_$E(DT,2,5)
 U IO(0)
 W !,"Writing to file ",AGPATH,AGFILE,"...."
 D WAIT^DICD
 W !
 D OPEN^%ZISH("AGNMFILE",AGPATH,AGFILE,"W")
 Q:POP
 U IO
 S (AGCNT,AGSYSID)=0
 F  S AGSYSID=$O(^TMP($J,"AGELUPNM",AGSYSID)) Q:'AGSYSID  D
 . S AGCNT=AGCNT+1
 . I '(AGCNT#1000) U IO(0) W AGCNT," of ",AGCNT(1)," / " U IO
 . Q:'$D(^TMP($J,"AGELUPNM",AGSYSID,2))
 . Q:'$D(^TMP($J,"AGELUPNM",AGSYSID,1))
 . S X=^TMP($J,"AGELUPNM",AGSYSID,1)_"^^^^^^^"_^(2)
 . W X,!
 .Q
 D CLOSE^%ZISH("AGNMFILE")
 Q
