BGP2ULF ; IHS/CMI/LAB - NO DESCRIPTION PROVIDED 27 May 2012 4:26 PM ;
 ;;12.0;IHS CLINICAL REPORTING;;JAN 9, 2012;Build 51
 ;
 ;
 W:$D(IOF) @IOF
 W !,"This option is used to upload a SU's 2012 CRS data.",!,"You must specify the directory in which the CRS 2012 data file resides",!,"and then enter the filename of the data.",!
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
 S DIR(0)="FO^2:30",DIR("A")="Enter filename w /ext (i.e. BG12101201.5)" K DA D ^DIR K DIR
 G:$D(DIRUT) DIR
 I Y="" G DIR
 I $E($$UP^XLFSTR(Y),1,4)'="BG12" W !!,"Filename must begin with BG12" G FILENAME
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
 I $P(BGPFILE,".",2)["HE" D PROCHE Q
 I $P(BGPFILE,".",2)["EL" D PROCEL Q
 I $P(BGPFILE,".",2)["PED" D PROCPED Q
 I $P(BGPFILE,".",2)["EO" D PROCEO^BGP2ULF1 Q
 ;I $P(BGPFILE,".",2)["ON" D PROCON Q
 W !,"Processing",!
 S BGP0=$P($G(^TMP("BGPUPL",$J,1,0)),"|",9)
 S BGPG=$P($G(^TMP("BGPUPL",$J,1,0)),"|")
 F X=1:1:14 S Y="BGP"_X,@Y=$P(BGP0,U,X)
 ;find existing entry and if exists, delete it
 S (X,BGPOIEN)=0 F  S X=$O(^BGPGPDCW(X)) Q:X'=+X  D
 .I '$D(^BGPGPDCW(X,0)) K ^BGPGPDCW(X) Q
 .S Y=^BGPGPDCW(X,0)
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
 I BGPOIEN S DA=BGPOIEN,DIK="^BGPGPDCW(" D ^DIK S DA=BGPOIEN,DIK="^BGPGPDPW(" D ^DIK S DA=BGPOIEN,DIK="^BGPGPDBW(" D ^DIK
 ;add entry
 L +^BGPGPDCW:10 I '$T W !!,"unable to lock global. TRY LATER" D EOJ Q
 L +^BGPGPDPW:10 I '$T W !!,"unable to lock global. TRY LATER" D EOJ Q
 L +^BGPGPDBW:10 I '$T W !!,"unable to lock global. TRY LATER" D EOJ Q
 D GETIEN^BGP2UTL
 I 'BGPIEN W !!,"error in file creation...call programmer." D EOJ Q
CY ;
 S DINUM=BGPIEN,X=$P(BGP0,U),DLAYGO=90548.03,DIC="^BGPGPDCW(",DIC(0)="L"
 K DD,D0,DO
 D FILE^DICN
 I Y=-1 W !,"error uploading file......" H 4 G EOJ
 S BGPIEN=+Y
 D ^XBFMK
 S X=0 F  S X=$O(^TMP("BGPUPL",$J,X)) Q:X'=+X  S V=^TMP("BGPUPL",$J,X,0) D
 .Q:$P(V,"|")'="BGPGPDCW"
 .S V=$P(V,"|",2,9999)
 .S N=$P(V,"|"),N2=$P(V,"|",2),N3=$P(V,"|",3),N4=$P(V,"|",4),N5=$P(V,"|",5),D=$P(V,"|",8)
 .I N5]"" S ^BGPGPDCW(BGPIEN,N,N2,N3,N4,N5)=D Q
 .I N4]"" S ^BGPGPDCW(BGPIEN,N,N2,N3,N4)=D Q
 .I N3]"" S ^BGPGPDCW(BGPIEN,N,N2,N3)=D Q
 .I N2]"" S ^BGPGPDCW(BGPIEN,N,N2)=D Q
 .I N]"" S ^BGPGPDCW(BGPIEN,N)=D
 .Q
 S DA=BGPIEN,DIK="^BGPGPDCW(" D IX1^DIK
