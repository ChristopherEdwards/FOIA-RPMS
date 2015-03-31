BGP4AUUL ;IHS/CMI/LAB - AREA UPLOAD;
 ;;14.0;IHS CLINICAL REPORTING;;NOV 14, 2013;Build 101
 ;
DESC ;----- ROUTINE DESCRIPTION
 ;; 
 ;;This routine was copied from the BGP1ULF routine and modified to
 ;;remove user interaction and screen output and other unneeded stuff.
 ;;$$END
 ;
 N I,X F I=1:1 S X=$P($T(DESC+I),";;",2) Q:X["$$END"  D EN^DDIOL(X)
 Q
 ;
EN(BGPDIR,BGPFILE) ;EP -- MAIN ENTRY POINT
 ;      INPUT:
 ;      BGPDIR   =  DIRECTORY
 ;      BGPFILE  =  FILE TO BE PROCESSED
 ;
READF ;EP read file
 NEW Y,X,I,BGPC
 S BGPC=1
 S Y=$$OPEN^%ZISH(BGPDIR,BGPFILE,"R")
 I Y D  G EOJ
 . S BGPERR="UNABLE TO OPEN FILE '"_BGPDIR_BGPFILE_"'"
 . ;S $ZR="<NOTOPEN>READF^BGPGPULF"
 . ;D ^ZTER 
 KILL ^TMP("BGPGPUPL",$J)
 F I=1:1 U IO R X:DTIME S X=$$STRIP(X) Q:X=""  S ^TMP("BGPGPUPL",$J,BGPC,0)=X,BGPC=BGPC+1 Q:$$STATUS^%ZISH=-1
 D ^%ZISC
PROC ;
 S BGP0=$P($G(^TMP("BGPGPUPL",$J,1,0)),"|",9)
 S BGPG=$P($G(^TMP("BGPGPUPL",$J,1,0)),"|")
 F X=1:1:14 S Y="BGP"_X,@Y=$P(BGP0,U,X)
 ;find existing entry and if exists, delete it
 S (X,BGPOIEN)=0 F  S X=$O(^BGPGPDCJ(X)) Q:X'=+X  D
 .I '$D(^BGPGPDCJ(X,0)) K ^BGPGPDCJ(X) Q
 .S Y=^BGPGPDCJ(X,0)
 .Q:$P(Y,U)'=BGP1
 .Q:$P(Y,U,2)'=BGP2
 .Q:$P(Y,U,3)'=BGP3
 .Q:$P(Y,U,4)'=BGP4
 .Q:$P(Y,U,5)'=BGP5
 .Q:$P(Y,U,6)'=BGP6
 .Q:$P(Y,U,8)'=BGP8
 .Q:$P(Y,U,9)'=BGP9
 .Q:$P(Y,U,10)'=BGP10
 .Q:$P(Y,U,11)'=BGP11
 .Q:$P(Y,U,12)'=BGP12
 .Q:$P(Y,U,14)'=BGP14
 .S BGPOIEN=X
 D ^XBFMK
 I BGPOIEN S DA=BGPOIEN,DIK="^BGPGPDCJ(" D ^DIK S DA=BGPOIEN,DIK="^BGPGPDPJ(" D ^DIK S DA=BGPOIEN,DIK="^BGPGPDBJ(" D ^DIK
 ;add entry
 L +^BGPGPDCJ:10 I '$T D EOJ Q
 L +^BGPGPDPJ:10 I '$T D EOJ Q
 L +^BGPGPDBJ:10 I '$T D EOJ Q
 D GETIEN^BGP4UTL
 I 'BGPIEN D EOJ Q
CY ;
 S DINUM=BGPIEN,X=$P(BGP0,U),DLAYGO=90552.03,DIC="^BGPGPDCJ(",DIC(0)="L"
 K DD,D0,DO
 D FILE^DICN
 I Y=-1 G EOJ
 S BGPIEN=+Y
 D ^XBFMK
 S X=0 F  S X=$O(^TMP("BGPGPUPL",$J,X)) Q:X'=+X  S V=^TMP("BGPGPUPL",$J,X,0) D
 .Q:$P(V,"|")'="BGPGPDCJ"
 .S V=$P(V,"|",2,9999)
 .S N=$P(V,"|"),N2=$P(V,"|",2),N3=$P(V,"|",3),N4=$P(V,"|",4),N5=$P(V,"|",5),D=$P(V,"|",8)
 .I N5]"" S ^BGPGPDCJ(BGPIEN,N,N2,N3,N4,N5)=D Q
 .I N4]"" S ^BGPGPDCJ(BGPIEN,N,N2,N3,N4)=D Q
 .I N3]"" S ^BGPGPDCJ(BGPIEN,N,N2,N3)=D Q
 .I N2]"" S ^BGPGPDCJ(BGPIEN,N,N2)=D Q
 .I N]"" S ^BGPGPDCJ(BGPIEN,N)=D
 .Q
 S DA=BGPIEN,DIK="^BGPGPDCJ(" D IX1^DIK
