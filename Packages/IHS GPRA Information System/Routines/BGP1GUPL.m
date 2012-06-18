BGP1GUPL ; IHS/CMI/LAB - GUI Upload ;
 ;;11.1;IHS CLINICAL REPORTING SYSTEM;;JUN 27, 2011;Build 33
 ;
 ;
EP(BGPRET,BGPUSER,BGPDUZ2,BGPOPTN,BGPDIR,BGPFILE,BGPRTIME) ;EP - called from GUI to produce COM REPORT CI05-AO-UPL
 ; SEE ROUTINE BGP1DL if you have questions about any of these variables
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
 ;  I put the list of files in the BGPGUIB global in field 1100 as an output
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
 I $P(BGPFILE,".",2)["EO" D PROCEO^BGP1GUP1 Q
 ;W !,"Processing",!
 S BGP1=$P($G(^TMP("BGPUPL",$J,1,0)),"|",9)
 S BGPG=$P($G(^TMP("BGPUPL",$J,1,0)),"|")
 F X=1:1:14 S Y="BGP"_X,@Y=$P(BGP1,U,X)
 ;find existing entry and if exists, delete it
 N X
 S (X,BGPOIEN)=0 F  S X=$O(^BGPGPDCB(X)) Q:X'=+X  D
 .Q:'$D(^BGPGPDCB(X,0))
 .S Y=^BGPGPDCB(X,0)
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
 I BGPOIEN S DA=BGPOIEN,DIK="^BGPGPDCB(" D ^DIK S DA=BGPOIEN,DIK="^BGPGPDPB(" D ^DIK S DA=BGPOIEN,DIK="^BGPGPDBB(" D ^DIK
 ;add entry
 L +^BGPGPDCB:10 I '$T S BGPRET=0_"^unable to lock global. TRY LATER" D EOJ Q
 L +^BGPGPDPB:10 I '$T S BGPRET=0_"^unable to lock global. TRY LATER" D EOJ Q
 L +^BGPGPDBB:10 I '$T S BGPRET=0_"^unable to lock global. TRY LATER" D EOJ Q
 D GETIEN^BGP1UTL
 I 'BGPIEN S BGPRET=0_"^error in file creation...call programmer." D EOJ Q
CY ;
 S DINUM=BGPIEN,X=$P(BGP1,U),DLAYGO=90545.03,DIC="^BGPGPDCB(",DIC(0)="L"
 K DD,D0,DO
 D FILE^DICN
 I Y=-1 S BGPRET=0_"^error uploading file......" G EOJ
 S BGPIEN=+Y
 D ^XBFMK
 S X=0 F  S X=$O(^TMP("BGPUPL",$J,X)) Q:X'=+X  S V=^TMP("BGPUPL",$J,X,0) D
 .Q:$P(V,"|")'="BGPGPDCB"
 .S V=$P(V,"|",2,9999)
 .S N=$P(V,"|"),N2=$P(V,"|",2),N3=$P(V,"|",3),N4=$P(V,"|",4),N5=$P(V,"|",5),D=$P(V,"|",8)
 .I N5]"" S ^BGPGPDCB(BGPIEN,N,N2,N3,N4,N5)=D Q
 .I N4]"" S ^BGPGPDCB(BGPIEN,N,N2,N3,N4)=D Q
 .I N3]"" S ^BGPGPDCB(BGPIEN,N,N2,N3)=D Q
 .I N2]"" S ^BGPGPDCB(BGPIEN,N,N2)=D Q
 .I N]"" S ^BGPGPDCB(BGPIEN,N)=D
 .Q
 S DA=BGPIEN,DIK="^BGPGPDCB(" D IX1^DIK
