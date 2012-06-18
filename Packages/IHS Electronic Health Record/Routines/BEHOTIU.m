BEHOTIU ;MSC/IND/DKM - TIU extensions;01-Dec-2009 12:24;MGH
 ;;1.1;BEH COMPONENTS;**015002**;Sep 18, 2007
 ;=================================================================
 ; RPC: Returns true if document has an associated diagnosis
HASDX(DATA,DOCIEN,DXS,ONEONLY) ;EP
 N VIEN,LP1,LP2,NAR1,NAR2,NAR3,ICD,X,Y
 S DATA=0,ONEONLY=$G(ONEONLY,1),VIEN=$P($G(^TIU(8925,+DOCIEN,0)),U,3)
 Q:'VIEN
 S LP1=0,DXS=""
 F  S DXS=$O(DXS(DXS)) Q:'$L(DXS)  D
 .I $TR(DXS(DXS)," ")="" K DXS(DXS)
 .E  S DXS(DXS)=$$UP^XLFSTR(DXS(DXS))
 F  S LP1=$O(^AUPNVPOV("AD",VIEN,LP1)) Q:'LP1  D  Q:DATA
 .S X=$G(^AUPNVPOV(LP1,0))
 .Q:'X
 .S NAR1=$P(X,U,4)
 .S:NAR1 NAR1=$P($G(^AUTNPOV(NAR1,0)),U)
 .S X=$G(^ICD9(+X,0)),NAR3=$G(^(1))
 .S ICD=$P(X,U),NAR2=$P(X,U,3)
 .S DXS=""
 .F  S DXS=$O(DXS(DXS)) Q:'$L(DXS)  D  Q:DATA
 ..S X=DXS(DXS)
 ..I X=ICD
 ..E  I NAR1[X
 ..E  I NAR2[X
 ..E  I NAR3[X
 ..E  Q
 ..I ONEONLY K DXS
 ..E  K DXS(DXS)
 ..S DATA=$D(DXS)<10
 Q
 ; RPC: Get title IEN given name
TITLEIEN(DATA,VALUE) ;EP
 S DATA=$O(^TIU(8925.1,"B",VALUE,0))
 Q
 ; RPC: Get document text associated with package reference
DOCTEXT(DATA,PKGREF) ;EP
 N TIUDA,UND,GBL,CANVIEW
 Q:'$L(PKGREF)
 S TIUDA=0,UND=$$REPEAT^XLFSTR("-",80)
 F  S TIUDA=$O(^TIU(8925,"G",PKGREF,TIUDA)) Q:'TIUDA  D
 .S CANVIEW=$$CANDO^TIULP(TIUDA,"VIEW")
 .I +CANVIEW>0 D
 ..D TGET^TIUSRVR1(.GBL,TIUDA)
 ..S @GBL@(0)=UND
 ..M @DATA@(TIUDA)=@GBL
 ..K @GBL
 Q
