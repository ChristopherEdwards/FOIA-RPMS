AMHLEP3 ; IHS/CMI/LAB - ADD NEW CHR ACTIVITY RECORDS ;
 ;;4.0;IHS BEHAVIORAL HEALTH;;MAY 14, 2010
 ;
SAN ;EP
 D SAN1
 Q
 ;
CASE(P,R,T) ;return 1 if case already opened
 S U="^"
 I '$G(P) Q ""
 I '$G(R) Q ""
 I $G(T)="" Q ""
 NEW X,H S (X,H)=0 F  S X=$O(^AMHPCASE("AA",P,9999999-$P($P(^AMHREC(R,0),U),"."),X)) Q:X'=+X   I $P(^AMHPCASE(X,0),U,2)=T,$P(^AMHPCASE(X,0),U,8)=$$PPINT^AMHUTIL(R) S H=1
 Q H
SAN1 ;
 W:$D(IOF) @IOF
 S AMHPAT=$P(^AMHREC(AMHR,0),U,8)
 S DA=AMHR,DDSFILE=9002011,DR="[AMHVT ADD RECORD]" D ^DDS ;record info
 I $D(DIMSG) W !!,"ERROR IN SCREENMAN FORM!!" S AMHQUIT=1 K DIMSG Q
 ;check here for required items
 S AMHERROR=0
 S AMHREC=^AMHREC(AMHR,0)
 I $P(AMHREC,U,4)="" W !,"Location of Encounter Missing!" S (AMHOKAY,AMHERROR)=1
 I $P(AMHREC,U,5)="" W !,"Community of Service Missing!" S (AMHOKAY,AMHERROR)=1
 I $P(AMHREC,U,6)="" W !,"Activity Type Missing!" S (AMHOKAY,AMHERROR)=1
 I $P(AMHREC,U,7)="" W !,"Type of Contact Missing!" S (AMHOKAY,AMHERROR)=1
 S (X,Y)=0 F  S X=$O(^AMHRPROV("AD",AMHR,X)) Q:X'=+X  I $P(^AMHRPROV(X,0),U,4)="P" S Y=Y+1
 I Y=0 W !,"No primary Provider!",$C(7),$C(7) S AMHERROR=1 H 2
 I Y>1 W !,"Multiple Primary Providers!",$C(7),$C(7) W:'$G(AMHERROR) " PLEASE EDIT THIS RECORD" H 2
 I AMHERROR=1 Q
I1 ;S DA=AMHR,DDSFILE=9002011,DR="[AMH INTAKE POVS]" D ^DDS ;pov and other info collection
 ;I $D(DIMSG) W !!,"ERROR IN SCREENMAN FORM!!" S AMHQUIT=1 K DIMSG Q
 I '$D(^AMHRPRO("AD",AMHR)) W !!,"At least one POV IS REQUIRED.  Please add one.",! H 2 G SAN1
 D EP1^AMHLESAN(AMHPAT,AMHR) ;INTAKE DATA COLLECTION
TP ;
 Q
