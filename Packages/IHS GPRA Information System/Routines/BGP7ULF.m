BGP7ULF ; IHS/CMI/LAB - NO DESCRIPTION PROVIDED ;
 ;;7.0;IHS CLINICAL REPORTING;;JAN 24, 2007
 ;
 ;
 W:$D(IOF) @IOF
 W !,"This option is used to upload a SU's 2007 CRS data.",!,"You must specify the directory in which the CRS 2007 data file resides",!,"and then enter the filename of the data.",!
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
 S DIR(0)="FO^2:30",DIR("A")="Enter filename w /ext (i.e. BG07101201.5)" K DA D ^DIR K DIR
 G:$D(DIRUT) DIR
 I Y="" G DIR
 I $E($$UP^XLFSTR(Y),1,4)'="BG07" W !!,"Filename must begin with BG07" G FILENAME
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
 W !,"Processing",!
 S BGP0=$P($G(^TMP("BGPUPL",$J,1,0)),"|",9)
 S BGPG=$P($G(^TMP("BGPUPL",$J,1,0)),"|")
 F X=1:1:14 S Y="BGP"_X,@Y=$P(BGP0,U,X)
 ;find existing entry and if exists, delete it
 S (X,BGPOIEN)=0 F  S X=$O(^BGPGPDCA(X)) Q:X'=+X  S Y=^BGPGPDCA(X,0)  D
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
 I BGPOIEN S DA=BGPOIEN,DIK="^BGPGPDCA(" D ^DIK S DA=BGPOIEN,DIK="^BGPGPDPA(" D ^DIK S DA=BGPOIEN,DIK="^BGPGPDBA(" D ^DIK
 ;add entry
 L +^BGPGPDCA:10 I '$T W !!,"unable to lock global. TRY LATER" D EOJ Q
 L +^BGPGPDPA:10 I '$T W !!,"unable to lock global. TRY LATER" D EOJ Q
 L +^BGPGPDBA:10 I '$T W !!,"unable to lock global. TRY LATER" D EOJ Q
 D GETIEN^BGP7UTL
 I 'BGPIEN W !!,"error in file creation...call programmer." D EOJ Q
CY ;
 S DINUM=BGPIEN,X=$P(BGP0,U),DLAYGO=90530.03,DIC="^BGPGPDCA(",DIC(0)="L"
 K DD,D0,DO
 D FILE^DICN
 I Y=-1 W !,"error uploading file......" H 4 G EOJ
 S BGPIEN=+Y
 D ^XBFMK
 S X=0 F  S X=$O(^TMP("BGPUPL",$J,X)) Q:X'=+X  S V=^TMP("BGPUPL",$J,X,0) D
 .Q:$P(V,"|")'="BGPGPDCA"
 .S V=$P(V,"|",2,9999)
 .S N=$P(V,"|"),N2=$P(V,"|",2),N3=$P(V,"|",3),N4=$P(V,"|",4),N5=$P(V,"|",5),D=$P(V,"|",8)
 .I N5]"" S ^BGPGPDCA(BGPIEN,N,N2,N3,N4,N5)=D Q
 .I N4]"" S ^BGPGPDCA(BGPIEN,N,N2,N3,N4)=D Q
 .I N3]"" S ^BGPGPDCA(BGPIEN,N,N2,N3)=D Q
 .I N2]"" S ^BGPGPDCA(BGPIEN,N,N2)=D Q
 .I N]"" S ^BGPGPDCA(BGPIEN,N)=D
 .Q
 S DA=BGPIEN,DIK="^BGPGPDCA(" D IX1^DIK
PY ;
 S DINUM=BGPIEN,X=$P(BGP0,U),DLAYGO=90530.04,DIC="^BGPGPDPA(",DIC(0)="L"
 K DD,D0,DO
 D FILE^DICN
 I Y=-1 W !,"error uploading file......" H 4 G EOJ
 S BGPIEN=+Y
 D ^XBFMK
 S X=0 F  S X=$O(^TMP("BGPUPL",$J,X)) Q:X'=+X  S V=^TMP("BGPUPL",$J,X,0) D
 .Q:$P(V,"|")'="BGPGPDPA"
 .S V=$P(V,"|",2,9999)
 .S N=$P(V,"|"),N2=$P(V,"|",2),N3=$P(V,"|",3),N4=$P(V,"|",4),N5=$P(V,"|",5),D=$P(V,"|",8)
 .I N5]"" S ^BGPGPDPA(BGPIEN,N,N2,N3,N4,N5)=D Q
 .I N4]"" S ^BGPGPDPA(BGPIEN,N,N2,N3,N4)=D Q
 .I N3]"" S ^BGPGPDPA(BGPIEN,N,N2,N3)=D Q
 .I N2]"" S ^BGPGPDPA(BGPIEN,N,N2)=D Q
 .I N]"" S ^BGPGPDPA(BGPIEN,N)=D
 .Q
 S DA=BGPIEN,DIK="^BGPGPDPA(" D IX1^DIK
