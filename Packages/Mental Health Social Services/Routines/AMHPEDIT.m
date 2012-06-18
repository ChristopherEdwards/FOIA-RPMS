AMHPEDIT ; IHS/CMI/LAB - INPUT TX ON PATIENT FIELD OF BH RECORD ;
 ;;4.0;IHS BEHAVIORAL HEALTH;;MAY 14, 2010
 ;
 ;
 Q:'$D(AMHDATE)
 I AUPNDOD,$P(AMHDATE,".")>AUPNDOD W !,"  <Patient died before the visit date: DOD is "_$$FMTE^XLFDT(AUPNDOD)_">" Q
 I $P(AMHDATE,".")<AUPNDOB W !,"  <Patient born after the record date>" K X Q
 Q
 ;
 ;
DODGP(P,D) ;EP - called from screenman
 ;
 Q
 I $G(P)="" Q
 NEW T
 K T
 I $$DOD^AUPNPAT(P),$P(D,".")>$$DOD^AUPNPAT(P) D
 .S T(1)="  <Patient died before the visit date: DOD is "_$$FMTE^XLFDT($$DOD^AUPNPAT(P))_">"
 .S T(2)="  If you do not want to create a visit for this patient, please remove"
 .S T(3)="  them from the list by using the '@' to delete them."
 .D HLP^DDSUTL(.T)
 Q
PTSECG ;EP - called from screenman
 I '$D(X) Q
 NEW AMHRESU,HLP,C,J
 S C=0
 D PTSEC^AMHUTIL2(.AMHRESU,X,1)
 I '$G(AMHRESU(1)) Q
 I $G(AMHRESU(1))=3!($G(AMHRESU(1))=4)!($G(AMHRESU(1))=5) D  Q
 .S J=1 F  S J=$O(AMHRESU(J)) Q:J'=+J  D EN^DDIOL($$CTR(AMHRESU(J)))
 .K X
 S J=1 F  S J=$O(AMHRESU(J)) Q:J'=+J  D EN^DDIOL($$CTR(AMHRESU(J)))
 D EN^DDIOL("If you don't want to access this patient, delete them from the group")
 D EN^DDIOL("using the @")
 Q
CTR(X,Y) ;EP - Center X in a field Y wide.
 Q $J("",$S($D(Y):Y,1:IOM)-$L(X)\2)_X
 ;----------
