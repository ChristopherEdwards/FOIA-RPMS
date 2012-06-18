AMHESIG ; IHS/CMI/LAB - ADD NEW MHSS ACTIVITY RECORDS 13 Aug 2007 4:21 PM 11 Jan 2010 5:19 PM ;
 ;;4.0;IHS BEHAVIORAL HEALTH;**1**;JUN 18, 2010;Build 8
 ;
 ;
ESIG(R,G) ;EP - called for esig
 NEW X1,DA,DR,DIE,D
 I '$D(^AMHREC(R,0)) Q "0^0^Invalid VISIT, no Esig required"
 I '$P(^AMHREC(R,0),U,8) Q "0^0"
 I '$$ESIGREQ(R),'$P($G(^AMHREC(R,11)),U,10) Q "0^1^E Sig not required for this visit, visit is prior to Version 4.0 install date."  ;not required
 I $P($G(^AMHREC(R,11)),U,10) Q "0^0^EHR created notes can only be signed in EHR" ;no EHR visits  cmi/maw 9/30/2009 changed text at request of PR 480
 I $P($G(^AMHREC(R,11)),U,12)]"" Q "0^1^Note already signed, no E Sig necessary." ;
 I $$PPINT^AMHUTIL(R)="" Q "0^0^No primary provider to check.  No PCC link."
 I $D(^AMHSITE(DUZ(2),19,"B",$$PPINT^AMHUTIL(R))) Q "0^1^Provider opted out of E Sig, no E Sig required."
 I DUZ'=$$PPINT^AMHUTIL(R) Q "0^0^Only the Primary provider is permitted to sign a note."
 I '$O(^AMHREC(R,31,0)) Q "0^0^A note must be entered before an E Sig can be applied-Visit will not pass to PCC^1"
 I '$G(G),$P(^AMHREC(R,0),U,34) Q "0^0^This is a group encounter.  Must be signed under the Group Options."
 Q "1^1"
 ;
ESIGGFI(AMHR) ;EP
 W !!,"SOAP/Progress Note Electronic Signature"
 D SIG^XUSESIG
 I X1="" Q
 S DIE="^AMHREC(",DA=AMHR,DR="1112///NOW;1113///"_$P($G(^VA(200,DUZ,20)),U,2)_";1116///"_$P(^VA(200,DUZ,20),U,3) D ^DIE K DA,DIE,DR
 I $D(Y) W !!,"Error updating electronic signature...see your supervisor for programmer help."
 K X1
 Q
ESIGREQ(R,D) ;EP - is esig required on this visit?
 NEW SD,G
 S R=$G(R)
 S D=$G(D)
 S SD=$$DATE()
 I SD="" Q 0  ;no start date
 ;
 S G=0
 I D]"" D  Q G
 .I D<SD S G=0 Q
 .S G=1
 I R,$D(^AMHREC(R,0)) S D=$P($P(^AMHREC(R,0),U),".")
 I D,D<SD Q 0
 I $P($G(^AMHREC(R,11)),U,10) Q 0
 Q 1
 ; 
DATE() ;EP - Determine DATE patch 10 was installed
 ;
 NEW P,M,A,D
 S D=""
 S P=$O(^DIC(9.4,"C","AMH",0))
 I P="" Q ""
 S M=$O(^DIC(9.4,P,22,"B","4.0",0))
 I M="" Q ""
 S D=$P($G(^DIC(9.4,P,22,M,0)),U,3)
 Q D
 ;
HELPESIG ;EP - called from help prompt
 W !!,"Enter a date to start prompting for the electronic signature.  "
 W !,"Any visit with a visit date on or after this date will require an electronic"
 W !,"signature.  The date must be equal to greater than ",$$FMTE^XLFDT($$DATE)
 W !," which is the date patch 10 was installed.",!
 Q
ESIGINT(R,G) ;EP - called for esig
 NEW X1,DA,DR,DIE,D
 I '$D(^AMHRINTK(R,0)) Q "0^0^Invalid intake, no Esig required"
 ;I '$$ESIGREQ(R) Q "0^1^E Sig not required for this visit, visit is prior to Version 4.0 install date."  ;not required
 I $P($G(^AMHRINTK(R,0)),U,12)]"" Q "0^1^Note already signed, no E Sig necessary." ;
 I $$VALI^XBDIQ1(9002011.13,R,.04)="" Q "0^0^No provider to check."
 I $D(^AMHSITE(DUZ(2),19,"B",$$VALI^XBDIQ1(9002011.13,R,.04))) Q "0^1^Provider opted out of E Sig, no E Sig required."
 I DUZ'=$$VALI^XBDIQ1(9002011.13,R,.04) Q "0^0^Only the provider is permitted to sign an Intake."
 I '$O(^AMHRINTK(R,41,0)) Q "0^0^An Intake narrative must be entered before an E Sig can be applied^1"
 Q "1^1"
 ;
ESIGGFII(AMHI) ;EP
 W !!,"Intake Electronic Signature"
 D SIG^XUSESIG
 I X1="" Q
 S DIE="^AMHRINTK(",DA=AMHI,DR=".11///NOW;.12///"_$P($G(^VA(200,DUZ,20)),U,2) D ^DIE K DA,DIE,DR
 I $D(Y) W !!,"Error updating electronic signature...see your supervisor for programmer help."
 K X1
 Q
ESIGREQI(R,D) ;EP - is esig required on this visit?
 NEW SD,G
 S R=$G(R)
 S D=$G(D)
 S SD=$$DATE()
 I SD="" Q 0  ;no start date
 ;
 S G=0
 I D]"" D  Q G
 .I D<SD S G=0 Q
 .S G=1
 I R,$D(^AMHREC(R,0)) S D=$P($P(^AMHREC(R,0),U),".")
 I D,D<SD Q 0
 Q 1
