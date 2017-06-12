BGP5ULF ; IHS/CMI/LAB - NO DESCRIPTION PROVIDED 27 May 2015 4:26 PM ; 09 Apr 2015  3:29 PM
 ;;15.1;IHS CLINICAL REPORTING;;MAY 06, 2015;Build 143
 ;
 ;
 W:$D(IOF) @IOF
 W !,"This option is used to upload a SU's 2015 CRS data.",!,"You must specify the directory in which the CRS 2015 data file resides",!,"and then enter the filename of the data.",!
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
 S DIR(0)="FO^2:30",DIR("A")="Enter filename w /ext (i.e. BG151101201.5)" K DA D ^DIR K DIR
 G:$D(DIRUT) DIR
 I Y="" G DIR
 I $E($$UP^XLFSTR(Y),1,5)'="BG151" W !!,"Filename must begin with BG151" G FILENAME
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
 F X=1:1:14,21 S Y="BGP"_X,@Y=$P(BGP0,U,X)
 I BGP21="" S BGP21="15.1"
 ;find existing entry and if exists, delete it
 S (X,BGPOIEN)=0 F  S X=$O(^BGPGPDCK(X)) Q:X'=+X  D
 .I '$D(^BGPGPDCK(X,0)) K ^BGPGPDCK(X) Q
 .S Y=^BGPGPDCK(X,0)
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
 .Q:$P(Y,U,21)'=BGP21
 .S BGPOIEN=X
 D ^XBFMK
 I BGPOIEN S DA=BGPOIEN,DIK="^BGPGPDCK(" D ^DIK S DA=BGPOIEN,DIK="^BGPGPDPK(" D ^DIK S DA=BGPOIEN,DIK="^BGPGPDBK(" D ^DIK
 ;add entry
 L +^BGPGPDCK:10 I '$T W !!,"unable to lock global. TRY LATER" D EOJ Q
 L +^BGPGPDPK:10 I '$T W !!,"unable to lock global. TRY LATER" D EOJ Q
 L +^BGPGPDBK:10 I '$T W !!,"unable to lock global. TRY LATER" D EOJ Q
 D GETIEN^BGP5UTL
 I 'BGPIEN W !!,"error in file creation...call programmer." D EOJ Q
CY ;
 S DINUM=BGPIEN,X=$P(BGP0,U),DLAYGO=90554.03,DIC="^BGPGPDCK(",DIC(0)="L"
 K DD,D0,DO
 D FILE^DICN
 I Y=-1 W !,"error uploading file......" H 4 G EOJ
 S BGPIEN=+Y
 D ^XBFMK
 S X=0 F  S X=$O(^TMP("BGPUPL",$J,X)) Q:X'=+X  S V=^TMP("BGPUPL",$J,X,0) D
 .Q:$P(V,"|")'="BGPGPDCK"
 .S V=$P(V,"|",2,9999)
 .S N=$P(V,"|"),N2=$P(V,"|",2),N3=$P(V,"|",3),N4=$P(V,"|",4),N5=$P(V,"|",5),D=$P(V,"|",8)
 .I N5]"" S ^BGPGPDCK(BGPIEN,N,N2,N3,N4,N5)=D Q
 .I N4]"" S ^BGPGPDCK(BGPIEN,N,N2,N3,N4)=D Q
 .I N3]"" S ^BGPGPDCK(BGPIEN,N,N2,N3)=D Q
 .I N2]"" S ^BGPGPDCK(BGPIEN,N,N2)=D Q
 .I N]"" S ^BGPGPDCK(BGPIEN,N)=D
 .Q
 S DA=BGPIEN,DIK="^BGPGPDCK(" D IX1^DIK
PY ;
 S DINUM=BGPIEN,X=$P(BGP0,U),DLAYGO=90554.04,DIC="^BGPGPDPK(",DIC(0)="L"
 K DD,D0,DO
 D FILE^DICN
 I Y=-1 W !,"error uploading file......" H 4 G EOJ
 S BGPIEN=+Y
 D ^XBFMK
 S X=0 F  S X=$O(^TMP("BGPUPL",$J,X)) Q:X'=+X  S V=^TMP("BGPUPL",$J,X,0) D
 .Q:$P(V,"|")'="BGPGPDPK"
 .S V=$P(V,"|",2,9999)
 .S N=$P(V,"|"),N2=$P(V,"|",2),N3=$P(V,"|",3),N4=$P(V,"|",4),N5=$P(V,"|",5),D=$P(V,"|",8)
 .I N5]"" S ^BGPGPDPK(BGPIEN,N,N2,N3,N4,N5)=D Q
 .I N4]"" S ^BGPGPDPK(BGPIEN,N,N2,N3,N4)=D Q
 .I N3]"" S ^BGPGPDPK(BGPIEN,N,N2,N3)=D Q
 .I N2]"" S ^BGPGPDPK(BGPIEN,N,N2)=D Q
 .I N]"" S ^BGPGPDPK(BGPIEN,N)=D
 .Q
 S DA=BGPIEN,DIK="^BGPGPDPK(" D IX1^DIK
