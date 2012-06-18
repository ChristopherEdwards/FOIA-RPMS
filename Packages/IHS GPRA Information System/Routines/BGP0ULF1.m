BGP0ULF1 ; IHS/CMI/LAB - NO DESCRIPTION PROVIDED 02 Jul 2009 9:38 AM ;
 ;;10.0;IHS CLINICAL REPORTING;;JUN 18, 2010
 ;
 ;
PROCEO ;EP
 W !,"Processing",!
 S BGP0=$P($G(^TMP("BGPUPL",$J,1,0)),"|",9)
 S BGPG=$P($G(^TMP("BGPUPL",$J,1,0)),"|")
 F X=1:1:14 S Y="BGP"_X,@Y=$P(BGP0,U,X)
 ;find existing entry and if exists, delete it
 S (X,BGPOIEN)=0 F  S X=$O(^BGPEOCT(X)) Q:X'=+X  D
 .I '$D(^BGPEOCT(X,0)) K ^BGPEOCT(X) Q
 .S Y=^BGPEOCT(X,0)
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
 I BGPOIEN S DA=BGPOIEN,DIK="^BGPEOCT(" D ^DIK S DA=BGPOIEN,DIK="^BGPEOPT(" D ^DIK S DA=BGPOIEN,DIK="^BGPEOBT(" D ^DIK
 ;add entry
 L +^BGPEOCT:10 I '$T W !!,"unable to lock global. TRY LATER" D EOJ^BGP0ULF Q
 L +^BGPEOPT:10 I '$T W !!,"unable to lock global. TRY LATER" D EOJ^BGP0ULF Q
 L +^BGPEOBT:10 I '$T W !!,"unable to lock global. TRY LATER" D EOJ^BGP0ULF Q
 D GETIEN^BGP0EOUT
 I 'BGPIEN W !!,"error in file creation...call programmer." D EOJ^BGP0ULF Q
ELCY ;
 S DINUM=BGPIEN,X=$P(BGP0,U),DLAYGO=90379.1,DIC="^BGPEOCT(",DIC(0)="L"
 K DD,D0,DO
 D FILE^DICN
 I Y=-1 W !,"error uploading file......" H 4 D EOJ^BGP0ULF Q
 S BGPIEN=+Y
 D ^XBFMK
 S X=0 F  S X=$O(^TMP("BGPUPL",$J,X)) Q:X'=+X  S V=^TMP("BGPUPL",$J,X,0) D
 .Q:$P(V,"|")'="BGPEOCT"
 .S V=$P(V,"|",2,9999)
 .S N=$P(V,"|"),N2=$P(V,"|",2),N3=$P(V,"|",3),N4=$P(V,"|",4),N5=$P(V,"|",5),D=$P(V,"|",8)
 .I N5]"" S ^BGPEOCT(BGPIEN,N,N2,N3,N4,N5)=D Q
 .I N4]"" S ^BGPEOCT(BGPIEN,N,N2,N3,N4)=D Q
 .I N3]"" S ^BGPEOCT(BGPIEN,N,N2,N3)=D Q
 .I N2]"" S ^BGPEOCT(BGPIEN,N,N2)=D Q
 .I N]"" S ^BGPEOCT(BGPIEN,N)=D
 .Q
 S DA=BGPIEN,DIK="^BGPEOCT(" D IX1^DIK
ELPY ;
 S DINUM=BGPIEN,X=$P(BGP0,U),DLAYGO=90379.11,DIC="^BGPEOPT(",DIC(0)="L"
 K DD,D0,DO
 D FILE^DICN
 I Y=-1 W !,"error uploading file......" H 4 D EOJ^BGP0ULF Q
 S BGPIEN=+Y
 D ^XBFMK
 S X=0 F  S X=$O(^TMP("BGPUPL",$J,X)) Q:X'=+X  S V=^TMP("BGPUPL",$J,X,0) D
 .Q:$P(V,"|")'="BGPEOPT"
 .S V=$P(V,"|",2,9999)
 .S N=$P(V,"|"),N2=$P(V,"|",2),N3=$P(V,"|",3),N4=$P(V,"|",4),N5=$P(V,"|",5),D=$P(V,"|",8)
 .I N5]"" S ^BGPEOPT(BGPIEN,N,N2,N3,N4,N5)=D Q
 .I N4]"" S ^BGPEOPT(BGPIEN,N,N2,N3,N4)=D Q
 .I N3]"" S ^BGPEOPT(BGPIEN,N,N2,N3)=D Q
 .I N2]"" S ^BGPEOPT(BGPIEN,N,N2)=D Q
 .I N]"" S ^BGPEOPT(BGPIEN,N)=D
 .Q
 S DA=BGPIEN,DIK="^BGPEOPT(" D IX1^DIK
ELBY ;
 S DINUM=BGPIEN,X=$P(BGP0,U),DLAYGO=90379.12,DIC="^BGPEOBT(",DIC(0)="L"
 K DD,D0,DO
 D FILE^DICN
 I Y=-1 W !,"error uploading file......" H 4 D EOJ^BGP0ULF Q
 S BGPIEN=+Y
 D ^XBFMK
 S X=0 F  S X=$O(^TMP("BGPUPL",$J,X)) Q:X'=+X  S V=^TMP("BGPUPL",$J,X,0) D
 .Q:$P(V,"|")'="BGPEOBT"
 .S V=$P(V,"|",2,9999)
 .S N=$P(V,"|"),N2=$P(V,"|",2),N3=$P(V,"|",3),N4=$P(V,"|",4),N5=$P(V,"|",5),D=$P(V,"|",8)
 .I N5]"" S ^BGPEOBT(BGPIEN,N,N2,N3,N4,N5)=D Q
 .I N4]"" S ^BGPEOBT(BGPIEN,N,N2,N3,N4)=D Q
 .I N3]"" S ^BGPEOBT(BGPIEN,N,N2,N3)=D Q
 .I N2]"" S ^BGPEOBT(BGPIEN,N,N2)=D Q
 .I N]"" S ^BGPEOBT(BGPIEN,N)=D
 .Q
 S DA=BGPIEN,DIK="^BGPEOBT(" D IX1^DIK
 W !,"Data uploaded."
 D EOJ^BGP0ULF
 Q
 ;