PY ;
 S DINUM=BGPIEN,X=$P(BGP0,U),DLAYGO=90552.04,DIC="^BGPGPDPJ(",DIC(0)="L"
 K DD,D0,DO
 D FILE^DICN
 I Y=-1 G EOJ
 S BGPIEN=+Y
 D ^XBFMK
 S X=0 F  S X=$O(^TMP("BGPGPUPL",$J,X)) Q:X'=+X  S V=^TMP("BGPGPUPL",$J,X,0) D
 .Q:$P(V,"|")'="BGPGPDPJ"
 .S V=$P(V,"|",2,9999)
 .S N=$P(V,"|"),N2=$P(V,"|",2),N3=$P(V,"|",3),N4=$P(V,"|",4),N5=$P(V,"|",5),D=$P(V,"|",8)
 .I N5]"" S ^BGPGPDPJ(BGPIEN,N,N2,N3,N4,N5)=D Q
 .I N4]"" S ^BGPGPDPJ(BGPIEN,N,N2,N3,N4)=D Q
 .I N3]"" S ^BGPGPDPJ(BGPIEN,N,N2,N3)=D Q
 .I N2]"" S ^BGPGPDPJ(BGPIEN,N,N2)=D Q
 .I N]"" S ^BGPGPDPJ(BGPIEN,N)=D
 .Q
 S DA=BGPIEN,DIK="^BGPGPDPJ(" D IX1^DIK
BY ;
 S DINUM=BGPIEN,X=$P(BGP0,U),DLAYGO=90552.05,DIC="^BGPGPDBJ(",DIC(0)="L"
 K DD,D0,DO
 D FILE^DICN
 I Y=-1 G EOJ
 S BGPIEN=+Y
 D ^XBFMK
 S X=0 F  S X=$O(^TMP("BGPGPUPL",$J,X)) Q:X'=+X  S V=^TMP("BGPGPUPL",$J,X,0) D
 .Q:$P(V,"|")'="BGPGPDBJ"
 .S V=$P(V,"|",2,9999)
 .S N=$P(V,"|"),N2=$P(V,"|",2),N3=$P(V,"|",3),N4=$P(V,"|",4),N5=$P(V,"|",5),D=$P(V,"|",8)
 .I N5]"" S ^BGPGPDBJ(BGPIEN,N,N2,N3,N4,N5)=D Q
 .I N4]"" S ^BGPGPDBJ(BGPIEN,N,N2,N3,N4)=D Q
 .I N3]"" S ^BGPGPDBJ(BGPIEN,N,N2,N3)=D Q
 .I N2]"" S ^BGPGPDBJ(BGPIEN,N,N2)=D Q
 .I N]"" S ^BGPGPDBJ(BGPIEN,N)=D
 .Q
 S DA=BGPIEN,DIK="^BGPGPDBJ(" D IX1^DIK
 D EOJ
 Q
