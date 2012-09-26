BGP2GUPL ; IHS/CMI/LAB - GUI Upload ;
 ;;12.1;IHS CLINICAL REPORTING;;MAY 17, 2012;Build 66
 ;
 ;
EP(BGPRET,BGPUSER,BGPDUZ2,BGPOPTN,BGPDIR,BGPFILE,BGPRTIME) ;EP - called from GUI to produce COM REPORT CI05-AO-UPL
 ; SEE ROUTINE BGP2DL if you have questions about any of these variables
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
 ;  I put the list of files in the BGPGUIW global in field 1100 as an output
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
 I $P(BGPFILE,".",2)["EO" D PROCEO^BGP2GUP1 Q
 ;W !,"Processing",!
 S BGP2=$P($G(^TMP("BGPUPL",$J,1,0)),"|",9)
 S BGPG=$P($G(^TMP("BGPUPL",$J,1,0)),"|")
 F X=1:1:14 S Y="BGP"_X,@Y=$P(BGP2,U,X)
 ;find existing entry and if exists, delete it
 N X
 S (X,BGPOIEN)=0 F  S X=$O(^BGPGPDCW(X)) Q:X'=+X  D
 .Q:'$D(^BGPGPDCW(X,0))
 .S Y=^BGPGPDCW(X,0)
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
 I BGPOIEN S DA=BGPOIEN,DIK="^BGPGPDCW(" D ^DIK S DA=BGPOIEN,DIK="^BGPGPDPW(" D ^DIK S DA=BGPOIEN,DIK="^BGPGPDBW(" D ^DIK
 ;add entry
 L +^BGPGPDCW:10 I '$T S BGPRET=0_"^unable to lock global. TRY LATER" D EOJ Q
 L +^BGPGPDPW:10 I '$T S BGPRET=0_"^unable to lock global. TRY LATER" D EOJ Q
 L +^BGPGPDBW:10 I '$T S BGPRET=0_"^unable to lock global. TRY LATER" D EOJ Q
 D GETIEN^BGP2UTL
 I 'BGPIEN S BGPRET=0_"^error in file creation...call programmer." D EOJ Q
CY ;
 S DINUM=BGPIEN,X=$P(BGP2,U),DLAYGO=90548.03,DIC="^BGPGPDCW(",DIC(0)="L"
 K DD,D0,DO
 D FILE^DICN
 I Y=-1 S BGPRET=0_"^error uploading file......" G EOJ
 S BGPIEN=+Y
 D ^XBFMK
 S X=0 F  S X=$O(^TMP("BGPUPL",$J,X)) Q:X'=+X  S V=^TMP("BGPUPL",$J,X,0) D
 .Q:$P(V,"|")'="BGPGPDCW"
 .S V=$P(V,"|",2,9999)
 .S N=$P(V,"|"),N2=$P(V,"|",2),N3=$P(V,"|",3),N4=$P(V,"|",4),N5=$P(V,"|",5),D=$P(V,"|",8)
 .I N5]"" S ^BGPGPDCW(BGPIEN,N,N2,N3,N4,N5)=D Q
 .I N4]"" S ^BGPGPDCW(BGPIEN,N,N2,N3,N4)=D Q
 .I N3]"" S ^BGPGPDCW(BGPIEN,N,N2,N3)=D Q
 .I N2]"" S ^BGPGPDCW(BGPIEN,N,N2)=D Q
 .I N]"" S ^BGPGPDCW(BGPIEN,N)=D
 .Q
 S DA=BGPIEN,DIK="^BGPGPDCW(" D IX1^DIK
