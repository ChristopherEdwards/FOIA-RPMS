BGP9GUPL ; IHS/CMI/LAB - GUI Upload ;
 ;;9.0;IHS CLINICAL REPORTING;**1**;JUL 01, 2009
 ;
 ;
EP(BGPRET,BGPUSER,BGPDUZ2,BGPOPTN,BGPDIR,BGPFILE,BGPRTIME) ;EP - called from GUI to produce COM REPORT CI05-AO-UPL
 ; SEE ROUTINE BGP9DL if you have questions about any of these variables
 ;  BGPUSER - DUZ
 ;  BGPDUZ2 - DUZ(2)
 ;  BGPOPTN - OPTION NAME
 ;  BGPFILE - FILE TO UPLOAD
 ;
 ;
 ;  BGPRET - return value is ien^error message. a zero (0) is
 ;  passed as ien if error occurred, display the filename back to the user
 ;  if they chose to export to area
 ;
 ;  I put the list of files in the BGPGUIN global in field 1100 as an output
 ;create entry in gui output file
 ;queue report to run with/GUIR
 D EP1
 S Y=$G(BGPRET)
 ;D EN^XBVK("BGP") S:$D(ZTQUEUED) ZTREQ="@"
 I '$P($G(BGPRET),U) S BGPRET=1_"^Upload OK"
 Q
EP1 ;
 S U="^"
 I $G(BGPUSER)="" S BGPRET=0_"^USER NOT PASSED" Q
 I $G(BGPDUZ2)="" S BGPRET=0_"^DUZ(2) NOT PASSED" Q
 I $G(BGPOPTN)="" S BGPRET=0_"^OPTION NAME NOT PASSED" Q
 I $G(BGPDIR)="" S BGPRET=0_"^DIRECTORY NAME NOT PASSED" Q
 I $G(BGPFILE)="" S BGPRET=0_"^FILE NAME NOT PASSED" Q
 S BGPRTIME=$G(BGPRTIME)
 ;S DUZ=BGPUSER
 S DUZ(2)=BGPDUZ2
 S:'$D(DT) DT=$$DT^XLFDT
 D ^XBKVAR
 S BGPGUI=1
 S IOM=80,BGPIOSL=55
 ;SEND THE REPORT PROCESS OFF TO THE BACKGROUND USING TASKMAN CALL
AOUPL ;
READF ;EP read file
 NEW Y,X,I,BGPC
 S BGPC=1
 S Y=$$OPEN^%ZISH(BGPDIR,BGPFILE,"R")
 I Y S BGPRET="0^CANNOT OPEN (OR ACCESS) FILE '"_BGPDIR_BGPFILE_"'." D EOJ Q
 KILL ^TMP("BGPUPL",$J)
 F I=1:1 U IO R X:DTIME S X=$$STRIP(X) Q:X=""  S ^TMP("BGPUPL",$J,BGPC,0)=X,BGPC=BGPC+1 Q:$$STATUS^%ZISH=-1
 D ^%ZISC
 ;W !!,"All done reading file",!