PY ;
 S DINUM=BGPIEN,X=$P(BGP0,U),DLAYGO=90548.04,DIC="^BGPGPDPW(",DIC(0)="L"
 K DD,D0,DO
 D FILE^DICN
 I Y=-1 W !,"error uploading file......" H 4 G EOJ
 S BGPIEN=+Y
 D ^XBFMK
 S X=0 F  S X=$O(^TMP("BGPUPL",$J,X)) Q:X'=+X  S V=^TMP("BGPUPL",$J,X,0) D
 .Q:$P(V,"|")'="BGPGPDPW"
 .S V=$P(V,"|",2,9999)
 .S N=$P(V,"|"),N2=$P(V,"|",2),N3=$P(V,"|",3),N4=$P(V,"|",4),N5=$P(V,"|",5),D=$P(V,"|",8)
 .I N5]"" S ^BGPGPDPW(BGPIEN,N,N2,N3,N4,N5)=D Q
 .I N4]"" S ^BGPGPDPW(BGPIEN,N,N2,N3,N4)=D Q
 .I N3]"" S ^BGPGPDPW(BGPIEN,N,N2,N3)=D Q
 .I N2]"" S ^BGPGPDPW(BGPIEN,N,N2)=D Q
 .I N]"" S ^BGPGPDPW(BGPIEN,N)=D
 .Q
 S DA=BGPIEN,DIK="^BGPGPDPW(" D IX1^DIK
BY ;
 S DINUM=BGPIEN,X=$P(BGP0,U),DLAYGO=90548.05,DIC="^BGPGPDBW(",DIC(0)="L"
 K DD,D0,DO
 D FILE^DICN
 I Y=-1 W !,"error uploading file......" H 4 G EOJ
 S BGPIEN=+Y
 D ^XBFMK
 S X=0 F  S X=$O(^TMP("BGPUPL",$J,X)) Q:X'=+X  S V=^TMP("BGPUPL",$J,X,0) D
 .Q:$P(V,"|")'="BGPGPDBW"
 .S V=$P(V,"|",2,9999)
 .S N=$P(V,"|"),N2=$P(V,"|",2),N3=$P(V,"|",3),N4=$P(V,"|",4),N5=$P(V,"|",5),D=$P(V,"|",8)
 .I N5]"" S ^BGPGPDBW(BGPIEN,N,N2,N3,N4,N5)=D Q
 .I N4]"" S ^BGPGPDBW(BGPIEN,N,N2,N3,N4)=D Q
 .I N3]"" S ^BGPGPDBW(BGPIEN,N,N2,N3)=D Q
 .I N2]"" S ^BGPGPDBW(BGPIEN,N,N2)=D Q
 .I N]"" S ^BGPGPDBW(BGPIEN,N)=D
 .Q
 S DA=BGPIEN,DIK="^BGPGPDBW(" D IX1^DIK
 W !,"Data uploaded."
 D EOJ
 Q
EOJ ;EP
 L -^BGPGPDCW
 L -^BGPGPDPW
 L -^BGPGPDBW
 L -^BGPHEDCB
 L -^BGPHEDPB
 L -^BGPHEDBB
 L -^BGPELDCW
 L -^BGPELDPW
 L -^BGPELDBW
 L -^BGPPEDCW
 L -^BGPPEDPW
 L -^BGPPEDBW
 L -^BGPEOCB
 L -^BGPEOPB
 L -^BGPEOBB
 D EOP^BGP2DH
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
PROCHE ;
 W !,"Processing",!
 S BGP0=$P($G(^TMP("BGPUPL",$J,1,0)),"|",9)
 S BGPG=$P($G(^TMP("BGPUPL",$J,1,0)),"|")
 F X=1:1:14 S Y="BGP"_X,@Y=$P(BGP0,U,X)
 ;find existing entry and if exists, delete it
 S (X,BGPOIEN)=0 F  S X=$O(^BGPHEDCB(X)) Q:X'=+X  D
 .I '$D(^BGPHEDCB(X,0)) K ^BGPHEDCB(X) Q
 .S Y=^BGPHEDCB(X,0)
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
 I BGPOIEN S DA=BGPOIEN,DIK="^BGPHEDCB(" D ^DIK S DA=BGPOIEN,DIK="^BGPHEDPB(" D ^DIK S DA=BGPOIEN,DIK="^BGPHEDBB(" D ^DIK
 ;add entry
 L +^BGPHEDCB:10 I '$T W !!,"unable to lock global. TRY LATER" D EOJ Q
 L +^BGPHEDPB:10 I '$T W !!,"unable to lock global. TRY LATER" D EOJ Q
 L +^BGPHEDBB:10 I '$T W !!,"unable to lock global. TRY LATER" D EOJ Q
 D GETIEN^BGP2HUTL
 I 'BGPIEN W !!,"error in file creation...call programmer." D EOJ Q