PY ;
 S DINUM=BGPIEN,X=$P(BGP2,U),DLAYGO=90548.04,DIC="^BGPGPDPW(",DIC(0)="L"
 K DD,D0,DO
 D FILE^DICN
 I Y=-1 S BGPRET=0_"^error uploading file......" G EOJ
 S BGPIEN=+Y
 D ^XBFMK
 S X=0 F  S X=$O(^TMP("BGPUPL",$J,X)) Q:X'=+X  S V=^TMP("BGPUPL",$J,X,0) D
 .Q:$P(V,"|")'="BGPGPDPW"
 .S V=$P(V,"|",2,9999)
 .S N=$P(V,"|"),N2=$P(V,"|",2),N3=$P(V,"|",3),N4=$P(V,"|",4),N5=$P(V,"|",5),D=$P(V,"|",8)
 .I N5]"" S ^BGPGPDPW(BGPIEN,N,N2,N3,N4,N5)=D Q
 .I N4]"" S ^BGPGPDPW(BGPIEN,N,N2,N3,N4)=D Q
 .I N3]"" S ^BGPGPDPW(BGPIEN,N,N2,N3)=D Q
 .I N2]"" S ^BGPGPDPW(BGPIEN,N,N2)=D Q
 .I N]"" S ^BGPGPDPW(BGPIEN,N)=D
 .Q
 S DA=BGPIEN,DIK="^BGPGPDPW(" D IX1^DIK
BY ;
 S DINUM=BGPIEN,X=$P(BGP2,U),DLAYGO=90548.05,DIC="^BGPGPDBW(",DIC(0)="L"
 K DD,D0,DO
 D FILE^DICN
 I Y=-1 S BGPRET=0_"^error uploading file......" G EOJ
 S BGPIEN=+Y
 D ^XBFMK
 S X=0 F  S X=$O(^TMP("BGPUPL",$J,X)) Q:X'=+X  S V=^TMP("BGPUPL",$J,X,0) D
 .Q:$P(V,"|")'="BGPGPDBW"
 .S V=$P(V,"|",2,9999)
 .S N=$P(V,"|"),N2=$P(V,"|",2),N3=$P(V,"|",3),N4=$P(V,"|",4),N5=$P(V,"|",5),D=$P(V,"|",8)
 .I N5]"" S ^BGPGPDBW(BGPIEN,N,N2,N3,N4,N5)=D Q
 .I N4]"" S ^BGPGPDBW(BGPIEN,N,N2,N3,N4)=D Q
 .I N3]"" S ^BGPGPDBW(BGPIEN,N,N2,N3)=D Q
 .I N2]"" S ^BGPGPDBW(BGPIEN,N,N2)=D Q
 .I N]"" S ^BGPGPDBW(BGPIEN,N)=D
 .Q
 S DA=BGPIEN,DIK="^BGPGPDBW(" D IX1^DIK
 ;W !,"Data uploaded."
 D EOJ
 Q
EOJ ;EP
 L -^BGPGPDCW
 L -^BGPGPDPW
 L -^BGPGPDBW
 L -^BGPHEDCB
 L -^BGPHEDPB
 L -^BGPHEDBB
 L -^BGPELDCW
 L -^BGPELDPW
 L -^BGPELDBW
 L -^BGPPEDCW
 L -^BGPPEDPW
 L -^BGPPEDBW
 L -^BGPEOCB
 L -^BGPEOBB
 L -^BGPEOPB
 ;D EOP^BGP2DH
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
 S BGP2=$P($G(^TMP("BGPUPL",$J,1,0)),"|",9)
 S BGPG=$P($G(^TMP("BGPUPL",$J,1,0)),"|")
 F X=1:1:14 S Y="BGP"_X,@Y=$P(BGP2,U,X)
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
 D GETIEN^BGP2HUTL
 I 'BGPIEN S BGPRET=0_"^error in file creation...call programmer." D EOJ Q