PROC ;
 I $P(BGPFILE,".",2)["HE" D PROCHE Q
 I $P(BGPFILE,".",2)["EL" D PROCEL Q
 I $P(BGPFILE,".",2)["PED" D PROCPED Q
 I $P(BGPFILE,".",2)["EO" D PROCEO^BGP9GUP1 Q
 ;W !,"Processing",!
 S BGP0=$P($G(^TMP("BGPUPL",$J,1,0)),"|",9)
 S BGPG=$P($G(^TMP("BGPUPL",$J,1,0)),"|")
 F X=1:1:14 S Y="BGP"_X,@Y=$P(BGP0,U,X)
 ;find existing entry and if exists, delete it
 N X
 S (X,BGPOIEN)=0 F  S X=$O(^BGPGPDCN(X)) Q:X'=+X  D
 .Q:'$D(^BGPGPDCN(X,0))
 .S Y=^BGPGPDCN(X,0)
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
 I BGPOIEN S DA=BGPOIEN,DIK="^BGPGPDCN(" D ^DIK S DA=BGPOIEN,DIK="^BGPGPDPN(" D ^DIK S DA=BGPOIEN,DIK="^BGPGPDBN(" D ^DIK
 ;add entry
 L +^BGPGPDCN:10 I '$T S BGPRET=0_"^unable to lock global. TRY LATER" D EOJ Q
 L +^BGPGPDPN:10 I '$T S BGPRET=0_"^unable to lock global. TRY LATER" D EOJ Q
 L +^BGPGPDBN:10 I '$T S BGPRET=0_"^unable to lock global. TRY LATER" D EOJ Q
 D GETIEN^BGP9UTL
 I 'BGPIEN S BGPRET=0_"^error in file creation...call programmer." D EOJ Q
CY ;
 S DINUM=BGPIEN,X=$P(BGP0,U),DLAYGO=90536.03,DIC="^BGPGPDCN(",DIC(0)="L"
 K DD,D0,DO
 D FILE^DICN
 I Y=-1 S BGPRET=0_"^error uploading file......" G EOJ
 S BGPIEN=+Y
 D ^XBFMK
 S X=0 F  S X=$O(^TMP("BGPUPL",$J,X)) Q:X'=+X  S V=^TMP("BGPUPL",$J,X,0) D
 .Q:$P(V,"|")'="BGPGPDCN"
 .S V=$P(V,"|",2,9999)
 .S N=$P(V,"|"),N2=$P(V,"|",2),N3=$P(V,"|",3),N4=$P(V,"|",4),N5=$P(V,"|",5),D=$P(V,"|",8)
 .I N5]"" S ^BGPGPDCN(BGPIEN,N,N2,N3,N4,N5)=D Q
 .I N4]"" S ^BGPGPDCN(BGPIEN,N,N2,N3,N4)=D Q
 .I N3]"" S ^BGPGPDCN(BGPIEN,N,N2,N3)=D Q
 .I N2]"" S ^BGPGPDCN(BGPIEN,N,N2)=D Q
 .I N]"" S ^BGPGPDCN(BGPIEN,N)=D
 .Q
 S DA=BGPIEN,DIK="^BGPGPDCN(" D IX1^DIK
PY ;
 S DINUM=BGPIEN,X=$P(BGP0,U),DLAYGO=90536.04,DIC="^BGPGPDPN(",DIC(0)="L"
 K DD,D0,DO
 D FILE^DICN
 I Y=-1 S BGPRET=0_"^error uploading file......" G EOJ
 S BGPIEN=+Y
 D ^XBFMK
 S X=0 F  S X=$O(^TMP("BGPUPL",$J,X)) Q:X'=+X  S V=^TMP("BGPUPL",$J,X,0) D
 .Q:$P(V,"|")'="BGPGPDPN"
 .S V=$P(V,"|",2,9999)
 .S N=$P(V,"|"),N2=$P(V,"|",2),N3=$P(V,"|",3),N4=$P(V,"|",4),N5=$P(V,"|",5),D=$P(V,"|",8)
 .I N5]"" S ^BGPGPDPN(BGPIEN,N,N2,N3,N4,N5)=D Q
 .I N4]"" S ^BGPGPDPN(BGPIEN,N,N2,N3,N4)=D Q
 .I N3]"" S ^BGPGPDPN(BGPIEN,N,N2,N3)=D Q
 .I N2]"" S ^BGPGPDPN(BGPIEN,N,N2)=D Q
 .I N]"" S ^BGPGPDPN(BGPIEN,N)=D
 .Q
 S DA=BGPIEN,DIK="^BGPGPDPN(" D IX1^DIK