HECY ;
 S DINUM=BGPIEN,X=$P(BGP0,U),DLAYGO=90546.03,DIC="^BGPHEDCB(",DIC(0)="L"
 K DD,D0,DO
 D FILE^DICN
 I Y=-1 W !,"error uploading file......" H 4 G EOJ
 S BGPIEN=+Y
 D ^XBFMK
 S X=0 F  S X=$O(^TMP("BGPUPL",$J,X)) Q:X'=+X  S V=^TMP("BGPUPL",$J,X,0) D
 .Q:$P(V,"|")'="BGPHEDCB"
 .S V=$P(V,"|",2,9999)
 .S N=$P(V,"|"),N2=$P(V,"|",2),N3=$P(V,"|",3),N4=$P(V,"|",4),N5=$P(V,"|",5),D=$P(V,"|",8)
 .I N5]"" S ^BGPHEDCB(BGPIEN,N,N2,N3,N4,N5)=D Q
 .I N4]"" S ^BGPHEDCB(BGPIEN,N,N2,N3,N4)=D Q
 .I N3]"" S ^BGPHEDCB(BGPIEN,N,N2,N3)=D Q
 .I N2]"" S ^BGPHEDCB(BGPIEN,N,N2)=D Q
 .I N]"" S ^BGPHEDCB(BGPIEN,N)=D
 .Q
 S DA=BGPIEN,DIK="^BGPHEDCB(" D IX1^DIK
HEPY ;
 S DINUM=BGPIEN,X=$P(BGP0,U),DLAYGO=90546.04,DIC="^BGPHEDPB(",DIC(0)="L"
 K DD,D0,DO
 D FILE^DICN
 I Y=-1 W !,"error uploading file......" H 4 G EOJ
 S BGPIEN=+Y
 D ^XBFMK
 S X=0 F  S X=$O(^TMP("BGPUPL",$J,X)) Q:X'=+X  S V=^TMP("BGPUPL",$J,X,0) D
 .Q:$P(V,"|")'="BGPHEDPB"
 .S V=$P(V,"|",2,9999)
 .S N=$P(V,"|"),N2=$P(V,"|",2),N3=$P(V,"|",3),N4=$P(V,"|",4),N5=$P(V,"|",5),D=$P(V,"|",8)
 .I N5]"" S ^BGPHEDPB(BGPIEN,N,N2,N3,N4,N5)=D Q
 .I N4]"" S ^BGPHEDPB(BGPIEN,N,N2,N3,N4)=D Q
 .I N3]"" S ^BGPHEDPB(BGPIEN,N,N2,N3)=D Q
 .I N2]"" S ^BGPHEDPB(BGPIEN,N,N2)=D Q
 .I N]"" S ^BGPHEDPB(BGPIEN,N)=D
 .Q
 S DA=BGPIEN,DIK="^BGPHEDPB(" D IX1^DIK
