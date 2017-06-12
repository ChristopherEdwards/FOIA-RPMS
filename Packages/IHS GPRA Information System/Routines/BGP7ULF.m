BGP7ULF ; IHS/CMI/LAB - UPLOAD AREA FILES ; 
 ;;17.0;IHS CLINICAL REPORTING;;AUG 30, 2016;Build 16
 ;
 ;
 W:$D(IOF) @IOF
 W !,"This option is used to upload a SU's 2017 CRS data.",!,"You must specify the directory in which the CRS 2017 data file resides",!,"and then enter the filename of the data.",!
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
 S DIR(0)="FO^2:30",DIR("A")="Enter filename w /ext (i.e. BG170101201.5)" K DA D ^DIR K DIR
 G:$D(DIRUT) DIR
 I Y="" G DIR
 I $E($$UP^XLFSTR(Y),1,5)'="BG170" W !!,"Filename must begin with BG170" G FILENAME
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
 S Q=""
 F X=1:1:9 I $P(BGP0,U,X)="" S Q=1
 I Q W !!,"File is corrupt, the site will need to re-run the report." K ^TMP("BGPUPL",$J) G EOJ
 S BGPG=$P($G(^TMP("BGPUPL",$J,1,0)),"|")
 F X=1:1:14,21 S Y="BGP"_X,@Y=$P(BGP0,U,X)
 I BGP21="" S BGP21="16"
 ;find existing entry and if exists, delete it
 S (X,BGPOIEN)=0 F  S X=$O(^BGPGPDCG(X)) Q:X'=+X  D
 .I '$D(^BGPGPDCG(X,0)) K ^BGPGPDCG(X) Q
 .S Y=^BGPGPDCG(X,0)
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
 I BGPOIEN S DA=BGPOIEN,DIK="^BGPGPDCG(" D ^DIK S DA=BGPOIEN,DIK="^BGPGPDPG(" D ^DIK S DA=BGPOIEN,DIK="^BGPGPDBG(" D ^DIK
 ;add entry
 L +^BGPGPDCG:10 I '$T W !!,"unable to lock global. TRY LATER" D EOJ Q
 L +^BGPGPDPG:10 I '$T W !!,"unable to lock global. TRY LATER" D EOJ Q
 L +^BGPGPDBG:10 I '$T W !!,"unable to lock global. TRY LATER" D EOJ Q
 D GETIEN^BGP7UTL
 I 'BGPIEN W !!,"error in file creation...call programmer." D EOJ Q
CY ;
 S DINUM=BGPIEN,X=$P(BGP0,U),DLAYGO=90558.03,DIC="^BGPGPDCG(",DIC(0)="L"
 K DD,D0,DO
 D FILE^DICN
 I Y=-1 W !,"error uploading file......" H 4 G EOJ
 S BGPIEN=+Y
 D ^XBFMK
 S X=0 F  S X=$O(^TMP("BGPUPL",$J,X)) Q:X'=+X  S V=^TMP("BGPUPL",$J,X,0) D
 .Q:$P(V,"|")'="BGPGPDCG"
 .S V=$P(V,"|",2,9999)
 .S N=$P(V,"|"),N2=$P(V,"|",2),N3=$P(V,"|",3),N4=$P(V,"|",4),N5=$P(V,"|",5),D=$P(V,"|",8)
 .I N5]"" S ^BGPGPDCG(BGPIEN,N,N2,N3,N4,N5)=D Q
 .I N4]"" S ^BGPGPDCG(BGPIEN,N,N2,N3,N4)=D Q
 .I N3]"" S ^BGPGPDCG(BGPIEN,N,N2,N3)=D Q
 .I N2]"" S ^BGPGPDCG(BGPIEN,N,N2)=D Q
 .I N]"" S ^BGPGPDCG(BGPIEN,N)=D
 .Q
 S DA=BGPIEN,DIK="^BGPGPDCG(" D IX1^DIK
