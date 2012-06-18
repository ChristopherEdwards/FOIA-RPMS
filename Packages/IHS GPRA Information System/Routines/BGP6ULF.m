BGP6ULF ; IHS/CMI/LAB - NO DESCRIPTION PROVIDED ;
 ;;7.0;IHS CLINICAL REPORTING;;JAN 24, 2007
 ;
 ;
 W:$D(IOF) @IOF
 W !,"This option is used to upload a SU's 2006 CRS data.",!,"You must specify the directory in which the CRS 2006 data file resides",!,"and then enter the filename of the data.",!
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
 S DIR(0)="FO^2:30",DIR("A")="Enter filename w /ext (i.e. BG06101201.5)" K DA D ^DIR K DIR
 G:$D(DIRUT) DIR
 I Y="" G DIR
 I $E($$UP^XLFSTR(Y),1,4)'="BG06" W !!,"Filename must begin with BG06" G FILENAME
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
 S (X,BGPOIEN)=0 F  S X=$O(^BGPGPDCS(X)) Q:X'=+X  S Y=^BGPGPDCS(X,0)  D
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
 I BGPOIEN S DA=BGPOIEN,DIK="^BGPGPDCS(" D ^DIK S DA=BGPOIEN,DIK="^BGPGPDPS(" D ^DIK S DA=BGPOIEN,DIK="^BGPGPDBS(" D ^DIK
 ;add entry
 L +^BGPGPDCS:10 I '$T W !!,"unable to lock global. TRY LATER" D EOJ Q
 L +^BGPGPDPS:10 I '$T W !!,"unable to lock global. TRY LATER" D EOJ Q
 L +^BGPGPDBS:10 I '$T W !!,"unable to lock global. TRY LATER" D EOJ Q
 D GETIEN^BGP6UTL
 I 'BGPIEN W !!,"error in file creation...call programmer." D EOJ Q
CY ;
 S DINUM=BGPIEN,X=$P(BGP0,U),DLAYGO=90374.03,DIC="^BGPGPDCS(",DIC(0)="L"
 K DD,D0,DO
 D FILE^DICN
 I Y=-1 W !,"error uploading file......" H 4 G EOJ
 S BGPIEN=+Y
 D ^XBFMK
 S X=0 F  S X=$O(^TMP("BGPUPL",$J,X)) Q:X'=+X  S V=^TMP("BGPUPL",$J,X,0) D
 .Q:$P(V,"|")'="BGPGPDCS"
 .S V=$P(V,"|",2,9999)
 .S N=$P(V,"|"),N2=$P(V,"|",2),N3=$P(V,"|",3),N4=$P(V,"|",4),N5=$P(V,"|",5),D=$P(V,"|",8)
 .I N5]"" S ^BGPGPDCS(BGPIEN,N,N2,N3,N4,N5)=D Q
 .I N4]"" S ^BGPGPDCS(BGPIEN,N,N2,N3,N4)=D Q
 .I N3]"" S ^BGPGPDCS(BGPIEN,N,N2,N3)=D Q
 .I N2]"" S ^BGPGPDCS(BGPIEN,N,N2)=D Q
 .I N]"" S ^BGPGPDCS(BGPIEN,N)=D
 .Q
 S DA=BGPIEN,DIK="^BGPGPDCS(" D IX1^DIK
PY ;
 S DINUM=BGPIEN,X=$P(BGP0,U),DLAYGO=90374.04,DIC="^BGPGPDPS(",DIC(0)="L"
 K DD,D0,DO
 D FILE^DICN
 I Y=-1 W !,"error uploading file......" H 4 G EOJ
 S BGPIEN=+Y
 D ^XBFMK
 S X=0 F  S X=$O(^TMP("BGPUPL",$J,X)) Q:X'=+X  S V=^TMP("BGPUPL",$J,X,0) D
 .Q:$P(V,"|")'="BGPGPDPS"
 .S V=$P(V,"|",2,9999)
 .S N=$P(V,"|"),N2=$P(V,"|",2),N3=$P(V,"|",3),N4=$P(V,"|",4),N5=$P(V,"|",5),D=$P(V,"|",8)
 .I N5]"" S ^BGPGPDPS(BGPIEN,N,N2,N3,N4,N5)=D Q
 .I N4]"" S ^BGPGPDPS(BGPIEN,N,N2,N3,N4)=D Q
 .I N3]"" S ^BGPGPDPS(BGPIEN,N,N2,N3)=D Q
 .I N2]"" S ^BGPGPDPS(BGPIEN,N,N2)=D Q
 .I N]"" S ^BGPGPDPS(BGPIEN,N)=D
 .Q
 S DA=BGPIEN,DIK="^BGPGPDPS(" D IX1^DIK