PY ;
 S DINUM=BGPIEN,X=$P(BGP1,U),DLAYGO=90545.04,DIC="^BGPGPDPB(",DIC(0)="L"
 K DD,D0,DO
 D FILE^DICN
 I Y=-1 S BGPRET=0_"^error uploading file......" G EOJ
 S BGPIEN=+Y
 D ^XBFMK
 S X=0 F  S X=$O(^TMP("BGPUPL",$J,X)) Q:X'=+X  S V=^TMP("BGPUPL",$J,X,0) D
 .Q:$P(V,"|")'="BGPGPDPB"
 .S V=$P(V,"|",2,9999)
 .S N=$P(V,"|"),N2=$P(V,"|",2),N3=$P(V,"|",3),N4=$P(V,"|",4),N5=$P(V,"|",5),D=$P(V,"|",8)
 .I N5]"" S ^BGPGPDPB(BGPIEN,N,N2,N3,N4,N5)=D Q
 .I N4]"" S ^BGPGPDPB(BGPIEN,N,N2,N3,N4)=D Q
 .I N3]"" S ^BGPGPDPB(BGPIEN,N,N2,N3)=D Q
 .I N2]"" S ^BGPGPDPB(BGPIEN,N,N2)=D Q
 .I N]"" S ^BGPGPDPB(BGPIEN,N)=D
 .Q
 S DA=BGPIEN,DIK="^BGPGPDPB(" D IX1^DIK
BY ;
 S DINUM=BGPIEN,X=$P(BGP1,U),DLAYGO=90545.05,DIC="^BGPGPDBB(",DIC(0)="L"
 K DD,D0,DO
 D FILE^DICN
 I Y=-1 S BGPRET=0_"^error uploading file......" G EOJ
 S BGPIEN=+Y
 D ^XBFMK
 S X=0 F  S X=$O(^TMP("BGPUPL",$J,X)) Q:X'=+X  S V=^TMP("BGPUPL",$J,X,0) D
 .Q:$P(V,"|")'="BGPGPDBB"
 .S V=$P(V,"|",2,9999)
 .S N=$P(V,"|"),N2=$P(V,"|",2),N3=$P(V,"|",3),N4=$P(V,"|",4),N5=$P(V,"|",5),D=$P(V,"|",8)
 .I N5]"" S ^BGPGPDBB(BGPIEN,N,N2,N3,N4,N5)=D Q
 .I N4]"" S ^BGPGPDBB(BGPIEN,N,N2,N3,N4)=D Q
 .I N3]"" S ^BGPGPDBB(BGPIEN,N,N2,N3)=D Q
 .I N2]"" S ^BGPGPDBB(BGPIEN,N,N2)=D Q
 .I N]"" S ^BGPGPDBB(BGPIEN,N)=D
 .Q
 S DA=BGPIEN,DIK="^BGPGPDBB(" D IX1^DIK
 ;W !,"Data uploaded."
 D EOJ
 Q
EOJ ;EP
 L -^BGPGPDCB
 L -^BGPGPDPB
 L -^BGPGPDBB
 L -^BGPHEDCB
 L -^BGPHEDPB
 L -^BGPHEDBB
 L -^BGPELDCB
 L -^BGPELDPB
 L -^BGPELDBB
 L -^BGPPEDCB
 L -^BGPPEDPB
 L -^BGPPEDBB
 L -^BGPEOCB
 L -^BGPEOBB
 L -^BGPEOPB
 ;D EOP^BGP1DH
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
 S BGP1=$P($G(^TMP("BGPUPL",$J,1,0)),"|",9)
 S BGPG=$P($G(^TMP("BGPUPL",$J,1,0)),"|")
 F X=1:1:14 S Y="BGP"_X,@Y=$P(BGP1,U,X)
 ;find existing entry and if exists, delete it
 N X
 S (X,BGPOIEN)=0 F  S X=$O(^BGPHEDCB(X)) Q:X'=+X  S Y=^BGPHEDCB(X,0)  D
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
 L +^BGPHEDCB:10 I '$T S BGPRET=0_"^unable to lock global. TRY LATER" D EOJ Q
 L +^BGPHEDPB:10 I '$T S BGPRET=0_"^unable to lock global. TRY LATER" D EOJ Q
 L +^BGPHEDBB:10 I '$T S BGPRET=0_"^unable to lock global. TRY LATER" D EOJ Q
 D GETIEN^BGP1HUTL
 I 'BGPIEN S BGPRET=0_"^error in file creation...call programmer." D EOJ Q
