BGP3ULF ; IHS/CMI/LAB - NO DESCRIPTION PROVIDED 27 May 2013 4:26 PM ; 09 Apr 2013  3:29 PM
 ;;13.0;IHS CLINICAL REPORTING;;NOV 20, 2012;Build 81
 ;
 ;
 W:$D(IOF) @IOF
 W !,"This option is used to upload a SU's 2013 CRS data.",!,"You must specify the directory in which the CRS 2013 data file resides",!,"and then enter the filename of the data.",!
FILE ;
 D HOME^%ZIS
DIR ;
 K DIR
 S BGPDIR=""
 S DIR(0)="FO^3:50",DIR("A")="Enter directory path (i.e. /usr/spool/uucppublic/)" K DA D ^DIR K DIR
 I $D(DIRUT) W !!,"Directory not entered!!  Bye." G EOJ
 I Y="" W !!,"Directory not entered!! Bye." G EOJ
 S BGPDIR=Y
FILENAME ;
 W !!
 S BGPFILE=""
 S DIR(0)="FO^2:30",DIR("A")="Enter filename w /ext (i.e. BG130101201.5)" K DA D ^DIR K DIR
 G:$D(DIRUT) DIR
 I Y="" G DIR
 I $E($$UP^XLFSTR(Y),1,5)'="BG130" W !!,"Filename must begin with BG130" G FILENAME
 S BGPFILE=Y
 W !,"Directory=",BGPDIR,"  ","File=",BGPFILE
 D READF
 G FILENAME
READF ;EP read file
 NEW Y,X,I,BGPC
 S BGPC=1
 S Y=$$OPEN^%ZISH(BGPDIR,BGPFILE,"R")
 I Y W !,*7,"CANNOT OPEN (OR ACCESS) FILE '",BGPDIR,BGPFILE,"'." G EOJ
 KILL ^TMP("BGPUPL",$J)
 F I=1:1 U IO R X:DTIME S X=$$STRIP(X) Q:X=""  S ^TMP("BGPUPL",$J,BGPC,0)=X,BGPC=BGPC+1 Q:$$STATUS^%ZISH=-1
 D ^%ZISC
 W !!,"All done reading file",!
PROC ;
 I $P(BGPFILE,".",2)["EL" D PROCEL Q
 I $P(BGPFILE,".",2)["PED" D PROCPED Q
 W !,"Processing",!
 S BGP0=$P($G(^TMP("BGPUPL",$J,1,0)),"|",9)
 S BGPG=$P($G(^TMP("BGPUPL",$J,1,0)),"|")
 F X=1:1:14 S Y="BGP"_X,@Y=$P(BGP0,U,X)
 ;find existing entry and if exists, delete it
 S (X,BGPOIEN)=0 F  S X=$O(^BGPGPDCH(X)) Q:X'=+X  D
 .I '$D(^BGPGPDCH(X,0)) K ^BGPGPDCH(X) Q
 .S Y=^BGPGPDCH(X,0)
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
 I BGPOIEN S DA=BGPOIEN,DIK="^BGPGPDCH(" D ^DIK S DA=BGPOIEN,DIK="^BGPGPDPH(" D ^DIK S DA=BGPOIEN,DIK="^BGPGPDBH(" D ^DIK
 ;add entry
 L +^BGPGPDCH:10 I '$T W !!,"unable to lock global. TRY LATER" D EOJ Q
 L +^BGPGPDPH:10 I '$T W !!,"unable to lock global. TRY LATER" D EOJ Q
 L +^BGPGPDBH:10 I '$T W !!,"unable to lock global. TRY LATER" D EOJ Q
 D GETIEN^BGP3UTL
 I 'BGPIEN W !!,"error in file creation...call programmer." D EOJ Q
CY ;
 S DINUM=BGPIEN,X=$P(BGP0,U),DLAYGO=90550.03,DIC="^BGPGPDCH(",DIC(0)="L"
 K DD,D0,DO
 D FILE^DICN
 I Y=-1 W !,"error uploading file......" H 4 G EOJ
 S BGPIEN=+Y
 D ^XBFMK
 S X=0 F  S X=$O(^TMP("BGPUPL",$J,X)) Q:X'=+X  S V=^TMP("BGPUPL",$J,X,0) D
 .Q:$P(V,"|")'="BGPGPDCH"
 .S V=$P(V,"|",2,9999)
 .S N=$P(V,"|"),N2=$P(V,"|",2),N3=$P(V,"|",3),N4=$P(V,"|",4),N5=$P(V,"|",5),D=$P(V,"|",8)
 .I N5]"" S ^BGPGPDCH(BGPIEN,N,N2,N3,N4,N5)=D Q
 .I N4]"" S ^BGPGPDCH(BGPIEN,N,N2,N3,N4)=D Q
 .I N3]"" S ^BGPGPDCH(BGPIEN,N,N2,N3)=D Q
 .I N2]"" S ^BGPGPDCH(BGPIEN,N,N2)=D Q
 .I N]"" S ^BGPGPDCH(BGPIEN,N)=D
 .Q
 S DA=BGPIEN,DIK="^BGPGPDCH(" D IX1^DIK