BY ;
 S DINUM=BGPIEN,X=$P(BGP0,U),DLAYGO=90536.05,DIC="^BGPGPDBN(",DIC(0)="L"
 K DD,D0,DO
 D FILE^DICN
 I Y=-1 S BGPRET=0_"^error uploading file......" G EOJ
 S BGPIEN=+Y
 D ^XBFMK
 S X=0 F  S X=$O(^TMP("BGPUPL",$J,X)) Q:X'=+X  S V=^TMP("BGPUPL",$J,X,0) D
 .Q:$P(V,"|")'="BGPGPDBN"
 .S V=$P(V,"|",2,9999)
 .S N=$P(V,"|"),N2=$P(V,"|",2),N3=$P(V,"|",3),N4=$P(V,"|",4),N5=$P(V,"|",5),D=$P(V,"|",8)
 .I N5]"" S ^BGPGPDBN(BGPIEN,N,N2,N3,N4,N5)=D Q
 .I N4]"" S ^BGPGPDBN(BGPIEN,N,N2,N3,N4)=D Q
 .I N3]"" S ^BGPGPDBN(BGPIEN,N,N2,N3)=D Q
 .I N2]"" S ^BGPGPDBN(BGPIEN,N,N2)=D Q
 .I N]"" S ^BGPGPDBN(BGPIEN,N)=D
 .Q
 S DA=BGPIEN,DIK="^BGPGPDBN(" D IX1^DIK
 ;W !,"Data uploaded."
 D EOJ
 Q
EOJ ;
 L -^BGPGPDCN
 L -^BGPGPDPN
 L -^BGPGPDBN
 L -^BGPHEDCN
 L -^BGPHEDPN
 L -^BGPHEDBN
 L -^BGPELDCN
 L -^BGPELDPN
 L -^BGPELDBN
 L -^BGPPEDCN
 L -^BGPPEDPN
 L -^BGPPEDBN
 ;D EOP^BGP9DH
 K IOPAR
 ;D HOME^%ZIS
 K X,X1,X2,X3,X4,X5,X6
 K A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,V,W,X,Y,Z
 K N,N1,N2,N3,N4,N5,N6
 K DIC,DA,X,Y,%Y,%,BGPJ,BGPTEXT,BGPLINE,BGP
 Q
STRIP(Z) ;REMOVE CONTROLL CHARACTERS
 NEW I
 F I=1:1:$L(Z) I (32>$A($E(Z,I))) S Z=$E(Z,1,I-1)_""_$E(Z,I+1,999)
 Q Z
 ;
PROCHE ;
 ;W !,"Processing",!
 S BGP0=$P($G(^TMP("BGPUPL",$J,1,0)),"|",9)
 S BGPG=$P($G(^TMP("BGPUPL",$J,1,0)),"|")
 F X=1:1:14 S Y="BGP"_X,@Y=$P(BGP0,U,X)
 ;find existing entry and if exists, delete it
 N X
 S (X,BGPOIEN)=0 F  S X=$O(^BGPHEDCN(X)) Q:X'=+X  S Y=^BGPHEDCN(X,0)  D
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
 I BGPOIEN S DA=BGPOIEN,DIK="^BGPHEDCN(" D ^DIK S DA=BGPOIEN,DIK="^BGPHEDPN(" D ^DIK S DA=BGPOIEN,DIK="^BGPHEDBN(" D ^DIK
 ;add entry
 L +^BGPHEDCN:10 I '$T S BGPRET=0_"^unable to lock global. TRY LATER" D EOJ Q
 L +^BGPHEDPN:10 I '$T S BGPRET=0_"^unable to lock global. TRY LATER" D EOJ Q
 L +^BGPHEDBN:10 I '$T S BGPRET=0_"^unable to lock global. TRY LATER" D EOJ Q
 D GETIEN^BGP9HUTL
 I 'BGPIEN S BGPRET=0_"^error in file creation...call programmer." D EOJ Q