HECY ;
 S DINUM=BGPIEN,X=$P(BGP1,U),DLAYGO=90546.03,DIC="^BGPHEDCB(",DIC(0)="L"
 K DD,D0,DO
 D FILE^DICN
 I Y=-1 S BGPRET=0_"^error uploading file......" G EOJ
 S BGPIEN=+Y
 D ^XBFMK
 N X
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
 S DINUM=BGPIEN,X=$P(BGP1,U),DLAYGO=90546.04,DIC="^BGPHEDPB(",DIC(0)="L"
 K DD,D0,DO
 D FILE^DICN
 I Y=-1 S BGPRET=0_"^error uploading file......" G EOJ
 S BGPIEN=+Y
 D ^XBFMK
 N X
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
 S DINUM=BGPIEN,X=$P(BGP1,U),DLAYGO=90546.05,DIC="^BGPHEDBB(",DIC(0)="L"
 K DD,D0,DO
 D FILE^DICN
 I Y=-1 S BGPRET=0_"^error uploading file......" G EOJ
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
 ;W !,"Data uploaded."
 D EOJ
 Q
 ;
PROCEL ;
 ;W !,"Processing",!
 S BGP1=$P($G(^TMP("BGPUPL",$J,1,0)),"|",9)
 S BGPG=$P($G(^TMP("BGPUPL",$J,1,0)),"|")
 F X=1:1:14 S Y="BGP"_X,@Y=$P(BGP1,U,X)
 ;find existing entry and if exists, delete it
 N X
 S (X,BGPOIEN)=0 F  S X=$O(^BGPELDCB(X)) Q:X'=+X  S Y=^BGPELDCB(X,0)  D
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
 I BGPOIEN S DA=BGPOIEN,DIK="^BGPELDCB(" D ^DIK S DA=BGPOIEN,DIK="^BGPELDPB(" D ^DIK S DA=BGPOIEN,DIK="^BGPELDBB(" D ^DIK
 ;add entry
 L +^BGPELDCB:10 I '$T S BGPRET=0_"^unable to lock global. TRY LATER" D EOJ Q
 L +^BGPELDPB:10 I '$T S BGPRET=0_"^unable to lock global. TRY LATER" D EOJ Q
 L +^BGPELDBB:10 I '$T S BGPRET=0_"^unable to lock global. TRY LATER" D EOJ Q
 D GETIEN^BGP1EUTL
 I 'BGPIEN S BGPRET=0_"^error in file creation...call programmer." D EOJ Q
ELCY ;
 S DINUM=BGPIEN,X=$P(BGP1,U),DLAYGO=90547.03,DIC="^BGPELDCB(",DIC(0)="L"
 K DD,D0,DO
 D FILE^DICN
 I Y=-1 S BGPRET=0_"^error uploading file......" G EOJ
 S BGPIEN=+Y
 D ^XBFMK
 S X=0 F  S X=$O(^TMP("BGPUPL",$J,X)) Q:X'=+X  S V=^TMP("BGPUPL",$J,X,0) D
 .Q:$P(V,"|")'="BGPELDCB"
 .S V=$P(V,"|",2,9999)
 .S N=$P(V,"|"),N2=$P(V,"|",2),N3=$P(V,"|",3),N4=$P(V,"|",4),N5=$P(V,"|",5),D=$P(V,"|",8)
 .I N5]"" S ^BGPELDCB(BGPIEN,N,N2,N3,N4,N5)=D Q
 .I N4]"" S ^BGPELDCB(BGPIEN,N,N2,N3,N4)=D Q
 .I N3]"" S ^BGPELDCB(BGPIEN,N,N2,N3)=D Q
 .I N2]"" S ^BGPELDCB(BGPIEN,N,N2)=D Q
 .I N]"" S ^BGPELDCB(BGPIEN,N)=D
 .Q
 S DA=BGPIEN,DIK="^BGPELDCB(" D IX1^DIK