BY ;
 S DINUM=BGPIEN,X=$P(BGP0,U),DLAYGO=90554.05,DIC="^BGPGPDBK(",DIC(0)="L"
 K DD,D0,DO
 D FILE^DICN
 I Y=-1 W !,"error uploading file......" H 4 G EOJ
 S BGPIEN=+Y
 D ^XBFMK
 S X=0 F  S X=$O(^TMP("BGPUPL",$J,X)) Q:X'=+X  S V=^TMP("BGPUPL",$J,X,0) D
 .Q:$P(V,"|")'="BGPGPDBK"
 .S V=$P(V,"|",2,9999)
 .S N=$P(V,"|"),N2=$P(V,"|",2),N3=$P(V,"|",3),N4=$P(V,"|",4),N5=$P(V,"|",5),D=$P(V,"|",8)
 .I N5]"" S ^BGPGPDBK(BGPIEN,N,N2,N3,N4,N5)=D Q
 .I N4]"" S ^BGPGPDBK(BGPIEN,N,N2,N3,N4)=D Q
 .I N3]"" S ^BGPGPDBK(BGPIEN,N,N2,N3)=D Q
 .I N2]"" S ^BGPGPDBK(BGPIEN,N,N2)=D Q
 .I N]"" S ^BGPGPDBK(BGPIEN,N)=D
 .Q
 S DA=BGPIEN,DIK="^BGPGPDBK(" D IX1^DIK
 W !,"Data uploaded."
 D EOJ
 Q
EOJ ;EP
 L -^BGPGPDCK
 L -^BGPGPDPK
 L -^BGPGPDBK
 L -^BGPELDCK
 L -^BGPELDPK
 L -^BGPELDBK
 L -^BGPPEDCK
 L -^BGPPEDPK
 L -^BGPPEDBK
 D EOP^BGP5DH
 K IOPAR
 D HOME^%ZIS
 K X,X1,X2,X3,X4,X5,X6
 K A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,V,W,X,Y,Z
 K N,N1,N2,N3,N4,N5,N6
 K DIC,DA,X,Y,%Y,%,BGPJ,BGPX,BGPTEXT,BGPLINE,BGP
 K BGP1,BGP2,BGP3,BGP4,BGP5,BGP6,BGP7,BGP8,BGP9,BGP10,BGP11,BGP12,BGP13,BGP14,BGP21
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
 S (X,BGPOIEN)=0 F  S X=$O(^BGPELDCK(X)) Q:X'=+X  D
 .I '$D(^BGPELDCK(X,0)) K ^BGPELDCK(X) Q
 .S Y=^BGPELDCK(X,0)
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
 I BGPOIEN S DA=BGPOIEN,DIK="^BGPELDCK(" D ^DIK S DA=BGPOIEN,DIK="^BGPELDPK(" D ^DIK S DA=BGPOIEN,DIK="^BGPELDBK(" D ^DIK
 ;add entry
 L +^BGPELDCK:10 I '$T W !!,"unable to lock global. TRY LATER" D EOJ Q
 L +^BGPELDPK:10 I '$T W !!,"unable to lock global. TRY LATER" D EOJ Q
 L +^BGPELDBK:10 I '$T W !!,"unable to lock global. TRY LATER" D EOJ Q
 D GETIEN^BGP5EUTL
 I 'BGPIEN W !!,"error in file creation...call programmer." D EOJ Q
