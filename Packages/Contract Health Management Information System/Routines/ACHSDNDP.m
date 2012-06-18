ACHSDNDP ; IHS/ITSC/PMF - DENIAL DISPLAY/EDIT ;  [ 10/16/2001   8:16 AM ]
 ;;3.1;CONTRACT HEALTH MGMT SYSTEM;;JUN 11, 2001
 ;
TOF ;
 Q:'$D(ACHSA)
 Q:'$D(^ACHSDEN(DUZ(2),"D",ACHSA,0))
 W @IOF
DSP ; --- Display
 D VIDEO^ACHS
 S:'$D(IORVON) IORVON=""
 S:'$D(IORVOFF) IORVOFF=""
 D HDR,P1
 G:'$D(DUOUT) TOF
END ;
 Q
 ;
HDR ;
 S ACHDPAT=$S($$DN^ACHS(0,7):$P($G(^DPT($$DN^ACHS(0,7),0)),U),1:$$DN^ACHS(10,1))
 W IORVON,!?79,!,"CHS DENIAL DISPLAY",?25,"PATIENT: ",$E(ACHDPAT,1,25),?62,"CHART#: "
 I $$DN^ACHS(0,6)="Y",$$DN^ACHS(0,7),$G(^AUPNPAT($$DN^ACHS(0,7),41,DUZ(2),0)) W $P($G(^AUPNPAT($$DN^ACHS(0,7),41,DUZ(2),0)),U,2)
 E  W "NONE"
 W !?79,IORVOFF,!,$$REPEAT^XLFSTR("=",79),!
 Q
 ;
P1 ; --- Display Page 1
 W "DATE ISSUED: ",$$FMTE^XLFDT($$DN^ACHS(0,2))
 W ?45,"ISSUED BY: ",$E($P($G(^VA(200,$$DN^ACHS(0,3),0)),U),1,25)
 W !!,"1. DATE MED SVC: ",IORVON,$$FMTE^XLFDT($$DN^ACHS(0,4)),IORVOFF
 W ?43,"2. DATE OF REQUEST: ",IORVON,$$FMTE^XLFDT($$DN^ACHS(0,5)),IORVOFF
 W !!,"3. MEDICAL PRIORITY: ",IORVON,$P($G(^ACHSMPRI($$DN^ACHS(400,2),0)),U),IORVOFF
 S %=$$DN^ACHS(100,10)
 ;
 W ?43,"4. VISIT TYPE: ",IORVON,$S(%="O":"OUTPATIENT",%="I":"INPATIENT",%="A":"AMBULANCE",%="P":"PATIENT ESCORT",%="D":"DENTAL",1:"UNKNOWN"),IORVOFF
 ;
 W !!,"5.*PRIMARY PROVIDER: ",IORVON,$S($$DN^ACHS(100,1)="Y":$P($G(^AUTTVNDR($$DN^ACHS(100,2),0)),U),1:$$DN^ACHS(100,3)),IORVOFF
 ;
 W !!,"6.*DIAGNOSIS: ",IORVON,$S($D(^ACHSDEN(DUZ(2),"D",ACHSA,500,0)):"ICD 9",$D(^ACHSDEN(DUZ(2),"D",ACHSA,700,0)):"CPT",1:"NONE"),IORVOFF
 ;
 W !!,"7.*PRIMARY DENIAL REASON: " S %=$$DN^ACHS(250,1) I % W IORVON,$P($G(^ACHSDENS(%,0)),U),IORVOFF
 ;
 W !!,"8.*OTHER RESOURCES: ",IORVON,$S($P($G(^ACHSDEN(DUZ(2),"D",ACHSA,800,0)),U,4):"YES",1:"NONE"),IORVOFF
 ;
 W !!,"9. OTHER IHS RESOURCES: ",IORVON,$S($P($G(^ACHSDEN(DUZ(2),"D",ACHSA,825,0)),U,4):"YES",1:"NONE"),IORVOFF
 ;
 W !!!?15,IORVON,"*",IORVOFF," - CHOOSE THESE FIELDS TO SEE FURTHER INFORMATION",!!,IORVON
 ;
 S %=$$DIR^ACHS("LO^1:9","Enter Number Of Field To Edit or <RETURN> To Accept","","","","")
 ;
 W IORVOFF
 I %="" S DUOUT=""
 Q:$D(DUOUT)!$D(DTOUT)!'%
 D @(+%)
 Q
 ;
1 ; --- Date of Service
 I '$$DIE(4) S DUOUT=""
 Q
 ;
2 ;  --- Date of Request
 I '$$DIE(5) S DUOUT=""
 Q
 ;
3 ; --- Medical priority
 I '$$DIE(420) S DUOUT=""
 Q
 ;
4 ; --- Service Type
 I '$$DIE(110) S DUOUT=""
 Q
 ;
5 ; --- Primary Provider
 D ^ACHSDN3
 Q
 ;
6 ; --- Diagnosis
 S X=$S($D(^ACHSDEN(DUZ(2),"D",ACHSA,700,0)):700,1:500)
 I '$$DIE(X) S DUOUT=""
 Q
 ;
7 ; --- Denial Reasons
 W !!
 D ^ACHSDN4
 Q
 ;
8 ; --- Other Resources
 W !!
 I '$$DIE(800) S DUOUT=""
 Q
 ;
 ;'OTHER IHS RESOURCES'
9 ;
 W !!
 I '$$DIE(825) S DUOUT=""
 Q
 ;
DIE(DR) ; --- Edit appropriate fields in Denial
 W !!
 S DA=ACHSA
 S DA(1)=DUZ(2)
 S DIE="^ACHSDEN("_DUZ(2)_",""D"","
 I '$$LOCK^ACHS("^ACHSDEN(DUZ(2),""D"",ACHSA)","+") Q 0
 D ^DIE
 I '$$LOCK^ACHS("^ACHSDEN(DUZ(2),""D"",ACHSA)","-") Q 0
 Q 1
 ;
