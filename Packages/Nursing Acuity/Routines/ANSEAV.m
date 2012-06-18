ANSEAV ;IHS/OIRM/DSD/CSC - VIEW ACUITY DATA; [ 02/25/98  10:32 AM ]
 ;;3.0;NURSING PATIENT ACUITY;;APR 01, 1996
 ;;VIEW ACUITY DATA
EN N C,D,I,L,N,P,T,X,Y,Z
 F  D EN1 Q:$D(DTOUT)!$D(DUOUT)
EXIT K ANSDA,ANSDT,ANSP,ANSS,ANSSH,ANSSTR,ANSUN,ANT,ANSX,ANSADMX,ANSADMY,AST,AST1,DTOUT,DUOUT,ANSDFN
 Q
EN1 D HEAD,^ANSUD
 Q:'$D(ANSDT)!'$D(ANSSH)!'$D(ANSUN)
 F  D EN2 Q:$D(DTOUT)!$D(DUOUT)!'$D(ANSDFN)
 K DUOUT
 Q
EN2 K ANSDFN
 D ^ANSUPT
 Q:$D(DTOUT)!$D(DUOUT)!'$D(ANSDFN)
 S ANSADM=$O(^ANSR("PT",ANSDFN,0))
 I ANSADM="" W *7,!!,"  Not Currently An Inpatient." Q
 I ANSADM,ANSUN'=$P(^ANSR(ANSADM,0),U,3) D  Q
 .W *7,!!," NOT Admitted to this Unit During This Time.",!!
 S (ANSADMX,ANSADMY)=""
 S ANSADMX=$O(^ANSR(ANSADM,"AT",ANSDT))
 I ANSADMX="" D A111A ;Q
 I ANSADMX D
 .S ANSADMY=$O(^ANSR(ANSADM,"AT",ANSADMX,ANSADMY))
 .I ANSADMY=""!('$D(^ANSR(+ANSADMY,"L",1,0)))!($P(ANSADMX,".",2)'=ANSSH) D A111A
 D CUR
 I $D(^ANSR(ANSADM,"DX")) S ANSDX=^("DX")
 D ^ANSEAV1
 Q
A111A Q:$P(^ANSR(ANSADM,0),"^",5)'="O"
 W *7,!!!,?24,"****  WARNING  ****",!!,?5,"This patient's assessment is not up-to-date",!,?5,"for the current date and shift."
 W !,?5,"Complete the patient assessment.....(Option 'PA', MAIN MENU)",!,?5,"for current date and shift before proceeding",!,?5,"to ensure correct calculations and reports."
 D PAUSE^ANSDIC
 Q
CUR S (M,N)=0,X=DT_".9",AT=0
 F  S M=$O(^ANSR(ANSADM,"AT",M)) Q:M=""!(M>X)  D
 .S O=0,ANSMR=M
 .F  S O=$O(^ANSR(ANSADM,"AT",M,O)) Q:O=""  D
 ..I $D(^ANSR(O,0)),$P(^(0),U,5)="D" S A=0
 ..S N=O
 I N=0 D
 .W !!,"Initial assessment of this patient has not been completed",!!,"Strike any key to continue..........."
 .D PAUSE^ANSDIC
 S (ANSCL,ANSAF)=""
 I N,$D(^ANSR(N,0)) S ANSDT=$P(^(0),U),ANSSH=$P(^(0),U,2),ANSUN=$P(^(0),U,3)
 S M=0
 F I=1:1 S M=$O(^ANSR(N,"L",M)) Q:M<1  I $D(^ANSR(N,"L",M,0)) S $P(ANSCL,U,M)=$P(^(0),U,2)
 S M=0
 F I=1:1 S M=$O(^ANSR(N,"F",M)) Q:M=""  I $D(^ANSR(N,"F",M,0)) S ANSAF=$G(ANSAF)_M_U
 Q
HEAD ;EP;DISPLAY HEADINGS
 K ANSY
 D HEAD^ANSMENU ;CSC 10/96
 S ANSX="PATIENT ACUITY DATA"
 W !!,?80-$L(ANSX)/2,ANSX
 Q
SUBH S Y=ANSDT
 X ^DD("DD")
 W !!!,?6,Y
 S Y="",ANSS=$P(ANSPAR,U,5)
 I $D(ANSSH) S X=$T(@ANSS),Y=$P($P(X,";;",ANSSH+1),U,2) W ?30,Y," Shift"
 I ANSUN,$D(^ANSD(59.1,ANSUN,0)) S Z=$P(^(0),U) W ?56,"Unit ",Z
 Q
DISP D HEAD,SUBH
 W !
 Q
2 ;;1^DAY;;2^NIGHT
3 ;;1^DAY;;2^EVENING;;3^NIGHT