PY ;
 S DINUM=BGPIEN,X=$P(BGP0,U),DLAYGO=90558.04,DIC="^BGPGPDPG(",DIC(0)="L"
 K DD,D0,DO
 D FILE^DICN
 I Y=-1 W !,"error uploading file......" H 4 G EOJ
 S BGPIEN=+Y
 D ^XBFMK
 S X=0 F  S X=$O(^TMP("BGPUPL",$J,X)) Q:X'=+X  S V=^TMP("BGPUPL",$J,X,0) D
 .Q:$P(V,"|")'="BGPGPDPG"
 .S V=$P(V,"|",2,9999)
 .S N=$P(V,"|"),N2=$P(V,"|",2),N3=$P(V,"|",3),N4=$P(V,"|",4),N5=$P(V,"|",5),D=$P(V,"|",8)
 .I N5]"" S ^BGPGPDPG(BGPIEN,N,N2,N3,N4,N5)=D Q
 .I N4]"" S ^BGPGPDPG(BGPIEN,N,N2,N3,N4)=D Q
 .I N3]"" S ^BGPGPDPG(BGPIEN,N,N2,N3)=D Q
 .I N2]"" S ^BGPGPDPG(BGPIEN,N,N2)=D Q
 .I N]"" S ^BGPGPDPG(BGPIEN,N)=D
 .Q
 S DA=BGPIEN,DIK="^BGPGPDPG(" D IX1^DIK
BY ;
 S DINUM=BGPIEN,X=$P(BGP0,U),DLAYGO=90558.05,DIC="^BGPGPDBG(",DIC(0)="L"
 K DD,D0,DO
 D FILE^DICN
 I Y=-1 W !,"error uploading file......" H 4 G EOJ
 S BGPIEN=+Y
 D ^XBFMK
 S X=0 F  S X=$O(^TMP("BGPUPL",$J,X)) Q:X'=+X  S V=^TMP("BGPUPL",$J,X,0) D
 .Q:$P(V,"|")'="BGPGPDBG"
 .S V=$P(V,"|",2,9999)
 .S N=$P(V,"|"),N2=$P(V,"|",2),N3=$P(V,"|",3),N4=$P(V,"|",4),N5=$P(V,"|",5),D=$P(V,"|",8)
 .I N5]"" S ^BGPGPDBG(BGPIEN,N,N2,N3,N4,N5)=D Q
 .I N4]"" S ^BGPGPDBG(BGPIEN,N,N2,N3,N4)=D Q
 .I N3]"" S ^BGPGPDBG(BGPIEN,N,N2,N3)=D Q
 .I N2]"" S ^BGPGPDBG(BGPIEN,N,N2)=D Q
 .I N]"" S ^BGPGPDBG(BGPIEN,N)=D
 .Q
 S DA=BGPIEN,DIK="^BGPGPDBG(" D IX1^DIK
 W !,"Data uploaded."
 D EOJ
 Q
EOJ ;EP
 L -^BGPGPDCG
 L -^BGPGPDPG
 L -^BGPGPDBG
 L -^BGPEDLCG
 L -^BGPEDLPG
 L -^BGPEDLBG
 L -^BGPPEDCG
 L -^BGPPEDPG
 L -^BGPPEDBG
 D EOP^BGP7DH
 K IOPAR
 D HOME^%ZIS
 K X,X1,X2,X3,X4,X5,X6
 K A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,V,W,X,Y,Z
 K N,N1,N2,N3,N4,N5,N6
 K DIC,DA,X,Y,%Y,%,BGPJ,BGPX,BGPTEXT,BGPLINE,BGP
 K BGP1,BGP2,BGP3,BGP4,BGP7,BGP7,BGP7,BGP8,BGP9,BGP10,BGP11,BGP12,BGP13,BGP14,BGP21
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
 S (X,BGPOIEN)=0 F  S X=$O(^BGPEDLCG(X)) Q:X'=+X  D
 .I '$D(^BGPEDLCG(X,0)) K ^BGPEDLCG(X) Q
 .S Y=^BGPEDLCG(X,0)
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
 I BGPOIEN S DA=BGPOIEN,DIK="^BGPEDLCG(" D ^DIK S DA=BGPOIEN,DIK="^BGPEDLPG(" D ^DIK S DA=BGPOIEN,DIK="^BGPEDLBG(" D ^DIK
 ;add entry
 L +^BGPEDLCG:10 I '$T W !!,"unable to lock global. TRY LATER" D EOJ Q
 L +^BGPEDLPG:10 I '$T W !!,"unable to lock global. TRY LATER" D EOJ Q
 L +^BGPEDLBG:10 I '$T W !!,"unable to lock global. TRY LATER" D EOJ Q
 D GETIEN^BGP7EUTL
 I 'BGPIEN W !!,"error in file creation...call programmer." D EOJ Q
