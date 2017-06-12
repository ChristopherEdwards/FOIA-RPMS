BGP6ULF ; IHS/CMI/LAB - NO DESCRIPTION PROVIDED 27 May 2016 4:26 PM 09 Apr 2016 3:29 PM ; 08 Mar 2016  11:16 AM
 ;;16.1;IHS CLINICAL REPORTING;;MAR 22, 2016;Build 170
 ;
 ;
 W:$D(IOF) @IOF
 W !,"This option is used to upload a SU's 2016 CRS data.",!,"You must specify the directory in which the CRS 2016 data file resides",!,"and then enter the filename of the data.",!
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
 S DIR(0)="FO^2:30",DIR("A")="Enter filename w /ext (i.e. BG161101201.5)" K DA D ^DIR K DIR
 G:$D(DIRUT) DIR
 I Y="" G DIR
 I $E($$UP^XLFSTR(Y),1,5)'="BG161" W !!,"Filename must begin with BG161" G FILENAME
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
 S (X,BGPOIEN)=0 F  S X=$O(^BGPGPDCM(X)) Q:X'=+X  D
 .I '$D(^BGPGPDCM(X,0)) K ^BGPGPDCM(X) Q
 .S Y=^BGPGPDCM(X,0)
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
 I BGPOIEN S DA=BGPOIEN,DIK="^BGPGPDCM(" D ^DIK S DA=BGPOIEN,DIK="^BGPGPDPM(" D ^DIK S DA=BGPOIEN,DIK="^BGPGPDBM(" D ^DIK
 ;add entry
 L +^BGPGPDCM:10 I '$T W !!,"unable to lock global. TRY LATER" D EOJ Q
 L +^BGPGPDPM:10 I '$T W !!,"unable to lock global. TRY LATER" D EOJ Q
 L +^BGPGPDBM:10 I '$T W !!,"unable to lock global. TRY LATER" D EOJ Q
 D GETIEN^BGP6UTL
 I 'BGPIEN W !!,"error in file creation...call programmer." D EOJ Q
CY ;
 S DINUM=BGPIEN,X=$P(BGP0,U),DLAYGO=90556.03,DIC="^BGPGPDCM(",DIC(0)="L"
 K DD,D0,DO
 D FILE^DICN
 I Y=-1 W !,"error uploading file......" H 4 G EOJ
 S BGPIEN=+Y
 D ^XBFMK
 S X=0 F  S X=$O(^TMP("BGPUPL",$J,X)) Q:X'=+X  S V=^TMP("BGPUPL",$J,X,0) D
 .Q:$P(V,"|")'="BGPGPDCM"
 .S V=$P(V,"|",2,9999)
 .S N=$P(V,"|"),N2=$P(V,"|",2),N3=$P(V,"|",3),N4=$P(V,"|",4),N5=$P(V,"|",5),D=$P(V,"|",8)
 .I N5]"" S ^BGPGPDCM(BGPIEN,N,N2,N3,N4,N5)=D Q
 .I N4]"" S ^BGPGPDCM(BGPIEN,N,N2,N3,N4)=D Q
 .I N3]"" S ^BGPGPDCM(BGPIEN,N,N2,N3)=D Q
 .I N2]"" S ^BGPGPDCM(BGPIEN,N,N2)=D Q
 .I N]"" S ^BGPGPDCM(BGPIEN,N)=D
 .Q
 S DA=BGPIEN,DIK="^BGPGPDCM(" D IX1^DIK
PY ;
 S DINUM=BGPIEN,X=$P(BGP0,U),DLAYGO=90556.04,DIC="^BGPGPDPM(",DIC(0)="L"
 K DD,D0,DO
 D FILE^DICN
 I Y=-1 W !,"error uploading file......" H 4 G EOJ
 S BGPIEN=+Y
 D ^XBFMK
 S X=0 F  S X=$O(^TMP("BGPUPL",$J,X)) Q:X'=+X  S V=^TMP("BGPUPL",$J,X,0) D
 .Q:$P(V,"|")'="BGPGPDPM"
 .S V=$P(V,"|",2,9999)
 .S N=$P(V,"|"),N2=$P(V,"|",2),N3=$P(V,"|",3),N4=$P(V,"|",4),N5=$P(V,"|",5),D=$P(V,"|",8)
 .I N5]"" S ^BGPGPDPM(BGPIEN,N,N2,N3,N4,N5)=D Q
 .I N4]"" S ^BGPGPDPM(BGPIEN,N,N2,N3,N4)=D Q
 .I N3]"" S ^BGPGPDPM(BGPIEN,N,N2,N3)=D Q
 .I N2]"" S ^BGPGPDPM(BGPIEN,N,N2)=D Q
 .I N]"" S ^BGPGPDPM(BGPIEN,N)=D
 .Q
 S DA=BGPIEN,DIK="^BGPGPDPM(" D IX1^DIK
