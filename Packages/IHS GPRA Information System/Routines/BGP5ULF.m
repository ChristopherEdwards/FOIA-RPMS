BGP5ULF ; IHS/CMI/LAB - NO DESCRIPTION PROVIDED ;
 ;;7.0;IHS CLINICAL REPORTING;;JAN 24, 2007
 ;
 ;
 W:$D(IOF) @IOF
 W !,"This option is used to upload a SU's 2005 CRS data.",!,"You must specify the directory in which the CRS 2005 data file resides",!,"and then enter the filename of the data.",!
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
 S DIR(0)="FO^2:30",DIR("A")="Enter filename w /ext (i.e. BG05101201.5)" K DA D ^DIR K DIR
 G:$D(DIRUT) DIR
 I Y="" G DIR
 I $E($$UP^XLFSTR(Y),1,4)'="BG05" W !!,"Filename must begin with BG05" G FILENAME
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
 W !,"Processing",!
 S BGP0=$P($G(^TMP("BGPUPL",$J,1,0)),"|",9)
 S BGPG=$P($G(^TMP("BGPUPL",$J,1,0)),"|")
 F X=1:1:14 S Y="BGP"_X,@Y=$P(BGP0,U,X)
 ;find existing entry and if exists, delete it
 S (X,BGPOIEN)=0 F  S X=$O(^BGPGPDCV(X)) Q:X'=+X  S Y=^BGPGPDCV(X,0)  D
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
 I BGPOIEN S DA=BGPOIEN,DIK="^BGPGPDCV(" D ^DIK S DA=BGPOIEN,DIK="^BGPGPDPV(" D ^DIK S DA=BGPOIEN,DIK="^BGPGPDBV(" D ^DIK
 ;add entry
 L +^BGPGPDCV:10 I '$T W !!,"unable to lock global. TRY LATER" D EOJ Q
 L +^BGPGPDPV:10 I '$T W !!,"unable to lock global. TRY LATER" D EOJ Q
 L +^BGPGPDBV:10 I '$T W !!,"unable to lock global. TRY LATER" D EOJ Q
 D GETIEN^BGP5UTL
 I 'BGPIEN W !!,"error in file creation...call programmer." D EOJ Q
CY ;
 S DINUM=BGPIEN,X=$P(BGP0,U),DLAYGO=90371.03,DIC="^BGPGPDCV(",DIC(0)="L"
 K DD,D0,DO
 D FILE^DICN
 I Y=-1 W !,"error uploading file......" H 4 G EOJ
 S BGPIEN=+Y
 D ^XBFMK
 S X=0 F  S X=$O(^TMP("BGPUPL",$J,X)) Q:X'=+X  S V=^TMP("BGPUPL",$J,X,0) D
 .Q:$P(V,"|")'="BGPGPDCV"
 .S V=$P(V,"|",2,9999)
 .S N=$P(V,"|"),N2=$P(V,"|",2),N3=$P(V,"|",3),N4=$P(V,"|",4),N5=$P(V,"|",5),D=$P(V,"|",8)
 .I N5]"" S ^BGPGPDCV(BGPIEN,N,N2,N3,N4,N5)=D Q
 .I N4]"" S ^BGPGPDCV(BGPIEN,N,N2,N3,N4)=D Q
 .I N3]"" S ^BGPGPDCV(BGPIEN,N,N2,N3)=D Q
 .I N2]"" S ^BGPGPDCV(BGPIEN,N,N2)=D Q
 .I N]"" S ^BGPGPDCV(BGPIEN,N)=D
 .Q
 S DA=BGPIEN,DIK="^BGPGPDCV(" D IX1^DIK
