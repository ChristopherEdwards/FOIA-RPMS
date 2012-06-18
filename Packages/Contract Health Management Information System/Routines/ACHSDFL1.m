ACHSDFL1 ; IHS/ITSC/PMF - DEFERRED SERVICES LETTER (2/2) ;   [ 10/31/2003  11:40 AM ]
 ;;3.1;CONTRACT HEALTH MGMT SYSTEM;**18**;JUNE 11,2001
 ;ACHS*3.1*18 5/20/2010;IHS/OIT/ABK;Change every occurrance of Deferred to Unmet Need
 ;
START ;EP
 U IO
 D BM^ACHS
 S ACHSBM=ACHSBM-4,ACHDONE=""
 I $D(ACHDONE) F I=1:1:4 W "*** OFFICE COPY *** "
 W !!
 ;IHS/SET/JVK ACHS*3.1*6 3/24/2003 SET DIWR=75
 ;S ACHSPG=1,DIWL=5,DIWR=$S($G(IOM):IOM,1:75),DIWF="W"
 S ACHSPG=1,DIWL=5,DIWR=75,DIWF="W"
DOC ;EP --- Document info
 I $$DF^ACHS(0,14)="Y" F I=1:1:4 W "DOCUMENT CANCELLED *"
 D HEADER^ACHSDNL2
 ;
 W !!!?DIWL-1,$$DATE^ACHSDARR($$DF^ACHS(0,2),"MM",1)," ",$$DATE^ACHSDARR($$DF^ACHS(0,2),"DD"),", ",$$DATE^ACHSDARR($$DF^ACHS(0,2),"YY"),!!
 ;
 I $$DF^ACHS(0,5)'="Y" S ACHDPAT=$$DF^ACHS(0,7)_U_$$DF^ACHS(0,8)_U_$$DF^ACHS(0,9)_U_$$DF^ACHS(0,10)_U_$$DF^ACHS(0,11) G DOC1
 ;
 S X=$G(^DPT($$DF^ACHS(0,6),.11)),ACHDPAT=U_$P(X,U)_" "_$P(X,U,2)_" "_$P(X,U,3)_U_$P(X,U,4)_U_$P(X,U,5)_U_$P(X,U,6)
 ;
 S ACHDPAT=$P($G(^DPT($$DF^ACHS(0,6),0)),U)_ACHDPAT
DOC1 ;
 S X=$P($P(ACHDPAT,U),",",2)
 I $E(X,1)=" " S X=$E(X,2,99)
 S Y=$P($P(ACHDPAT,U),",",1)
 ;
 W !?DIWL-1,X," ",Y,!?DIWL-1,$P(ACHDPAT,U,2),!?DIWL-1,$P(ACHDPAT,U,3),", ",$S($P(ACHDPAT,U,4):$P($G(^DIC(5,$P(ACHDPAT,U,4),0)),U,2),1:""),"  ",$P(ACHDPAT,U,5),!
 W !!?DIWL-1,"Re:               Patient: ",$P($P(ACHDPAT,U,1),",",2)," ",$P($P(ACHDPAT,U),",",1)
 ;{ABK,7/16/10}W !?DIWL+3,"Contract Health Services Deferred Medical/Dental request for: ",!
 W !?DIWL+3,"Contract Health Services Unmet Need Medical/Dental request for: ",!
 D TYPE^ACHSDFL
 W !?DIWL+3,"Date request received: ",$$DATE^ACHSDARR($$DF^ACHS(0,4),"MM",1)," ",$$DATE^ACHSDARR($$DF^ACHS(0,4),"DD"),", ",$$DATE^ACHSDARR($$DF^ACHS(0,4),"YY")
 I $$DF^ACHS(100,5) W !?DIWL+10,"Estimated Cost: $" W $$DF^ACHS(100,5)
 W !!!?DIWL-1,"Dear ",$P($P(ACHDPAT,U),",",2)," ",$P($P(ACHDPAT,U),",",1)," :",!!
 S ACHDX=0
 F  S ACHDX=$O(^ACHSDEF(DUZ(2),2,ACHDX)) Q:+ACHDX=0  D  Q:$G(ACHSQUIT)
 .S X=$G(^ACHSDEF(DUZ(2),2,ACHDX,0)) D ^DIWP,PG:$Y>ACHSBM Q:$G(ACHSQUIT)
 D ^DIWW