HECY ;
 S DINUM=BGPIEN,X=$P(BGP0,U),DLAYGO=90537.03,DIC="^BGPHEDCN(",DIC(0)="L"
 K DD,D0,DO
 D FILE^DICN
 I Y=-1 S BGPRET=0_"^error uploading file......" G EOJ
 S BGPIEN=+Y
 D ^XBFMK
 N X
 S X=0 F  S X=$O(^TMP("BGPUPL",$J,X)) Q:X'=+X  S V=^TMP("BGPUPL",$J,X,0) D
 .Q:$P(V,"|")'="BGPHEDCN"
 .S V=$P(V,"|",2,9999)
 .S N=$P(V,"|"),N2=$P(V,"|",2),N3=$P(V,"|",3),N4=$P(V,"|",4),N5=$P(V,"|",5),D=$P(V,"|",8)
 .I N5]"" S ^BGPHEDCN(BGPIEN,N,N2,N3,N4,N5)=D Q
 .I N4]"" S ^BGPHEDCN(BGPIEN,N,N2,N3,N4)=D Q
 .I N3]"" S ^BGPHEDCN(BGPIEN,N,N2,N3)=D Q
 .I N2]"" S ^BGPHEDCN(BGPIEN,N,N2)=D Q
 .I N]"" S ^BGPHEDCN(BGPIEN,N)=D
 .Q
 S DA=BGPIEN,DIK="^BGPHEDCN(" D IX1^DIK
HEPY ;
 S DINUM=BGPIEN,X=$P(BGP0,U),DLAYGO=90537.04,DIC="^BGPHEDPN(",DIC(0)="L"
 K DD,D0,DO
 D FILE^DICN
 I Y=-1 S BGPRET=0_"^error uploading file......" G EOJ
 S BGPIEN=+Y
 D ^XBFMK
 N X
 S X=0 F  S X=$O(^TMP("BGPUPL",$J,X)) Q:X'=+X  S V=^TMP("BGPUPL",$J,X,0) D
 .Q:$P(V,"|")'="BGPHEDPN"
 .S V=$P(V,"|",2,9999)
 .S N=$P(V,"|"),N2=$P(V,"|",2),N3=$P(V,"|",3),N4=$P(V,"|",4),N5=$P(V,"|",5),D=$P(V,"|",8)
 .I N5]"" S ^BGPHEDPN(BGPIEN,N,N2,N3,N4,N5)=D Q
 .I N4]"" S ^BGPHEDPN(BGPIEN,N,N2,N3,N4)=D Q
 .I N3]"" S ^BGPHEDPN(BGPIEN,N,N2,N3)=D Q
 .I N2]"" S ^BGPHEDPN(BGPIEN,N,N2)=D Q
 .I N]"" S ^BGPHEDPN(BGPIEN,N)=D
 .Q
 S DA=BGPIEN,DIK="^BGPHEDPN(" D IX1^DIK
HEBY ;
 S DINUM=BGPIEN,X=$P(BGP0,U),DLAYGO=90537.05,DIC="^BGPHEDBN(",DIC(0)="L"
 K DD,D0,DO
 D FILE^DICN
 I Y=-1 S BGPRET=0_"^error uploading file......" G EOJ
 S BGPIEN=+Y
 D ^XBFMK
 S X=0 F  S X=$O(^TMP("BGPUPL",$J,X)) Q:X'=+X  S V=^TMP("BGPUPL",$J,X,0) D
 .Q:$P(V,"|")'="BGPHEDBN"
 .S V=$P(V,"|",2,9999)
 .S N=$P(V,"|"),N2=$P(V,"|",2),N3=$P(V,"|",3),N4=$P(V,"|",4),N5=$P(V,"|",5),D=$P(V,"|",8)
 .I N5]"" S ^BGPHEDBN(BGPIEN,N,N2,N3,N4,N5)=D Q
 .I N4]"" S ^BGPHEDBN(BGPIEN,N,N2,N3,N4)=D Q
 .I N3]"" S ^BGPHEDBN(BGPIEN,N,N2,N3)=D Q
 .I N2]"" S ^BGPHEDBN(BGPIEN,N,N2)=D Q
 .I N]"" S ^BGPHEDBN(BGPIEN,N)=D
 .Q
 S DA=BGPIEN,DIK="^BGPHEDBN(" D IX1^DIK
 ;W !,"Data uploaded."
 D EOJ
 Q
 ;
