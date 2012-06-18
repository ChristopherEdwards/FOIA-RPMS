BGP3ULF ; IHS/CMI/LAB - NO DESCRIPTION PROVIDED ;
 ;;7.0;IHS CLINICAL REPORTING;;JAN 24, 2007
 ;
 ;
 W:$D(IOF) @IOF
 W !,"This option is used to upload a SU's FY 03 GPRA data.",!,"You must specify the directory in which the GPRA data file resides",!,"and then enter the filename of the GPRA data.",!
FILE ;upload global
 D HOME^%ZIS
DIR ;
 K DIR
 S BGPDIR=""
 S DIR(0)="F^3:50",DIR("A")="Enter directory path (i.e. /usr/spool/uucppublic/)" K DA D ^DIR K DIR
 I $D(DIRUT) W !!,"Directory not entered!!  Bye." G XIT
 S BGPDIR=Y
 S BGPFILE=""
 S DIR(0)="F^2:30",DIR("A")="Enter filename w /ext (i.e. BG03101201.5)" K DA D ^DIR K DIR
 G:$D(DIRUT) DIR
 I $E($$UP^XLFSTR(Y),1,4)'="BG03" W !!,"Filename must begin with BG03" G FILE
 S BGPFILE=Y
 W !,"Directory=",BGPDIR,"  ","File=",BGPFILE
READF ;read file
 NEW Y,X,I,BGPC
 S BGPC=1
 S Y=$$OPEN^%ZISH(BGPDIR,BGPFILE,"R")
 I Y W !,*7,"CANNOT OPEN (OR ACCESS) FILE '",BGPDIR,BGPFILE,"'." G XIT
 KILL ^TMP("BGPUPL",$J)
 F I=1:1 U IO R X:DTIME S X=$$STRIP(X) Q:X=""  S ^TMP("BGPUPL",$J,BGPC,0)=X,BGPC=BGPC+1 Q:$$STATUS^%ZISH=-1
 D ^%ZISC
 W !!,"All done reading file",!
PROC ;
 W !,"Processing",!
 S BGP0=$P($G(^TMP("BGPUPL",$J,1,0)),"|",9)
 S BGPG=$P($G(^TMP("BGPUPL",$J,1,0)),"|")
 F X=1:1:12 S Y="BGP"_X,@Y=$P(BGP0,U,X)
 ;find existing entry and if exists, delete it
 S (X,BGPOIEN)=0 F  S X=$O(^BGPGPDC(X)) Q:X'=+X  S Y=^BGPGPDC(X,0)  D
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
 .S BGPOIEN=X
 D ^XBFMK
 I BGPOIEN S DA=BGPOIEN,DIK="^BGPGPDC(" D ^DIK S DA=BGPOIEN,DIK="^BGPGPDP(" D ^DIK S DA=BGPOIEN,DIK="^BGPGPDB(" D ^DIK
 ;add entry
 L +^BGPGPDC:10 I '$T W !!,"unable to lock global. TRY LATER" D XIT Q
 L +^BGPGPDP:10 I '$T W !!,"unable to lock global. TRY LATER" D XIT Q
 L +^BGPGPDB:10 I '$T W !!,"unable to lock global. TRY LATER" D XIT Q
 D GETIEN^BGP3UTL
 I 'BGPIEN W !!,"error in file creation...call programmer." D XIT Q
