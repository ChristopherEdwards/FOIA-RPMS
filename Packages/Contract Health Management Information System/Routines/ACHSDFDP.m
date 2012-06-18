ACHSDFDP ; IHS/ITSC/PMF - DEFERRED SERVICES DISPLAY/EDIT ; [ 12/06/2002  10:36 AM ]
 ;;3.1;CONTRACT HEALTH MGMT SYSTEM;**18**;JUN 11, 2001
 ;IHS/SET/GTH ACHS*3.1*5 12/06/2002 - Remove direct ref to non-package global.
 ;ACHS*3.1*18 4/1/2010;IHS/OIT/ABK;Change every occurrance of Deferred to Unmet Need
 Q:'$D(ACHSA)
 Q:'$D(^ACHSDEF(DUZ(2),0))
 Q:'$D(^ACHSDEF(DUZ(2),"D",ACHSA,0))
 D VIDEO^ACHS
 S:'$D(IORVON) IORVON=""
 S:'$D(IORVOFF) IORVOFF=""
 ;
 N ACHDFDP
 F  D HDR,PG Q:$D(DUOUT)!$D(DTOUT)!$D(ACHDONE)
END ;
 Q
 ;
HDR ; --- Screen Header.
 W @IOF
 S ACHDPAT=$S($$DF^ACHS(0,5)="Y":$P($G(^DPT($$DF^ACHS(0,6),0)),U),1:$$DF^ACHS(0,7))
 W IORVON,!?79,!
 ;{ABK, 4/2/10}W "CHS DEFERRED SERVICE",?28,"PATIENT: ",$E(ACHDPAT,1,25)
 W "CHS UNMET NEED",?28,"PATIENT: ",$E(ACHDPAT,1,25)
 W ?62,"CHART# ",$S($$DF^ACHS(0,5)="Y":$P($G(^AUPNPAT($$DF^ACHS(0,6),41,DUZ(2),0)),U,2),$$DF^ACHS(0,5)="N":$$DF^ACHS(0,12),1:"NONE")
 W $J("",79-$X),!?79,IORVOFF,!,$$REPEAT^XLFSTR("=",79),!
 Q
 ;
PG ; --- Page Display
 S ACHDFDP=$G(^ACHSDEF(DUZ(2),"D",ACHSA,100))
 W "DATE ISSUED: ",$$FMTE^XLFDT($$DF^ACHS(0,2))
 ;W ?45,"ISSUED BY: ",$E($P($G(^VA(200,$$DF^ACHS(0,3),0)),U),1,25),!;IHS/SET/GTH ACHS*3.1*5 12/06/2002
 W ?45,"ISSUED BY: ",$E($$GET1^DIQ(200,$$DF^ACHS(0,3),.01),1,25),! ;IHS/SET/GTH ACHS*3.1*5 12/06/2002
 W !,"1. DATE OF REQUEST: ",IORVON,$$FMTE^XLFDT($$DF^ACHS(0,4)),IORVOFF
 W ?45,"2. TYPE: ",IORVON,$$EXTSET^XBFUNC(9002066.01,110,$P(ACHDFDP,U,2)),IORVOFF
 W !!,"3. CATEGORY: ",IORVON," ",$P($G(^ACHSDFC($P(ACHDFDP,U),0)),U)," ",IORVOFF
 W !!,"4. SUB-CATEGORY: ",IORVON,$P($G(^ACHSDFC($P(ACHDFDP,U),1,$P(ACHDFDP,U,4),0)),U)," ",IORVOFF
 W !!,"5. UNITS OF SERVICE: ",IORVON," ",$P(ACHDFDP,U,3)," ",IORVOFF
 W !!,"6.*DIAGNOSIS / PROCEDURE: ",IORVON,$S($O(^ACHSDEF(DUZ(2),"D",ACHSA,200,0)):" ICD9",1:""),$S($O(^ACHSDEF(DUZ(2),"D",ACHSA,300,0)):" CPT",1:""),IORVOFF
 ;{ABK, 4/2/10}W !!,"7.*DEFERRED SVC COMMENT: ",IORVON,$S($D(^ACHSDEF(DUZ(2),"D",ACHSA,400,0)):"YES",1:"NONE"),IORVOFF
 W !!,"7.*UNMET NEED COMMENT: ",IORVON,$S($D(^ACHSDEF(DUZ(2),"D",ACHSA,400,0)):"YES",1:"NONE"),IORVOFF
 W !!,IORVON," * ",IORVOFF," - CHOOSE THESE TO SEE FURTHER INFORMATION"
 S %=$$DIR^ACHS("LO^1:7","Enter Number Of Field To Edit or <RETURN> To Accept","","","",1)
 I %="" S ACHDONE=1 Q
 Q:$D(DUOUT)!$D(DTOUT)
 I Y]"" D @(+Y)
 Q
 ;
1 ; --- Request Date.
 D DIE(4)
 Q
 ;
2 ; --- Type of Service.
 D DIE(110)
 Q
 ;
3 ; --- Deferred Service Category.
 D DIE(100)
 Q
 ;
4 ; --- Deferred Service Sub Category.
 N DIC
 S DIC="^ACHSDFC("_$P(ACHDFDP,U)_",1,"
 S DIC(0)="A"
 S DIC("B")=$P(ACHDFDP,U,4)
 D ^DIC
 Q:Y<1
 S DIE="^ACHSDEF("_DUZ(2)_",""D"","
 S DA(1)=DUZ(2)
 S DA=ACHSA
 S DR="105////"_+Y
 D ^DIE
 K DA,DIC,DIE
 Q
 ;
5 ; --- Units of Service.
 D DIE(120)
 Q
 ;
6 ; --- Diagnosis / Procedure.
 D:$O(^ACHSDEF(DUZ(2),"D",ACHSA,200,0))!($P(ACHDFDP,U,2)="I") DIE(200)
 D:$O(^ACHSDEF(DUZ(2),"D",ACHSA,300,0))!($P(ACHDFDP,U,2)="O") DIE(300)
 Q
 ;
7 ; --- Deferred Service Comment.
 D DIE(400)
 Q
 ;
DIE(DR) ; --- Edit items in Deferred Service
 W !!
 S DIE="^ACHSDEF("_DUZ(2)_",""D"","
 S DA(1)=DUZ(2)
 S DA=ACHSA
 D ^DIE
 K DA,DIE
 Q
 ;