ELPY ;
 S DINUM=BGPIEN,X=$P(BGP1,U),DLAYGO=90547.04,DIC="^BGPELDPB(",DIC(0)="L"
 K DD,D0,DO
 D FILE^DICN
 I Y=-1 S BGPRET=0_"^error uploading file......" G EOJ
 S BGPIEN=+Y
 D ^XBFMK
 S X=0 F  S X=$O(^TMP("BGPUPL",$J,X)) Q:X'=+X  S V=^TMP("BGPUPL",$J,X,0) D
 .Q:$P(V,"|")'="BGPELDPB"
 .S V=$P(V,"|",2,9999)
 .S N=$P(V,"|"),N2=$P(V,"|",2),N3=$P(V,"|",3),N4=$P(V,"|",4),N5=$P(V,"|",5),D=$P(V,"|",8)
 .I N5]"" S ^BGPELDPB(BGPIEN,N,N2,N3,N4,N5)=D Q
 .I N4]"" S ^BGPELDPB(BGPIEN,N,N2,N3,N4)=D Q
 .I N3]"" S ^BGPELDPB(BGPIEN,N,N2,N3)=D Q
 .I N2]"" S ^BGPELDPB(BGPIEN,N,N2)=D Q
 .I N]"" S ^BGPELDPB(BGPIEN,N)=D
 .Q
 S DA=BGPIEN,DIK="^BGPELDPB(" D IX1^DIK
ELBY ;
 S DINUM=BGPIEN,X=$P(BGP1,U),DLAYGO=90547.05,DIC="^BGPELDBB(",DIC(0)="L"
 K DD,D0,DO
 D FILE^DICN
 I Y=-1 S BGPRET=0_"^error uploading file......" G EOJ
 S BGPIEN=+Y
 D ^XBFMK
 N X
 S X=0 F  S X=$O(^TMP("BGPUPL",$J,X)) Q:X'=+X  S V=^TMP("BGPUPL",$J,X,0) D
 .Q:$P(V,"|")'="BGPELDBB"
 .S V=$P(V,"|",2,9999)
 .S N=$P(V,"|"),N2=$P(V,"|",2),N3=$P(V,"|",3),N4=$P(V,"|",4),N5=$P(V,"|",5),D=$P(V,"|",8)
 .I N5]"" S ^BGPELDBB(BGPIEN,N,N2,N3,N4,N5)=D Q
 .I N4]"" S ^BGPELDBB(BGPIEN,N,N2,N3,N4)=D Q
 .I N3]"" S ^BGPELDBB(BGPIEN,N,N2,N3)=D Q
 .I N2]"" S ^BGPELDBB(BGPIEN,N,N2)=D Q
 .I N]"" S ^BGPELDBB(BGPIEN,N)=D
 .Q
 S DA=BGPIEN,DIK="^BGPELDBB(" D IX1^DIK
 ;W !,"Data uploaded."
 D EOJ
 Q
 ;
PROCPED ;
 ;W !,"Processing",!
 S BGP1=$P($G(^TMP("BGPUPL",$J,1,0)),"|",9)
 S BGPG=$P($G(^TMP("BGPUPL",$J,1,0)),"|")
 F X=1:1:14 S Y="BGP"_X,@Y=$P(BGP1,U,X)
 ;find existing entry and if exists, delete it
 N X
 S (X,BGPOIEN)=0 F  S X=$O(^BGPPEDCB(X)) Q:X'=+X  S Y=^BGPPEDCB(X,0)  D
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
 I BGPOIEN S DA=BGPOIEN,DIK="^BGPPEDCB(" D ^DIK S DA=BGPOIEN,DIK="^BGPPEDPB(" D ^DIK S DA=BGPOIEN,DIK="^BGPPEDBB(" D ^DIK
 ;add entry
 L +^BGPPEDCB:10 I '$T S BGPRET=0_"^unable to lock global. TRY LATER" D EOJ Q
 L +^BGPPEDPB:10 I '$T S BGPRET=0_"^unable to lock global. TRY LATER" D EOJ Q
 L +^BGPPEDBB:10 I '$T S BGPRET=0_"^unable to lock global. TRY LATER" D EOJ Q
 D GETIEN^BGP1PUTL
 I 'BGPIEN S BGPRET=0_"^error in file creation...call programmer." D EOJ Q
