BGP7GUPL ; IHS/CMI/LAB - GUI Upload 16 May 2016 2:34 PM ; 
 ;;17.0;IHS CLINICAL REPORTING;;AUG 30, 2016;Build 16
 ;
 ;
EP(BGPRET,BGPUSER,BGPDUZ2,BGPOPTN,BGPDIR,BGPFILE,BGPRTIME) ;EP - called from GUI to produce COM REPORT CI05-AO-UPL
 ; SEE ROUTINE BGP7DL if you have questions about any of these variables
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
 ;  I put the list of files in the BGPGUIG global in field 1100 as an output
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
 I $P(BGPFILE,".",2)["EL" D PROCEL Q
 I $P(BGPFILE,".",2)["PED" D PROCPED Q
 ;W !,"Processing",!
 S BGP0=$P($G(^TMP("BGPUPL",$J,1,0)),"|",9)
 S BGPG=$P($G(^TMP("BGPUPL",$J,1,0)),"|")
 F X=1:1:14,21 S Y="BGP"_X,@Y=$P(BGP0,U,X)
 I BGP21="" S BGP21="16"
 ;find existing entry and if exists, delete it
 N X
 S (X,BGPOIEN)=0 F  S X=$O(^BGPGPDCG(X)) Q:X'=+X  D
 .Q:'$D(^BGPGPDCG(X,0))
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
 L +^BGPGPDCG:10 I '$T S BGPRET=0_"^unable to lock global. TRY LATER" D EOJ Q
 L +^BGPGPDPG:10 I '$T S BGPRET=0_"^unable to lock global. TRY LATER" D EOJ Q
 L +^BGPGPDBG:10 I '$T S BGPRET=0_"^unable to lock global. TRY LATER" D EOJ Q
 D GETIEN^BGP7UTL
 I 'BGPIEN S BGPRET=0_"^error in file creation...call programmer." D EOJ Q
CY ;
 S DINUM=BGPIEN,X=$P(BGP0,U),DLAYGO=90558.03,DIC="^BGPGPDCG(",DIC(0)="L"
 K DD,D0,DO
 D FILE^DICN
 I Y=-1 S BGPRET=0_"^error uploading file......" G EOJ
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
 I Y=-1 S BGPRET=0_"^error uploading file......" G EOJ
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
 I Y=-1 S BGPRET=0_"^error uploading file......" G EOJ
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
 ;W !,"Data uploaded."
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
 ;D EOP^BGP7DH
 K IOPAR
 ;D HOME^%ZIS
 K X,X1,X2,X3,X4,X5,X6
 K A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,V,W,X,Y,Z
 K N,N1,N2,N3,N4,N5,N6
 K DIC,DA,X,Y,%Y,%,BGPJ,BGPTEXT,BGPLINE,BGP
 K BGP1,BGP2,BGP3,BGP4,BGP7,BGP7,BGP7,BGP8,BGP9,BGP10,BGP11,BGP12,BGP13,BGP14,BGP21
 Q
STRIP(Z) ;REMOVE CONTROLL CHARACTERS
 NEW I
 F I=1:1:$L(Z) I (32>$A($E(Z,I))) S Z=$E(Z,1,I-1)_""_$E(Z,I+1,999)
 Q Z
PROCEL ;
 ;W !,"Processing",!
 S BGP0=$P($G(^TMP("BGPUPL",$J,1,0)),"|",9)
 S BGPG=$P($G(^TMP("BGPUPL",$J,1,0)),"|")
 F X=1:1:14 S Y="BGP"_X,@Y=$P(BGP0,U,X)
 ;find existing entry and if exists, delete it
 N X
 S (X,BGPOIEN)=0 F  S X=$O(^BGPEDLCG(X)) Q:X'=+X  S Y=^BGPEDLCG(X,0)  D
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
 L +^BGPEDLCG:10 I '$T S BGPRET=0_"^unable to lock global. TRY LATER" D EOJ Q
 L +^BGPEDLPG:10 I '$T S BGPRET=0_"^unable to lock global. TRY LATER" D EOJ Q
 L +^BGPEDLBG:10 I '$T S BGPRET=0_"^unable to lock global. TRY LATER" D EOJ Q
 D GETIEN^BGP7EUTL
 I 'BGPIEN S BGPRET=0_"^error in file creation...call programmer." D EOJ Q
ELCY ;
 S DINUM=BGPIEN,X=$P(BGP0,U),DLAYGO=90559.03,DIC="^BGPEDLCG(",DIC(0)="L"
 K DD,D0,DO
 D FILE^DICN
 I Y=-1 S BGPRET=0_"^error uploading file......" G EOJ
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
 I Y=-1 S BGPRET=0_"^error uploading file......" G EOJ
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
 I Y=-1 S BGPRET=0_"^error uploading file......" G EOJ
 S BGPIEN=+Y
 D ^XBFMK
 N X
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
 S (X,BGPOIEN)=0 F  S X=$O(^BGPPEDCG(X)) Q:X'=+X  S Y=^BGPPEDCG(X,0)  D
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
 L +^BGPPEDCG:10 I '$T S BGPRET=0_"^unable to lock global. TRY LATER" D EOJ Q
 L +^BGPPEDPG:10 I '$T S BGPRET=0_"^unable to lock global. TRY LATER" D EOJ Q
 L +^BGPPEDBG:10 I '$T S BGPRET=0_"^unable to lock global. TRY LATER" D EOJ Q
 D GETIEN^BGP7PUTL
 I 'BGPIEN S BGPRET=0_"^error in file creation...call programmer." D EOJ Q
PEDCY ;
 S DINUM=BGPIEN,X=$P(BGP0,U),DLAYGO=90558.12,DIC="^BGPPEDCG(",DIC(0)="L"
 K DD,D0,DO
 D FILE^DICN
 I Y=-1 S BGPRET=0_"^error uploading file......" G EOJ
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
 I Y=-1 S BGPRET=0_"^error uploading file......" G EOJ
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
 I Y=-1 S BGPRET=0_"^error uploading file......" G EOJ
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
 ;W !,"Data uploaded."
 D EOJ
 Q
 ;