ELCY ;
 S DINUM=BGPIEN,X=$P(BGP0,U),DLAYGO=90555.03,DIC="^BGPELDCK(",DIC(0)="L"
 K DD,D0,DO
 D FILE^DICN
 I Y=-1 W !,"error uploading file......" H 4 G EOJ
 S BGPIEN=+Y
 D ^XBFMK
 S X=0 F  S X=$O(^TMP("BGPUPL",$J,X)) Q:X'=+X  S V=^TMP("BGPUPL",$J,X,0) D
 .Q:$P(V,"|")'="BGPELDCK"
 .S V=$P(V,"|",2,9999)
 .S N=$P(V,"|"),N2=$P(V,"|",2),N3=$P(V,"|",3),N4=$P(V,"|",4),N5=$P(V,"|",5),D=$P(V,"|",8)
 .I N5]"" S ^BGPELDCK(BGPIEN,N,N2,N3,N4,N5)=D Q
 .I N4]"" S ^BGPELDCK(BGPIEN,N,N2,N3,N4)=D Q
 .I N3]"" S ^BGPELDCK(BGPIEN,N,N2,N3)=D Q
 .I N2]"" S ^BGPELDCK(BGPIEN,N,N2)=D Q
 .I N]"" S ^BGPELDCK(BGPIEN,N)=D
 .Q
 S DA=BGPIEN,DIK="^BGPELDCK(" D IX1^DIK
ELPY ;
 S DINUM=BGPIEN,X=$P(BGP0,U),DLAYGO=90555.04,DIC="^BGPELDPK(",DIC(0)="L"
 K DD,D0,DO
 D FILE^DICN
 I Y=-1 W !,"error uploading file......" H 4 G EOJ
 S BGPIEN=+Y
 D ^XBFMK
 S X=0 F  S X=$O(^TMP("BGPUPL",$J,X)) Q:X'=+X  S V=^TMP("BGPUPL",$J,X,0) D
 .Q:$P(V,"|")'="BGPELDPK"
 .S V=$P(V,"|",2,9999)
 .S N=$P(V,"|"),N2=$P(V,"|",2),N3=$P(V,"|",3),N4=$P(V,"|",4),N5=$P(V,"|",5),D=$P(V,"|",8)
 .I N5]"" S ^BGPELDPK(BGPIEN,N,N2,N3,N4,N5)=D Q
 .I N4]"" S ^BGPELDPK(BGPIEN,N,N2,N3,N4)=D Q
 .I N3]"" S ^BGPELDPK(BGPIEN,N,N2,N3)=D Q
 .I N2]"" S ^BGPELDPK(BGPIEN,N,N2)=D Q
 .I N]"" S ^BGPELDPK(BGPIEN,N)=D
 .Q
 S DA=BGPIEN,DIK="^BGPELDPK(" D IX1^DIK
ELBY ;
 S DINUM=BGPIEN,X=$P(BGP0,U),DLAYGO=90555.05,DIC="^BGPELDBK(",DIC(0)="L"
 K DD,D0,DO
 D FILE^DICN
 I Y=-1 W !,"error uploading file......" H 4 G EOJ
 S BGPIEN=+Y
 D ^XBFMK
 S X=0 F  S X=$O(^TMP("BGPUPL",$J,X)) Q:X'=+X  S V=^TMP("BGPUPL",$J,X,0) D
 .Q:$P(V,"|")'="BGPELDBK"
 .S V=$P(V,"|",2,9999)
 .S N=$P(V,"|"),N2=$P(V,"|",2),N3=$P(V,"|",3),N4=$P(V,"|",4),N5=$P(V,"|",5),D=$P(V,"|",8)
 .I N5]"" S ^BGPELDBK(BGPIEN,N,N2,N3,N4,N5)=D Q
 .I N4]"" S ^BGPELDBK(BGPIEN,N,N2,N3,N4)=D Q
 .I N3]"" S ^BGPELDBK(BGPIEN,N,N2,N3)=D Q
 .I N2]"" S ^BGPELDBK(BGPIEN,N,N2)=D Q
 .I N]"" S ^BGPELDBK(BGPIEN,N)=D
 .Q
 S DA=BGPIEN,DIK="^BGPELDBK(" D IX1^DIK
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
 S (X,BGPOIEN)=0 F  S X=$O(^BGPPEDCK(X)) Q:X'=+X  D
 .I '$D(^BGPPEDCK(X,0)) K ^BGPPEDCK(X) Q
 .S Y=^BGPPEDCK(X,0)
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
 I BGPOIEN S DA=BGPOIEN,DIK="^BGPPEDCK(" D ^DIK S DA=BGPOIEN,DIK="^BGPPEDPK(" D ^DIK S DA=BGPOIEN,DIK="^BGPPEDBK(" D ^DIK
 ;add entry
 L +^BGPPEDCK:10 I '$T W !!,"unable to lock global. TRY LATER" D EOJ Q
 L +^BGPPEDPK:10 I '$T W !!,"unable to lock global. TRY LATER" D EOJ Q
 L +^BGPPEDBK:10 I '$T W !!,"unable to lock global. TRY LATER" D EOJ Q
 D GETIEN^BGP5PUTL
 I 'BGPIEN W !!,"error in file creation...call programmer." D EOJ Q
