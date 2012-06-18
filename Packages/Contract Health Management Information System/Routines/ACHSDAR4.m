ACHSDAR4 ; IHS/ITSC/TPF/PMF - APPEAL TO ALTERNATE RESOURCE (2/3) ; 
 ;;3.1;CONTRACT HEALTH MGMT SYSTEM;;JUN 11, 2001
 ;
START ;EP
 U IO
 D BM^ACHS
 S ACHSBM=ACHSBM-4,ACHDONE=""
 F I=1:1:4 W "*** OFFICE COPY *** "
 W !!!
 S ACHSPG=1,DIWL=5,DIWR=$S($G(IOM):IOM,1:75),DIWF="W"
DOC ;
 D HEADER^ACHSDNL2
 ;
 ;get the patient name from one place if not registered,
 ;from another if they are registered.
 I $$DN^ACHS(0,6)'="Y" S ACHDPAT=$G(^ACHSDEN(DUZ(2),"D",ACHSA,10))
 E  S ACHDPAT=$P($G(^DPT($$DN^ACHS(0,7),0)),U)
 ;
 ;reverse the name so that first name is first
 S ACHDPAT=$P(ACHDPAT,",",2)_" "_$P(ACHDPAT,",",1)
 S ACHDALR=$G(^AUTNINS(ACHDALRS,0))
DOC1 ;
 W !!!,?DIWL-1,$$DATE^ACHSDARR($$DN^ACHS(0,2),"MM",1)," ",$$DATE^ACHSDARR($$DN^ACHS(0,2),"DD"),", ",$$DATE^ACHSDARR($$DN^ACHS(0,2),"YY")
 W !!!!,?DIWL-1,$P($G(^AUTNINS(ACHDALRS,4)),U)
 ;
 I $P(ACHDALR,U,2)']"" W !!! G DOC2
 W !?DIWL-1,$P(ACHDALR,U,2),!?DIWL-1,$P(ACHDALR,U,3)_", "_$P($G(^DIC(5,$P(ACHDALR,U,4),0)),U,2)_"  "_$P(ACHDALR,U,5),!
 ;
DOC2 ;
 S ACHDALR=$P(ACHDALR,U)
 W !!,?DIWL-1,"Re:              Patient: ",ACHDPAT,!,?DIWL+8,"Date of service: ",$$DATE^ACHSDARR($$DN^ACHS(0,4),"MM",1)," ",$$DATE^ACHSDARR($$DN^ACHS(0,4),"DD"),", ",$$DATE^ACHSDARR($$DN^ACHS(0,4),"YY")
 D PROV^ACHSDAR5
 ;
 ;
 W !!,?DIWL-1,"Dear ",$P(ACHDALR,U),",",!!
 S ACHDDAT=$P($G(^ACHSDEN(DUZ(2),"D",ACHSA,800,ACHDALRS,0)),U,5)
 S ACHDDAT=$$DATE^ACHSDARR(ACHDDAT,"MM",1)_" "_$$DATE^ACHSDARR(ACHDDAT,"DD")_", "_$$DATE^ACHSDARR(ACHDDAT,"YY")
 S X="The Indian Health Service (IHS), on behalf of |_|"_ACHDPAT_"|_|,"
 D ^DIWP,PG:$Y>ACHSBM Q:$G(ACHSQUIT)
 S X="hereby appeals the decision of |_|"_ACHDALR_"|_|,"
 D ^DIWP,PG:$Y>ACHSBM Q:$G(ACHSQUIT)
 S X="dated |_|"_ACHDDAT_"|_|.  The patient has authorized the IHS to act as the"
 D ^DIWP,PG:$Y>ACHSBM Q:$G(ACHSQUIT)
 S X="representative in this matter by signing the Authorization to Release and"
 D ^DIWP,PG:$Y>ACHSBM Q:$G(ACHSQUIT)
 S X="Appointment of Representative form, attached herein."
 D ^DIWP,PG:$Y>ACHSBM Q:$G(ACHSQUIT)  D ^DIWW
 S DIWF="I5C60W"
 W !!
 ; --- Alt Resource Appeal Option Text
 S ACHDOP=0
 F  S ACHDOP=$O(^ACHSDEN(DUZ(2),"D",ACHSA,800,ACHDALRS,4,ACHDOP)) Q:+ACHDOP=0  D  Q:$G(ACHSQUIT)
 .S ACHDX=0
 .F  S ACHDX=$O(^ACHSDENR(DUZ(2),13,ACHDOP,1,ACHDX)) Q:+ACHDX=0  D
 ..S X=$G(^ACHSDENR(DUZ(2),13,ACHDOP,1,ACHDX,0)) D ^DIWP,PG:$Y>ACHSBM Q:$G(ACHSQUIT)
 D ^DIWW
 S DIWL=5,DIWR=$S($G(IOM):IOM,1:75)
 K DIWF
 ;