AD ;
 W !!?DIWL+10,$$AD^ACHS(1)
 I $L($$AD^ACHS(7)) W !?DIWL+10,$$AD^ACHS(7)
 W !?DIWL+10,"ATTN: CONTRACT HEALTH SERVICES"
 W !?DIWL+10,$$AD^ACHS(2),!?DIWL+10,$$AD^ACHS(3),", ",$P($G(^DIC(5,$$AD^ACHS(4),0)),U,2),"  ",$$AD^ACHS(5),!?DIWL+10,"Telephone: ",$$AD^ACHS(6)
 W !!
 S X="Any appeal of this decision must be made in writing by the patient or the patient's guardian/representative within thirty (30) days from the date of receipt of this letter."
 D ^DIWP,^DIWW,PG:$Y>ACHSBM Q:$G(ACHSQUIT)
BOTTXT ;
 W !
 ;{ABK, 5/20/10}S X="Any questions regarding deferred services should be directed to the Contract Health Service Office at "_$$SUD^ACHS(6)_"."
 S X="Any questions regarding unmet needs should be directed to the Contract Health Service Office at "_$$SUD^ACHS(6)_"."
 D ^DIWP,^DIWW,PG:$Y>ACHSBM Q:$G(ACHSQUIT)
SUD ; --- SUD Signature Block
 D PG:$Y>(ACHSBM-15) Q:$G(ACHSQUIT)
 W !!!?DIWL+30,"Sincerely yours,",!!!!?DIWL+30,$$SUD^ACHS(1)
 I $L($$SUD^ACHS(7)) W !?DIWL+30,$$SUD^ACHS(7)
 W !?DIWL+30,$$SUD^ACHS(2),!?DIWL+30,$$SUD^ACHS(3),", ",$P($G(^DIC(5,$$SUD^ACHS(4),0)),U,2),"  ",$$SUD^ACHS(5),!?DIWL+30,"Telephone: ",$$SUD^ACHS(6)
CMT ; --- Office Comments
 G:'$D(ACHDONE) END^ACHSDFL
 D PG:$Y>(ACHSBM-7) Q:$G(ACHSQUIT)
 ;{ABK, 5/20/10}W !!!,"Deferred Services Number: ",$$DF^ACHS(0,1)
 W !!!,"Unmet Needs Number: ",$$DF^ACHS(0,1)
 W !,"            Chart Number: ",$S($$DF^ACHS(0,5)="Y":$P($G(^AUPNPAT($$DF^ACHS(0,6),41,DUZ(2),0)),U,2),$L($$DF^ACHS(0,12)):$$DF^ACHS(0,12),1:"No Chart Number Available")
 I $$DF^ACHS(500,1)'="Y" W !,"No Receipt Information Available",! G CMT1
 W !,"       Method of receipt: ",$$DF^ACHS(500,2)
 W !,"         Date of receipt: ",$$FMTE^XLFDT($$DF^ACHS(500,3))
 W !,"             Received by: ",$$DF^ACHS(500,4)
CMT1 ;
 G:'$D(^ACHSDEF(DUZ(2),"D",ACHSA,400,0)) END^ACHSDFL
 ;{ABK, 5/20/10}W !,"Deferred Services Comment:"
 W !,"Unmet Needs Comment:"
 S ACHDX=0
 F  S ACHDX=$O(^ACHSDEF(DUZ(2),"D",ACHSA,400,ACHDX)) Q:+ACHDX=0  D
 .S X=$G(^ACHSDEF(DUZ(2),"D",ACHSA,400,ACHDX,0)) D ^DIWP,PG:$Y>ACHSBM Q:$G(ACHSQUIT)
 D ^DIWW
 D END^ACHSDFL
 Q
 ;
PG ; --- Paginate, write header
 D RTRN^ACHS
 S ACHSPG=ACHSPG+1
 W @IOF,!!!?DIWL-1,$P(ACHDPAT,U),?($S($G(IOM):IOM,1:75)-$L($$DF^ACHS(0,1))),$$DF^ACHS(0,1),!?($S($G(IOM):IOM,1:75)-$L("Page "_ACHSPG)),"Page ",ACHSPG,!!
 Q
 ;