PY ;
 S DINUM=BGPIEN,X=$P(BGP0,U),DLAYGO=90550.04,DIC="^BGPGPDPH(",DIC(0)="L"
 K DD,D0,DO
 D FILE^DICN
 I Y=-1 W !,"error uploading file......" H 4 G EOJ
 S BGPIEN=+Y
 D ^XBFMK
 S X=0 F  S X=$O(^TMP("BGPUPL",$J,X)) Q:X'=+X  S V=^TMP("BGPUPL",$J,X,0) D
 .Q:$P(V,"|")'="BGPGPDPH"
 .S V=$P(V,"|",2,9999)
 .S N=$P(V,"|"),N2=$P(V,"|",2),N3=$P(V,"|",3),N4=$P(V,"|",4),N5=$P(V,"|",5),D=$P(V,"|",8)
 .I N5]"" S ^BGPGPDPH(BGPIEN,N,N2,N3,N4,N5)=D Q
 .I N4]"" S ^BGPGPDPH(BGPIEN,N,N2,N3,N4)=D Q
 .I N3]"" S ^BGPGPDPH(BGPIEN,N,N2,N3)=D Q
 .I N2]"" S ^BGPGPDPH(BGPIEN,N,N2)=D Q
 .I N]"" S ^BGPGPDPH(BGPIEN,N)=D
 .Q
 S DA=BGPIEN,DIK="^BGPGPDPH(" D IX1^DIK
BY ;
 S DINUM=BGPIEN,X=$P(BGP0,U),DLAYGO=90550.05,DIC="^BGPGPDBH(",DIC(0)="L"
 K DD,D0,DO
 D FILE^DICN
 I Y=-1 W !,"error uploading file......" H 4 G EOJ
 S BGPIEN=+Y
 D ^XBFMK
 S X=0 F  S X=$O(^TMP("BGPUPL",$J,X)) Q:X'=+X  S V=^TMP("BGPUPL",$J,X,0) D
 .Q:$P(V,"|")'="BGPGPDBH"
 .S V=$P(V,"|",2,9999)
 .S N=$P(V,"|"),N2=$P(V,"|",2),N3=$P(V,"|",3),N4=$P(V,"|",4),N5=$P(V,"|",5),D=$P(V,"|",8)
 .I N5]"" S ^BGPGPDBH(BGPIEN,N,N2,N3,N4,N5)=D Q
 .I N4]"" S ^BGPGPDBH(BGPIEN,N,N2,N3,N4)=D Q
 .I N3]"" S ^BGPGPDBH(BGPIEN,N,N2,N3)=D Q
 .I N2]"" S ^BGPGPDBH(BGPIEN,N,N2)=D Q
 .I N]"" S ^BGPGPDBH(BGPIEN,N)=D
 .Q
 S DA=BGPIEN,DIK="^BGPGPDBH(" D IX1^DIK
 W !,"Data uploaded."
 D EOJ
 Q
