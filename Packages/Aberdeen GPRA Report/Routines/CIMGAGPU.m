CIMGAGPU ; CMI/TUCSON/LAB - NO DESCRIPTION PROVIDED ;  
 ;;1.0;ABERDEEN GPRA REPORT;;JAN 22, 2000
 ;
 ;
 W:$D(IOF) @IOF
 W !,"This option is used to upload a SU's GPRA data.",!,"You must specify the directory in which the GPRA data files resides",!,"and then enter the filename of the GPRA data.",!
FILE ;upload global
DIR ;
 K DIR
 S CIMDIR=""
 S DIR(0)="F^3:30",DIR("A")="Enter directory path (i.e. /usr/spool/uucppublic/)" K DA D ^DIR K DIR
 I $D(DIRUT) W !!,"Directory not entered!!  Bye." G XIT
 S CIMDIR=Y
 S CIMFILE=""
 S DIR(0)="F^2:30",DIR("A")="Enter filename w /ext (i.e. G101201.5)" K DA D ^DIR K DIR
 G:$D(DIRUT) DIR
 S CIMFILE=Y
 W !,"Directory=",CIMDIR,"  ","File=",CIMFILE
READF ;read file
 NEW Y,X,I,CIMC
 S CIMC=1
 S Y=$$OPEN^%ZISH(CIMDIR,CIMFILE,"R")
 I Y W !,*7,"CANNOT OPEN (OR ACCESS) FILE '",CIMDIR,CIMFILE,"'." G XIT
 KILL ^TMP("CIMGPRA",$J)
 F I=1:1 U IO R X:DTIME S X=$$STRIP(X) S ^TMP("CIMGPRA",$J,CIMC,0)=X,CIMC=CIMC+1 Q:$$STATUS^%ZISH=-1
 D ^%ZISC
 W !!,"All done reading file",!
PROC ;
 W !,"Processing",!
 S CIM0=$P($G(^TMP("CIMGPRA",$J,1,0)),"|",8)
 I $L(CIM0,U)'=6 W "error in data" H 3 G XIT
 ;find existing entry and if exists, delete it
 S (X,CIMOIEN)=0 F  S X=$O(^CIMAGP(X)) Q:X'=+X  S Y=^CIMAGP(X,0) I Y=CIM0 S CIMOIEN=X
 D ^XBFMK
 I CIMOIEN S DA=CIMOIEN,DIK="^CIMAGP(" D ^DIK
 ;add entry
 S X=$P(CIM0,U),DLAYGO=19255.01,DIC="^CIMAGP(",DIC(0)="L"
 K DD,D0,DO
 D FILE^DICN
 I Y=-1 W !,"error uploading file......" H 4 G XIT
 S CIMIEN=+Y
 D ^XBFMK
 ;S X=0 F  S X=$O(^TMP("CIMGPRA",$J,X)) Q:X'=+X  S V=^TMP("CIMGPRA",$J,X,0) S N=$P(V,"|"),D=$P(V,"|",2) I N]"" S ^CIMAGP(CIMIEN,N)=D
 S X=0 F  S X=$O(^TMP("CIMGPRA",$J,X)) Q:X'=+X  S V=^TMP("CIMGPRA",$J,X,0) D
 .S N=$P(V,"|"),N2=$P(V,"|",2),N3=$P(V,"|",3),N4=$P(V,"|",4),N5=$P(V,"|",5),D=$P(V,"|",8)
 .I N5]"" S ^CIMAGP(CIMIEN,N,N2,N3,N4,N5)=D Q
 .I N4]"" S ^CIMAGP(CIMIEN,N,N2,N3,N4)=D Q
 .I N3]"" S ^CIMAGP(CIMIEN,N,N2,N3)=D Q
 .I N2]"" S ^CIMAGP(CIMIEN,N,N2)=D Q
 .I N]"" S ^CIMAGP(CIMIEN,N)=D
 .Q
 S DA=CIMIEN,DIK="^CIMAGP(" D IX1^DIK
 W !,"Data uploaded."
 D XIT
 Q
XIT ;
 K IOPAR
 D HOME^%ZIS
 D EN^XBVK("CIM")
 K X,X1,X2,X3,X4,X5,X6
 K A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,V,W,X,Y,Z
 K N,N1,N2,N3,N4,N5,N6
 K DIC,DA,X,Y,%Y,%,CIMJ,CIMX,CIMTEXT,CIMLINE,CIM
 Q
STRIP(Z) ;REMOVE CONTROLL CHARACTERS
 NEW I
 F I=1:1:$L(Z) I (32>$A($E(Z,I))) S Z=$E(Z,1,I-1)_" "_$E(Z,I+1,999)
 Q Z
 ;
 ;
BANNER ;EP
V ; GET VERSION
 S CIM("VERSION")="1.0  January, 2000"
 I $G(CIMTEXT)="" S CIMTEXT="TEXT",CIMLINE=3 G PRINT
 S CIMTEXT="TEXT"_CIMTEXT
 F CIMJ=1:1 S CIMX=$T(@CIMTEXT+CIMJ),CIMX=$P(CIMX,";;",2) Q:CIMX="QUIT"!(CIMX="")  S CIMLINE=CIMJ
PRINT W:$D(IOF) @IOF
 F CIMJ=1:1:CIMLINE S CIMX=$T(@CIMTEXT+CIMJ),CIMX=$P(CIMX,";;",2) W !?80-$L(CIMX)\2,CIMX K CIMX
 W !?80-(8+$L(CIM("VERSION")))/2,"Version ",CIM("VERSION")
SITE G XIT:'$D(DUZ(2)) G:'DUZ(2) XIT S CIM("SITE")=$P(^DIC(4,DUZ(2),0),"^") W !!?80-$L(CIM("SITE"))\2,CIM("SITE")
TEXT ;
 ;;***************************************************
 ;;**   Aberdeen Area GPRA Data Reporting System    **
 ;;***************************************************
 ;;QUIT
