BGP8ULF1 ; IHS/CMI/LAB - NO DESCRIPTION PROVIDED ; 02 Jul 2008  9:38 AM
 ;;8.0;IHS CLINICAL REPORTING;**2**;MAR 12, 2008
 ;
 ;
PROCEO ;EP
 W !,"Processing",!
 S BGP0=$P($G(^TMP("BGPUPL",$J,1,0)),"|",9)
 S BGPG=$P($G(^TMP("BGPUPL",$J,1,0)),"|")
 F X=1:1:14 S Y="BGP"_X,@Y=$P(BGP0,U,X)
 ;find existing entry and if exists, delete it
 S (X,BGPOIEN)=0 F  S X=$O(^BGPEOCE(X)) Q:X'=+X  D
 .I '$D(^BGPEOCE(X,0)) K ^BGPEOCE(X) Q
 .S Y=^BGPEOCE(X,0)
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
 I BGPOIEN S DA=BGPOIEN,DIK="^BGPEOCE(" D ^DIK S DA=BGPOIEN,DIK="^BGPEOPE(" D ^DIK S DA=BGPOIEN,DIK="^BGPEOBE(" D ^DIK
 ;add entry
 L +^BGPEOCE:10 I '$T W !!,"unable to lock global. TRY LATER" D EOJ^BGP8ULF Q
 L +^BGPEOPE:10 I '$T W !!,"unable to lock global. TRY LATER" D EOJ^BGP8ULF Q
 L +^BGPEOBE:10 I '$T W !!,"unable to lock global. TRY LATER" D EOJ^BGP8ULF Q
 D GETIEN^BGP8EOUT
 I 'BGPIEN W !!,"error in file creation...call programmer." D EOJ^BGP8ULF Q
ELCY ;
 S DINUM=BGPIEN,X=$P(BGP0,U),DLAYGO=90535.1,DIC="^BGPEOCE(",DIC(0)="L"
 K DD,D0,DO
 D FILE^DICN
 I Y=-1 W !,"error uploading file......" H 4 D EOJ^BGP8ULF Q
 S BGPIEN=+Y
 D ^XBFMK
 S X=0 F  S X=$O(^TMP("BGPUPL",$J,X)) Q:X'=+X  S V=^TMP("BGPUPL",$J,X,0) D
 .Q:$P(V,"|")'="BGPEOCE"
 .S V=$P(V,"|",2,9999)
 .S N=$P(V,"|"),N2=$P(V,"|",2),N3=$P(V,"|",3),N4=$P(V,"|",4),N5=$P(V,"|",5),D=$P(V,"|",8)
 .I N5]"" S ^BGPEOCE(BGPIEN,N,N2,N3,N4,N5)=D Q
 .I N4]"" S ^BGPEOCE(BGPIEN,N,N2,N3,N4)=D Q
 .I N3]"" S ^BGPEOCE(BGPIEN,N,N2,N3)=D Q
 .I N2]"" S ^BGPEOCE(BGPIEN,N,N2)=D Q
 .I N]"" S ^BGPEOCE(BGPIEN,N)=D
 .Q
 S DA=BGPIEN,DIK="^BGPEOCE(" D IX1^DIK
ELPY ;
 S DINUM=BGPIEN,X=$P(BGP0,U),DLAYGO=90535.11,DIC="^BGPEOPE(",DIC(0)="L"
 K DD,D0,DO
 D FILE^DICN
 I Y=-1 W !,"error uploading file......" H 4 D EOJ^BGP8ULF Q
 S BGPIEN=+Y
 D ^XBFMK
 S X=0 F  S X=$O(^TMP("BGPUPL",$J,X)) Q:X'=+X  S V=^TMP("BGPUPL",$J,X,0) D
 .Q:$P(V,"|")'="BGPEOPE"
 .S V=$P(V,"|",2,9999)
 .S N=$P(V,"|"),N2=$P(V,"|",2),N3=$P(V,"|",3),N4=$P(V,"|",4),N5=$P(V,"|",5),D=$P(V,"|",8)
 .I N5]"" S ^BGPEOPE(BGPIEN,N,N2,N3,N4,N5)=D Q
 .I N4]"" S ^BGPEOPE(BGPIEN,N,N2,N3,N4)=D Q
 .I N3]"" S ^BGPEOPE(BGPIEN,N,N2,N3)=D Q
 .I N2]"" S ^BGPEOPE(BGPIEN,N,N2)=D Q
 .I N]"" S ^BGPEOPE(BGPIEN,N)=D
 .Q
 S DA=BGPIEN,DIK="^BGPEOPE(" D IX1^DIK
ELBY ;
 S DINUM=BGPIEN,X=$P(BGP0,U),DLAYGO=90535.12,DIC="^BGPEOBE(",DIC(0)="L"
 K DD,D0,DO
 D FILE^DICN
 I Y=-1 W !,"error uploading file......" H 4 D EOJ^BGP8ULF Q
 S BGPIEN=+Y
 D ^XBFMK
 S X=0 F  S X=$O(^TMP("BGPUPL",$J,X)) Q:X'=+X  S V=^TMP("BGPUPL",$J,X,0) D
 .Q:$P(V,"|")'="BGPEOBE"
 .S V=$P(V,"|",2,9999)
 .S N=$P(V,"|"),N2=$P(V,"|",2),N3=$P(V,"|",3),N4=$P(V,"|",4),N5=$P(V,"|",5),D=$P(V,"|",8)
 .I N5]"" S ^BGPEOBE(BGPIEN,N,N2,N3,N4,N5)=D Q
 .I N4]"" S ^BGPEOBE(BGPIEN,N,N2,N3,N4)=D Q
 .I N3]"" S ^BGPEOBE(BGPIEN,N,N2,N3)=D Q
 .I N2]"" S ^BGPEOBE(BGPIEN,N,N2)=D Q
 .I N]"" S ^BGPEOBE(BGPIEN,N)=D
 .Q
 S DA=BGPIEN,DIK="^BGPEOBE(" D IX1^DIK
 W !,"Data uploaded."
 D EOJ^BGP8ULF
 Q
 ;