HEBY ;
 S DINUM=BGPIEN,X=$P(BGP0,U),DLAYGO=90546.05,DIC="^BGPHEDBB(",DIC(0)="L"
 K DD,D0,DO
 D FILE^DICN
 I Y=-1 W !,"error uploading file......" H 4 G EOJ
 S BGPIEN=+Y
 D ^XBFMK
 S X=0 F  S X=$O(^TMP("BGPUPL",$J,X)) Q:X'=+X  S V=^TMP("BGPUPL",$J,X,0) D
 .Q:$P(V,"|")'="BGPHEDBB"
 .S V=$P(V,"|",2,9999)
 .S N=$P(V,"|"),N2=$P(V,"|",2),N3=$P(V,"|",3),N4=$P(V,"|",4),N5=$P(V,"|",5),D=$P(V,"|",8)
 .I N5]"" S ^BGPHEDBB(BGPIEN,N,N2,N3,N4,N5)=D Q
 .I N4]"" S ^BGPHEDBB(BGPIEN,N,N2,N3,N4)=D Q
 .I N3]"" S ^BGPHEDBB(BGPIEN,N,N2,N3)=D Q
 .I N2]"" S ^BGPHEDBB(BGPIEN,N,N2)=D Q
 .I N]"" S ^BGPHEDBB(BGPIEN,N)=D
 .Q
 S DA=BGPIEN,DIK="^BGPHEDBB(" D IX1^DIK
 W !,"Data uploaded."
 D EOJ
 Q
 ;
PROCEL ;
 W !,"Processing",!
 S BGP0=$P($G(^TMP("BGPUPL",$J,1,0)),"|",9)
 S BGPG=$P($G(^TMP("BGPUPL",$J,1,0)),"|")
 F X=1:1:14 S Y="BGP"_X,@Y=$P(BGP0,U,X)
 ;find existing entry and if exists, delete it
 S (X,BGPOIEN)=0 F  S X=$O(^BGPELDCW(X)) Q:X'=+X  D
 .I '$D(^BGPELDCW(X,0)) K ^BGPELDCW(X) Q
 .S Y=^BGPELDCW(X,0)
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
 I BGPOIEN S DA=BGPOIEN,DIK="^BGPELDCW(" D ^DIK S DA=BGPOIEN,DIK="^BGPELDPW(" D ^DIK S DA=BGPOIEN,DIK="^BGPELDBW(" D ^DIK
 ;add entry
 L +^BGPELDCW:10 I '$T W !!,"unable to lock global. TRY LATER" D EOJ Q
 L +^BGPELDPW:10 I '$T W !!,"unable to lock global. TRY LATER" D EOJ Q
 L +^BGPELDBW:10 I '$T W !!,"unable to lock global. TRY LATER" D EOJ Q
 D GETIEN^BGP2EUTL
 I 'BGPIEN W !!,"error in file creation...call programmer." D EOJ Q
ELCY ;
 S DINUM=BGPIEN,X=$P(BGP0,U),DLAYGO=90546.03,DIC="^BGPELDCW(",DIC(0)="L"
 K DD,D0,DO
 D FILE^DICN
 I Y=-1 W !,"error uploading file......" H 4 G EOJ
 S BGPIEN=+Y
 D ^XBFMK
 S X=0 F  S X=$O(^TMP("BGPUPL",$J,X)) Q:X'=+X  S V=^TMP("BGPUPL",$J,X,0) D
 .Q:$P(V,"|")'="BGPELDCW"
 .S V=$P(V,"|",2,9999)
 .S N=$P(V,"|"),N2=$P(V,"|",2),N3=$P(V,"|",3),N4=$P(V,"|",4),N5=$P(V,"|",5),D=$P(V,"|",8)
 .I N5]"" S ^BGPELDCW(BGPIEN,N,N2,N3,N4,N5)=D Q
 .I N4]"" S ^BGPELDCW(BGPIEN,N,N2,N3,N4)=D Q
 .I N3]"" S ^BGPELDCW(BGPIEN,N,N2,N3)=D Q
 .I N2]"" S ^BGPELDCW(BGPIEN,N,N2)=D Q
 .I N]"" S ^BGPELDCW(BGPIEN,N)=D
 .Q
 S DA=BGPIEN,DIK="^BGPELDCW(" D IX1^DIK