PY ;
 S DINUM=BGPIEN,X=$P(BGP0,U),DLAYGO=90371.04,DIC="^BGPGPDPV(",DIC(0)="L"
 K DD,D0,DO
 D FILE^DICN
 I Y=-1 W !,"error uploading file......" H 4 G EOJ
 S BGPIEN=+Y
 D ^XBFMK
 S X=0 F  S X=$O(^TMP("BGPUPL",$J,X)) Q:X'=+X  S V=^TMP("BGPUPL",$J,X,0) D
 .Q:$P(V,"|")'="BGPGPDPV"
 .S V=$P(V,"|",2,9999)
 .S N=$P(V,"|"),N2=$P(V,"|",2),N3=$P(V,"|",3),N4=$P(V,"|",4),N5=$P(V,"|",5),D=$P(V,"|",8)
 .I N5]"" S ^BGPGPDPV(BGPIEN,N,N2,N3,N4,N5)=D Q
 .I N4]"" S ^BGPGPDPV(BGPIEN,N,N2,N3,N4)=D Q
 .I N3]"" S ^BGPGPDPV(BGPIEN,N,N2,N3)=D Q
 .I N2]"" S ^BGPGPDPV(BGPIEN,N,N2)=D Q
 .I N]"" S ^BGPGPDPV(BGPIEN,N)=D
 .Q
 S DA=BGPIEN,DIK="^BGPGPDPV(" D IX1^DIK
BY ;
 S DINUM=BGPIEN,X=$P(BGP0,U),DLAYGO=90371.05,DIC="^BGPGPDBV(",DIC(0)="L"
 K DD,D0,DO
 D FILE^DICN
 I Y=-1 W !,"error uploading file......" H 4 G EOJ
 S BGPIEN=+Y
 D ^XBFMK
 S X=0 F  S X=$O(^TMP("BGPUPL",$J,X)) Q:X'=+X  S V=^TMP("BGPUPL",$J,X,0) D
 .Q:$P(V,"|")'="BGPGPDBV"
 .S V=$P(V,"|",2,9999)
 .S N=$P(V,"|"),N2=$P(V,"|",2),N3=$P(V,"|",3),N4=$P(V,"|",4),N5=$P(V,"|",5),D=$P(V,"|",8)
 .I N5]"" S ^BGPGPDBV(BGPIEN,N,N2,N3,N4,N5)=D Q
 .I N4]"" S ^BGPGPDBV(BGPIEN,N,N2,N3,N4)=D Q
 .I N3]"" S ^BGPGPDBV(BGPIEN,N,N2,N3)=D Q
 .I N2]"" S ^BGPGPDBV(BGPIEN,N,N2)=D Q
 .I N]"" S ^BGPGPDBV(BGPIEN,N)=D
 .Q
 S DA=BGPIEN,DIK="^BGPGPDBV(" D IX1^DIK
 W !,"Data uploaded."
 D EOJ
 Q
EOJ ;
 L -^BGPGPDCV
 L -^BGPGPDPV
 L -^BGPGPDBV
 L -^BGPHEDCV
 L -^BGPHEDPV
 L -^BGPHEDBV
 L -^BGPELDCV
 L -^BGPELDPV
 L -^BGPELDBV
 D EOP^BGPDH
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
 S (X,BGPOIEN)=0 F  S X=$O(^BGPHEDCV(X)) Q:X'=+X  S Y=^BGPHEDCV(X,0)  D
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
 I BGPOIEN S DA=BGPOIEN,DIK="^BGPHEDCV(" D ^DIK S DA=BGPOIEN,DIK="^BGPHEDPV(" D ^DIK S DA=BGPOIEN,DIK="^BGPHEDBV(" D ^DIK
 ;add entry
 L +^BGPHEDCV:10 I '$T W !!,"unable to lock global. TRY LATER" D EOJ Q
 L +^BGPHEDPV:10 I '$T W !!,"unable to lock global. TRY LATER" D EOJ Q
 L +^BGPHEDBV:10 I '$T W !!,"unable to lock global. TRY LATER" D EOJ Q
 D GETIEN^BGP5HUTL
 I 'BGPIEN W !!,"error in file creation...call programmer." D EOJ Q
HECY ;
 S DINUM=BGPIEN,X=$P(BGP0,U),DLAYGO=90372.03,DIC="^BGPHEDCV(",DIC(0)="L"
 K DD,D0,DO
 D FILE^DICN
 I Y=-1 W !,"error uploading file......" H 4 G EOJ
 S BGPIEN=+Y
 D ^XBFMK
 S X=0 F  S X=$O(^TMP("BGPUPL",$J,X)) Q:X'=+X  S V=^TMP("BGPUPL",$J,X,0) D
 .Q:$P(V,"|")'="BGPHEDCV"
 .S V=$P(V,"|",2,9999)
 .S N=$P(V,"|"),N2=$P(V,"|",2),N3=$P(V,"|",3),N4=$P(V,"|",4),N5=$P(V,"|",5),D=$P(V,"|",8)
 .I N5]"" S ^BGPHEDCV(BGPIEN,N,N2,N3,N4,N5)=D Q
 .I N4]"" S ^BGPHEDCV(BGPIEN,N,N2,N3,N4)=D Q
 .I N3]"" S ^BGPHEDCV(BGPIEN,N,N2,N3)=D Q
 .I N2]"" S ^BGPHEDCV(BGPIEN,N,N2)=D Q
 .I N]"" S ^BGPHEDCV(BGPIEN,N)=D
 .Q
 S DA=BGPIEN,DIK="^BGPHEDCV(" D IX1^DIK