BY ;
 S DINUM=BGPIEN,X=$P(BGP0,U),DLAYGO=90556.05,DIC="^BGPGPDBM(",DIC(0)="L"
 K DD,D0,DO
 D FILE^DICN
 I Y=-1 W !,"error uploading file......" H 4 G EOJ
 S BGPIEN=+Y
 D ^XBFMK
 S X=0 F  S X=$O(^TMP("BGPUPL",$J,X)) Q:X'=+X  S V=^TMP("BGPUPL",$J,X,0) D
 .Q:$P(V,"|")'="BGPGPDBM"
 .S V=$P(V,"|",2,9999)
 .S N=$P(V,"|"),N2=$P(V,"|",2),N3=$P(V,"|",3),N4=$P(V,"|",4),N5=$P(V,"|",5),D=$P(V,"|",8)
 .I N5]"" S ^BGPGPDBM(BGPIEN,N,N2,N3,N4,N5)=D Q
 .I N4]"" S ^BGPGPDBM(BGPIEN,N,N2,N3,N4)=D Q
 .I N3]"" S ^BGPGPDBM(BGPIEN,N,N2,N3)=D Q
 .I N2]"" S ^BGPGPDBM(BGPIEN,N,N2)=D Q
 .I N]"" S ^BGPGPDBM(BGPIEN,N)=D
 .Q
 S DA=BGPIEN,DIK="^BGPGPDBM(" D IX1^DIK
 W !,"Data uploaded."
 D EOJ
 Q
EOJ ;EP
 L -^BGPGPDCM
 L -^BGPGPDPM
 L -^BGPGPDBM
 L -^BGPELDCM
 L -^BGPELDPM
 L -^BGPELDBM
 L -^BGPPEDCM
 L -^BGPPEDPM
 L -^BGPPEDBM
 D EOP^BGP6DH
 K IOPAR
 D HOME^%ZIS
 K X,X1,X2,X3,X4,X5,X6
 K A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,V,W,X,Y,Z
 K N,N1,N2,N3,N4,N5,N6
 K DIC,DA,X,Y,%Y,%,BGPJ,BGPX,BGPTEXT,BGPLINE,BGP
 K BGP1,BGP2,BGP3,BGP4,BGP6,BGP6,BGP7,BGP8,BGP9,BGP10,BGP11,BGP12,BGP13,BGP14,BGP21
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
 S (X,BGPOIEN)=0 F  S X=$O(^BGPELDCM(X)) Q:X'=+X  D
 .I '$D(^BGPELDCM(X,0)) K ^BGPELDCM(X) Q
 .S Y=^BGPELDCM(X,0)
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
 I BGPOIEN S DA=BGPOIEN,DIK="^BGPELDCM(" D ^DIK S DA=BGPOIEN,DIK="^BGPELDPM(" D ^DIK S DA=BGPOIEN,DIK="^BGPELDBM(" D ^DIK
 ;add entry
 L +^BGPELDCM:10 I '$T W !!,"unable to lock global. TRY LATER" D EOJ Q
 L +^BGPELDPM:10 I '$T W !!,"unable to lock global. TRY LATER" D EOJ Q
 L +^BGPELDBM:10 I '$T W !!,"unable to lock global. TRY LATER" D EOJ Q
 D GETIEN^BGP6EUTL
 I 'BGPIEN W !!,"error in file creation...call programmer." D EOJ Q