PEDCY ;
 S DINUM=BGPIEN,X=$P(BGP1,U),DLAYGO=90545.12,DIC="^BGPPEDCB(",DIC(0)="L"
 K DD,D0,DO
 D FILE^DICN
 I Y=-1 S BGPRET=0_"^error uploading file......" G EOJ
 S BGPIEN=+Y
 D ^XBFMK
 S X=0 F  S X=$O(^TMP("BGPUPL",$J,X)) Q:X'=+X  S V=^TMP("BGPUPL",$J,X,0) D
 .Q:$P(V,"|")'="BGPPEDCB"
 .S V=$P(V,"|",2,9999)
 .S N=$P(V,"|"),N2=$P(V,"|",2),N3=$P(V,"|",3),N4=$P(V,"|",4),N5=$P(V,"|",5),D=$P(V,"|",8)
 .I N5]"" S ^BGPPEDCB(BGPIEN,N,N2,N3,N4,N5)=D Q
 .I N4]"" S ^BGPPEDCB(BGPIEN,N,N2,N3,N4)=D Q
 .I N3]"" S ^BGPPEDCB(BGPIEN,N,N2,N3)=D Q
 .I N2]"" S ^BGPPEDCB(BGPIEN,N,N2)=D Q
 .I N]"" S ^BGPPEDCB(BGPIEN,N)=D
 .Q
 S DA=BGPIEN,DIK="^BGPPEDCB(" D IX1^DIK
PEDPY ;
 S DINUM=BGPIEN,X=$P(BGP1,U),DLAYGO=90545.13,DIC="^BGPPEDPB(",DIC(0)="L"
 K DD,D0,DO
 D FILE^DICN
 I Y=-1 S BGPRET=0_"^error uploading file......" G EOJ
 S BGPIEN=+Y
 D ^XBFMK
 S X=0 F  S X=$O(^TMP("BGPUPL",$J,X)) Q:X'=+X  S V=^TMP("BGPUPL",$J,X,0) D
 .Q:$P(V,"|")'="BGPPEDPB"
 .S V=$P(V,"|",2,9999)
 .S N=$P(V,"|"),N2=$P(V,"|",2),N3=$P(V,"|",3),N4=$P(V,"|",4),N5=$P(V,"|",5),D=$P(V,"|",8)
 .I N5]"" S ^BGPPEDPB(BGPIEN,N,N2,N3,N4,N5)=D Q
 .I N4]"" S ^BGPPEDPB(BGPIEN,N,N2,N3,N4)=D Q
 .I N3]"" S ^BGPPEDPB(BGPIEN,N,N2,N3)=D Q
 .I N2]"" S ^BGPPEDPB(BGPIEN,N,N2)=D Q
 .I N]"" S ^BGPPEDPB(BGPIEN,N)=D
 .Q
 S DA=BGPIEN,DIK="^BGPPEDPB(" D IX1^DIK
PEDBY ;
 S DINUM=BGPIEN,X=$P(BGP1,U),DLAYGO=90545.14,DIC="^BGPPEDBB(",DIC(0)="L"
 K DD,D0,DO
 D FILE^DICN
 I Y=-1 S BGPRET=0_"^error uploading file......" G EOJ
 S BGPIEN=+Y
 D ^XBFMK
 S X=0 F  S X=$O(^TMP("BGPUPL",$J,X)) Q:X'=+X  S V=^TMP("BGPUPL",$J,X,0) D
 .Q:$P(V,"|")'="BGPPEDBB"
 .S V=$P(V,"|",2,9999)
 .S N=$P(V,"|"),N2=$P(V,"|",2),N3=$P(V,"|",3),N4=$P(V,"|",4),N5=$P(V,"|",5),D=$P(V,"|",8)
 .I N5]"" S ^BGPPEDBB(BGPIEN,N,N2,N3,N4,N5)=D Q
 .I N4]"" S ^BGPPEDBB(BGPIEN,N,N2,N3,N4)=D Q
 .I N3]"" S ^BGPPEDBB(BGPIEN,N,N2,N3)=D Q
 .I N2]"" S ^BGPPEDBB(BGPIEN,N,N2)=D Q
 .I N]"" S ^BGPPEDBB(BGPIEN,N)=D
 .Q
 S DA=BGPIEN,DIK="^BGPPEDBB(" D IX1^DIK
 ;W !,"Data uploaded."
 D EOJ
 Q
 ;