ELPY ;
 S DINUM=BGPIEN,X=$P(BGP0,U),DLAYGO=90546.04,DIC="^BGPELDPW(",DIC(0)="L"
 K DD,D0,DO
 D FILE^DICN
 I Y=-1 W !,"error uploading file......" H 4 G EOJ
 S BGPIEN=+Y
 D ^XBFMK
 S X=0 F  S X=$O(^TMP("BGPUPL",$J,X)) Q:X'=+X  S V=^TMP("BGPUPL",$J,X,0) D
 .Q:$P(V,"|")'="BGPELDPW"
 .S V=$P(V,"|",2,9999)
 .S N=$P(V,"|"),N2=$P(V,"|",2),N3=$P(V,"|",3),N4=$P(V,"|",4),N5=$P(V,"|",5),D=$P(V,"|",8)
 .I N5]"" S ^BGPELDPW(BGPIEN,N,N2,N3,N4,N5)=D Q
 .I N4]"" S ^BGPELDPW(BGPIEN,N,N2,N3,N4)=D Q
 .I N3]"" S ^BGPELDPW(BGPIEN,N,N2,N3)=D Q
 .I N2]"" S ^BGPELDPW(BGPIEN,N,N2)=D Q
 .I N]"" S ^BGPELDPW(BGPIEN,N)=D
 .Q
 S DA=BGPIEN,DIK="^BGPELDPW(" D IX1^DIK
ELBY ;
 S DINUM=BGPIEN,X=$P(BGP0,U),DLAYGO=90546.05,DIC="^BGPELDBW(",DIC(0)="L"
 K DD,D0,DO
 D FILE^DICN
 I Y=-1 W !,"error uploading file......" H 4 G EOJ
 S BGPIEN=+Y
 D ^XBFMK
 S X=0 F  S X=$O(^TMP("BGPUPL",$J,X)) Q:X'=+X  S V=^TMP("BGPUPL",$J,X,0) D
 .Q:$P(V,"|")'="BGPELDBW"
 .S V=$P(V,"|",2,9999)
 .S N=$P(V,"|"),N2=$P(V,"|",2),N3=$P(V,"|",3),N4=$P(V,"|",4),N5=$P(V,"|",5),D=$P(V,"|",8)
 .I N5]"" S ^BGPELDBW(BGPIEN,N,N2,N3,N4,N5)=D Q
 .I N4]"" S ^BGPELDBW(BGPIEN,N,N2,N3,N4)=D Q
 .I N3]"" S ^BGPELDBW(BGPIEN,N,N2,N3)=D Q
 .I N2]"" S ^BGPELDBW(BGPIEN,N,N2)=D Q
 .I N]"" S ^BGPELDBW(BGPIEN,N)=D
 .Q
 S DA=BGPIEN,DIK="^BGPELDBW(" D IX1^DIK
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
 S (X,BGPOIEN)=0 F  S X=$O(^BGPPEDCW(X)) Q:X'=+X  D
 .I '$D(^BGPPEDCW(X,0)) K ^BGPPEDCW(X) Q
 .S Y=^BGPPEDCW(X,0)
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
 I BGPOIEN S DA=BGPOIEN,DIK="^BGPPEDCW(" D ^DIK S DA=BGPOIEN,DIK="^BGPPEDPW(" D ^DIK S DA=BGPOIEN,DIK="^BGPPEDBW(" D ^DIK
 ;add entry
 L +^BGPPEDCW:10 I '$T W !!,"unable to lock global. TRY LATER" D EOJ Q
 L +^BGPPEDPW:10 I '$T W !!,"unable to lock global. TRY LATER" D EOJ Q
 L +^BGPPEDBW:10 I '$T W !!,"unable to lock global. TRY LATER" D EOJ Q
 D GETIEN^BGP2PUTL
 I 'BGPIEN W !!,"error in file creation...call programmer." D EOJ Q