HECY ;
 S DINUM=BGPIEN,X=$P(BGP2,U),DLAYGO=90546.03,DIC="^BGPHEDCB(",DIC(0)="L"
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
 S DINUM=BGPIEN,X=$P(BGP2,U),DLAYGO=90546.04,DIC="^BGPHEDPB(",DIC(0)="L"
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
 S DINUM=BGPIEN,X=$P(BGP2,U),DLAYGO=90546.05,DIC="^BGPHEDBB(",DIC(0)="L"
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
 S BGP2=$P($G(^TMP("BGPUPL",$J,1,0)),"|",9)
 S BGPG=$P($G(^TMP("BGPUPL",$J,1,0)),"|")
 F X=1:1:14 S Y="BGP"_X,@Y=$P(BGP2,U,X)
 ;find existing entry and if exists, delete it
 N X
 S (X,BGPOIEN)=0 F  S X=$O(^BGPELDCW(X)) Q:X'=+X  S Y=^BGPELDCW(X,0)  D
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
 I BGPOIEN S DA=BGPOIEN,DIK="^BGPELDCW(" D ^DIK S DA=BGPOIEN,DIK="^BGPELDPW(" D ^DIK S DA=BGPOIEN,DIK="^BGPELDBW(" D ^DIK
 ;add entry
 L +^BGPELDCW:10 I '$T S BGPRET=0_"^unable to lock global. TRY LATER" D EOJ Q
 L +^BGPELDPW:10 I '$T S BGPRET=0_"^unable to lock global. TRY LATER" D EOJ Q
 L +^BGPELDBW:10 I '$T S BGPRET=0_"^unable to lock global. TRY LATER" D EOJ Q
 D GETIEN^BGP2EUTL
 I 'BGPIEN S BGPRET=0_"^error in file creation...call programmer." D EOJ Q
ELCY ;
 S DINUM=BGPIEN,X=$P(BGP2,U),DLAYGO=90549.03,DIC="^BGPELDCW(",DIC(0)="L"
 K DD,D0,DO
 D FILE^DICN
 I Y=-1 S BGPRET=0_"^error uploading file......" G EOJ
 S BGPIEN=+Y
 D ^XBFMK
 S X=0 F  S X=$O(^TMP("BGPUPL",$J,X)) Q:X'=+X  S V=^TMP("BGPUPL",$J,X,0) D
 .Q:$P(V,"|")'="BGPELDCW"
 .S V=$P(V,"|",2,9999)
 .S N=$P(V,"|"),N2=$P(V,"|",2),N3=$P(V,"|",3),N4=$P(V,"|",4),N5=$P(V,"|",5),D=$P(V,"|",8)
 .I N5]"" S ^BGPELDCW(BGPIEN,N,N2,N3,N4,N5)=D Q
 .I N4]"" S ^BGPELDCW(BGPIEN,N,N2,N3,N4)=D Q
 .I N3]"" S ^BGPELDCW(BGPIEN,N,N2,N3)=D Q
 .I N2]"" S ^BGPELDCW(BGPIEN,N,N2)=D Q
 .I N]"" S ^BGPELDCW(BGPIEN,N)=D
 .Q
 S DA=BGPIEN,DIK="^BGPELDCW(" D IX1^DIK
ELPY ;
 S DINUM=BGPIEN,X=$P(BGP2,U),DLAYGO=90549.04,DIC="^BGPELDPW(",DIC(0)="L"
 K DD,D0,DO
 D FILE^DICN
 I Y=-1 S BGPRET=0_"^error uploading file......" G EOJ
 S BGPIEN=+Y
 D ^XBFMK
 S X=0 F  S X=$O(^TMP("BGPUPL",$J,X)) Q:X'=+X  S V=^TMP("BGPUPL",$J,X,0) D
 .Q:$P(V,"|")'="BGPELDPW"
 .S V=$P(V,"|",2,9999)
 .S N=$P(V,"|"),N2=$P(V,"|",2),N3=$P(V,"|",3),N4=$P(V,"|",4),N5=$P(V,"|",5),D=$P(V,"|",8)
 .I N5]"" S ^BGPELDPW(BGPIEN,N,N2,N3,N4,N5)=D Q
 .I N4]"" S ^BGPELDPW(BGPIEN,N,N2,N3,N4)=D Q
 .I N3]"" S ^BGPELDPW(BGPIEN,N,N2,N3)=D Q
 .I N2]"" S ^BGPELDPW(BGPIEN,N,N2)=D Q
 .I N]"" S ^BGPELDPW(BGPIEN,N)=D
 .Q
 S DA=BGPIEN,DIK="^BGPELDPW(" D IX1^DIK
