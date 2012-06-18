ANSUWR ;IHS/OIRM/DSD/CSC - UNIT WORKLOAD REPORT; [ 02/25/98  10:32 AM ]
 ;;3.0;NURSING PATIENT ACUITY;;APR 01, 1996
 ;;UNIT WORKLOAD REPORT
EN D EN1
EXIT K ANSHIFT,ANSCAT1,ANSCAT2,ANSCAT3,ANSCAT4,ANSCAT5,ANSCAT6
 Q
EN1 ;
 D DATES^ANSDATE
 Q:$D(ANSQUIT)!$D(ANSOUT)!'$G(ANSBEGIN)
 S:'$G(ANSEND) ANSEND=DT
 D UNIT^ANSUD
 Q:'$G(ANSUN)
 D DATA Q
 D HEAD,SHEAD^ANSUWR1,PERCENT
 Q
DATA S ANSDATE=ANSBEGIN
 F  S ANSDATE=$O(^ANSR("AB",ANSDATE)) Q:'ANSDATE!(ANSDATE>ANSEND)  D
 .S ANSX=0
 .F  S ANSX=$O(^ANSR("AB",ANSDATE,ANSUN,ANSX)) Q:'ANSX  S ANSZ=^ANSR(ANSX,0) D
 ..W !,ANSZ
 ..S ANSZ=0
 ..F  S ANSZ=$O(^ANSR(ANSX,"L",ANSZ)) Q:'ANSZ  S ANS=$G(^ANSR(ANSX,"L",ANSZ,0)) D  ;;CSC 9-10-96
 ...S L=$P(ANS,U,2)
 ...I L>4,$P(^ANSD(59,+ANS,0),U,L) S L=$P(^(0),U,L)
 Q
HEAD ;HEADER
 W @IOF,?25,"UNIT WORKLOAD REPORT"
 W !!,"UNIT........:  ",ANSUNIT
 W !,"DATE........:  "
 S Y=ANSDATE
 X ^DD("DD")
 W Y
 W !,"DATE PRINTED:  "
 S Y=DT
 X ^DD("DD")
 W Y
 Q
PERCENT ;
 S ANSHIFT(1)=45
 W !!,"PERCENT OF STAFF IN 24 HOURS",!,"ASSIGNED TO ",ANSHIFT," SHIFT: ",$J(ANSHIFT(1),3)," %"
 W !!?10,"+--------------------------+"
 W !?10,"|                          |"
 W !?10,"| STAFF HOURS REQUIRED     |"
 W !?10,"|                          |"
 W !?10,"|--------------------------|"
 W !?10,"|        |        |        |"
 W !?10,"| HOURS  |        |        |"
 W !?10,"| FOR ALL| DISTRI-|        |"
 W !?10,"| PAT'S  | BUTION | RESULT |"
 W !?10,"|        |        |        |"
 W !?10,"|--------------------------|"
 W !?10,"|        |        |        |"
 F J=1:1:4 S Z=$S(J=1:"ANSRN",J=2:"ANSLPN",J=3:"ANSNA",J=4:"ANSALL") D P1 W !?10,"|",$J(X,6),"  |",$J(ANSHIFT(1),6),"  |",$J($FN(X*ANSHIFT(1)/100,"P"),8),"|"
 W !?10,"|        |        |        |"
 W !?10,"+--------------------------+"
 Q
P1 S X=0
 F I=1:1:6 S X=X+$P(@Z@(I),U,2)
 Q
