ABMERUT2 ; IHS/FCS/DRS - ABMERUTL cont.;    
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;
 ; New Routine - Split from ABMERUTL on 08/30/2001
 Q
 ; ABM*2.4*9 IHS/FCS/DRS 09/21/01 ; Part 15 - split POS out from large ABMERUTL and validate
 ; the POS code before sending to Envoy.  Necessitated by San Xavier's
 ; hardcopy 1500 override value "03" which is rejected by Envoy's
 ; edit checks.  If it turns out that this payer really absolutely
 ; has to have 03 even in the electronic form, then Envoy will have
 ; to do something  - either stuff in the 03 at Envoy, or have us do
 ; it and have Envoy disable their POS check for that one payer.
 ; Though it seems as if that one payer had an exception, that some
 ; other Envoy customer would have encountered the problem by now
 ; and Envoy already would have adjusted their checking accordingly.
 ; So either we're the first or the 03 really isn't needed.
 ;
POS(X) ;EP - Point of Service ; parameter X apparently unused - comment said
 ; it was Mode of Export
 S X=$G(^ABMNINS(DUZ(2),ABMP("INS"),2,"AOVR",3,37,3,ABMP("VTYP")))
 D POSOK
 I X="" S X=$G(^ABMNINS(DUZ(2),ABMP("INS"),2,"AOVR",3,37,3,0))
 D POSOK
 I X="" S X=$G(^ABMNINS(DUZ(2),ABMP("INS"),2,"AOVR",14,37,3,ABMP("VTYP")))
 D POSOK
 I X="" S X=$G(^ABMNINS(DUZ(2),ABMP("INS"),2,"AOVR",14,37,3,0))
 D POSOK
 I X'="" Q X
 S X=$P($G(^ABMDPARM(ABMP("LDFN"),1,3)),"^",6)
 S:X="" X=$P($G(^ABMDPARM(DUZ(2),1,3)),"^",6)
 S:X X=$P(^ABMDCODE(X,0),"^")
 I X="" S X=11
 Q X
 ;
 ; POSOK new in ABM*2.4*9
POSOK ; Valid Point of Service code in X; reset X="" if invalid
 Q:X=""  Q:'$$ENVOY^ABMEF19  ; only enforce for Envoy
 S:'$D(^ABMDCODE("AC","H",X)) X="" Q