EOJ ;EP
 L -^BGPGPDCJ
 L -^BGPGPDPJ
 L -^BGPGPDBJ
 K IOPAR
 D HOME^%ZIS
 K X,X1,X2,X3,X4,X5,X6
 K A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,V,W,X,Y,Z
 K N,N1,N2,N3,N4,N5,N6
 K DIC,DA,X,Y,%Y,%,BGPJ,BGPX,BGPTEXT,BGPLINE,BGP
 Q
STRIP(Z) ;REMOVE CONTROLL CHARACTERS
 NEW I
 F I=1:1:$L(Z) I (32>$A($E(Z,I))) S Z=$E(Z,1,I-1)_""_$E(Z,I+1,999)
 Q Z
SCH ;EP - called from option to schedule the area aggregate for the next "2nd Friday"
 ;INFORM
 W !!,"This option is used to automatically schedule the Auto Area"
 W !,"file aggregation for the second Friday of the month.",!
 S BGPTASK=$$CHKFQT()
 I BGPTASK W !!,"The option is already scheduled to run: TASK # ",BGPTASK," at ",$$HTE^XLFDT($P(^%ZTSK(BGPTASK,0),U,6)),"." D DEL,PAUSE^BGP4DU,XIT^BGP4AUUP Q
 NEW BGPDT,BGPX,BGPY
 S BGPDT=DT
 ;get next "second Friday" in this month
 ;S BGPX=$E(DT,1,5)_"01"  ;first of this month
 S BGPY=0  ;friday counter
 ;S X=DT
 ;D DW^%DTC
 D
 . S BGPDT=$E(DT,1,5)_"01"
 . S X=BGPDT D DW^%DTC I X="FRIDAY" S BGPY=BGPY+1
 . F  D  Q:BGPY=2
 . . S (X,BGPDT)=$$FMADD^XLFDT(BGPDT,1)
 . . D DW^%DTC
 . . Q:X'="FRIDAY"
 . . S BGPY=BGPY+1
 I BGPDT<DT D
 .;ADD 1 TO bgpdt Until the month changs
 .S BGPY=0
 .S BGPDT=DT F  S BGPDT=$$FMADD^XLFDT(BGPDT,1) Q:$E(BGPDT,4,5)'=$E(DT,4,5)
 .S X=BGPDT D DW^%DTC I X="FRIDAY" S BGPY=BGPY+1
 .F  D  Q:BGPY=2
 ..S (X,BGPDT)=$$FMADD^XLFDT(BGPDT,1)
 ..D DW^%DTC
 ..Q:X'="FRIDAY"
 ..S BGPY=BGPY+1
 W !,"This option will be scheduled for ",$$FMTE^XLFDT(BGPDT)," at 12:00pm.",!
 K DIR
 S DIR(0)="Y",DIR("A")="Do you wish to continue and schedule it",DIR("B")="Y" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) Q
 I 'Y Q
 ;S BGPOPT="BGP 14 AUTO PROC SITE FILES"
 ;S BGPOPTD0=$O(^DIC(19,"B",BGPOPT,0))
 ;I 'BGPOPTD0 D  Q
 ;. D BMES^XPDUTL("'BGP 14 AUTO PROC SITE FILES' OPTION NOT FOUND!")
 ;. D PAUSE^BGP4DU
 ;. D XIT^BGP4AUUP
 ;Q:'BGPOPTD0
 ;S BGPD0=$O(^DIC(19.2,"B",BGPOPTD0,0))
 ;D ADDOPT(BGPOPTD0,.BGPD0)
 S BGPX=BGPDT_".12"
 ;D EDITOPT(BGPD0)
 ;ztload
 S ZTDTH=BGPX
 ;S ZTSAVE("BGP*")=""
 S ZTRTN="AUTO^BGP4AUUP"
 S ZTDESC="BGP4 AUTO GPRA AREA AGGREGATE"
 S ZTIO=""
 D ^%ZTLOAD
 S BGPTSK=$G(ZTSK)
 D BMES^XPDUTL("OPTION 'BGP4 AUTO AREA AGGREGATE' SCHEDULED AS TASK #"_BGPTSK)
 D PAUSE^BGP4DU,XIT^BGP4AUUP
 Q
