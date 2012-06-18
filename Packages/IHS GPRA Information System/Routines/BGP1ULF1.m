BGP1ULF1 ; IHS/CMI/LAB - NO DESCRIPTION PROVIDED 02 Jul 2010 9:38 AM ;
 ;;11.1;IHS CLINICAL REPORTING SYSTEM;;JUN 27, 2011;Build 33
 ;
 ;
PROCEO ;EP
 W !,"Processing",!
 S BGP0=$P($G(^TMP("BGPUPL",$J,1,0)),"|",9)
 S BGPG=$P($G(^TMP("BGPUPL",$J,1,0)),"|")
 F X=1:1:14 S Y="BGP"_X,@Y=$P(BGP0,U,X)
 ;find existing entry and if exists, delete it
 S (X,BGPOIEN)=0 F  S X=$O(^BGPEOCB(X)) Q:X'=+X  D
 .I '$D(^BGPEOCB(X,0)) K ^BGPEOCB(X) Q
 .S Y=^BGPEOCB(X,0)
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
 I BGPOIEN S DA=BGPOIEN,DIK="^BGPEOCB(" D ^DIK S DA=BGPOIEN,DIK="^BGPEOPB(" D ^DIK S DA=BGPOIEN,DIK="^BGPEOBB(" D ^DIK
 ;add entry
 L +^BGPEOCB:10 I '$T W !!,"unable to lock global. TRY LATER" D EOJ^BGP1ULF Q
 L +^BGPEOPB:10 I '$T W !!,"unable to lock global. TRY LATER" D EOJ^BGP1ULF Q
 L +^BGPEOBB:10 I '$T W !!,"unable to lock global. TRY LATER" D EOJ^BGP1ULF Q
 D GETIEN^BGP1EOUT
 I 'BGPIEN W !!,"error in file creation...call programmer." D EOJ^BGP1ULF Q
ELCY ;
 S DINUM=BGPIEN,X=$P(BGP0,U),DLAYGO=90547.1,DIC="^BGPEOCB(",DIC(0)="L"
 K DD,D0,DO
 D FILE^DICN
 I Y=-1 W !,"error uploading file......" H 4 D EOJ^BGP1ULF Q
 S BGPIEN=+Y
 D ^XBFMK
 S X=0 F  S X=$O(^TMP("BGPUPL",$J,X)) Q:X'=+X  S V=^TMP("BGPUPL",$J,X,0) D
 .Q:$P(V,"|")'="BGPEOCB"
 .S V=$P(V,"|",2,9999)
 .S N=$P(V,"|"),N2=$P(V,"|",2),N3=$P(V,"|",3),N4=$P(V,"|",4),N5=$P(V,"|",5),D=$P(V,"|",8)
 .I N5]"" S ^BGPEOCB(BGPIEN,N,N2,N3,N4,N5)=D Q
 .I N4]"" S ^BGPEOCB(BGPIEN,N,N2,N3,N4)=D Q
 .I N3]"" S ^BGPEOCB(BGPIEN,N,N2,N3)=D Q
 .I N2]"" S ^BGPEOCB(BGPIEN,N,N2)=D Q
 .I N]"" S ^BGPEOCB(BGPIEN,N)=D
 .Q
 S DA=BGPIEN,DIK="^BGPEOCB(" D IX1^DIK
ELPY ;
 S DINUM=BGPIEN,X=$P(BGP0,U),DLAYGO=90547.11,DIC="^BGPEOPB(",DIC(0)="L"
 K DD,D0,DO
 D FILE^DICN
 I Y=-1 W !,"error uploading file......" H 4 D EOJ^BGP1ULF Q
 S BGPIEN=+Y
 D ^XBFMK
 S X=0 F  S X=$O(^TMP("BGPUPL",$J,X)) Q:X'=+X  S V=^TMP("BGPUPL",$J,X,0) D
 .Q:$P(V,"|")'="BGPEOPB"
 .S V=$P(V,"|",2,9999)
 .S N=$P(V,"|"),N2=$P(V,"|",2),N3=$P(V,"|",3),N4=$P(V,"|",4),N5=$P(V,"|",5),D=$P(V,"|",8)
 .I N5]"" S ^BGPEOPB(BGPIEN,N,N2,N3,N4,N5)=D Q
 .I N4]"" S ^BGPEOPB(BGPIEN,N,N2,N3,N4)=D Q
 .I N3]"" S ^BGPEOPB(BGPIEN,N,N2,N3)=D Q
 .I N2]"" S ^BGPEOPB(BGPIEN,N,N2)=D Q
 .I N]"" S ^BGPEOPB(BGPIEN,N)=D
 .Q
 S DA=BGPIEN,DIK="^BGPEOPB(" D IX1^DIK
ELBY ;
 S DINUM=BGPIEN,X=$P(BGP0,U),DLAYGO=90547.12,DIC="^BGPEOBB(",DIC(0)="L"
 K DD,D0,DO
 D FILE^DICN
 I Y=-1 W !,"error uploading file......" H 4 D EOJ^BGP1ULF Q
 S BGPIEN=+Y
 D ^XBFMK
 S X=0 F  S X=$O(^TMP("BGPUPL",$J,X)) Q:X'=+X  S V=^TMP("BGPUPL",$J,X,0) D
 .Q:$P(V,"|")'="BGPEOBB"
 .S V=$P(V,"|",2,9999)
 .S N=$P(V,"|"),N2=$P(V,"|",2),N3=$P(V,"|",3),N4=$P(V,"|",4),N5=$P(V,"|",5),D=$P(V,"|",8)
 .I N5]"" S ^BGPEOBB(BGPIEN,N,N2,N3,N4,N5)=D Q
 .I N4]"" S ^BGPEOBB(BGPIEN,N,N2,N3,N4)=D Q
 .I N3]"" S ^BGPEOBB(BGPIEN,N,N2,N3)=D Q
 .I N2]"" S ^BGPEOBB(BGPIEN,N,N2)=D Q
 .I N]"" S ^BGPEOBB(BGPIEN,N)=D
 .Q
 S DA=BGPIEN,DIK="^BGPEOBB(" D IX1^DIK
 W !,"Data uploaded."
 D EOJ^BGP1ULF
 Q
 ;