PROCEL ;
 ;W !,"Processing",!
 S BGP0=$P($G(^TMP("BGPUPL",$J,1,0)),"|",9)
 S BGPG=$P($G(^TMP("BGPUPL",$J,1,0)),"|")
 F X=1:1:14 S Y="BGP"_X,@Y=$P(BGP0,U,X)
 ;find existing entry and if exists, delete it
 N X
 S (X,BGPOIEN)=0 F  S X=$O(^BGPELDCN(X)) Q:X'=+X  S Y=^BGPELDCN(X,0)  D
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
 I BGPOIEN S DA=BGPOIEN,DIK="^BGPELDCN(" D ^DIK S DA=BGPOIEN,DIK="^BGPELDPN(" D ^DIK S DA=BGPOIEN,DIK="^BGPELDBN(" D ^DIK
 ;add entry
 L +^BGPELDCN:10 I '$T S BGPRET=0_"^unable to lock global. TRY LATER" D EOJ Q
 L +^BGPELDPN:10 I '$T S BGPRET=0_"^unable to lock global. TRY LATER" D EOJ Q
 L +^BGPELDBN:10 I '$T S BGPRET=0_"^unable to lock global. TRY LATER" D EOJ Q
 D GETIEN^BGP9EUTL
 I 'BGPIEN S BGPRET=0_"^error in file creation...call programmer." D EOJ Q
ELCY ;
 S DINUM=BGPIEN,X=$P(BGP0,U),DLAYGO=90538.03,DIC="^BGPELDCN(",DIC(0)="L"
 K DD,D0,DO
 D FILE^DICN
 I Y=-1 S BGPRET=0_"^error uploading file......" G EOJ
 S BGPIEN=+Y
 D ^XBFMK
 S X=0 F  S X=$O(^TMP("BGPUPL",$J,X)) Q:X'=+X  S V=^TMP("BGPUPL",$J,X,0) D
 .Q:$P(V,"|")'="BGPELDCN"
 .S V=$P(V,"|",2,9999)
 .S N=$P(V,"|"),N2=$P(V,"|",2),N3=$P(V,"|",3),N4=$P(V,"|",4),N5=$P(V,"|",5),D=$P(V,"|",8)
 .I N5]"" S ^BGPELDCN(BGPIEN,N,N2,N3,N4,N5)=D Q
 .I N4]"" S ^BGPELDCN(BGPIEN,N,N2,N3,N4)=D Q
 .I N3]"" S ^BGPELDCN(BGPIEN,N,N2,N3)=D Q
 .I N2]"" S ^BGPELDCN(BGPIEN,N,N2)=D Q
 .I N]"" S ^BGPELDCN(BGPIEN,N)=D
 .Q
 S DA=BGPIEN,DIK="^BGPELDCN(" D IX1^DIK
ELPY ;
 S DINUM=BGPIEN,X=$P(BGP0,U),DLAYGO=90538.04,DIC="^BGPELDPN(",DIC(0)="L"
 K DD,D0,DO
 D FILE^DICN
 I Y=-1 S BGPRET=0_"^error uploading file......" G EOJ
 S BGPIEN=+Y
 D ^XBFMK
 S X=0 F  S X=$O(^TMP("BGPUPL",$J,X)) Q:X'=+X  S V=^TMP("BGPUPL",$J,X,0) D
 .Q:$P(V,"|")'="BGPELDPN"
 .S V=$P(V,"|",2,9999)
 .S N=$P(V,"|"),N2=$P(V,"|",2),N3=$P(V,"|",3),N4=$P(V,"|",4),N5=$P(V,"|",5),D=$P(V,"|",8)
 .I N5]"" S ^BGPELDPN(BGPIEN,N,N2,N3,N4,N5)=D Q
 .I N4]"" S ^BGPELDPN(BGPIEN,N,N2,N3,N4)=D Q
 .I N3]"" S ^BGPELDPN(BGPIEN,N,N2,N3)=D Q
 .I N2]"" S ^BGPELDPN(BGPIEN,N,N2)=D Q
 .I N]"" S ^BGPELDPN(BGPIEN,N)=D
 .Q
 S DA=BGPIEN,DIK="^BGPELDPN(" D IX1^DIK