BY ;
 S DINUM=BGPIEN,X=$P(BGP0,U),DLAYGO=90530.05,DIC="^BGPGPDBA(",DIC(0)="L"
 K DD,D0,DO
 D FILE^DICN
 I Y=-1 W !,"error uploading file......" H 4 G EOJ
 S BGPIEN=+Y
 D ^XBFMK
 S X=0 F  S X=$O(^TMP("BGPUPL",$J,X)) Q:X'=+X  S V=^TMP("BGPUPL",$J,X,0) D
 .Q:$P(V,"|")'="BGPGPDBA"
 .S V=$P(V,"|",2,9999)
 .S N=$P(V,"|"),N2=$P(V,"|",2),N3=$P(V,"|",3),N4=$P(V,"|",4),N5=$P(V,"|",5),D=$P(V,"|",8)
 .I N5]"" S ^BGPGPDBA(BGPIEN,N,N2,N3,N4,N5)=D Q
 .I N4]"" S ^BGPGPDBA(BGPIEN,N,N2,N3,N4)=D Q
 .I N3]"" S ^BGPGPDBA(BGPIEN,N,N2,N3)=D Q
 .I N2]"" S ^BGPGPDBA(BGPIEN,N,N2)=D Q
 .I N]"" S ^BGPGPDBA(BGPIEN,N)=D
 .Q
 S DA=BGPIEN,DIK="^BGPGPDBA(" D IX1^DIK
 W !,"Data uploaded."
 D EOJ
 Q
EOJ ;
 L -^BGPGPDCA
 L -^BGPGPDPA
 L -^BGPGPDBA
 L -^BGPHEDCA
 L -^BGPHEDPA
 L -^BGPHEDBA
 L -^BGPELDCA
 L -^BGPELDPA
 L -^BGPELDBA
 L -^BGPPEDCA
 L -^BGPPEDPA
 L -^BGPPEDBA
 D EOP^BGP7DH
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
 S (X,BGPOIEN)=0 F  S X=$O(^BGPHEDCA(X)) Q:X'=+X  S Y=^BGPHEDCA(X,0)  D
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
 I BGPOIEN S DA=BGPOIEN,DIK="^BGPHEDCA(" D ^DIK S DA=BGPOIEN,DIK="^BGPHEDPA(" D ^DIK S DA=BGPOIEN,DIK="^BGPHEDBA(" D ^DIK
 ;add entry
 L +^BGPHEDCA:10 I '$T W !!,"unable to lock global. TRY LATER" D EOJ Q
 L +^BGPHEDPA:10 I '$T W !!,"unable to lock global. TRY LATER" D EOJ Q
 L +^BGPHEDBA:10 I '$T W !!,"unable to lock global. TRY LATER" D EOJ Q
 D GETIEN^BGP7HUTL
 I 'BGPIEN W !!,"error in file creation...call programmer." D EOJ Q
HECY ;
 S DINUM=BGPIEN,X=$P(BGP0,U),DLAYGO=90531.03,DIC="^BGPHEDCA(",DIC(0)="L"
 K DD,D0,DO
 D FILE^DICN
 I Y=-1 W !,"error uploading file......" H 4 G EOJ
 S BGPIEN=+Y
 D ^XBFMK
 S X=0 F  S X=$O(^TMP("BGPUPL",$J,X)) Q:X'=+X  S V=^TMP("BGPUPL",$J,X,0) D
 .Q:$P(V,"|")'="BGPHEDCA"
 .S V=$P(V,"|",2,9999)
 .S N=$P(V,"|"),N2=$P(V,"|",2),N3=$P(V,"|",3),N4=$P(V,"|",4),N5=$P(V,"|",5),D=$P(V,"|",8)
 .I N5]"" S ^BGPHEDCA(BGPIEN,N,N2,N3,N4,N5)=D Q
 .I N4]"" S ^BGPHEDCA(BGPIEN,N,N2,N3,N4)=D Q
 .I N3]"" S ^BGPHEDCA(BGPIEN,N,N2,N3)=D Q
 .I N2]"" S ^BGPHEDCA(BGPIEN,N,N2)=D Q
 .I N]"" S ^BGPHEDCA(BGPIEN,N)=D
 .Q
 S DA=BGPIEN,DIK="^BGPHEDCA(" D IX1^DIK