BY ;
 S DINUM=BGPIEN,X=$P(BGP0,U),DLAYGO=90374.05,DIC="^BGPGPDBS(",DIC(0)="L"
 K DD,D0,DO
 D FILE^DICN
 I Y=-1 W !,"error uploading file......" H 4 G EOJ
 S BGPIEN=+Y
 D ^XBFMK
 S X=0 F  S X=$O(^TMP("BGPUPL",$J,X)) Q:X'=+X  S V=^TMP("BGPUPL",$J,X,0) D
 .Q:$P(V,"|")'="BGPGPDBS"
 .S V=$P(V,"|",2,9999)
 .S N=$P(V,"|"),N2=$P(V,"|",2),N3=$P(V,"|",3),N4=$P(V,"|",4),N5=$P(V,"|",5),D=$P(V,"|",8)
 .I N5]"" S ^BGPGPDBS(BGPIEN,N,N2,N3,N4,N5)=D Q
 .I N4]"" S ^BGPGPDBS(BGPIEN,N,N2,N3,N4)=D Q
 .I N3]"" S ^BGPGPDBS(BGPIEN,N,N2,N3)=D Q
 .I N2]"" S ^BGPGPDBS(BGPIEN,N,N2)=D Q
 .I N]"" S ^BGPGPDBS(BGPIEN,N)=D
 .Q
 S DA=BGPIEN,DIK="^BGPGPDBS(" D IX1^DIK
 W !,"Data uploaded."
 D EOJ
 Q
EOJ ;
 L -^BGPGPDCS
 L -^BGPGPDPS
 L -^BGPGPDBS
 L -^BGPHEDCS
 L -^BGPHEDPS
 L -^BGPHEDBS
 L -^BGPELDCS
 L -^BGPELDPS
 L -^BGPELDBS
 D EOP^BGP6DH
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
 S (X,BGPOIEN)=0 F  S X=$O(^BGPHEDCS(X)) Q:X'=+X  S Y=^BGPHEDCS(X,0)  D
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
 I BGPOIEN S DA=BGPOIEN,DIK="^BGPHEDCS(" D ^DIK S DA=BGPOIEN,DIK="^BGPHEDPS(" D ^DIK S DA=BGPOIEN,DIK="^BGPHEDBS(" D ^DIK
 ;add entry
 L +^BGPHEDCS:10 I '$T W !!,"unable to lock global. TRY LATER" D EOJ Q
 L +^BGPHEDPS:10 I '$T W !!,"unable to lock global. TRY LATER" D EOJ Q
 L +^BGPHEDBS:10 I '$T W !!,"unable to lock global. TRY LATER" D EOJ Q
 D GETIEN^BGP6HUTL
 I 'BGPIEN W !!,"error in file creation...call programmer." D EOJ Q
HECY ;
 S DINUM=BGPIEN,X=$P(BGP0,U),DLAYGO=90375.03,DIC="^BGPHEDCS(",DIC(0)="L"
 K DD,D0,DO
 D FILE^DICN
 I Y=-1 W !,"error uploading file......" H 4 G EOJ
 S BGPIEN=+Y
 D ^XBFMK
 S X=0 F  S X=$O(^TMP("BGPUPL",$J,X)) Q:X'=+X  S V=^TMP("BGPUPL",$J,X,0) D
 .Q:$P(V,"|")'="BGPHEDCS"
 .S V=$P(V,"|",2,9999)
 .S N=$P(V,"|"),N2=$P(V,"|",2),N3=$P(V,"|",3),N4=$P(V,"|",4),N5=$P(V,"|",5),D=$P(V,"|",8)
 .I N5]"" S ^BGPHEDCS(BGPIEN,N,N2,N3,N4,N5)=D Q
 .I N4]"" S ^BGPHEDCS(BGPIEN,N,N2,N3,N4)=D Q
 .I N3]"" S ^BGPHEDCS(BGPIEN,N,N2,N3)=D Q
 .I N2]"" S ^BGPHEDCS(BGPIEN,N,N2)=D Q
 .I N]"" S ^BGPHEDCS(BGPIEN,N)=D
 .Q
 S DA=BGPIEN,DIK="^BGPHEDCS(" D IX1^DIK