ELBY ;
 S DINUM=BGPIEN,X=$P(BGP0,U),DLAYGO=90538.05,DIC="^BGPELDBN(",DIC(0)="L"
 K DD,D0,DO
 D FILE^DICN
 I Y=-1 S BGPRET=0_"^error uploading file......" G EOJ
 S BGPIEN=+Y
 D ^XBFMK
 N X
 S X=0 F  S X=$O(^TMP("BGPUPL",$J,X)) Q:X'=+X  S V=^TMP("BGPUPL",$J,X,0) D
 .Q:$P(V,"|")'="BGPELDBN"
 .S V=$P(V,"|",2,9999)
 .S N=$P(V,"|"),N2=$P(V,"|",2),N3=$P(V,"|",3),N4=$P(V,"|",4),N5=$P(V,"|",5),D=$P(V,"|",8)
 .I N5]"" S ^BGPELDBN(BGPIEN,N,N2,N3,N4,N5)=D Q
 .I N4]"" S ^BGPELDBN(BGPIEN,N,N2,N3,N4)=D Q
 .I N3]"" S ^BGPELDBN(BGPIEN,N,N2,N3)=D Q
 .I N2]"" S ^BGPELDBN(BGPIEN,N,N2)=D Q
 .I N]"" S ^BGPELDBN(BGPIEN,N)=D
 .Q
 S DA=BGPIEN,DIK="^BGPELDBN(" D IX1^DIK
 ;W !,"Data uploaded."
 D EOJ
 Q
 ;
PROCPED ;
 ;W !,"Processing",!
 S BGP0=$P($G(^TMP("BGPUPL",$J,1,0)),"|",9)
 S BGPG=$P($G(^TMP("BGPUPL",$J,1,0)),"|")
 F X=1:1:14 S Y="BGP"_X,@Y=$P(BGP0,U,X)
 ;find existing entry and if exists, delete it
 N X
 S (X,BGPOIEN)=0 F  S X=$O(^BGPPEDCN(X)) Q:X'=+X  S Y=^BGPPEDCN(X,0)  D
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
 I BGPOIEN S DA=BGPOIEN,DIK="^BGPPEDCN(" D ^DIK S DA=BGPOIEN,DIK="^BGPPEDPN(" D ^DIK S DA=BGPOIEN,DIK="^BGPPEDBN(" D ^DIK
 ;add entry
 L +^BGPPEDCN:10 I '$T S BGPRET=0_"^unable to lock global. TRY LATER" D EOJ Q
 L +^BGPPEDPN:10 I '$T S BGPRET=0_"^unable to lock global. TRY LATER" D EOJ Q
 L +^BGPPEDBN:10 I '$T S BGPRET=0_"^unable to lock global. TRY LATER" D EOJ Q
 D GETIEN^BGP9PUTL
 I 'BGPIEN S BGPRET=0_"^error in file creation...call programmer." D EOJ Q