PEDCY ;
 S DINUM=BGPIEN,X=$P(BGP0,U),DLAYGO=90548.12,DIC="^BGPPEDCW(",DIC(0)="L"
 K DD,D0,DO
 D FILE^DICN
 I Y=-1 W !,"error uploading file......" H 4 G EOJ
 S BGPIEN=+Y
 D ^XBFMK
 S X=0 F  S X=$O(^TMP("BGPUPL",$J,X)) Q:X'=+X  S V=^TMP("BGPUPL",$J,X,0) D
 .Q:$P(V,"|")'="BGPPEDCW"
 .S V=$P(V,"|",2,9999)
 .S N=$P(V,"|"),N2=$P(V,"|",2),N3=$P(V,"|",3),N4=$P(V,"|",4),N5=$P(V,"|",5),D=$P(V,"|",8)
 .I N5]"" S ^BGPPEDCW(BGPIEN,N,N2,N3,N4,N5)=D Q
 .I N4]"" S ^BGPPEDCW(BGPIEN,N,N2,N3,N4)=D Q
 .I N3]"" S ^BGPPEDCW(BGPIEN,N,N2,N3)=D Q
 .I N2]"" S ^BGPPEDCW(BGPIEN,N,N2)=D Q
 .I N]"" S ^BGPPEDCW(BGPIEN,N)=D
 .Q
 S DA=BGPIEN,DIK="^BGPPEDCW(" D IX1^DIK
PEDPY ;
 S DINUM=BGPIEN,X=$P(BGP0,U),DLAYGO=90548.13,DIC="^BGPPEDPW(",DIC(0)="L"
 K DD,D0,DO
 D FILE^DICN
 I Y=-1 W !,"error uploading file......" H 4 G EOJ
 S BGPIEN=+Y
 D ^XBFMK
 S X=0 F  S X=$O(^TMP("BGPUPL",$J,X)) Q:X'=+X  S V=^TMP("BGPUPL",$J,X,0) D
 .Q:$P(V,"|")'="BGPPEDPW"
 .S V=$P(V,"|",2,9999)
 .S N=$P(V,"|"),N2=$P(V,"|",2),N3=$P(V,"|",3),N4=$P(V,"|",4),N5=$P(V,"|",5),D=$P(V,"|",8)
 .I N5]"" S ^BGPPEDPW(BGPIEN,N,N2,N3,N4,N5)=D Q
 .I N4]"" S ^BGPPEDPW(BGPIEN,N,N2,N3,N4)=D Q
 .I N3]"" S ^BGPPEDPW(BGPIEN,N,N2,N3)=D Q
 .I N2]"" S ^BGPPEDPW(BGPIEN,N,N2)=D Q
 .I N]"" S ^BGPPEDPW(BGPIEN,N)=D
 .Q
 S DA=BGPIEN,DIK="^BGPPEDPW(" D IX1^DIK
PEDBY ;
 S DINUM=BGPIEN,X=$P(BGP0,U),DLAYGO=90548.14,DIC="^BGPPEDBW(",DIC(0)="L"
 K DD,D0,DO
 D FILE^DICN
 I Y=-1 W !,"error uploading file......" H 4 G EOJ
 S BGPIEN=+Y
 D ^XBFMK
 S X=0 F  S X=$O(^TMP("BGPUPL",$J,X)) Q:X'=+X  S V=^TMP("BGPUPL",$J,X,0) D
 .Q:$P(V,"|")'="BGPPEDBW"
 .S V=$P(V,"|",2,9999)
 .S N=$P(V,"|"),N2=$P(V,"|",2),N3=$P(V,"|",3),N4=$P(V,"|",4),N5=$P(V,"|",5),D=$P(V,"|",8)
 .I N5]"" S ^BGPPEDBW(BGPIEN,N,N2,N3,N4,N5)=D Q
 .I N4]"" S ^BGPPEDBW(BGPIEN,N,N2,N3,N4)=D Q
 .I N3]"" S ^BGPPEDBW(BGPIEN,N,N2,N3)=D Q
 .I N2]"" S ^BGPPEDBW(BGPIEN,N,N2)=D Q
 .I N]"" S ^BGPPEDBW(BGPIEN,N)=D
 .Q
 S DA=BGPIEN,DIK="^BGPPEDBW(" D IX1^DIK
 W !,"Data uploaded."
 D EOJ
 Q