ELCY ;
 S DINUM=BGPIEN,X=$P(BGP0,U),DLAYGO=90557.03,DIC="^BGPELDCM(",DIC(0)="L"
 K DD,D0,DO
 D FILE^DICN
 I Y=-1 W !,"error uploading file......" H 4 G EOJ
 S BGPIEN=+Y
 D ^XBFMK
 S X=0 F  S X=$O(^TMP("BGPUPL",$J,X)) Q:X'=+X  S V=^TMP("BGPUPL",$J,X,0) D
 .Q:$P(V,"|")'="BGPELDCM"
 .S V=$P(V,"|",2,9999)
 .S N=$P(V,"|"),N2=$P(V,"|",2),N3=$P(V,"|",3),N4=$P(V,"|",4),N5=$P(V,"|",5),D=$P(V,"|",8)
 .I N5]"" S ^BGPELDCM(BGPIEN,N,N2,N3,N4,N5)=D Q
 .I N4]"" S ^BGPELDCM(BGPIEN,N,N2,N3,N4)=D Q
 .I N3]"" S ^BGPELDCM(BGPIEN,N,N2,N3)=D Q
 .I N2]"" S ^BGPELDCM(BGPIEN,N,N2)=D Q
 .I N]"" S ^BGPELDCM(BGPIEN,N)=D
 .Q
 S DA=BGPIEN,DIK="^BGPELDCM(" D IX1^DIK
ELPY ;
 S DINUM=BGPIEN,X=$P(BGP0,U),DLAYGO=90557.04,DIC="^BGPELDPM(",DIC(0)="L"
 K DD,D0,DO
 D FILE^DICN
 I Y=-1 W !,"error uploading file......" H 4 G EOJ
 S BGPIEN=+Y
 D ^XBFMK
 S X=0 F  S X=$O(^TMP("BGPUPL",$J,X)) Q:X'=+X  S V=^TMP("BGPUPL",$J,X,0) D
 .Q:$P(V,"|")'="BGPELDPM"
 .S V=$P(V,"|",2,9999)
 .S N=$P(V,"|"),N2=$P(V,"|",2),N3=$P(V,"|",3),N4=$P(V,"|",4),N5=$P(V,"|",5),D=$P(V,"|",8)
 .I N5]"" S ^BGPELDPM(BGPIEN,N,N2,N3,N4,N5)=D Q
 .I N4]"" S ^BGPELDPM(BGPIEN,N,N2,N3,N4)=D Q
 .I N3]"" S ^BGPELDPM(BGPIEN,N,N2,N3)=D Q
 .I N2]"" S ^BGPELDPM(BGPIEN,N,N2)=D Q
 .I N]"" S ^BGPELDPM(BGPIEN,N)=D
 .Q
 S DA=BGPIEN,DIK="^BGPELDPM(" D IX1^DIK
ELBY ;
 S DINUM=BGPIEN,X=$P(BGP0,U),DLAYGO=90557.05,DIC="^BGPELDBM(",DIC(0)="L"
 K DD,D0,DO
 D FILE^DICN
 I Y=-1 W !,"error uploading file......" H 4 G EOJ
 S BGPIEN=+Y
 D ^XBFMK
 S X=0 F  S X=$O(^TMP("BGPUPL",$J,X)) Q:X'=+X  S V=^TMP("BGPUPL",$J,X,0) D
 .Q:$P(V,"|")'="BGPELDBM"
 .S V=$P(V,"|",2,9999)
 .S N=$P(V,"|"),N2=$P(V,"|",2),N3=$P(V,"|",3),N4=$P(V,"|",4),N5=$P(V,"|",5),D=$P(V,"|",8)
 .I N5]"" S ^BGPELDBM(BGPIEN,N,N2,N3,N4,N5)=D Q
 .I N4]"" S ^BGPELDBM(BGPIEN,N,N2,N3,N4)=D Q
 .I N3]"" S ^BGPELDBM(BGPIEN,N,N2,N3)=D Q
 .I N2]"" S ^BGPELDBM(BGPIEN,N,N2)=D Q
 .I N]"" S ^BGPELDBM(BGPIEN,N)=D
 .Q
 S DA=BGPIEN,DIK="^BGPELDBM(" D IX1^DIK
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
 S (X,BGPOIEN)=0 F  S X=$O(^BGPPEDCM(X)) Q:X'=+X  D
 .I '$D(^BGPPEDCM(X,0)) K ^BGPPEDCM(X) Q
 .S Y=^BGPPEDCM(X,0)
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
 I BGPOIEN S DA=BGPOIEN,DIK="^BGPPEDCM(" D ^DIK S DA=BGPOIEN,DIK="^BGPPEDPM(" D ^DIK S DA=BGPOIEN,DIK="^BGPPEDBM(" D ^DIK
 ;add entry
 L +^BGPPEDCM:10 I '$T W !!,"unable to lock global. TRY LATER" D EOJ Q
 L +^BGPPEDPM:10 I '$T W !!,"unable to lock global. TRY LATER" D EOJ Q
 L +^BGPPEDBM:10 I '$T W !!,"unable to lock global. TRY LATER" D EOJ Q
 D GETIEN^BGP6PUTL
 I 'BGPIEN W !!,"error in file creation...call programmer." D EOJ Q