SCHGUI ;EP -- gui scheduler
 NEW BGPDT,BGPX,BGPY
 S BGPDT=DT
 ;get next "second Friday" in this month
 ;S BGPX=$E(DT,1,5)_"01"  ;first of this month
 S BGPY=0  ;friday counter
 ;S X=DT
 ;D DW^%DTC
 D
 . S BGPDT=$E(DT,1,5)_"01"
 . S X=BGPDT D DW^%DTC I X="FRIDAY" S BGPY=BGPY+1
 . F  D  Q:BGPY=2
 . . S (X,BGPDT)=$$FMADD^XLFDT(BGPDT,1)
 . . D DW^%DTC
 . . Q:X'="FRIDAY"
 . . S BGPY=BGPY+1
 I BGPDT<DT D
 .;ADD 1 TO bgpdt Until the month changs
 .S BGPY=0
 .S BGPDT=DT F  S BGPDT=$$FMADD^XLFDT(BGPDT,1) Q:$E(BGPDT,4,5)'=$E(DT,4,5)
 .S X=BGPDT D DW^%DTC I X="FRIDAY" S BGPY=BGPY+1
 .F  D  Q:BGPY=2
 ..S (X,BGPDT)=$$FMADD^XLFDT(BGPDT,1)
 ..D DW^%DTC
 ..Q:X'="FRIDAY"
 ..S BGPY=BGPY+1
 S BGPX=BGPDT_".12"
 ;D EDITOPT(BGPD0)
 ;ztload
 S ZTDTH=BGPX
 ;S ZTSAVE("BGP*")=""
 S ZTRTN="AUTO^BGP4AUUP"
 S ZTDESC="BGP4 AUTO GPRA AREA AGGREGATE"
 S ZTIO=""
 D ^%ZTLOAD
 S BGPTSK=$G(ZTSK)
 Q
 ;
ADDOPT(BGPOPTD0,BGPD0) ;
 ;----- ADD OPTION TO OPTION SCHEDULING FILE
 ;
 N DD,DIC,DO,X,Y
 ;
 S BGPD0=$O(^DIC(19.2,"B",BGPOPTD0,0)) I BGPD0 Q
 S BGPD0=0
 S X=BGPOPTD0
 S DIC="^DIC(19.2,"
 S DIC(0)=""
 D FILE^DICN
 Q:+Y'>0
 S BGPD0=+Y
 Q
EDITOPT(BGPD0) ;
 ;----- EDIT OPTION SCHEDULING OPTION
 ;
 N %DT,%L,%X,%Y,BGPDT,BGPF,DIFROM,D,D0,DA,DI,DIC,DIE,DIE,DQ,DR,X,Y
 ;
 S BGPF="1M"
 S DA=BGPD0
 S DIE="^DIC(19.2,"
 S DR="2///^S X=BGPX;6///^S X=BGPF"
 D ^DIE
 Q
CHKFQT() ;EP - check for queued task (BGP AUTO GPRA EXTRACT and BGPSITE variable within the task
 NEW X,Y,Z,Q
 S Y=$$FMTH^XLFDT(DT)
 S Q=""  ;not found
 S X=0
 F  S X=$O(^%ZTSK(X)) Q:X'=+X  D
 .Q:$P($G(^%ZTSK(X,0)),U,1,2)'="AUTO^BGP4AUUP"
 .Q:$P($G(^%ZTSK(X,.03)),U,1)'="BGP4 AUTO GPRA AREA AGGREGATE"  ;"BGP 14 AUTO GPRA EXTRACT"  ;not the gpra export
 .Q:$P($G(^%ZTSK(X,0)),U,6)<Y
 .S Q=X  ;found it scheduled
 Q Q
DEL ;EP
 K DIR
 S DIR(0)="Y",DIR("A")="Do you wish to Un-Schedule the task",DIR("B")="N" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) W !!,"Task still scheduled." Q
 I 'Y W !!,"Task still scheduled." Q
 D DELTASK^BGP4AUEX
 W !!,"Task Un-Scheduled.",!
 Q