CY ;
 S DINUM=BGPIEN,X=$P(BGP0,U),DLAYGO=90243,DIC="^BGPGPDC(",DIC(0)="L"
 K DD,D0,DO
 D FILE^DICN
 I Y=-1 W !,"error uploading file......" H 4 G XIT
 S BGPIEN=+Y
 D ^XBFMK
 S X=0 F  S X=$O(^TMP("BGPUPL",$J,X)) Q:X'=+X  S V=^TMP("BGPUPL",$J,X,0) D
 .Q:$P(V,"|")'="BGPGPDC"
 .S V=$P(V,"|",2,9999)
 .S N=$P(V,"|"),N2=$P(V,"|",2),N3=$P(V,"|",3),N4=$P(V,"|",4),N5=$P(V,"|",5),D=$P(V,"|",8)
 .I N5]"" S ^BGPGPDC(BGPIEN,N,N2,N3,N4,N5)=D Q
 .I N4]"" S ^BGPGPDC(BGPIEN,N,N2,N3,N4)=D Q
 .I N3]"" S ^BGPGPDC(BGPIEN,N,N2,N3)=D Q
 .I N2]"" S ^BGPGPDC(BGPIEN,N,N2)=D Q
 .I N]"" S ^BGPGPDC(BGPIEN,N)=D
 .Q
 S DA=BGPIEN,DIK="^BGPGPDC(" D IX1^DIK
PY ;
 S DINUM=BGPIEN,X=$P(BGP0,U),DLAYGO=90243.01,DIC="^BGPGPDP(",DIC(0)="L"
 K DD,D0,DO
 D FILE^DICN
 I Y=-1 W !,"error uploading file......" H 4 G XIT
 S BGPIEN=+Y
 D ^XBFMK
 S X=0 F  S X=$O(^TMP("BGPUPL",$J,X)) Q:X'=+X  S V=^TMP("BGPUPL",$J,X,0) D
 .Q:$P(V,"|")'="BGPGPDP"
 .S V=$P(V,"|",2,9999)
 .S N=$P(V,"|"),N2=$P(V,"|",2),N3=$P(V,"|",3),N4=$P(V,"|",4),N5=$P(V,"|",5),D=$P(V,"|",8)
 .I N5]"" S ^BGPGPDP(BGPIEN,N,N2,N3,N4,N5)=D Q
 .I N4]"" S ^BGPGPDP(BGPIEN,N,N2,N3,N4)=D Q
 .I N3]"" S ^BGPGPDP(BGPIEN,N,N2,N3)=D Q
 .I N2]"" S ^BGPGPDP(BGPIEN,N,N2)=D Q
 .I N]"" S ^BGPGPDP(BGPIEN,N)=D
 .Q
 S DA=BGPIEN,DIK="^BGPGPDP(" D IX1^DIK
BY ;
 S DINUM=BGPIEN,X=$P(BGP0,U),DLAYGO=90243.02,DIC="^BGPGPDB(",DIC(0)="L"
 K DD,D0,DO
 D FILE^DICN
 I Y=-1 W !,"error uploading file......" H 4 G XIT
 S BGPIEN=+Y
 D ^XBFMK
 S X=0 F  S X=$O(^TMP("BGPUPL",$J,X)) Q:X'=+X  S V=^TMP("BGPUPL",$J,X,0) D
 .Q:$P(V,"|")'="BGPGPDB"
 .S V=$P(V,"|",2,9999)
 .S N=$P(V,"|"),N2=$P(V,"|",2),N3=$P(V,"|",3),N4=$P(V,"|",4),N5=$P(V,"|",5),D=$P(V,"|",8)
 .I N5]"" S ^BGPGPDB(BGPIEN,N,N2,N3,N4,N5)=D Q
 .I N4]"" S ^BGPGPDB(BGPIEN,N,N2,N3,N4)=D Q
 .I N3]"" S ^BGPGPDB(BGPIEN,N,N2,N3)=D Q
 .I N2]"" S ^BGPGPDB(BGPIEN,N,N2)=D Q
 .I N]"" S ^BGPGPDB(BGPIEN,N)=D
 .Q
 S DA=BGPIEN,DIK="^BGPGPDB(" D IX1^DIK
 W !,"Data uploaded."
 D XIT
 Q
XIT ;
 L -^BGPGPDC
 L -^BGPGPDP
 L -^BGPGPDB
 D EOP^BGPDH
 K IOPAR
 D HOME^%ZIS
 D EN^XBVK("BGP")
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
 ;