BOTTXT ;
 W !!!?DIWL-1,"Please keep me informed on the status of this appeal."
 D PG:$Y>ACHSBM Q:$G(ACHSQUIT)
 ;
SUD ; --- SUD Signature Block
 D PG:$Y>(ACHSBM-15) Q:$G(ACHSQUIT)
 W !!?30,"Sincerely yours,",!!!!!!?30,$$SUD^ACHS(1)
 I $L($$SUD^ACHS(7)) W !?30,$$SUD^ACHS(7)
 W !?30,$$SUD^ACHS(2),!?30,$$SUD^ACHS(3),", ",$P($G(^DIC(5,$$SUD^ACHS(4),0)),U,2),"  ",$$SUD^ACHS(5),!?30,"Telephone: ",$$SUD^ACHS(6)
 ;
CMT ; --- Office Comments
 I '$D(ACHDONE) D END Q
 W !!!,"Denial Number: ",$$DN^ACHS(0,1)
 ;W !,"Chart Number: ",$S($$DN^ACHS(0,6)="Y":$P($G(^AUPNPAT($$DN^ACHS(0,7),41,DUZ(2),0)),U,2),$L($$DN^ACHS(10,6)):$$DN^ACHS(10,6),1:"No Chart Number Available")
 ;IS THE 'PATIENT REGISTERED?'
 I $$DN^ACHS(0,6)="Y" D
 .;IF REGISTERED IS THERE A 'REGISTERED PATIENT' PTR?
 .W:'$$DN^ACHS(0,7) !!,"CANNOT FIND A PATIENT POINTER FOR A APPARENTLY REGISTERED PATIENT WITHIN THE 'CHS DENIAL DATA' FILE!!",!,"REPORT THIS TO YOUR SITE MANAGER IMMEDIATELY!",!,"DOCUMENT IEN: ",ACHSA
 .Q:'$$DN^ACHS(0,6)
 .W $P($G(^AUPNPAT($$DN^ACHS(0,7),41,DUZ(2),0)),U,2)
 W $S($L($$DN^ACHS(10,6)):$$DN^ACHS(10,6),1:"No Chart Number Available")
 ;
 I $$DN^ACHS(850,1)'="Y" W !,"No Receipt Information Available",! G CMT1
 W !,"Method of receipt: ",$$DN^ACHS(850,2)
 W !,"Date of receipt: ",$$FMTE^XLFDT($$DN^ACHS(850,3))
 W !,"Received by: ",$$DN^ACHS(850,4)
 ;
 ;
CMT1 ; --- Alternate Resources Appeal Comments
 I '$D(^ACHSDEN(DUZ(2),"D",ACHSA,800,ACHDALRS,5,0)) D END Q
 W !,"Alternate Resources Appeal Comments: ",!
 S ACHD=0
 F  S ACHD=$O(^ACHSDEN(DUZ(2),"D",ACHSA,800,ACHDALRS,5,ACHD)) Q:'ACHD  D  Q:$G(ACHSQUIT)
 .S X=$G(^ACHSDEN(DUZ(2),"D",ACHSA,800,ACHDALRS,5,ACHD,0)) D ^DIWP,PG:$Y>ACHSBM Q:$G(ACHSQUIT)
 D ^DIWW
 D END
 Q
 ;
END ;EP
 W !!!
 I $D(ACHDONE) D  G DOC
 . F I=1:1:4 W "*** OFFICE COPY *** "
 . K ACHDONE
 . W @IOF
 . S ACHSPG=1,DIWL=5,DIWR=$S($G(IOM):IOM,1:75),DIWF="W"
 ;
 I '$D(ACHDLKER) D ^ACHSDARR   ;PATIENT RELEASE OF INFORMATION FORM
 I IO=IO(0) D RTRN^ACHS
 W @IOF
 K ACHSA,ACHDALRS,ACHDLKER,DIR,ACHDOCT,ACHD,ACHDX,ACHDDAT,ACHDPAT,ACHDALR,ACHDOP,ACHDPROV
 D ^%ZISC
 Q
 ;
PG ;
 D RTRN^ACHS
 Q:$G(ACHSQUIT)
 S ACHSPG=ACHSPG+1
 W @IOF,!!!?DIWL-1,ACHDPAT,?($S($G(IOM):IOM,1:75)-$L(ACHDALR)),ACHDALR,!?($S($G(IOM):IOM,1:75)-$L("Page "_ACHSPG)),"Page ",ACHSPG,!!
 Q
 ;