PEDCY ;
 S DINUM=BGPIEN,X=$P(BGP0,U),DLAYGO=90556.12,DIC="^BGPPEDCM(",DIC(0)="L"
 K DD,D0,DO
 D FILE^DICN
 I Y=-1 W !,"error uploading file......" H 4 G EOJ
 S BGPIEN=+Y
 D ^XBFMK
 S X=0 F  S X=$O(^TMP("BGPUPL",$J,X)) Q:X'=+X  S V=^TMP("BGPUPL",$J,X,0) D
 .Q:$P(V,"|")'="BGPPEDCM"
 .S V=$P(V,"|",2,9999)
 .S N=$P(V,"|"),N2=$P(V,"|",2),N3=$P(V,"|",3),N4=$P(V,"|",4),N5=$P(V,"|",5),D=$P(V,"|",8)
 .I N5]"" S ^BGPPEDCM(BGPIEN,N,N2,N3,N4,N5)=D Q
 .I N4]"" S ^BGPPEDCM(BGPIEN,N,N2,N3,N4)=D Q
 .I N3]"" S ^BGPPEDCM(BGPIEN,N,N2,N3)=D Q
 .I N2]"" S ^BGPPEDCM(BGPIEN,N,N2)=D Q
 .I N]"" S ^BGPPEDCM(BGPIEN,N)=D
 .Q
 S DA=BGPIEN,DIK="^BGPPEDCM(" D IX1^DIK
PEDPY ;
 S DINUM=BGPIEN,X=$P(BGP0,U),DLAYGO=90556.13,DIC="^BGPPEDPM(",DIC(0)="L"
 K DD,D0,DO
 D FILE^DICN
 I Y=-1 W !,"error uploading file......" H 4 G EOJ
 S BGPIEN=+Y
 D ^XBFMK
 S X=0 F  S X=$O(^TMP("BGPUPL",$J,X)) Q:X'=+X  S V=^TMP("BGPUPL",$J,X,0) D
 .Q:$P(V,"|")'="BGPPEDPM"
 .S V=$P(V,"|",2,9999)
 .S N=$P(V,"|"),N2=$P(V,"|",2),N3=$P(V,"|",3),N4=$P(V,"|",4),N5=$P(V,"|",5),D=$P(V,"|",8)
 .I N5]"" S ^BGPPEDPM(BGPIEN,N,N2,N3,N4,N5)=D Q
 .I N4]"" S ^BGPPEDPM(BGPIEN,N,N2,N3,N4)=D Q
 .I N3]"" S ^BGPPEDPM(BGPIEN,N,N2,N3)=D Q
 .I N2]"" S ^BGPPEDPM(BGPIEN,N,N2)=D Q
 .I N]"" S ^BGPPEDPM(BGPIEN,N)=D
 .Q
 S DA=BGPIEN,DIK="^BGPPEDPM(" D IX1^DIK
PEDBY ;
 S DINUM=BGPIEN,X=$P(BGP0,U),DLAYGO=90556.14,DIC="^BGPPEDBM(",DIC(0)="L"
 K DD,D0,DO
 D FILE^DICN
 I Y=-1 W !,"error uploading file......" H 4 G EOJ
 S BGPIEN=+Y
 D ^XBFMK
 S X=0 F  S X=$O(^TMP("BGPUPL",$J,X)) Q:X'=+X  S V=^TMP("BGPUPL",$J,X,0) D
 .Q:$P(V,"|")'="BGPPEDBM"
 .S V=$P(V,"|",2,9999)
 .S N=$P(V,"|"),N2=$P(V,"|",2),N3=$P(V,"|",3),N4=$P(V,"|",4),N5=$P(V,"|",5),D=$P(V,"|",8)
 .I N5]"" S ^BGPPEDBM(BGPIEN,N,N2,N3,N4,N5)=D Q
 .I N4]"" S ^BGPPEDBM(BGPIEN,N,N2,N3,N4)=D Q
 .I N3]"" S ^BGPPEDBM(BGPIEN,N,N2,N3)=D Q
 .I N2]"" S ^BGPPEDBM(BGPIEN,N,N2)=D Q
 .I N]"" S ^BGPPEDBM(BGPIEN,N)=D
 .Q
 S DA=BGPIEN,DIK="^BGPPEDBM(" D IX1^DIK
 W !,"Data uploaded."
 D EOJ
 Q