ELBY ;
 S DINUM=BGPIEN,X=$P(BGP2,U),DLAYGO=90549.05,DIC="^BGPELDBW(",DIC(0)="L"
 K DD,D0,DO
 D FILE^DICN
 I Y=-1 S BGPRET=0_"^error uploading file......" G EOJ
 S BGPIEN=+Y
 D ^XBFMK
 N X
 S X=0 F  S X=$O(^TMP("BGPUPL",$J,X)) Q:X'=+X  S V=^TMP("BGPUPL",$J,X,0) D
 .Q:$P(V,"|")'="BGPELDBW"
 .S V=$P(V,"|",2,9999)
 .S N=$P(V,"|"),N2=$P(V,"|",2),N3=$P(V,"|",3),N4=$P(V,"|",4),N5=$P(V,"|",5),D=$P(V,"|",8)
 .I N5]"" S ^BGPELDBW(BGPIEN,N,N2,N3,N4,N5)=D Q
 .I N4]"" S ^BGPELDBW(BGPIEN,N,N2,N3,N4)=D Q
 .I N3]"" S ^BGPELDBW(BGPIEN,N,N2,N3)=D Q
 .I N2]"" S ^BGPELDBW(BGPIEN,N,N2)=D Q
 .I N]"" S ^BGPELDBW(BGPIEN,N)=D
 .Q
 S DA=BGPIEN,DIK="^BGPELDBW(" D IX1^DIK
 ;W !,"Data uploaded."
 D EOJ
 Q
 ;
PROCPED ;
 ;W !,"Processing",!
 S BGP2=$P($G(^TMP("BGPUPL",$J,1,0)),"|",9)
 S BGPG=$P($G(^TMP("BGPUPL",$J,1,0)),"|")
 F X=1:1:14 S Y="BGP"_X,@Y=$P(BGP2,U,X)
 ;find existing entry and if exists, delete it
 N X
 S (X,BGPOIEN)=0 F  S X=$O(^BGPPEDCW(X)) Q:X'=+X  S Y=^BGPPEDCW(X,0)  D
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
 I BGPOIEN S DA=BGPOIEN,DIK="^BGPPEDCW(" D ^DIK S DA=BGPOIEN,DIK="^BGPPEDPW(" D ^DIK S DA=BGPOIEN,DIK="^BGPPEDBW(" D ^DIK
 ;add entry
 L +^BGPPEDCW:10 I '$T S BGPRET=0_"^unable to lock global. TRY LATER" D EOJ Q
 L +^BGPPEDPW:10 I '$T S BGPRET=0_"^unable to lock global. TRY LATER" D EOJ Q
 L +^BGPPEDBW:10 I '$T S BGPRET=0_"^unable to lock global. TRY LATER" D EOJ Q
 D GETIEN^BGP2PUTL
 I 'BGPIEN S BGPRET=0_"^error in file creation...call programmer." D EOJ Q
