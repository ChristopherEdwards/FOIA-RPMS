INHRTH1 ;DP; 2 Apr 98 16:16;27 Dec 95 10:39;Throughput analyzer report II 
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 Q
PARM() ;Get parameters
 ;
 S DIC=4005,DIC(0)="AEMNQZ"
 S POP=0 D DES Q:'Y  Q:POP 0
 S (INBEG,INEND)=0
 Q:'$$GETRNG(.INBEG,.INEND) 0
 S POP=0 D STU Q:POP 0
 I ST="" S ST=X1 W "ALL"
 D DET Q:POP 0
 Q 1
 ;
DES ;Get multiple destinations
 K X,X2,IN1 S X2=""
 F I=1:1 D  Q:POP  W:Y=-1&(X2="") "ALL" Q:Y=-1
 .D ^DIC S:X[U POP=1 Q:POP  Q:+Y<1
 .S X(+Y)=$P(^INRHD(+Y,0),U)
 .S IN1(X(+Y))="",X2=X2_(+Y)_","
 Q
GETRNG(START,STOP) ;get start & stop dates
 ;
 S START=1,STOP=999999999
 W ! Q:'$$IEN(.START,"Starting Date: ") 0
 ; Search starts on the previous day at midnight.
 ; The asking start date
 S INABEG=Y
 W ! Q:'$$IEN(.STOP,"  Ending Date: ") 0
 ; The asking stop date
 S INAEND=Y
 ; Set up the date/time 
 D GETDATE(.INABEG,.INAEND,.START,.STOP)
 Q 1
 ;
IEN(IEN,ASK) ;read date
 ;
 S %DT="TAEX",%DT("A")=$G(ASK) D ^%DT Q:Y<1 0
 Q 1
 ;
 Q
DET ;Detail yes/no
 W ! S DET=$$YN^UTSRD("Detailed: ;N")
 I DET[U S POP=1 Q
INT ;Read time interval
 W !! D ^UTSRD("Time interval: ;1.4AN;;;60 ;;;;;INTM","Enter 1 to 60 Minutes Or 1H to 24H for Hours. ") I 'INTM S POP=1 Q
 D PAGES
 W @IOF,!,"Destination: " I $L(X2)=0 W "All "
 E  F I=1:1:$L(X2,",")-1 W ?13,$P(^INRHD($P(X2,",",I),0),U),!
 ;W !,"Status(s): " F I=1:1:$L(ST) W ?13,$P($P(X3,";",I),":",2),!
 W !,"Status(s): " F I=1:1:$L(ST) W ?13,$P($P(X3,$E(ST,I)_":",2),";"),!
 W !,"From: ",$$CDATASC^%ZTFDT($E(INABEG,1,12),3,1)
 W !,"  To: ",$$CDATASC^%ZTFDT($E(INAEND,1,12),3,1),!
 W !,"Detail: ",$S(DET=1:"Yes",1:"No"),!
 W !,"Time intervals: ",INTM W $S(INTM["H":"r",1:"Minutes") W !!
 W "This report is about ",PAGES," page" W:PAGES>1 "s" W " long",!!
 S Z=$$CR^UTSRD
 I Z S POP=1 Q
 ; taskman variables
 ; ST    = status string
 ; X     = detail 1 yes 0 no
 ; X2    = destination list (IEN,...)
 ; INBEG = beginning date@time
 ; INEND = ending date@time
 ; INTM  = time interval
 ;
 S INLOAD=ST_U_DET_U_X2_U_INBEG_U_INEND_U_INTM_U_INABEG_U_INAEND
 W ! Q
 ;
STU ;Build status string
 N I,C S (X1,ST)=""
 S X3=$P(^DD(4001,.03,0),U,3,99)
 F I=1:1:$L(X3,":")-1 S X1=X1_$P($P(X3,";",I),":")
 W ! F I=1:1 D ST Q:C=""!POP
 Q
ST ;Display status list
 W ! D ^UTSRD("Status: ","^D ST0^INHRTH1") Q:POP
 S C=X Q:C=""
 I C=U S POP=1 Q
 I C="ALL" S ST=X1,C="" Q
 ; enter a "-" to remove an item
 I C["-",$L(ST)>0 S C=$E(C,2) D  Q
 .S ST=$E(ST,1,($F(ST,C)-2))_$E(ST,($F(ST,C)),99)
 I X1[(C) W " ",$P($P(X3,";",($F(X1,C)-1)),":",2) S ST=ST_C Q
ST0 N I W !,"Please select from:"
 F I=1:1:$L(X1) W !," ",$P($P(X3,";",I),":"),"  ",$P($P(X3,";",I),":",2)
 W !," ALL"
 S:$$CR^UTSRD POP=1
 Q
ST1 ;get the status string to be printed as part of the header.
 ; INLN(3) = line 1
 ; INLN(4) = line 2
 N I
 S X=$P(^DD(4001,.03,0),U,3,99),(X3,X4)=""
 ;F I=1:1:$L(ST) S X3=X3_$P($P(X,";",I),":",2) S:I<$L(ST) X3=X3_", "
 F I=1:1:$L(ST) S X3=X3_$P($P(X,$E(ST,I)_":",2),";") S:I<$L(ST) X3=X3_", "
 I $L(X3)>(IOM-8) S X4=X3 D
 .F I=$L(X4,","):-1 S X3=$P(X4,",",1,I) I $L(X3)<((IOM+8)\2) S X4=$P(X4,",",(I+1),99) Q
 S INLN(3)=X3,INLN(4)=X4
 Q
PAGES ;Calculate number of pages for the report
 ; time periods * destenations * number of statuses * number of days \ 55
 S X=INTM S:INTM["H" X=INTM*60
 S X=1440\X*($S(DET:$L(ST),1:1))
 S X=X*($S(X2[",":$L(X2,",")-1,1:$P(^INRHD(0),U,4)))
 S X=X*($$CDATF2H^%ZTFDT(INEND)-$$CDATF2H^%ZTFDT(INBEG))
 S PAGES=X\55 S:PAGES<1 PAGES=1
 Q
 ;
GETDATE(INASTART,INAEND,INSTART,INEND) ; setup the date/time 
 ; Description: Set the start and end times appropriately
 ; Return: None
 ; Parameters:
 ;    INASTART = The asking start date from user
 ;    INAEND   = The asking end date from user
 ;              ( must be passed in by reference because they will 
 ;        be adjusted, i.e. INAEND=T will become INAEND=T@2400 )
 ;    INSTART  = The reference start date to be searched in ^INTHU
 ;    INEND    = The reference end date to be searched in ^INTHU
 ;
 ; Code Begins:
 N INTEMP
 S INEND=$G(INAEND),INSTART=$G(INASTART)
 S:'INEND!(INEND=DT) INEND=DT_".24"
 ; Take care a special case (start date T-1@0800 and end date t-1)
 S:(INEND\1=INEND)&(INSTART\1=INEND) INEND=INEND+.24
 I (INEND-INSTART)<0 D
 .  ; a RECENT to PAST search criteria
 .  S INTEMP=INSTART,(INASTART,INSTART)=INEND
 .  S:((INSTART\1)=INSTART) INSTART=INSTART-.0000001
 .  I (INTEMP\1)=INTEMP S INEND=INTEMP+.999999,INAEND=INTEMP+.24
 .  I (INTEMP\1)'=INTEMP S (INAEND,INEND)=INTEMP
 E  D
 .  ; a PAST to RECENT search criteria
 .  I ((INEND\1)=INEND) S INAEND=INEND+.24,INEND=INEND+.999999
 .  E  S INAEND=INEND,INEND=INEND+.000099 ; Because second resolution can not be entered
 .  S INASTART=INSTART,INSTART=INSTART-.0000001
 ; At this point, INSTART AND INEND are defined, however we need
 ; to look it up in ^INTHU for the existing date value
 S INSTART=INSTART-3
 S INSTART=$O(^INTHU("B",INSTART))
 S INEND=$O(^INTHU("B",INEND),-1)
 ; if start date is not found, set it to end date.  This only
 ; happened if start date is greater than the latest date in ^INTHU
 I '$G(INSTART) S INSTART=INEND
 ; if end date is not found, set it to start date.  This only happened
 ; when end date is smaller than the earliest date in ^INTHU
 I '$G(INEND) S INEND=INSTART
 Q