EOJ ;EP
 L -^BGPGPDCH
 L -^BGPGPDPH
 L -^BGPGPDBH
 L -^BGPELDCH
 L -^BGPELDPH
 L -^BGPELDBH
 L -^BGPPEDCH
 L -^BGPPEDPH
 L -^BGPPEDBH
 D EOP^BGP3DH
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
 ;
PROCEL ;
 W !,"Processing",!
 S BGP0=$P($G(^TMP("BGPUPL",$J,1,0)),"|",9)
 S BGPG=$P($G(^TMP("BGPUPL",$J,1,0)),"|")
 F X=1:1:14 S Y="BGP"_X,@Y=$P(BGP0,U,X)
 ;find existing entry and if exists, delete it
 S (X,BGPOIEN)=0 F  S X=$O(^BGPELDCH(X)) Q:X'=+X  D
 .I '$D(^BGPELDCH(X,0)) K ^BGPELDCH(X) Q
 .S Y=^BGPELDCH(X,0)
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
 I BGPOIEN S DA=BGPOIEN,DIK="^BGPELDCH(" D ^DIK S DA=BGPOIEN,DIK="^BGPELDPH(" D ^DIK S DA=BGPOIEN,DIK="^BGPELDBH(" D ^DIK
 ;add entry
 L +^BGPELDCH:10 I '$T W !!,"unable to lock global. TRY LATER" D EOJ Q
 L +^BGPELDPH:10 I '$T W !!,"unable to lock global. TRY LATER" D EOJ Q
 L +^BGPELDBH:10 I '$T W !!,"unable to lock global. TRY LATER" D EOJ Q
 D GETIEN^BGP3EUTL
 I 'BGPIEN W !!,"error in file creation...call programmer." D EOJ Q
ELCY ;
 S DINUM=BGPIEN,X=$P(BGP0,U),DLAYGO=90551.03,DIC="^BGPELDCH(",DIC(0)="L"
 K DD,D0,DO
 D FILE^DICN
 I Y=-1 W !,"error uploading file......" H 4 G EOJ
 S BGPIEN=+Y
 D ^XBFMK
 S X=0 F  S X=$O(^TMP("BGPUPL",$J,X)) Q:X'=+X  S V=^TMP("BGPUPL",$J,X,0) D
 .Q:$P(V,"|")'="BGPELDCH"
 .S V=$P(V,"|",2,9999)
 .S N=$P(V,"|"),N2=$P(V,"|",2),N3=$P(V,"|",3),N4=$P(V,"|",4),N5=$P(V,"|",5),D=$P(V,"|",8)
 .I N5]"" S ^BGPELDCH(BGPIEN,N,N2,N3,N4,N5)=D Q
 .I N4]"" S ^BGPELDCH(BGPIEN,N,N2,N3,N4)=D Q
 .I N3]"" S ^BGPELDCH(BGPIEN,N,N2,N3)=D Q
 .I N2]"" S ^BGPELDCH(BGPIEN,N,N2)=D Q
 .I N]"" S ^BGPELDCH(BGPIEN,N)=D
 .Q
 S DA=BGPIEN,DIK="^BGPELDCH(" D IX1^DIK
ELPY ;
 S DINUM=BGPIEN,X=$P(BGP0,U),DLAYGO=90551.04,DIC="^BGPELDPH(",DIC(0)="L"
 K DD,D0,DO
 D FILE^DICN
 I Y=-1 W !,"error uploading file......" H 4 G EOJ
 S BGPIEN=+Y
 D ^XBFMK
 S X=0 F  S X=$O(^TMP("BGPUPL",$J,X)) Q:X'=+X  S V=^TMP("BGPUPL",$J,X,0) D
 .Q:$P(V,"|")'="BGPELDPH"
 .S V=$P(V,"|",2,9999)
 .S N=$P(V,"|"),N2=$P(V,"|",2),N3=$P(V,"|",3),N4=$P(V,"|",4),N5=$P(V,"|",5),D=$P(V,"|",8)
 .I N5]"" S ^BGPELDPH(BGPIEN,N,N2,N3,N4,N5)=D Q
 .I N4]"" S ^BGPELDPH(BGPIEN,N,N2,N3,N4)=D Q
 .I N3]"" S ^BGPELDPH(BGPIEN,N,N2,N3)=D Q
 .I N2]"" S ^BGPELDPH(BGPIEN,N,N2)=D Q
 .I N]"" S ^BGPELDPH(BGPIEN,N)=D
 .Q
 S DA=BGPIEN,DIK="^BGPELDPH(" D IX1^DIK