HEPY ;
 S DINUM=BGPIEN,X=$P(BGP0,U),DLAYGO=90531.04,DIC="^BGPHEDPA(",DIC(0)="L"
 K DD,D0,DO
 D FILE^DICN
 I Y=-1 W !,"error uploading file......" H 4 G EOJ
 S BGPIEN=+Y
 D ^XBFMK
 S X=0 F  S X=$O(^TMP("BGPUPL",$J,X)) Q:X'=+X  S V=^TMP("BGPUPL",$J,X,0) D
 .Q:$P(V,"|")'="BGPHEDPA"
 .S V=$P(V,"|",2,9999)
 .S N=$P(V,"|"),N2=$P(V,"|",2),N3=$P(V,"|",3),N4=$P(V,"|",4),N5=$P(V,"|",5),D=$P(V,"|",8)
 .I N5]"" S ^BGPHEDPA(BGPIEN,N,N2,N3,N4,N5)=D Q
 .I N4]"" S ^BGPHEDPA(BGPIEN,N,N2,N3,N4)=D Q
 .I N3]"" S ^BGPHEDPA(BGPIEN,N,N2,N3)=D Q
 .I N2]"" S ^BGPHEDPA(BGPIEN,N,N2)=D Q
 .I N]"" S ^BGPHEDPA(BGPIEN,N)=D
 .Q
 S DA=BGPIEN,DIK="^BGPHEDPA(" D IX1^DIK
HEBY ;
 S DINUM=BGPIEN,X=$P(BGP0,U),DLAYGO=90531.05,DIC="^BGPHEDBA(",DIC(0)="L"
 K DD,D0,DO
 D FILE^DICN
 I Y=-1 W !,"error uploading file......" H 4 G EOJ
 S BGPIEN=+Y
 D ^XBFMK
 S X=0 F  S X=$O(^TMP("BGPUPL",$J,X)) Q:X'=+X  S V=^TMP("BGPUPL",$J,X,0) D
 .Q:$P(V,"|")'="BGPHEDBA"
 .S V=$P(V,"|",2,9999)
 .S N=$P(V,"|"),N2=$P(V,"|",2),N3=$P(V,"|",3),N4=$P(V,"|",4),N5=$P(V,"|",5),D=$P(V,"|",8)
 .I N5]"" S ^BGPHEDBA(BGPIEN,N,N2,N3,N4,N5)=D Q
 .I N4]"" S ^BGPHEDBA(BGPIEN,N,N2,N3,N4)=D Q
 .I N3]"" S ^BGPHEDBA(BGPIEN,N,N2,N3)=D Q
 .I N2]"" S ^BGPHEDBA(BGPIEN,N,N2)=D Q
 .I N]"" S ^BGPHEDBA(BGPIEN,N)=D
 .Q
 S DA=BGPIEN,DIK="^BGPHEDBA(" D IX1^DIK
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
 S (X,BGPOIEN)=0 F  S X=$O(^BGPELDCA(X)) Q:X'=+X  S Y=^BGPELDCA(X,0)  D
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
 I BGPOIEN S DA=BGPOIEN,DIK="^BGPELDCA(" D ^DIK S DA=BGPOIEN,DIK="^BGPELDPA(" D ^DIK S DA=BGPOIEN,DIK="^BGPELDBA(" D ^DIK
 ;add entry
 L +^BGPELDCA:10 I '$T W !!,"unable to lock global. TRY LATER" D EOJ Q
 L +^BGPELDPA:10 I '$T W !!,"unable to lock global. TRY LATER" D EOJ Q
 L +^BGPELDBA:10 I '$T W !!,"unable to lock global. TRY LATER" D EOJ Q
 D GETIEN^BGP7EUTL
 I 'BGPIEN W !!,"error in file creation...call programmer." D EOJ Q
