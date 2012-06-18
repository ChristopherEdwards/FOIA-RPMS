ABMDTIN2 ; IHS/ASDST/DMJ - Maintenance of INSURER FILE part 3 ;   
 ;;2.6;IHS Third Party Billing;**6**;NOV 12, 2009
PROV2 ;
 W !!
 S ABMENTRY=0
 F  D  Q:+Y<0!(ABMENTRY=4)  ;ask for list of qualifiers
 .D ^XBFMK
 .S DA(1)=ABM("DFN")
 .S DIC="^ABMNINS("_DUZ(2)_","_DA(1)_",3.5,"
 .S DIC("P")=$P(^DD(9002274.09,3.5,0),U,2)
 .S DIC(0)="AEQLM"
 .S DIC("A")="Enter First 2310/2330/2440 Qualifier to use: "
 .I ABMENTRY'=0 S DIC("A")=$S(ABMENTRY=1:"Second",ABMENTRY=2:"Third",ABMENTRY=3:"Fourth",1:"")_" 2310/2330/2440 Qualifier to use: "
 .D ^DIC
 .Q:+Y<0
 .S ABMENTRY=+$G(ABMENTRY)+1
 .S ABMQ(ABMENTRY)=$P(Y,U,2)
 W !!,"Now set up your provider numbers for qualifiers..."
 D ^XBFMK
 F ABMX("I")=1:1:4 D
 .Q:$G(ABMQ(ABMX("I")))=""
 .W !!,"Providers for qualifier "_$G(ABMQ(ABMX("I")))
 .F  D  Q:+Y<0
 ..D ^XBFMK
 ..S DA(2)=ABM("DFN")
 ..S DA(1)=ABMX("I")
 ..S DIC="^ABMNINS("_DUZ(2)_","_DA(2)_",3.5,"_DA(1)_",1,"
 ..S DIC("P")=$P(^DD(9002274.0935,.02,0),U,2)
 ..S DIC(0)="AEQLM"
 ..S DIC("A")="Select Provider: "
 ..D ^DIC
 ..Q:+Y<0
 ..S:$G(ABMQ(ABMX("I")))="0B" ABMPRVN=$$SLN^ABMEEPRV($P(Y,U,2))
 ..S:$G(ABMQ(ABMX("I")))="1G" ABMPRVN=$$UPIN^ABMEEPRV($P(Y,U,2))
 ..S:$G(ABMQ(ABMX("I")))="G2" ABMPRVN=$$PI^ABMUTLF($P(Y,U,2))
 ..W !,"Number "_ABMPRVN_" will be used from the New Person file"
 D PAZ^ABMDRUTL
 Q