ELBY ;
 S DINUM=BGPIEN,X=$P(BGP0,U),DLAYGO=90551.05,DIC="^BGPELDBH(",DIC(0)="L"
 K DD,D0,DO
 D FILE^DICN
 I Y=-1 W !,"error uploading file......" H 4 G EOJ
 S BGPIEN=+Y
 D ^XBFMK
 S X=0 F  S X=$O(^TMP("BGPUPL",$J,X)) Q:X'=+X  S V=^TMP("BGPUPL",$J,X,0) D
 .Q:$P(V,"|")'="BGPELDBH"
 .S V=$P(V,"|",2,9999)
 .S N=$P(V,"|"),N2=$P(V,"|",2),N3=$P(V,"|",3),N4=$P(V,"|",4),N5=$P(V,"|",5),D=$P(V,"|",8)
 .I N5]"" S ^BGPELDBH(BGPIEN,N,N2,N3,N4,N5)=D Q
 .I N4]"" S ^BGPELDBH(BGPIEN,N,N2,N3,N4)=D Q
 .I N3]"" S ^BGPELDBH(BGPIEN,N,N2,N3)=D Q
 .I N2]"" S ^BGPELDBH(BGPIEN,N,N2)=D Q
 .I N]"" S ^BGPELDBH(BGPIEN,N)=D
 .Q
 S DA=BGPIEN,DIK="^BGPELDBH(" D IX1^DIK
 W !,"Data uploaded."
 D EOJ
 Q
 ;
PROCPED ;
 W !,"Processing",!
 S BGP0=$P($G(^TMP("BGPUPL",$J,1,0)),"|",9)
 S BGPG=$P($G(^TMP("BGPUPL",$J,1,0)),"|")
 F X=1:1:14 S Y="BGP"_X,@Y=$P(BGP0,U,X)
 ;find existing entry and if exists, delete it
 S (X,BGPOIEN)=0 F  S X=$O(^BGPPEDCH(X)) Q:X'=+X  D
 .I '$D(^BGPPEDCH(X,0)) K ^BGPPEDCH(X) Q
 .S Y=^BGPPEDCH(X,0)
 .Q:$P(Y,U)'=BGP1
 .Q:$P(Y,U,2)'=BGP2
 .Q:$P(Y,U,3)'=BGP3
 .Q:$P(Y,U,4)'=BGP4
 .Q:$P(Y,U,5)'=BGP5
 .Q:$P(Y,U,6)'=BGP6
 .Q:$P(Y,U,7)'=BGP7
 .Q:$P(Y,U,8)'=BGP8
 .Q:$P(Y,U,9)'=BGP9
 .Q:$P(Y,U,10)'=BGP10
 .Q:$P(Y,U,11)'=BGP11
 .Q:$P(Y,U,12)'=BGP12
 .S BGPOIEN=X
 D ^XBFMK
 I BGPOIEN S DA=BGPOIEN,DIK="^BGPPEDCH(" D ^DIK S DA=BGPOIEN,DIK="^BGPPEDPH(" D ^DIK S DA=BGPOIEN,DIK="^BGPPEDBH(" D ^DIK
 ;add entry
 L +^BGPPEDCH:10 I '$T W !!,"unable to lock global. TRY LATER" D EOJ Q
 L +^BGPPEDPH:10 I '$T W !!,"unable to lock global. TRY LATER" D EOJ Q
 L +^BGPPEDBH:10 I '$T W !!,"unable to lock global. TRY LATER" D EOJ Q
 D GETIEN^BGP3PUTL
 I 'BGPIEN W !!,"error in file creation...call programmer." D EOJ Q