ELCY ;
 S DINUM=BGPIEN,X=$P(BGP0,U),DLAYGO=90531.03,DIC="^BGPELDCA(",DIC(0)="L"
 K DD,D0,DO
 D FILE^DICN
 I Y=-1 W !,"error uploading file......" H 4 G EOJ
 S BGPIEN=+Y
 D ^XBFMK
 S X=0 F  S X=$O(^TMP("BGPUPL",$J,X)) Q:X'=+X  S V=^TMP("BGPUPL",$J,X,0) D
 .Q:$P(V,"|")'="BGPELDCA"
 .S V=$P(V,"|",2,9999)
 .S N=$P(V,"|"),N2=$P(V,"|",2),N3=$P(V,"|",3),N4=$P(V,"|",4),N5=$P(V,"|",5),D=$P(V,"|",8)
 .I N5]"" S ^BGPELDCA(BGPIEN,N,N2,N3,N4,N5)=D Q
 .I N4]"" S ^BGPELDCA(BGPIEN,N,N2,N3,N4)=D Q
 .I N3]"" S ^BGPELDCA(BGPIEN,N,N2,N3)=D Q
 .I N2]"" S ^BGPELDCA(BGPIEN,N,N2)=D Q
 .I N]"" S ^BGPELDCA(BGPIEN,N)=D
 .Q
 S DA=BGPIEN,DIK="^BGPELDCA(" D IX1^DIK
ELPY ;
 S DINUM=BGPIEN,X=$P(BGP0,U),DLAYGO=90531.04,DIC="^BGPELDPA(",DIC(0)="L"
 K DD,D0,DO
 D FILE^DICN
 I Y=-1 W !,"error uploading file......" H 4 G EOJ
 S BGPIEN=+Y
 D ^XBFMK
 S X=0 F  S X=$O(^TMP("BGPUPL",$J,X)) Q:X'=+X  S V=^TMP("BGPUPL",$J,X,0) D
 .Q:$P(V,"|")'="BGPELDPA"
 .S V=$P(V,"|",2,9999)
 .S N=$P(V,"|"),N2=$P(V,"|",2),N3=$P(V,"|",3),N4=$P(V,"|",4),N5=$P(V,"|",5),D=$P(V,"|",8)
 .I N5]"" S ^BGPELDPA(BGPIEN,N,N2,N3,N4,N5)=D Q
 .I N4]"" S ^BGPELDPA(BGPIEN,N,N2,N3,N4)=D Q
 .I N3]"" S ^BGPELDPA(BGPIEN,N,N2,N3)=D Q
 .I N2]"" S ^BGPELDPA(BGPIEN,N,N2)=D Q
 .I N]"" S ^BGPELDPA(BGPIEN,N)=D
 .Q
 S DA=BGPIEN,DIK="^BGPELDPA(" D IX1^DIK
ELBY ;
 S DINUM=BGPIEN,X=$P(BGP0,U),DLAYGO=90531.05,DIC="^BGPELDBA(",DIC(0)="L"
 K DD,D0,DO
 D FILE^DICN
 I Y=-1 W !,"error uploading file......" H 4 G EOJ
 S BGPIEN=+Y
 D ^XBFMK
 S X=0 F  S X=$O(^TMP("BGPUPL",$J,X)) Q:X'=+X  S V=^TMP("BGPUPL",$J,X,0) D
 .Q:$P(V,"|")'="BGPELDBA"
 .S V=$P(V,"|",2,9999)
 .S N=$P(V,"|"),N2=$P(V,"|",2),N3=$P(V,"|",3),N4=$P(V,"|",4),N5=$P(V,"|",5),D=$P(V,"|",8)
 .I N5]"" S ^BGPELDBA(BGPIEN,N,N2,N3,N4,N5)=D Q
 .I N4]"" S ^BGPELDBA(BGPIEN,N,N2,N3,N4)=D Q
 .I N3]"" S ^BGPELDBA(BGPIEN,N,N2,N3)=D Q
 .I N2]"" S ^BGPELDBA(BGPIEN,N,N2)=D Q
 .I N]"" S ^BGPELDBA(BGPIEN,N)=D
 .Q
 S DA=BGPIEN,DIK="^BGPELDBA(" D IX1^DIK
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
 S (X,BGPOIEN)=0 F  S X=$O(^BGPPEDCA(X)) Q:X'=+X  S Y=^BGPPEDCA(X,0)  D
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
 I BGPOIEN S DA=BGPOIEN,DIK="^BGPPEDCA(" D ^DIK S DA=BGPOIEN,DIK="^BGPPEDPA(" D ^DIK S DA=BGPOIEN,DIK="^BGPPEDBA(" D ^DIK
 ;add entry
 L +^BGPPEDCA:10 I '$T W !!,"unable to lock global. TRY LATER" D EOJ Q
 L +^BGPPEDPA:10 I '$T W !!,"unable to lock global. TRY LATER" D EOJ Q
 L +^BGPPEDBA:10 I '$T W !!,"unable to lock global. TRY LATER" D EOJ Q
 D GETIEN^BGP7PUTL
 I 'BGPIEN W !!,"error in file creation...call programmer." D EOJ Q