PEDCY ;
 S DINUM=BGPIEN,X=$P(BGP0,U),DLAYGO=90536.12,DIC="^BGPPEDCN(",DIC(0)="L"
 K DD,D0,DO
 D FILE^DICN
 I Y=-1 S BGPRET=0_"^error uploading file......" G EOJ
 S BGPIEN=+Y
 D ^XBFMK
 S X=0 F  S X=$O(^TMP("BGPUPL",$J,X)) Q:X'=+X  S V=^TMP("BGPUPL",$J,X,0) D
 .Q:$P(V,"|")'="BGPPEDCN"
 .S V=$P(V,"|",2,9999)
 .S N=$P(V,"|"),N2=$P(V,"|",2),N3=$P(V,"|",3),N4=$P(V,"|",4),N5=$P(V,"|",5),D=$P(V,"|",8)
 .I N5]"" S ^BGPPEDCN(BGPIEN,N,N2,N3,N4,N5)=D Q
 .I N4]"" S ^BGPPEDCN(BGPIEN,N,N2,N3,N4)=D Q
 .I N3]"" S ^BGPPEDCN(BGPIEN,N,N2,N3)=D Q
 .I N2]"" S ^BGPPEDCN(BGPIEN,N,N2)=D Q
 .I N]"" S ^BGPPEDCN(BGPIEN,N)=D
 .Q
 S DA=BGPIEN,DIK="^BGPPEDCN(" D IX1^DIK
PEDPY ;
 S DINUM=BGPIEN,X=$P(BGP0,U),DLAYGO=90536.13,DIC="^BGPPEDPN(",DIC(0)="L"
 K DD,D0,DO
 D FILE^DICN
 I Y=-1 S BGPRET=0_"^error uploading file......" G EOJ
 S BGPIEN=+Y
 D ^XBFMK
 S X=0 F  S X=$O(^TMP("BGPUPL",$J,X)) Q:X'=+X  S V=^TMP("BGPUPL",$J,X,0) D
 .Q:$P(V,"|")'="BGPPEDPN"
 .S V=$P(V,"|",2,9999)
 .S N=$P(V,"|"),N2=$P(V,"|",2),N3=$P(V,"|",3),N4=$P(V,"|",4),N5=$P(V,"|",5),D=$P(V,"|",8)
 .I N5]"" S ^BGPPEDPN(BGPIEN,N,N2,N3,N4,N5)=D Q
 .I N4]"" S ^BGPPEDPN(BGPIEN,N,N2,N3,N4)=D Q
 .I N3]"" S ^BGPPEDPN(BGPIEN,N,N2,N3)=D Q
 .I N2]"" S ^BGPPEDPN(BGPIEN,N,N2)=D Q
 .I N]"" S ^BGPPEDPN(BGPIEN,N)=D
 .Q
 S DA=BGPIEN,DIK="^BGPPEDPN(" D IX1^DIK
PEDBY ;
 S DINUM=BGPIEN,X=$P(BGP0,U),DLAYGO=90536.14,DIC="^BGPPEDBN(",DIC(0)="L"
 K DD,D0,DO
 D FILE^DICN
 I Y=-1 S BGPRET=0_"^error uploading file......" G EOJ
 S BGPIEN=+Y
 D ^XBFMK
 S X=0 F  S X=$O(^TMP("BGPUPL",$J,X)) Q:X'=+X  S V=^TMP("BGPUPL",$J,X,0) D
 .Q:$P(V,"|")'="BGPPEDBN"
 .S V=$P(V,"|",2,9999)
 .S N=$P(V,"|"),N2=$P(V,"|",2),N3=$P(V,"|",3),N4=$P(V,"|",4),N5=$P(V,"|",5),D=$P(V,"|",8)
 .I N5]"" S ^BGPPEDBN(BGPIEN,N,N2,N3,N4,N5)=D Q
 .I N4]"" S ^BGPPEDBN(BGPIEN,N,N2,N3,N4)=D Q
 .I N3]"" S ^BGPPEDBN(BGPIEN,N,N2,N3)=D Q
 .I N2]"" S ^BGPPEDBN(BGPIEN,N,N2)=D Q
 .I N]"" S ^BGPPEDBN(BGPIEN,N)=D
 .Q
 S DA=BGPIEN,DIK="^BGPPEDBN(" D IX1^DIK
 ;W !,"Data uploaded."
 D EOJ
 Q
 ;