PEDCY ;
 S DINUM=BGPIEN,X=$P(BGP2,U),DLAYGO=90548.12,DIC="^BGPPEDCW(",DIC(0)="L"
 K DD,D0,DO
 D FILE^DICN
 I Y=-1 S BGPRET=0_"^error uploading file......" G EOJ
 S BGPIEN=+Y
 D ^XBFMK
 S X=0 F  S X=$O(^TMP("BGPUPL",$J,X)) Q:X'=+X  S V=^TMP("BGPUPL",$J,X,0) D
 .Q:$P(V,"|")'="BGPPEDCW"
 .S V=$P(V,"|",2,9999)
 .S N=$P(V,"|"),N2=$P(V,"|",2),N3=$P(V,"|",3),N4=$P(V,"|",4),N5=$P(V,"|",5),D=$P(V,"|",8)
 .I N5]"" S ^BGPPEDCW(BGPIEN,N,N2,N3,N4,N5)=D Q
 .I N4]"" S ^BGPPEDCW(BGPIEN,N,N2,N3,N4)=D Q
 .I N3]"" S ^BGPPEDCW(BGPIEN,N,N2,N3)=D Q
 .I N2]"" S ^BGPPEDCW(BGPIEN,N,N2)=D Q
 .I N]"" S ^BGPPEDCW(BGPIEN,N)=D
 .Q
 S DA=BGPIEN,DIK="^BGPPEDCW(" D IX1^DIK
PEDPY ;
 S DINUM=BGPIEN,X=$P(BGP2,U),DLAYGO=90548.13,DIC="^BGPPEDPW(",DIC(0)="L"
 K DD,D0,DO
 D FILE^DICN
 I Y=-1 S BGPRET=0_"^error uploading file......" G EOJ
 S BGPIEN=+Y
 D ^XBFMK
 S X=0 F  S X=$O(^TMP("BGPUPL",$J,X)) Q:X'=+X  S V=^TMP("BGPUPL",$J,X,0) D
 .Q:$P(V,"|")'="BGPPEDPW"
 .S V=$P(V,"|",2,9999)
 .S N=$P(V,"|"),N2=$P(V,"|",2),N3=$P(V,"|",3),N4=$P(V,"|",4),N5=$P(V,"|",5),D=$P(V,"|",8)
 .I N5]"" S ^BGPPEDPW(BGPIEN,N,N2,N3,N4,N5)=D Q
 .I N4]"" S ^BGPPEDPW(BGPIEN,N,N2,N3,N4)=D Q
 .I N3]"" S ^BGPPEDPW(BGPIEN,N,N2,N3)=D Q
 .I N2]"" S ^BGPPEDPW(BGPIEN,N,N2)=D Q
 .I N]"" S ^BGPPEDPW(BGPIEN,N)=D
 .Q
 S DA=BGPIEN,DIK="^BGPPEDPW(" D IX1^DIK
PEDBY ;
 S DINUM=BGPIEN,X=$P(BGP2,U),DLAYGO=90548.14,DIC="^BGPPEDBW(",DIC(0)="L"
 K DD,D0,DO
 D FILE^DICN
 I Y=-1 S BGPRET=0_"^error uploading file......" G EOJ
 S BGPIEN=+Y
 D ^XBFMK
 S X=0 F  S X=$O(^TMP("BGPUPL",$J,X)) Q:X'=+X  S V=^TMP("BGPUPL",$J,X,0) D
 .Q:$P(V,"|")'="BGPPEDBW"
 .S V=$P(V,"|",2,9999)
 .S N=$P(V,"|"),N2=$P(V,"|",2),N3=$P(V,"|",3),N4=$P(V,"|",4),N5=$P(V,"|",5),D=$P(V,"|",8)
 .I N5]"" S ^BGPPEDBW(BGPIEN,N,N2,N3,N4,N5)=D Q
 .I N4]"" S ^BGPPEDBW(BGPIEN,N,N2,N3,N4)=D Q
 .I N3]"" S ^BGPPEDBW(BGPIEN,N,N2,N3)=D Q
 .I N2]"" S ^BGPPEDBW(BGPIEN,N,N2)=D Q
 .I N]"" S ^BGPPEDBW(BGPIEN,N)=D
 .Q
 S DA=BGPIEN,DIK="^BGPPEDBW(" D IX1^DIK
 ;W !,"Data uploaded."
 D EOJ
 Q
 ;