ELCY ;
 S DINUM=BGPIEN,X=$P(BGP0,U),DLAYGO=90559.03,DIC="^BGPEDLCG(",DIC(0)="L"
 K DD,D0,DO
 D FILE^DICN
 I Y=-1 W !,"error uploading file......" H 4 G EOJ
 S BGPIEN=+Y
 D ^XBFMK
 S X=0 F  S X=$O(^TMP("BGPUPL",$J,X)) Q:X'=+X  S V=^TMP("BGPUPL",$J,X,0) D
 .Q:$P(V,"|")'="BGPEDLCG"
 .S V=$P(V,"|",2,9999)
 .S N=$P(V,"|"),N2=$P(V,"|",2),N3=$P(V,"|",3),N4=$P(V,"|",4),N5=$P(V,"|",5),D=$P(V,"|",8)
 .I N5]"" S ^BGPEDLCG(BGPIEN,N,N2,N3,N4,N5)=D Q
 .I N4]"" S ^BGPEDLCG(BGPIEN,N,N2,N3,N4)=D Q
 .I N3]"" S ^BGPEDLCG(BGPIEN,N,N2,N3)=D Q
 .I N2]"" S ^BGPEDLCG(BGPIEN,N,N2)=D Q
 .I N]"" S ^BGPEDLCG(BGPIEN,N)=D
 .Q
 S DA=BGPIEN,DIK="^BGPEDLCG(" D IX1^DIK
ELPY ;
 S DINUM=BGPIEN,X=$P(BGP0,U),DLAYGO=90559.04,DIC="^BGPEDLPG(",DIC(0)="L"
 K DD,D0,DO
 D FILE^DICN
 I Y=-1 W !,"error uploading file......" H 4 G EOJ
 S BGPIEN=+Y
 D ^XBFMK
 S X=0 F  S X=$O(^TMP("BGPUPL",$J,X)) Q:X'=+X  S V=^TMP("BGPUPL",$J,X,0) D
 .Q:$P(V,"|")'="BGPEDLPG"
 .S V=$P(V,"|",2,9999)
 .S N=$P(V,"|"),N2=$P(V,"|",2),N3=$P(V,"|",3),N4=$P(V,"|",4),N5=$P(V,"|",5),D=$P(V,"|",8)
 .I N5]"" S ^BGPEDLPG(BGPIEN,N,N2,N3,N4,N5)=D Q
 .I N4]"" S ^BGPEDLPG(BGPIEN,N,N2,N3,N4)=D Q
 .I N3]"" S ^BGPEDLPG(BGPIEN,N,N2,N3)=D Q
 .I N2]"" S ^BGPEDLPG(BGPIEN,N,N2)=D Q
 .I N]"" S ^BGPEDLPG(BGPIEN,N)=D
 .Q
 S DA=BGPIEN,DIK="^BGPEDLPG(" D IX1^DIK
ELBY ;
 S DINUM=BGPIEN,X=$P(BGP0,U),DLAYGO=90559.05,DIC="^BGPEDLBG(",DIC(0)="L"
 K DD,D0,DO
 D FILE^DICN
 I Y=-1 W !,"error uploading file......" H 4 G EOJ
 S BGPIEN=+Y
 D ^XBFMK
 S X=0 F  S X=$O(^TMP("BGPUPL",$J,X)) Q:X'=+X  S V=^TMP("BGPUPL",$J,X,0) D
 .Q:$P(V,"|")'="BGPEDLBG"
 .S V=$P(V,"|",2,9999)
 .S N=$P(V,"|"),N2=$P(V,"|",2),N3=$P(V,"|",3),N4=$P(V,"|",4),N5=$P(V,"|",5),D=$P(V,"|",8)
 .I N5]"" S ^BGPEDLBG(BGPIEN,N,N2,N3,N4,N5)=D Q
 .I N4]"" S ^BGPEDLBG(BGPIEN,N,N2,N3,N4)=D Q
 .I N3]"" S ^BGPEDLBG(BGPIEN,N,N2,N3)=D Q
 .I N2]"" S ^BGPEDLBG(BGPIEN,N,N2)=D Q
 .I N]"" S ^BGPEDLBG(BGPIEN,N)=D
 .Q
 S DA=BGPIEN,DIK="^BGPEDLBG(" D IX1^DIK
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
 S (X,BGPOIEN)=0 F  S X=$O(^BGPPEDCG(X)) Q:X'=+X  D
 .I '$D(^BGPPEDCG(X,0)) K ^BGPPEDCG(X) Q
 .S Y=^BGPPEDCG(X,0)
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
 I BGPOIEN S DA=BGPOIEN,DIK="^BGPPEDCG(" D ^DIK S DA=BGPOIEN,DIK="^BGPPEDPG(" D ^DIK S DA=BGPOIEN,DIK="^BGPPEDBG(" D ^DIK
 ;add entry
 L +^BGPPEDCG:10 I '$T W !!,"unable to lock global. TRY LATER" D EOJ Q
 L +^BGPPEDPG:10 I '$T W !!,"unable to lock global. TRY LATER" D EOJ Q
 L +^BGPPEDBG:10 I '$T W !!,"unable to lock global. TRY LATER" D EOJ Q
 D GETIEN^BGP7PUTL
 I 'BGPIEN W !!,"error in file creation...call programmer." D EOJ Q
