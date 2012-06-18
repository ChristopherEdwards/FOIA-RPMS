BGP9GUP1 ; IHS/CMI/LAB - GUI Upload Continued ;
 ;;9.0;IHS CLINICAL REPORTING;**1**;JUL 01, 2009
 ;
 ;
PROCEO ;EP
 ;W !,"Processing",!
 S BGP0=$P($G(^TMP("BGPUPL",$J,1,0)),"|",9)
 S BGPG=$P($G(^TMP("BGPUPL",$J,1,0)),"|")
 F X=1:1:14 S Y="BGP"_X,@Y=$P(BGP0,U,X)
 ;find existing entry and if exists, delete it
 S (X,BGPOIEN)=0 F  S X=$O(^BGPEOCN(X)) Q:X'=+X  D
 .I '$D(^BGPEOCN(X,0)) K ^BGPEOCN(X) Q
 .S Y=^BGPEOCN(X,0)
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
 I BGPOIEN S DA=BGPOIEN,DIK="^BGPEOCN(" D ^DIK S DA=BGPOIEN,DIK="^BGPEOPN(" D ^DIK S DA=BGPOIEN,DIK="^BGPEOBN(" D ^DIK
 ;add entry
 L +^BGPEOCN:10 I '$T W !!,"unable to lock global. TRY LATER" D EOJ^BGP9GUPL Q
 L +^BGPEOPN:10 I '$T W !!,"unable to lock global. TRY LATER" D EOJ^BGP9GUPL Q
 L +^BGPEOBN:10 I '$T W !!,"unable to lock global. TRY LATER" D EOJ^BGP9GUPL Q
 D GETIEN^BGP9EOUT
 I 'BGPIEN S BGPRET=0_"^error in file creation...call programmer." D EOJ^BGP9GUPL Q
ELCY ;
 S DINUM=BGPIEN,X=$P(BGP0,U),DLAYGO=90538.1,DIC="^BGPEOCN(",DIC(0)="L"
 K DD,D0,DO
 D FILE^DICN
 I Y=-1 S BGPRET=0_"^error uploading file" D EOJ^BGP9GUPL Q
 S BGPIEN=+Y
 D ^XBFMK
 S X=0 F  S X=$O(^TMP("BGPUPL",$J,X)) Q:X'=+X  S V=^TMP("BGPUPL",$J,X,0) D
 .Q:$P(V,"|")'="BGPEOCN"
 .S V=$P(V,"|",2,9999)
 .S N=$P(V,"|"),N2=$P(V,"|",2),N3=$P(V,"|",3),N4=$P(V,"|",4),N5=$P(V,"|",5),D=$P(V,"|",8)
 .I N5]"" S ^BGPEOCN(BGPIEN,N,N2,N3,N4,N5)=D Q
 .I N4]"" S ^BGPEOCN(BGPIEN,N,N2,N3,N4)=D Q
 .I N3]"" S ^BGPEOCN(BGPIEN,N,N2,N3)=D Q
 .I N2]"" S ^BGPEOCN(BGPIEN,N,N2)=D Q
 .I N]"" S ^BGPEOCN(BGPIEN,N)=D
 .Q
 S DA=BGPIEN,DIK="^BGPEOCN(" D IX1^DIK
ELPY ;
 S DINUM=BGPIEN,X=$P(BGP0,U),DLAYGO=90538.11,DIC="^BGPEOPN(",DIC(0)="L"
 K DD,D0,DO
 D FILE^DICN
 I Y=-1 S BGPRET=0_"^error uploading file" D EOJ^BGP9GUPL Q
 S BGPIEN=+Y
 D ^XBFMK
 S X=0 F  S X=$O(^TMP("BGPUPL",$J,X)) Q:X'=+X  S V=^TMP("BGPUPL",$J,X,0) D
 .Q:$P(V,"|")'="BGPEOPN"
 .S V=$P(V,"|",2,9999)
 .S N=$P(V,"|"),N2=$P(V,"|",2),N3=$P(V,"|",3),N4=$P(V,"|",4),N5=$P(V,"|",5),D=$P(V,"|",8)
 .I N5]"" S ^BGPEOPN(BGPIEN,N,N2,N3,N4,N5)=D Q
 .I N4]"" S ^BGPEOPN(BGPIEN,N,N2,N3,N4)=D Q
 .I N3]"" S ^BGPEOPN(BGPIEN,N,N2,N3)=D Q
 .I N2]"" S ^BGPEOPN(BGPIEN,N,N2)=D Q
 .I N]"" S ^BGPEOPN(BGPIEN,N)=D
 .Q
 S DA=BGPIEN,DIK="^BGPEOPN(" D IX1^DIK
ELBY ;
 S DINUM=BGPIEN,X=$P(BGP0,U),DLAYGO=90538.12,DIC="^BGPEOBN(",DIC(0)="L"
 K DD,D0,DO
 D FILE^DICN
 I Y=-1 S BGPRET=0_"^error uploading file" D EOJ^BGP9GUPL Q
 S BGPIEN=+Y
 D ^XBFMK
 S X=0 F  S X=$O(^TMP("BGPUPL",$J,X)) Q:X'=+X  S V=^TMP("BGPUPL",$J,X,0) D
 .Q:$P(V,"|")'="BGPEOBN"
 .S V=$P(V,"|",2,9999)
 .S N=$P(V,"|"),N2=$P(V,"|",2),N3=$P(V,"|",3),N4=$P(V,"|",4),N5=$P(V,"|",5),D=$P(V,"|",8)
 .I N5]"" S ^BGPEOBN(BGPIEN,N,N2,N3,N4,N5)=D Q
 .I N4]"" S ^BGPEOBN(BGPIEN,N,N2,N3,N4)=D Q
 .I N3]"" S ^BGPEOBN(BGPIEN,N,N2,N3)=D Q
 .I N2]"" S ^BGPEOBN(BGPIEN,N,N2)=D Q
 .I N]"" S ^BGPEOBN(BGPIEN,N)=D
 .Q
 S DA=BGPIEN,DIK="^BGPEOBN(" D IX1^DIK
 D EOJ^BGP9GUPL
 Q
 ;