PEDCY ;
 S DINUM=BGPIEN,X=$P(BGP0,U),DLAYGO=90554.12,DIC="^BGPPEDCK(",DIC(0)="L"
 K DD,D0,DO
 D FILE^DICN
 I Y=-1 W !,"error uploading file......" H 4 G EOJ
 S BGPIEN=+Y
 D ^XBFMK
 S X=0 F  S X=$O(^TMP("BGPUPL",$J,X)) Q:X'=+X  S V=^TMP("BGPUPL",$J,X,0) D
 .Q:$P(V,"|")'="BGPPEDCK"
 .S V=$P(V,"|",2,9999)
 .S N=$P(V,"|"),N2=$P(V,"|",2),N3=$P(V,"|",3),N4=$P(V,"|",4),N5=$P(V,"|",5),D=$P(V,"|",8)
 .I N5]"" S ^BGPPEDCK(BGPIEN,N,N2,N3,N4,N5)=D Q
 .I N4]"" S ^BGPPEDCK(BGPIEN,N,N2,N3,N4)=D Q
 .I N3]"" S ^BGPPEDCK(BGPIEN,N,N2,N3)=D Q
 .I N2]"" S ^BGPPEDCK(BGPIEN,N,N2)=D Q
 .I N]"" S ^BGPPEDCK(BGPIEN,N)=D
 .Q
 S DA=BGPIEN,DIK="^BGPPEDCK(" D IX1^DIK
PEDPY ;
 S DINUM=BGPIEN,X=$P(BGP0,U),DLAYGO=90554.13,DIC="^BGPPEDPK(",DIC(0)="L"
 K DD,D0,DO
 D FILE^DICN
 I Y=-1 W !,"error uploading file......" H 4 G EOJ
 S BGPIEN=+Y
 D ^XBFMK
 S X=0 F  S X=$O(^TMP("BGPUPL",$J,X)) Q:X'=+X  S V=^TMP("BGPUPL",$J,X,0) D
 .Q:$P(V,"|")'="BGPPEDPK"
 .S V=$P(V,"|",2,9999)
 .S N=$P(V,"|"),N2=$P(V,"|",2),N3=$P(V,"|",3),N4=$P(V,"|",4),N5=$P(V,"|",5),D=$P(V,"|",8)
 .I N5]"" S ^BGPPEDPK(BGPIEN,N,N2,N3,N4,N5)=D Q
 .I N4]"" S ^BGPPEDPK(BGPIEN,N,N2,N3,N4)=D Q
 .I N3]"" S ^BGPPEDPK(BGPIEN,N,N2,N3)=D Q
 .I N2]"" S ^BGPPEDPK(BGPIEN,N,N2)=D Q
 .I N]"" S ^BGPPEDPK(BGPIEN,N)=D
 .Q
 S DA=BGPIEN,DIK="^BGPPEDPK(" D IX1^DIK
PEDBY ;
 S DINUM=BGPIEN,X=$P(BGP0,U),DLAYGO=90554.14,DIC="^BGPPEDBK(",DIC(0)="L"
 K DD,D0,DO
 D FILE^DICN
 I Y=-1 W !,"error uploading file......" H 4 G EOJ
 S BGPIEN=+Y
 D ^XBFMK
 S X=0 F  S X=$O(^TMP("BGPUPL",$J,X)) Q:X'=+X  S V=^TMP("BGPUPL",$J,X,0) D
 .Q:$P(V,"|")'="BGPPEDBK"
 .S V=$P(V,"|",2,9999)
 .S N=$P(V,"|"),N2=$P(V,"|",2),N3=$P(V,"|",3),N4=$P(V,"|",4),N5=$P(V,"|",5),D=$P(V,"|",8)
 .I N5]"" S ^BGPPEDBK(BGPIEN,N,N2,N3,N4,N5)=D Q
 .I N4]"" S ^BGPPEDBK(BGPIEN,N,N2,N3,N4)=D Q
 .I N3]"" S ^BGPPEDBK(BGPIEN,N,N2,N3)=D Q
 .I N2]"" S ^BGPPEDBK(BGPIEN,N,N2)=D Q
 .I N]"" S ^BGPPEDBK(BGPIEN,N)=D
 .Q
 S DA=BGPIEN,DIK="^BGPPEDBK(" D IX1^DIK
 W !,"Data uploaded."
 D EOJ
 Q