PEDCY ;
 S DINUM=BGPIEN,X=$P(BGP0,U),DLAYGO=90558.12,DIC="^BGPPEDCG(",DIC(0)="L"
 K DD,D0,DO
 D FILE^DICN
 I Y=-1 W !,"error uploading file......" H 4 G EOJ
 S BGPIEN=+Y
 D ^XBFMK
 S X=0 F  S X=$O(^TMP("BGPUPL",$J,X)) Q:X'=+X  S V=^TMP("BGPUPL",$J,X,0) D
 .Q:$P(V,"|")'="BGPPEDCG"
 .S V=$P(V,"|",2,9999)
 .S N=$P(V,"|"),N2=$P(V,"|",2),N3=$P(V,"|",3),N4=$P(V,"|",4),N5=$P(V,"|",5),D=$P(V,"|",8)
 .I N5]"" S ^BGPPEDCG(BGPIEN,N,N2,N3,N4,N5)=D Q
 .I N4]"" S ^BGPPEDCG(BGPIEN,N,N2,N3,N4)=D Q
 .I N3]"" S ^BGPPEDCG(BGPIEN,N,N2,N3)=D Q
 .I N2]"" S ^BGPPEDCG(BGPIEN,N,N2)=D Q
 .I N]"" S ^BGPPEDCG(BGPIEN,N)=D
 .Q
 S DA=BGPIEN,DIK="^BGPPEDCG(" D IX1^DIK
PEDPY ;
 S DINUM=BGPIEN,X=$P(BGP0,U),DLAYGO=90558.13,DIC="^BGPPEDPG(",DIC(0)="L"
 K DD,D0,DO
 D FILE^DICN
 I Y=-1 W !,"error uploading file......" H 4 G EOJ
 S BGPIEN=+Y
 D ^XBFMK
 S X=0 F  S X=$O(^TMP("BGPUPL",$J,X)) Q:X'=+X  S V=^TMP("BGPUPL",$J,X,0) D
 .Q:$P(V,"|")'="BGPPEDPG"
 .S V=$P(V,"|",2,9999)
 .S N=$P(V,"|"),N2=$P(V,"|",2),N3=$P(V,"|",3),N4=$P(V,"|",4),N5=$P(V,"|",5),D=$P(V,"|",8)
 .I N5]"" S ^BGPPEDPG(BGPIEN,N,N2,N3,N4,N5)=D Q
 .I N4]"" S ^BGPPEDPG(BGPIEN,N,N2,N3,N4)=D Q
 .I N3]"" S ^BGPPEDPG(BGPIEN,N,N2,N3)=D Q
 .I N2]"" S ^BGPPEDPG(BGPIEN,N,N2)=D Q
 .I N]"" S ^BGPPEDPG(BGPIEN,N)=D
 .Q
 S DA=BGPIEN,DIK="^BGPPEDPG(" D IX1^DIK
PEDBY ;
 S DINUM=BGPIEN,X=$P(BGP0,U),DLAYGO=90558.14,DIC="^BGPPEDBG(",DIC(0)="L"
 K DD,D0,DO
 D FILE^DICN
 I Y=-1 W !,"error uploading file......" H 4 G EOJ
 S BGPIEN=+Y
 D ^XBFMK
 S X=0 F  S X=$O(^TMP("BGPUPL",$J,X)) Q:X'=+X  S V=^TMP("BGPUPL",$J,X,0) D
 .Q:$P(V,"|")'="BGPPEDBG"
 .S V=$P(V,"|",2,9999)
 .S N=$P(V,"|"),N2=$P(V,"|",2),N3=$P(V,"|",3),N4=$P(V,"|",4),N5=$P(V,"|",5),D=$P(V,"|",8)
 .I N5]"" S ^BGPPEDBG(BGPIEN,N,N2,N3,N4,N5)=D Q
 .I N4]"" S ^BGPPEDBG(BGPIEN,N,N2,N3,N4)=D Q
 .I N3]"" S ^BGPPEDBG(BGPIEN,N,N2,N3)=D Q
 .I N2]"" S ^BGPPEDBG(BGPIEN,N,N2)=D Q
 .I N]"" S ^BGPPEDBG(BGPIEN,N)=D
 .Q
 S DA=BGPIEN,DIK="^BGPPEDBG(" D IX1^DIK
 W !,"Data uploaded."
 D EOJ
 Q
