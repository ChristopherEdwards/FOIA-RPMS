ORDV04A ;SLC/DAN - OE/RR ;7/30/01  14:33
 ;;3.0;ORDER ENTRY/RESULTS REPORTING;**109**;Dec 17,1997
 ;
 Q
ENSR ; Entry point for component
 ;External calls to ^GMTSROB, ^DIQ, ^GMTSORC, ^DIWP
 ;External references to ^SRF, ^DD, ^ICPT
 N GMIDT,GMN,SURG
 I '$D(^SRF("B",DFN)) Q
 S GMN=0 F  S GMN=$O(^SRF("B",DFN,GMN)) Q:GMN'>0  D SORT
 I '$D(SURG) Q
 S GMIDT=0 F  S GMIDT=$O(SURG(GMIDT)) Q:GMIDT'>0!(ORCNT'<ORMAX)  S GMN=SURG(GMIDT) D EXTRCT
 Q
 ;
SORT ; Sort surgeries by inverted date
 N GMDT
 S GMDT=$P(^SRF(GMN,0),U,9) I GMDT>ORDBEG&(GMDT<ORDEND) D
 . F  Q:'$D(SURG(9999999-GMDT))  S GMDT=GMDT+.0001
 . S SURG(9999999-GMDT)=GMN
 Q
EXTRCT ; Extract surgical case record
 N X,GMI,GMDT,OPPRC,POSDX,PREDX,SPEC,STATUS,SURGEON,VER
 N DCTDTM,TRSDTM,Y,C,DIWL,DIWF,ORSITE,ORMORE,SITE
 S ORCNT=ORCNT+1,ORMORE=0
 S GMDT=$$DATE^ORDVU($P(^SRF(GMN,0),U,9))
 D STATUS^GMTSROB S:'$D(STATUS) STATUS="UNKNOWN"
 S X=$P(^SRF(GMN,0),U,4) I X>0 S Y=X,C=$P(^DD(130,.04,0),U,2) D Y^DIQ S SPEC=Y K Y
 I $D(^SRF(GMN,.1)) S X=$P(^SRF(GMN,.1),U,4) I X>0 S Y=X,C=$P(^DD(130,.14,0),U,2) D Y^DIQ S SURGEON=Y K Y
 S VER=$S($G(^SRF(GMN,"VER"))'="Y":"(Unverified)",1:"")
 S PREDX(0)=$S($G(^SRF(GMN,33))]"":$P(^(33),U),1:"") S GMI=0 F  S GMI=$O(^SRF(GMN,14,GMI)) Q:GMI'>0  S PREDX(GMI)=$P(^SRF(GMN,14,GMI,0),U)
 S POSDX(0)=$S($G(^SRF(GMN,34))]"":$P(^(34),U),1:"") S GMI=0 F  S GMI=$O(^SRF(GMN,15,GMI)) Q:GMI'>0  S POSDX(GMI)=$P(^SRF(GMN,15,GMI,0),U)
 S OPPRC(0)=$P($G(^SRF(GMN,"OP")),U,1,2) S:$P(OPPRC(0),U,2)]"" $P(OPPRC(0),U,2)=$P($$CPT^ICPTCOD($P($G(^SRF(GMN,"OP")),U,2)),U,3) D
 . S GMI=0 F  S GMI=$O(^SRF(GMN,13,GMI)) Q:GMI'>0  S OPPRC(GMI)=$P($G(^SRF(GMN,13,GMI,0)),U)_U_$G(^SRF(GMN,13,GMI,2)) S:$P(OPPRC(GMI),U,2)]"" $P(OPPRC(GMI),U,2)=$P($$CPT^ICPTCOD($P($G(^SRF(GMN,13,GMI,2)),U)),U,3)
 S X=$P($G(^SRF(GMN,31)),U,6) S:X>0 DCTDTM=$$DATE^ORDVU(X)
 S X=$P($G(^SRF(GMN,31)),U,7) S:X>0 TRSDTM=$$DATE^ORDVU(X)
 S DIWL=0,DIWF="N",ORSITE=$$SITE^VASITE,ORSITE=$P(ORSITE,"^",2)_";"_$P(ORSITE,"^",3)
 K ^UTILITY($J,"W")
 I $D(^SRF(GMN,12)) F GMI=1:1:$P(^SRF(GMN,12,0),U,4) S X=^SRF(GMN,12,GMI,0) D ^DIWP
 S SITE=ORSITE
 S ^TMP("ORDATA",$J,GMIDT,"WP",1)="1^"_SITE ;Station ID
 S ^TMP("ORDATA",$J,GMIDT,"WP",2)="2^"_GMDT ; date
 ;
 ; Operative Procedure(s)
 S GMI="" F  S GMI=$O(OPPRC(GMI)) Q:GMI=""  D  S:GMI ORMORE=1
 . S ^TMP("ORDATA",$J,GMIDT,"WP",3,GMI)="3^"_$P(OPPRC(GMI),U)_$S($P(OPPRC(GMI),U,2)]"":" - "_$P(OPPRC(GMI),U,2),1:"")
 ;
 S ^TMP("ORDATA",$J,GMIDT,"WP",4)="4^"_$G(SPEC) ;surgical specialty
 ;
 S ^TMP("ORDATA",$J,GMIDT,"WP",5)="5^"_$G(SURGEON) ; surgeon
 S ^TMP("ORDATA",$J,GMIDT,"WP",6)="6^"_$G(STATUS) ; op status
 ;
 ; Pre-operative diagnosis
 S GMI="" F  S GMI=$O(PREDX(GMI)) Q:GMI=""  D  S:GMI ORMORE=1
 . S ^TMP("ORDATA",$J,GMIDT,"WP",7,GMI)="7^"_PREDX(GMI)
 ;
 ; Post-operative diagnosis
 S GMI="" F  S GMI=$O(POSDX(GMI)) Q:GMI=""  D  S:GMI ORMORE=1
 . S ^TMP("ORDATA",$J,GMIDT,"WP",8,GMI)="8^"_POSDX(GMI)
 ;
 ; Lab work? Y/N
 S ^TMP("ORDATA",$J,GMIDT,"WP",9)="9^"_$S($O(^SRF(GMN,9,0)):"Yes",1:"No")
 S ^TMP("ORDATA",$J,GMIDT,"WP",10)="10^"_$G(DCTDTM) ; dictation time
 S ^TMP("ORDATA",$J,GMIDT,"WP",11)="11^"_$G(TRSDTM) ; transcription time
 ;
 ; surgeon's dictation
 I $D(^UTILITY($J,"W")) D  S ORMORE=1
 . K ^TMP("ORHSSRT",$J)
 . F GMI=1:1:^UTILITY($J,"W",DIWL) D
 .. S ^TMP("ORHSSRT",$J,GMIDT,"WP",GMI)=^UTILITY($J,"W",DIWL,GMI,0)
 . D SPMRG^ORDVU($NA(^TMP("ORHSSRT",$J,GMIDT,"WP")),$NA(^TMP("ORDATA",$J,GMIDT,"WP",12)),12)
 . K ^UTILITY($J,"W")
 . K ^TMP("ORHSSRT",$J)
 I ORMORE S ^TMP("ORDATA",$J,GMIDT,"WP",13)="13^[+]" ;flag for detail
 Q