PEDCY ;
 S DINUM=BGPIEN,X=$P(BGP0,U),DLAYGO=90550.12,DIC="^BGPPEDCH(",DIC(0)="L"
 K DD,D0,DO
 D FILE^DICN
 I Y=-1 W !,"error uploading file......" H 4 G EOJ
 S BGPIEN=+Y
 D ^XBFMK
 S X=0 F  S X=$O(^TMP("BGPUPL",$J,X)) Q:X'=+X  S V=^TMP("BGPUPL",$J,X,0) D
 .Q:$P(V,"|")'="BGPPEDCH"
 .S V=$P(V,"|",2,9999)
 .S N=$P(V,"|"),N2=$P(V,"|",2),N3=$P(V,"|",3),N4=$P(V,"|",4),N5=$P(V,"|",5),D=$P(V,"|",8)
 .I N5]"" S ^BGPPEDCH(BGPIEN,N,N2,N3,N4,N5)=D Q
 .I N4]"" S ^BGPPEDCH(BGPIEN,N,N2,N3,N4)=D Q
 .I N3]"" S ^BGPPEDCH(BGPIEN,N,N2,N3)=D Q
 .I N2]"" S ^BGPPEDCH(BGPIEN,N,N2)=D Q
 .I N]"" S ^BGPPEDCH(BGPIEN,N)=D
 .Q
 S DA=BGPIEN,DIK="^BGPPEDCH(" D IX1^DIK
PEDPY ;
 S DINUM=BGPIEN,X=$P(BGP0,U),DLAYGO=90550.13,DIC="^BGPPEDPH(",DIC(0)="L"
 K DD,D0,DO
 D FILE^DICN
 I Y=-1 W !,"error uploading file......" H 4 G EOJ
 S BGPIEN=+Y
 D ^XBFMK
 S X=0 F  S X=$O(^TMP("BGPUPL",$J,X)) Q:X'=+X  S V=^TMP("BGPUPL",$J,X,0) D
 .Q:$P(V,"|")'="BGPPEDPH"
 .S V=$P(V,"|",2,9999)
 .S N=$P(V,"|"),N2=$P(V,"|",2),N3=$P(V,"|",3),N4=$P(V,"|",4),N5=$P(V,"|",5),D=$P(V,"|",8)
 .I N5]"" S ^BGPPEDPH(BGPIEN,N,N2,N3,N4,N5)=D Q
 .I N4]"" S ^BGPPEDPH(BGPIEN,N,N2,N3,N4)=D Q
 .I N3]"" S ^BGPPEDPH(BGPIEN,N,N2,N3)=D Q
 .I N2]"" S ^BGPPEDPH(BGPIEN,N,N2)=D Q
 .I N]"" S ^BGPPEDPH(BGPIEN,N)=D
 .Q
 S DA=BGPIEN,DIK="^BGPPEDPH(" D IX1^DIK
PEDBY ;
 S DINUM=BGPIEN,X=$P(BGP0,U),DLAYGO=90550.14,DIC="^BGPPEDBH(",DIC(0)="L"
 K DD,D0,DO
 D FILE^DICN
 I Y=-1 W !,"error uploading file......" H 4 G EOJ
 S BGPIEN=+Y
 D ^XBFMK
 S X=0 F  S X=$O(^TMP("BGPUPL",$J,X)) Q:X'=+X  S V=^TMP("BGPUPL",$J,X,0) D
 .Q:$P(V,"|")'="BGPPEDBH"
 .S V=$P(V,"|",2,9999)
 .S N=$P(V,"|"),N2=$P(V,"|",2),N3=$P(V,"|",3),N4=$P(V,"|",4),N5=$P(V,"|",5),D=$P(V,"|",8)
 .I N5]"" S ^BGPPEDBH(BGPIEN,N,N2,N3,N4,N5)=D Q
 .I N4]"" S ^BGPPEDBH(BGPIEN,N,N2,N3,N4)=D Q
 .I N3]"" S ^BGPPEDBH(BGPIEN,N,N2,N3)=D Q
 .I N2]"" S ^BGPPEDBH(BGPIEN,N,N2)=D Q
 .I N]"" S ^BGPPEDBH(BGPIEN,N)=D
 .Q
 S DA=BGPIEN,DIK="^BGPPEDBH(" D IX1^DIK
 W !,"Data uploaded."
 D EOJ
 Q