PEDCY ;
 S DINUM=BGPIEN,X=$P(BGP0,U),DLAYGO=90530.12,DIC="^BGPPEDCA(",DIC(0)="L"
 K DD,D0,DO
 D FILE^DICN
 I Y=-1 W !,"error uploading file......" H 4 G EOJ
 S BGPIEN=+Y
 D ^XBFMK
 S X=0 F  S X=$O(^TMP("BGPUPL",$J,X)) Q:X'=+X  S V=^TMP("BGPUPL",$J,X,0) D
 .Q:$P(V,"|")'="BGPPEDCA"
 .S V=$P(V,"|",2,9999)
 .S N=$P(V,"|"),N2=$P(V,"|",2),N3=$P(V,"|",3),N4=$P(V,"|",4),N5=$P(V,"|",5),D=$P(V,"|",8)
 .I N5]"" S ^BGPPEDCA(BGPIEN,N,N2,N3,N4,N5)=D Q
 .I N4]"" S ^BGPPEDCA(BGPIEN,N,N2,N3,N4)=D Q
 .I N3]"" S ^BGPPEDCA(BGPIEN,N,N2,N3)=D Q
 .I N2]"" S ^BGPPEDCA(BGPIEN,N,N2)=D Q
 .I N]"" S ^BGPPEDCA(BGPIEN,N)=D
 .Q
 S DA=BGPIEN,DIK="^BGPPEDCA(" D IX1^DIK
PEDPY ;
 S DINUM=BGPIEN,X=$P(BGP0,U),DLAYGO=90530.13,DIC="^BGPPEDPA(",DIC(0)="L"
 K DD,D0,DO
 D FILE^DICN
 I Y=-1 W !,"error uploading file......" H 4 G EOJ
 S BGPIEN=+Y
 D ^XBFMK
 S X=0 F  S X=$O(^TMP("BGPUPL",$J,X)) Q:X'=+X  S V=^TMP("BGPUPL",$J,X,0) D
 .Q:$P(V,"|")'="BGPPEDPA"
 .S V=$P(V,"|",2,9999)
 .S N=$P(V,"|"),N2=$P(V,"|",2),N3=$P(V,"|",3),N4=$P(V,"|",4),N5=$P(V,"|",5),D=$P(V,"|",8)
 .I N5]"" S ^BGPPEDPA(BGPIEN,N,N2,N3,N4,N5)=D Q
 .I N4]"" S ^BGPPEDPA(BGPIEN,N,N2,N3,N4)=D Q
 .I N3]"" S ^BGPPEDPA(BGPIEN,N,N2,N3)=D Q
 .I N2]"" S ^BGPPEDPA(BGPIEN,N,N2)=D Q
 .I N]"" S ^BGPPEDPA(BGPIEN,N)=D
 .Q
 S DA=BGPIEN,DIK="^BGPPEDPA(" D IX1^DIK
PEDBY ;
 S DINUM=BGPIEN,X=$P(BGP0,U),DLAYGO=90530.14,DIC="^BGPPEDBA(",DIC(0)="L"
 K DD,D0,DO
 D FILE^DICN
 I Y=-1 W !,"error uploading file......" H 4 G EOJ
 S BGPIEN=+Y
 D ^XBFMK
 S X=0 F  S X=$O(^TMP("BGPUPL",$J,X)) Q:X'=+X  S V=^TMP("BGPUPL",$J,X,0) D
 .Q:$P(V,"|")'="BGPPEDBA"
 .S V=$P(V,"|",2,9999)
 .S N=$P(V,"|"),N2=$P(V,"|",2),N3=$P(V,"|",3),N4=$P(V,"|",4),N5=$P(V,"|",5),D=$P(V,"|",8)
 .I N5]"" S ^BGPPEDBA(BGPIEN,N,N2,N3,N4,N5)=D Q
 .I N4]"" S ^BGPPEDBA(BGPIEN,N,N2,N3,N4)=D Q
 .I N3]"" S ^BGPPEDBA(BGPIEN,N,N2,N3)=D Q
 .I N2]"" S ^BGPPEDBA(BGPIEN,N,N2)=D Q
 .I N]"" S ^BGPPEDBA(BGPIEN,N)=D
 .Q
 S DA=BGPIEN,DIK="^BGPPEDBA(" D IX1^DIK
 W !,"Data uploaded."
 D EOJ
 Q
