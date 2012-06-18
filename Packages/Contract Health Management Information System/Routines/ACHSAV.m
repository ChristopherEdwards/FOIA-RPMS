ACHSAV ; IHS/ITSC/PMF - DOCUMENT DISPLAY ;  [ 03/29/2005  3:10 PM ]
 ;;3.1;CONTRACT HEALTH MGMT SYSTEM;**12**;JUN 11, 2001
 ;ITSC/SET/JVK ACHS*3.1*12 ADD DHHS # TO DISPLAY 12/22/2004
 ;
 ;
 ;ITSC/SET/JVK ACHS*3.1*12 ADD DHHS NUMBER
 I ACHSORDN'="" S ACHSDOFY=$P(^ACHSF(DUZ(2),"D",ACHSDIEN,0),U,27)
 I ACHSORDN="" S ACHSDOFY=ACHSACFY
 I ACHSORDN'="" S ACHSCTYP=$S($P($G(^ACHSF(DUZ(2),"D",ACHSDIEN,2)),U,9)'="":$P(^ACHSF(DUZ(2),"D",ACHSDIEN,2),U,9),1:"")
 I $D(ACHSCTYP),ACHSCTYP'="" S ACHSCTYP=$P(^ACHSCTYP(ACHSCTYP,0),U,2)
 I ACHSORDN="" S ACHSCTYP=""
 S ACHSDHHS="HHSI"_$P($G(^ACHSF(DUZ(2),0)),U,11)_ACHSDOFY_$E(ACHSORDN,3,5)_$E(ACHSORDN,7,11)_ACHSCTYP
 W @IOF,"Form # ",$S(ACHSTYP=1:"43",ACHSTYP=2:"57",ACHSTYP=3:"64",1:"") W:ACHSREFT]"" ?55,"REF TYPE" W:ACHSORDN]"" ?68,"Order No."
 S T=$S(ACHSTYP=1:"Hospital Service",ACHSTYP=2:"Dental Service",ACHSTYP=3:"Outpatient Service",1:"")
 ;ITSC/SET/JVK ACHS*3.1*12 COMMENT OUT BELOW AND ADD DHHS #
 ;W !,$$FMTE^XLFDT(ACHSODT),?80-$L(T)\2,T,?59,ACHSREFT,?79-$L(ACHSORDN),ACHSORDN,!,"-------------------------------------------------------------------------------"
 W !,$$FMTE^XLFDT(ACHSODT),?80-$L(T)\2,T,?59,ACHSREFT,?79-$L(ACHSORDN),ACHSORDN,!
 W ?44,"HHS Order No:",?79-$L(ACHSDHHS),ACHSDHHS,!,"-------------------------------------------------------------------------------"
 S T=$S($G(DFN):"Patient",1:"Description")
 W !?39-$L(T)/2,T,?40,"|",?46,"Ordering Facility & Provider"
 ;
 ;GET ARRAY VARS SET UP FOR 
 D ALL^ACHSUDF
 ;
 F I=1:1:4 D
 .W !,$E($G(A(I)),1,38)
 .W:I=4 ?23,$G(A(5))
 .W ?40,"|"
 .W ?42,$E($G(B(I)),1,37)
 W !,"-------------------------------------------------------------------------------"
 W !
 W $G(A(6))
 W ?40,"|"
 W ?42,$E($G(D(1)),1,37)
 W !
 W $G(A(7))
 W ?40,"|"
 W ?42,$E($G(D(2)),1,37)
 W !
 W $G(A(9))
 W ?40,"|"
 W ?42,$E($G(D(3)),1,37)
 W !
 W $G(A(10))
 W ?40,"|"
 W ?42,$E($G(D(4)),1,37)
 W ?56,$E($G(F(6)),1,20)
 ;
 ;INPATIENT OUTPATIENT
 W !?40,"|"
 W ?42,$E($G(D(13)),1,35)
 W !,"-------------------------------------------------------------------------------",!
 W $G(C(4))
 W ?42,$G(A(8))
 W ?41," SCC: ",$G(F(8))
 W:$D(C(4))!$D(A(8)) !
 ;
 W "DCR Acct. = ",$P($G(^ACHS(9,DUZ(2),"RN")),U,ACHSDCR)
 W ?42,"CAN/OBJ: ",$G(F(7))," / ",$G(F(9),"N/A"),"  ",$G(ACHSCOPT,"N/A")
 W !?1,"Estimated Charge: ",$G(E(9))
 ; 
 I ACHSTYP=1 W ?42,"Days: ",$G(ACHSESDA)
 I ACHSTYP=3 W ?42,"Hosp Order No: ",$G(E(10))
 K A,B,C,D,E,F
 Q
 ;