HEPY ;
 S DINUM=BGPIEN,X=$P(BGP0,U),DLAYGO=90375.04,DIC="^BGPHEDPS(",DIC(0)="L"
 K DD,D0,DO
 D FILE^DICN
 I Y=-1 W !,"error uploading file......" H 4 G EOJ
 S BGPIEN=+Y
 D ^XBFMK
 S X=0 F  S X=$O(^TMP("BGPUPL",$J,X)) Q:X'=+X  S V=^TMP("BGPUPL",$J,X,0) D
 .Q:$P(V,"|")'="BGPHEDPS"
 .S V=$P(V,"|",2,9999)
 .S N=$P(V,"|"),N2=$P(V,"|",2),N3=$P(V,"|",3),N4=$P(V,"|",4),N5=$P(V,"|",5),D=$P(V,"|",8)
 .I N5]"" S ^BGPHEDPS(BGPIEN,N,N2,N3,N4,N5)=D Q
 .I N4]"" S ^BGPHEDPS(BGPIEN,N,N2,N3,N4)=D Q
 .I N3]"" S ^BGPHEDPS(BGPIEN,N,N2,N3)=D Q
 .I N2]"" S ^BGPHEDPS(BGPIEN,N,N2)=D Q
 .I N]"" S ^BGPHEDPS(BGPIEN,N)=D
 .Q
 S DA=BGPIEN,DIK="^BGPHEDPS(" D IX1^DIK
HEBY ;
 S DINUM=BGPIEN,X=$P(BGP0,U),DLAYGO=90375.05,DIC="^BGPHEDBS(",DIC(0)="L"
 K DD,D0,DO
 D FILE^DICN
 I Y=-1 W !,"error uploading file......" H 4 G EOJ
 S BGPIEN=+Y
 D ^XBFMK
 S X=0 F  S X=$O(^TMP("BGPUPL",$J,X)) Q:X'=+X  S V=^TMP("BGPUPL",$J,X,0) D
 .Q:$P(V,"|")'="BGPHEDBS"
 .S V=$P(V,"|",2,9999)
 .S N=$P(V,"|"),N2=$P(V,"|",2),N3=$P(V,"|",3),N4=$P(V,"|",4),N5=$P(V,"|",5),D=$P(V,"|",8)
 .I N5]"" S ^BGPHEDBS(BGPIEN,N,N2,N3,N4,N5)=D Q
 .I N4]"" S ^BGPHEDBS(BGPIEN,N,N2,N3,N4)=D Q
 .I N3]"" S ^BGPHEDBS(BGPIEN,N,N2,N3)=D Q
 .I N2]"" S ^BGPHEDBS(BGPIEN,N,N2)=D Q
 .I N]"" S ^BGPHEDBS(BGPIEN,N)=D
 .Q
 S DA=BGPIEN,DIK="^BGPHEDBS(" D IX1^DIK
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
 S (X,BGPOIEN)=0 F  S X=$O(^BGPELDCS(X)) Q:X'=+X  S Y=^BGPELDCS(X,0)  D
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
 I BGPOIEN S DA=BGPOIEN,DIK="^BGPELDCS(" D ^DIK S DA=BGPOIEN,DIK="^BGPELDPS(" D ^DIK S DA=BGPOIEN,DIK="^BGPELDBS(" D ^DIK
 ;add entry
 L +^BGPELDCS:10 I '$T W !!,"unable to lock global. TRY LATER" D EOJ Q
 L +^BGPELDPS:10 I '$T W !!,"unable to lock global. TRY LATER" D EOJ Q
 L +^BGPELDBS:10 I '$T W !!,"unable to lock global. TRY LATER" D EOJ Q
 D GETIEN^BGP6HUTL
 I 'BGPIEN W !!,"error in file creation...call programmer." D EOJ Q
