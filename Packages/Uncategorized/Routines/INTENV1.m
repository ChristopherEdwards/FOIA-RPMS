INTENV1 ;bar; 26 Feb 97 18:07; Purge modules for GIS Environment Mgmt
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 Q
 ;
TPURGE(INPURGE,INTT) ; purge transactions from UIF based on criteria
 ; input:  INPURGE = amount of time to keep data, required
 ;                   format: nL where n = number and L is a letter
 ;                      D = days, H = hours, M = minutes
 ;         INTT = Transaction Type filter value (text with wild cards)
 ;                example: "HL TEST*", optional
 ;                can also pass in the array already built
 N DIK,DA,INC,INP,INX,INX0
 S INP=INPURGE,INPURGE=$$PDATE($G(INPURGE)) Q:'INPURGE
 S:$L($G(INTT)) %=$$TTCONV(INTT,.INTT)
 S INX=0,INC=0,DIK="^INTHU(" F  S INX=$O(^INTHU(INX)) Q:'INX  D
 . I '$L($G(^INTHU(INX,0))) K ^INTHU(INX) Q
 . S INX0=^INTHU(INX,0) Q:$P(INX0,U,14)'<INPURGE
 . I $D(INTT) Q:'$D(INTT(+$P(INX0,U,11)))
 . D REMSCH(+$P(INX0,U,16),$P(INX0,U,19),$P(INX0,U,2),INX)
 . S DA=INX D ^DIK
 . S INC=INC+1 I INC>20 S INC=0 H 1
 ; purge formatter jobs if INTT is defined
 D:$D(INTT) FPURGE(INP,.INTT)
 Q
 ;
TDPURGE(INPURGE,INDEST) ; purge transactions from UIF based on criteria
 ; input:  INPURGE = amount of time to keep data, required
 ;                   format: nL where n = number and L is a letter
 ;                      D = days, H = hours, M = minutes
 ;         INDEST = DESTINATION ien
 N DIK,DA,INC,INQ,INX,INX0
 S ZTSK=+$G(ZTSK)
 S INPURGE=$$PDATE($G(INPURGE)) Q:'INPURGE
 S INC=0,INQ="^INLHDEST("_INDEST_")",DIK="^INTHU("
 F  S INQ=$Q(@INQ) Q:$QS(INQ,1)'=INDEST  S INX=$QS(INQ,4) D
 . I '$L($G(^INTHU(INX,0))) K ^INTHU(INX),@INQ Q
 . S INX0=^INTHU(INX,0) Q:$P(INX0,U,14)'<INPURGE
 . D REMSCH(+$P(INX0,U,16),$P(INX0,U,19),$P(INX0,U,2),INX)
 . S INC=INC+1 I INC>20 S INC=0 H 1
 . S DA=INX D ^DIK
 Q
 ;
EPURGE(INPURGE,INCON) ; purge GIS errors
 ; input:  INPURGE = amount of data to keep, required
 ;                   format: nL where n = number and L is a letter
 ;                      D = days, H = hours, M = minutes
 ;         INCON = flag to consolidate remaining errors 1 = YES,
 ;                      0 = NO, default is no
 ;
 N DIK,DA,INC,INX,INX0,INXP,INCONT,INDIR
 S INPURGE=$$PDATE($G(INPURGE)) Q:'INPURGE  K ^UTILITY($J,"ERR")
 S INCON=+$G(INCON),INX=" ",INC=0,DIK="^INTHER("
 F  S INX=$O(^INTHER(INX),-1) Q:'INX  D
 . I '$L($G(^INTHER(INX,0))) K ^INTHER(INX) Q
 . ; INXP flag tell whether data should purge
 . S INX0=^INTHER(INX,0),INXP=$P(INX0,U)'>INPURGE
 . I 'INXP,INCON D
 .. ; criteria: TTien ^ BCFien ^ first_50_chars_of_error_msg
 .. S INCONT=$P(INX0,U,2)_U_$P(INX0,U,11)_U_$E($G(^INTHER(INX,2,1,0)),1,50)
 .. Q:'$L($TR(INCONT,"^"))
 .. I $D(^UTILITY($J,"ERR",INCONT)) S INXP=1 Q
 .. S ^UTILITY($J,"ERR",INCONT)=""
 . Q:'INXP  S DA=INX,INC=INC+1 D ^DIK I INC>20 S INC=0 H 1
 K ^UTILITY($J,"ERR")
 Q
 ;
FPURGE(INPURGE,INTT) ; remove formatter tasks
 ; input:  INPURGE = amount of data to keep, required
 ;                   format: nL where n = number and L is a letter
 ;                      D = days, H = hours, M = minutes
 ;         INTT    = list of TT iens to search for and remove from
 ;                   formatter queue
 N DIK,DA,INX,INX0,H
 S INPURGE=$$PDATE($G(INPURGE),1) Q:'INPURGE
 S:$L($G(INTT)) %=$$TTCONV(INTT,.INTT)
 S INX=0,DIK="^INLHFTSK("
 F  S INX=$O(^INLHFTSK(INX)) Q:'INX  D
 . S INX0=$G(^INLHFTSK(INX,0)) Q:$P(INX0,U,4)]INPURGE
 . I $D(INTT) Q:'$D(INTT(+$P(INX0,U)))
 . S DA=INX D ^DIK
 Q
 ;