HEPY ;
 S DINUM=BGPIEN,X=$P(BGP0,U),DLAYGO=90372.04,DIC="^BGPHEDPV(",DIC(0)="L"
 K DD,D0,DO
 D FILE^DICN
 I Y=-1 W !,"error uploading file......" H 4 G EOJ
 S BGPIEN=+Y
 D ^XBFMK
 S X=0 F  S X=$O(^TMP("BGPUPL",$J,X)) Q:X'=+X  S V=^TMP("BGPUPL",$J,X,0) D
 .Q:$P(V,"|")'="BGPHEDPV"
 .S V=$P(V,"|",2,9999)
 .S N=$P(V,"|"),N2=$P(V,"|",2),N3=$P(V,"|",3),N4=$P(V,"|",4),N5=$P(V,"|",5),D=$P(V,"|",8)
 .I N5]"" S ^BGPHEDPV(BGPIEN,N,N2,N3,N4,N5)=D Q
 .I N4]"" S ^BGPHEDPV(BGPIEN,N,N2,N3,N4)=D Q
 .I N3]"" S ^BGPHEDPV(BGPIEN,N,N2,N3)=D Q
 .I N2]"" S ^BGPHEDPV(BGPIEN,N,N2)=D Q
 .I N]"" S ^BGPHEDPV(BGPIEN,N)=D
 .Q
 S DA=BGPIEN,DIK="^BGPHEDPV(" D IX1^DIK
HEBY ;
 S DINUM=BGPIEN,X=$P(BGP0,U),DLAYGO=90372.05,DIC="^BGPHEDBV(",DIC(0)="L"
 K DD,D0,DO
 D FILE^DICN
 I Y=-1 W !,"error uploading file......" H 4 G EOJ
 S BGPIEN=+Y
 D ^XBFMK
 S X=0 F  S X=$O(^TMP("BGPUPL",$J,X)) Q:X'=+X  S V=^TMP("BGPUPL",$J,X,0) D
 .Q:$P(V,"|")'="BGPHEDBV"
 .S V=$P(V,"|",2,9999)
 .S N=$P(V,"|"),N2=$P(V,"|",2),N3=$P(V,"|",3),N4=$P(V,"|",4),N5=$P(V,"|",5),D=$P(V,"|",8)
 .I N5]"" S ^BGPHEDBV(BGPIEN,N,N2,N3,N4,N5)=D Q
 .I N4]"" S ^BGPHEDBV(BGPIEN,N,N2,N3,N4)=D Q
 .I N3]"" S ^BGPHEDBV(BGPIEN,N,N2,N3)=D Q
 .I N2]"" S ^BGPHEDBV(BGPIEN,N,N2)=D Q
 .I N]"" S ^BGPHEDBV(BGPIEN,N)=D
 .Q
 S DA=BGPIEN,DIK="^BGPHEDBV(" D IX1^DIK
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
 S (X,BGPOIEN)=0 F  S X=$O(^BGPELDCV(X)) Q:X'=+X  S Y=^BGPELDCV(X,0)  D
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
 I BGPOIEN S DA=BGPOIEN,DIK="^BGPELDCV(" D ^DIK S DA=BGPOIEN,DIK="^BGPELDPV(" D ^DIK S DA=BGPOIEN,DIK="^BGPELDBV(" D ^DIK
 ;add entry
 L +^BGPELDCV:10 I '$T W !!,"unable to lock global. TRY LATER" D EOJ Q
 L +^BGPELDPV:10 I '$T W !!,"unable to lock global. TRY LATER" D EOJ Q
 L +^BGPELDBV:10 I '$T W !!,"unable to lock global. TRY LATER" D EOJ Q
 D GETIEN^BGP5HUTL
 I 'BGPIEN W !!,"error in file creation...call programmer." D EOJ Q
