ASDAL ; IHS/ADC/PDW/ENM - IHS APPT LIST CALLS ;  [ 05/17/1999  1:51 PM ]
 ;;5.0;IHS SCHEDULING;**2**;MAR 25, 1999
 ; -- subrtns called by SDAL and SDAL0
 ;
ASK ;EP; called to ask IHS questions
 K ASDQ
 S DIR(0)="Y",DIR("B")="YES",DIR("A")="INCLUDE WALK-INS" ;IHS added
 S DIR("?")="If you answer YES both walk-ins and chart requests will print"
 D ^DIR K DIR I $D(DIRUT) S ASDQ="" Q
 S ASDWI='Y
 ;I $$NOAMB,'$D(^XUSEC("SDZSUP",DUZ)) S ASDAMB=0 Q ;IHS/DSD/ENM 05/17/99
 I $$NOAMB,'$D(^XUSEC("SDZSUP",DUZ)) S ASDAMB=0 G PHO ;IHS/DSD/ENM 05/17/99
 S DIR(0)="Y",DIR("B")="NO",DIR("A")="INCLUDE WHO MADE APPT"
 D ^DIR K DIR I $D(DIRUT) S ASDQ="" Q
 S ASDAMB=Y
PHO K ASDPH K DIR S DIR(0)="Y",DIR("B")="NO" ;IHS/DSD/ENM 05/17/99 PHO ADD
 S DIR("A")="INCLUDE PATIENT'S PHONE #" D ^DIR K DIR
 I $D(DIRUT) S ASDPH="" Q
 S ASDPH=Y
 Q
 ;
HED ;EP; called by SDAL0 for IHS version of heading
 NEW X
 I SD1!(IOST["C-") W @IOF
 W !?16,$$CONF^ASDUT
 S (SDB,SD1)=1
 I '$D(ASDT) S X=$$HTFM^XLFDT($H),ASDT=$$FMTE^XLFDT($E(X,1,12),"2P")
 W !,"APPOINTMENTS FOR  ",$P(^SC(SC,0),U,1)," CLINIC ON  ",SDPD
 W !?2,"TIME",?11,"PATIENT NAME",?33,"HRCN",?43,"DOB"
 W ?53," LAB@",?62,"X-RAY@",?74,"EKG@"
 W !?15,"OTHER INFORMATION",?55,"Printed: ",ASDT
 S SDXX="",$P(SDXX,"=",81)="" W !,SDXX
 Q
 ;
TYPE ;EP; prints type of appt
 NEW X
 I $X>15 W !!
 I $P(^DPT(DFN,"S",SDT,0),U,7)=4 W ?12,"Walk-in/Chart Request" Q
 S X=$G(^SC(SC,"S",SDT,1,K,"C")) Q:X=""
 D TM^SDROUT0 W ?12,"Checked in at ",X
 Q
 ;
AMB ;EP; prints appt made by if asked for
 NEW X,Y
 Q:'$G(ASDAMB)
 S X=$P($G(^SC(SC,"S",SDT,1,K,0)),U,6),Y=$P($G(^(0)),U,7) Q:X=""
 W !?15,"Made by ",$P($G(^VA(200,X,0)),U),"  on ",$$FMTE^XLFDT(Y,"2D")
 I $P($G(^VA(200,X,.13)),U,2)]"" W ?53,"Phone: ",$P(^(.13),U,2)
 Q
 ;
SHORT(SC,DATE) ;EP -- short list of appt times,lengths, & other info\
 NEW T,P,N,END,C,Y,X
 S Y=DATE D DD^%DT W !!?15,"OTHER APPTS ALREADY SCHEDULED FOR ",Y
 W !?15,$$REPEAT^XLFSTR("=",46),!
 S END=DATE+.2400,T=DATE-.0001,C=0
 F  S T=$O(^SC(SC,"S",T)) Q:'T!(T>END)  D
 . S P=0 F  S P=$O(^SC(SC,"S",T,1,P)) Q:'P  D
 .. S N=$G(^SC(SC,"S",T,1,P,0)) Q:N=""
 .. S Y=T D DD^%DT
 .. W !?2,$P(Y,"@",2),?10,$P(N,U,2)," MIN",?20,$E($P(N,U,4),1,59)
 .. S C=C+1 I C#10=0 K DIR S DIR(0)="E",DIR("A")="Return to continue" D ^DIR K DIR
 Q
 ;
DOB() ;EP; -- returns date of birth
 N Y S Y=$P($G(^DPT(+$G(DFN),0)),U,3) X ^DD("DD") Q Y
 ;
WI() ;EP; -- returns 1 if appt to be excluded from the list
 Q $S($G(ASDWI):$S($P(^DPT(DFN,"S",SDT,0),U,7)=4:1,1:0),1:0)
 ;
NOAMB() ; -- returns 1 if restrict viewing of who made appt turned on
 Q $$VALI^XBDIQ1(40.8,$$DIV^ASDUT,9999999.12)
 ;
PHONE() ;EP; -- returns patient's phone number
 I $G(ASDPH)'=1 Q ""
 Q $P($G(^DPT(DFN,.13)),U)_"  "