ELCY ;
 S DINUM=BGPIEN,X=$P(BGP0,U),DLAYGO=90375.03,DIC="^BGPELDCS(",DIC(0)="L"
 K DD,D0,DO
 D FILE^DICN
 I Y=-1 W !,"error uploading file......" H 4 G EOJ
 S BGPIEN=+Y
 D ^XBFMK
 S X=0 F  S X=$O(^TMP("BGPUPL",$J,X)) Q:X'=+X  S V=^TMP("BGPUPL",$J,X,0) D
 .Q:$P(V,"|")'="BGPELDCS"
 .S V=$P(V,"|",2,9999)
 .S N=$P(V,"|"),N2=$P(V,"|",2),N3=$P(V,"|",3),N4=$P(V,"|",4),N5=$P(V,"|",5),D=$P(V,"|",8)
 .I N5]"" S ^BGPELDCS(BGPIEN,N,N2,N3,N4,N5)=D Q
 .I N4]"" S ^BGPELDCS(BGPIEN,N,N2,N3,N4)=D Q
 .I N3]"" S ^BGPELDCS(BGPIEN,N,N2,N3)=D Q
 .I N2]"" S ^BGPELDCS(BGPIEN,N,N2)=D Q
 .I N]"" S ^BGPELDCS(BGPIEN,N)=D
 .Q
 S DA=BGPIEN,DIK="^BGPELDCS(" D IX1^DIK
ELPY ;
 S DINUM=BGPIEN,X=$P(BGP0,U),DLAYGO=90375.04,DIC="^BGPELDPS(",DIC(0)="L"
 K DD,D0,DO
 D FILE^DICN
 I Y=-1 W !,"error uploading file......" H 4 G EOJ
 S BGPIEN=+Y
 D ^XBFMK
 S X=0 F  S X=$O(^TMP("BGPUPL",$J,X)) Q:X'=+X  S V=^TMP("BGPUPL",$J,X,0) D
 .Q:$P(V,"|")'="BGPELDPS"
 .S V=$P(V,"|",2,9999)
 .S N=$P(V,"|"),N2=$P(V,"|",2),N3=$P(V,"|",3),N4=$P(V,"|",4),N5=$P(V,"|",5),D=$P(V,"|",8)
 .I N5]"" S ^BGPELDPS(BGPIEN,N,N2,N3,N4,N5)=D Q
 .I N4]"" S ^BGPELDPS(BGPIEN,N,N2,N3,N4)=D Q
 .I N3]"" S ^BGPELDPS(BGPIEN,N,N2,N3)=D Q
 .I N2]"" S ^BGPELDPS(BGPIEN,N,N2)=D Q
 .I N]"" S ^BGPELDPS(BGPIEN,N)=D
 .Q
 S DA=BGPIEN,DIK="^BGPELDPS(" D IX1^DIK
ELBY ;
 S DINUM=BGPIEN,X=$P(BGP0,U),DLAYGO=90375.05,DIC="^BGPELDBS(",DIC(0)="L"
 K DD,D0,DO
 D FILE^DICN
 I Y=-1 W !,"error uploading file......" H 4 G EOJ
 S BGPIEN=+Y
 D ^XBFMK
 S X=0 F  S X=$O(^TMP("BGPUPL",$J,X)) Q:X'=+X  S V=^TMP("BGPUPL",$J,X,0) D
 .Q:$P(V,"|")'="BGPELDBS"
 .S V=$P(V,"|",2,9999)
 .S N=$P(V,"|"),N2=$P(V,"|",2),N3=$P(V,"|",3),N4=$P(V,"|",4),N5=$P(V,"|",5),D=$P(V,"|",8)
 .I N5]"" S ^BGPELDBS(BGPIEN,N,N2,N3,N4,N5)=D Q
 .I N4]"" S ^BGPELDBS(BGPIEN,N,N2,N3,N4)=D Q
 .I N3]"" S ^BGPELDBS(BGPIEN,N,N2,N3)=D Q
 .I N2]"" S ^BGPELDBS(BGPIEN,N,N2)=D Q
 .I N]"" S ^BGPELDBS(BGPIEN,N)=D
 .Q
 S DA=BGPIEN,DIK="^BGPELDBS(" D IX1^DIK
 W !,"Data uploaded."
 D EOJ
 Q
 ;