ELCY ;
 S DINUM=BGPIEN,X=$P(BGP0,U),DLAYGO=90372.03,DIC="^BGPELDCV(",DIC(0)="L"
 K DD,D0,DO
 D FILE^DICN
 I Y=-1 W !,"error uploading file......" H 4 G EOJ
 S BGPIEN=+Y
 D ^XBFMK
 S X=0 F  S X=$O(^TMP("BGPUPL",$J,X)) Q:X'=+X  S V=^TMP("BGPUPL",$J,X,0) D
 .Q:$P(V,"|")'="BGPELDCV"
 .S V=$P(V,"|",2,9999)
 .S N=$P(V,"|"),N2=$P(V,"|",2),N3=$P(V,"|",3),N4=$P(V,"|",4),N5=$P(V,"|",5),D=$P(V,"|",8)
 .I N5]"" S ^BGPELDCV(BGPIEN,N,N2,N3,N4,N5)=D Q
 .I N4]"" S ^BGPELDCV(BGPIEN,N,N2,N3,N4)=D Q
 .I N3]"" S ^BGPELDCV(BGPIEN,N,N2,N3)=D Q
 .I N2]"" S ^BGPELDCV(BGPIEN,N,N2)=D Q
 .I N]"" S ^BGPELDCV(BGPIEN,N)=D
 .Q
 S DA=BGPIEN,DIK="^BGPELDCV(" D IX1^DIK
ELPY ;
 S DINUM=BGPIEN,X=$P(BGP0,U),DLAYGO=90372.04,DIC="^BGPELDPV(",DIC(0)="L"
 K DD,D0,DO
 D FILE^DICN
 I Y=-1 W !,"error uploading file......" H 4 G EOJ
 S BGPIEN=+Y
 D ^XBFMK
 S X=0 F  S X=$O(^TMP("BGPUPL",$J,X)) Q:X'=+X  S V=^TMP("BGPUPL",$J,X,0) D
 .Q:$P(V,"|")'="BGPELDPV"
 .S V=$P(V,"|",2,9999)
 .S N=$P(V,"|"),N2=$P(V,"|",2),N3=$P(V,"|",3),N4=$P(V,"|",4),N5=$P(V,"|",5),D=$P(V,"|",8)
 .I N5]"" S ^BGPELDPV(BGPIEN,N,N2,N3,N4,N5)=D Q
 .I N4]"" S ^BGPELDPV(BGPIEN,N,N2,N3,N4)=D Q
 .I N3]"" S ^BGPELDPV(BGPIEN,N,N2,N3)=D Q
 .I N2]"" S ^BGPELDPV(BGPIEN,N,N2)=D Q
 .I N]"" S ^BGPELDPV(BGPIEN,N)=D
 .Q
 S DA=BGPIEN,DIK="^BGPELDPV(" D IX1^DIK
ELBY ;
 S DINUM=BGPIEN,X=$P(BGP0,U),DLAYGO=90372.05,DIC="^BGPELDBV(",DIC(0)="L"
 K DD,D0,DO
 D FILE^DICN
 I Y=-1 W !,"error uploading file......" H 4 G EOJ
 S BGPIEN=+Y
 D ^XBFMK
 S X=0 F  S X=$O(^TMP("BGPUPL",$J,X)) Q:X'=+X  S V=^TMP("BGPUPL",$J,X,0) D
 .Q:$P(V,"|")'="BGPELDBV"
 .S V=$P(V,"|",2,9999)
 .S N=$P(V,"|"),N2=$P(V,"|",2),N3=$P(V,"|",3),N4=$P(V,"|",4),N5=$P(V,"|",5),D=$P(V,"|",8)
 .I N5]"" S ^BGPELDBV(BGPIEN,N,N2,N3,N4,N5)=D Q
 .I N4]"" S ^BGPELDBV(BGPIEN,N,N2,N3,N4)=D Q
 .I N3]"" S ^BGPELDBV(BGPIEN,N,N2,N3)=D Q
 .I N2]"" S ^BGPELDBV(BGPIEN,N,N2)=D Q
 .I N]"" S ^BGPELDBV(BGPIEN,N)=D
 .Q
 S DA=BGPIEN,DIK="^BGPELDBV(" D IX1^DIK
 W !,"Data uploaded."
 D EOJ
 Q
 ;