DPURGE ; remove destination entries with no UIF
 ; input:  INTT = list of TT iens to search for and remove from
 ;                 formatter queue
 N DIK,DA,INX,INX01
 S INC=0,INQ="^INLHDEST(0)",DIK="^INTHU("
 F  S INQ=$Q(@INQ) Q:'$L(INQ)  S INX=$QS(INQ,4) D
 . K:'$L($G(^INTHU(INX,0))) ^INTHU(INX),@INQ
 Q
 ;
REMSCH(PRIO,DTTM,DEST,DA) ; remove entries from Output and Destination queues
 ; input: PRIO = priority, DTTM = $H, DEST = dest ien, DA = UIF ien
 Q:'$L(PRIO)!'$L(DTTM)!'$L(DEST)!'$L(DA)
 K ^INLHSCH(PRIO,DTTM,DA),^INLHDEST(DEST,PRIO,DTTM,DA)
 Q
 ;
TTCONV(INTT,INTTA) ; take a TT filter value and create an array of iens
 ; input: INTT = string to match TTs, can use wildcards (*)
 ;               and minus (-) to remove selections
 ;        INTTA = array of iens and names passed by reference
 ; output: returns number selected or deselected
 ;
 N INREM,INSELECT,INCNT
 S INSEL='($E(INTT)="-") S:'INSEL INTT=$E(INTT,2,$L(INTT))
 I INTT'["*" S INCNT=0 D  Q INCNT
 . N DIC S DIC="^INRHT(",X=INTT,DIC(0)="QM"
 . S Y=$$DIC^INHSYS05(DIC,X,"",DIC(0)) Q:Y<1
 . I INSEL S:'$D(INTTA(Y)) INTTA(+Y)=$P(Y,U,2),INCNT=1 Q
 . I $D(INTTA(Y)) K INTTA(+Y) S INCNT=-1
 N F,L,N,X,Y S Y=""
 ; get each * piece, conv * to match any, string to match one of string
 S L=$L(INTT,"*"),F=1 F I=1:1:L S X=$P(INTT,"*",I) D
 . I $L(X) S Y=Y_"1"""_X_"""",F=1-(I=L)
 . S:F Y=Y_"0.E",F=0
 K X S X="I N?"_Y,N="",INCNT=0
 F  S N=$O(^INRHT("B",N)) Q:'$L(N)  D
 . X X E  Q
 . S Y=$O(^INRHT("B",N,0)) Q:'Y
 . I INSEL S:'$D(INTTA(Y)) INTTA(Y)=N,INCNT=INCNT+1 Q
 . I $D(INTTA(Y)) K INTTA(Y) S INCNT=INCNT-1
 Q INCNT
 ;
CLEAN ; clear all dynamic GIS files and queues
 ; UIF, Error File, Formatter, Ouput Controller, Destination
 ; STOPALL^INHB should be called first, but can be run in uptime
 N FILE,X,MESSID
 S MESSID=+$G(^INTHU("MESSID"))
 F FILE="^INTHU","^INTHER","^INLHFTSK","^INLHSCH","^INLHDEST" D
 . L +@FILE@(0)
 . S X=$P($G(@FILE@(0)),"^",1,2) K @FILE S:$L(X) @FILE@(0)=X
 . L -@FILE@(0)
 S:$L(MESSID) ^INTHU("MESSID")=MESSID
 Q
 ;
SHUT ; shutdown all GIS, code copied from STOPALL^INHB, removed writes
 N INDA,X
 ; Signal all background processes to quit
 F X=1:1:100 K ^INRHB("RUN")
 ; shutdown active servers
 S INDA=0 F  S INDA=$O(^INTHPC("ACT",1,INDA)) Q:'INDA  I +$P(^INTHPC(INDA,0),U,8),$$VER^INHB(INDA) S X=$$SRVRHNG^INHB(INDA)
 Q
 ;
PDATE(X,C) ; calculate date/time to purge to based on user input
 ; input: X format: nl where n = number and l is a letter
 ;                D = days, H = hours, M = minutes
 ;        C = 0 return in FM format (default), 1 = return in ascii-$H
 ;
 N D,H,M,T,H1,H2
 S T=$$UPCASE^%ZTF($E(X,$L(X))) Q:'$L(T)!("DHM"'[T) 0
 S (D,H,M)=0,@T=+X,H2=$H,H1=$P(H2,","),H2=$P(H2,",",2) D
 . I D S H1=H1-D Q
 . S H2=H2-(H*3600)-(M*60)
 . I H2<0 S H1=H1+(H2+1\86400)-1,H2=H2#86400
 I $G(C) Q H1_","_$E("00000",1,5-$L(H2))_H2
 Q $$CDATH2F^%ZTFDT(H1_","_H2)
 ;
