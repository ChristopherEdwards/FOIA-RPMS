ABMDEMRG ; IHS/ASDST/DMJ - MERGE CLAIMS ; 
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;
 ;IHS/DSD/DMJ - 9/14/1999 - NOIS NDA-1198-180003 Patch 3 #14
 ;       By-passed $$NXNM and allowed duplicate claim numbers
 ;
 ; IHS/SD/SDR v2.5 p10 - IM20059
 ;   Data was getting overwritten when merging; changed so
 ;   minimal data will be lost
 ; IHS/SD/SDR - v2.5 p12 - UFMS
 ;   If user isn't logged into cashiering session they can't do
 ;   this option; also added so if claims are deleted they will
 ;   be added to cashiering session
 ; IHS/SD/SDR - v2.5 p13 - IM26006
 ;   Fix for UNDEF error on page 9D of CE
 ; IHS/SD/SDR - v2.5 p13 - IM26259
 ;   Fix <UNDEF>DEL+16^ABMDEMRG when capturing deleted claims
 ;   in cashiering session (variable was being overwritten)
 ;
START ;START HERE
 I $P($G(^ABMDPARM(DUZ(2),1,4)),U,15)=1 D  Q:+$G(ABMUOPNS)=0
 .S ABMUOPNS=$$FINDOPEN^ABMUCUTL(DUZ)
 .I +$G(ABMUOPNS)=0 D  Q
 ..W !!,"* * YOU MUST SIGN IN TO BE ABLE TO PERFORM BILLING FUNCTIONS! * *",!
 ..S DIR(0)="E",DIR("A")="Enter RETURN to Continue" D ^DIR K DIR
 S DIC="^ABMDCLM(DUZ(2),"
 S DIC(0)="AEMQ"
 F ABMI=1:1 D  Q:$G(ABM("F1"))
 .S DIC("A")="Enter "_ABMI_$S(ABMI=1:"st",ABMI=2:"nd",ABMI=3:"rd",1:"th")_" claim: "
 .W !
 .D ^DIC
 .I +Y<0 S ABM("F1")=1 Q
 .I ABMI=1 S ABM("PDFN")=$P(^ABMDCLM(DUZ(2),+Y,0),U),ABM("VTYP")=$P(^(0),"^",7)
 .I ABMI=1 S DIC("S")="I $P(^(0),""^"",1)=ABM(""PDFN"")"
 .Q:$D(ABM("CLM1",+Y))
 .S ABM("CLM1",+Y)=""
 .S ABMDL("CLM",ABMI)=+Y
 I '$D(ABMDL("CLM")) K ABM Q
 K DIC,ABMI
 W !,"PATIENT: ",$P($G(^DPT(ABM("PDFN"),0)),U)
 W !?3,"CLAIM #s: "
 S I=0,ABM("TOT")=0
 F  S I=$O(ABMDL("CLM",I)) Q:'I  D
 .W ABMDL("CLM",I),"  "
 .S ABM("TOT")=ABM("TOT")+1
 W !,+$G(ABM("TOT"))," claims selected."
 I +$G(ABM("TOT"))<2 K ABM Q
 S DIR("A")="Proceed with merge"
 S DIR(0)="Y"
 D ^DIR
 K DIR
 I Y'=1 K ABM Q
 K DD,DO
 S DIC="^ABMDCLM(DUZ(2),"
 S DIC(0)="L"
 S X=ABM("PDFN")
 S DINUM=$$NXNM^ABMDUTL
 D FILE^DICN
 I +Y<0 W !,"Claim not created.",! K ABM Q
 S ABMP("CDFN")=+Y
 W !,"Claim # ",ABMP("CDFN")," created.",!
 W !,"Merging selected claims to claim ",ABMP("CDFN")
 S I=0
 F  S I=$O(ABMDL("CLM",I)) Q:'I  D
 .I $P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),0)),U,4)="U" W !,"Claim # ",ABMDL("CLM",I)," NOT merged-unbillable status." ;don't merge unbillable claims
 .;non-multiple nodes
 .M ^ABMDCLM(DUZ(2),ABMP("CDFN"),0)=^ABMDCLM(DUZ(2),ABMDL("CLM",I),0)
 .M ^ABMDCLM(DUZ(2),ABMP("CDFN"),4)=^ABMDCLM(DUZ(2),ABMDL("CLM",I),4)
 .M ^ABMDCLM(DUZ(2),ABMP("CDFN"),5)=^ABMDCLM(DUZ(2),ABMDL("CLM",I),5)
 .M ^ABMDCLM(DUZ(2),ABMP("CDFN"),6)=^ABMDCLM(DUZ(2),ABMDL("CLM",I),6)
 .M ^ABMDCLM(DUZ(2),ABMP("CDFN"),7)=^ABMDCLM(DUZ(2),ABMDL("CLM",I),7)
 .M ^ABMDCLM(DUZ(2),ABMP("CDFN"),8)=^ABMDCLM(DUZ(2),ABMDL("CLM",I),8)
 .M ^ABMDCLM(DUZ(2),ABMP("CDFN"),9)=^ABMDCLM(DUZ(2),ABMDL("CLM",I),9)
 .M ^ABMDCLM(DUZ(2),ABMP("CDFN"),10)=^ABMDCLM(DUZ(2),ABMDL("CLM",I),10)
 .M ^ABMDCLM(DUZ(2),ABMP("CDFN"),12)=^ABMDCLM(DUZ(2),ABMDL("CLM",I),12)
 .M ^ABMDCLM(DUZ(2),ABMP("CDFN"),70)=^ABMDCLM(DUZ(2),ABMDL("CLM",I),70)
 .;DINUMed multiples
 .M ^ABMDCLM(DUZ(2),ABMP("CDFN"),11)=^ABMDCLM(DUZ(2),ABMDL("CLM",I),11)  ;PCC visits
 .M ^ABMDCLM(DUZ(2),ABMP("CDFN"),13)=^ABMDCLM(DUZ(2),ABMDL("CLM",I),13)  ;Insurers
 .M ^ABMDCLM(DUZ(2),ABMP("CDFN"),15)=^ABMDCLM(DUZ(2),ABMDL("CLM",I),15)  ;APC visits
 .I $D(ABMDXTST) D  ;flag that coor. dxs need to be removed
 ..S ABMI=0
 ..F  S ABMI=$O(^ABMDCLM(DUZ(2),ABMDL("CLM",I),17,ABMI)) Q:+ABMI=0  D  Q:$G(ABMDXFLG)=1
 ...I $G(ABMDXTST(ABMI))="" S ABMDXFLG=1
 .I $G(ABMDXFLG)'=1 M ABMDXTST=^ABMDCLM(DUZ(2),ABMDL("CLM",I),17)
 .M ^ABMDCLM(DUZ(2),ABMP("CDFN"),17)=^ABMDCLM(DUZ(2),ABMDL("CLM",I),17)  ;DXs
 .M ^ABMDCLM(DUZ(2),ABMP("CDFN"),19)=^ABMDCLM(DUZ(2),ABMDL("CLM",I),19)  ;PXs-DINUMed in routine ABMDE5D
 .M ^ABMDCLM(DUZ(2),ABMP("CDFN"),51)=^ABMDCLM(DUZ(2),ABMDL("CLM",I),51)  ;Occurrence Codes
 .M ^ABMDCLM(DUZ(2),ABMP("CDFN"),53)=^ABMDCLM(DUZ(2),ABMDL("CLM",I),53)  ;Condition Codes
 .M ^ABMDCLM(DUZ(2),ABMP("CDFN"),59)=^ABMDCLM(DUZ(2),ABMDL("CLM",I),59)  ;Special Program codes
 .;not DINUMED multiples
 .F ABMMULT=14,21,23,25,27,33,35,37,39,41,43,45,47,57,61 D MULT  ;merge multiples into array
 .;weird DINUMed multiples
 .S ABMI=0
 .M ABMDCLM(55,0)=^ABMDCLM(DUZ(2),ABMDL("CLM",I),55,0)
 .F  S ABMI=$O(^ABMDCLM(DUZ(2),ABMDL("CLM",I),55,ABMI)) Q:+ABMI=0  D
 ..I $G(ABMDCLM(55,ABMI,0))'="",($P($G(^ABMDCODE($P($G(^ABMDCLM(DUZ(2),ABMDL("CLM",I),55,ABMI,0)),U),0)),U,2)="V") S $P(ABMDCLM(55,ABMI,0),U,2)=$P(ABMDCLM(55,ABMI,0),U,2)+$P($G(^ABMDCLM(DUZ(2),ABMDL("CLM",I),55,ABMI,0)),U,2)
 ..E  S ABMDCLM(55,ABMI,0)=$G(^ABMDCLM(DUZ(2),ABMDL("CLM",I),55,ABMI,0))
 .S ABM("SDF")=$P(^ABMDCLM(DUZ(2),ABMDL("CLM",I),7),U)
 .S ABM("SDT")=$P(^ABMDCLM(DUZ(2),ABMDL("CLM",I),7),U,2)
 .D
 ..I I=1 D  Q
 ...S ABM("OSDF")=ABM("SDF")
 ...S ABM("OSDT")=ABM("SDT")
 ...Q
 ..I ABM("SDF")<ABM("OSDF"),ABM("SDF")'="" S ABM("OSDF")=ABM("SDF")
 ..I ABM("SDT")>ABM("OSDT") S ABM("OSDT")=ABM("SDT")
 .W !,"Claim # ",ABMDL("CLM",I)," merged."
 ;
 I ABM("OSDF")<$P(^ABMDCLM(DUZ(2),ABMP("CDFN"),7),U) D
 .S DIE="^ABMDCLM(DUZ(2),"
 .S DA=ABMP("CDFN")
 .S DR=".71///"_ABM("OSDF")
 .D ^DIE
 .Q
 I ABM("OSDT")>$P(^ABMDCLM(DUZ(2),ABMP("CDFN"),7),"^",2) D
 .S DIE="^ABMDCLM(DUZ(2),"
 .S DA=ABMP("CDFN")
 .S DR=".72///"_ABM("OSDT")
 .D ^DIE
 .Q
 ;
 ;each med necess. indicator only once on claim
 I $D(ABMDCLM(14)) D
 .S ABMIEN=0
 .F  S ABMIEN=$O(ABMDCLM(14,ABMIEN)) Q:+ABMIEN=0  D
 ..I $G(ABMMED($G(ABMDCLM(14,ABMIEN,0))))'="" K ABMDCLM(14,ABMIEN,0)
 ..E  S ABMMED($G(ABMDCLM(14,ABMIEN,0)))=1
 ;make sure only one attending provider
 I $D(ABMDCLM(41)) D
 .S ABMIEN=999  ;start at last entry and go up; want attending from last claim selected
 .F  S ABMIEN=$O(ABMDCLM(41,ABMIEN),-1) Q:+ABMIEN=0  D
 ..I $P($G(ABMDCLM(41,ABMIEN,0)),U,2)="A",($G(ABMPRV("A"))'="") S $P(ABMDCLM(41,ABMIEN,0),U,2)="T"
 ..I $G(ABMPRV("A"))=""  S ABMPRV("A")=ABMIEN
 ;
 ;merge line items into new claim
 S ABMMULT=""
 F  S ABMMULT=$O(ABMDCLM(ABMMULT)) Q:$G(ABMMULT)=""  D
 .S ABMIEN=0
 .M ^ABMDCLM(DUZ(2),ABMP("CDFN"),ABMMULT,0)=ABMDCLM(ABMMULT,0)
 .F  S ABMIEN=$O(ABMDCLM(ABMMULT,ABMIEN)) Q:+ABMIEN=0  D
 ..M ^ABMDCLM(DUZ(2),ABMP("CDFN"),ABMMULT,ABMIEN)=ABMDCLM(ABMMULT,ABMIEN)
 ;
 ;check/remove coordinating Dxs because they will no longer be accurate
 I $G(ABMDXFLG)=1 D
 .W !!,"More than 1 DX exists on merging claims.  All Current Coordinating"
 .W !,"DX pointers being removed"
 .F ABMI=21,23,27,33,35,37,39,43,45,47 D
 ..S ABMIEN=0
 ..F  S ABMIEN=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),ABMI,ABMIEN)) Q:+ABMIEN=0  D
 ...K DIC,DIE,DA,DR,X,Y
 ...S DA(1)=ABMP("CDFN")
 ...S DA=ABMIEN
 ...S DIE="^ABMDCLM(DUZ(2),"_DA(1)_","_ABMI_","
 ...I ABMI=21 S DR=".04////@"
 ...I ABMI=23 S DR=".13////@"
 ...I ABMI=27 S DR=".06////@"
 ...I ABMI=33 S DR=".04////@"
 ...I ABMI=35 S DR=".08////@"
 ...I ABMI=37 S DR=".09////@"
 ...I ABMI=39 S DR=".1////@"
 ...I ABMI=43 S DR=".06////@"
 ...I ABMI=45 S DR=".06////@"
 ...I ABMI=47 S DR=".06////@"
 ...D ^DIE
 ;
PRIO ;re-shuffle priority fields for new claim
 F I=13,17,19,21,41 D  ; Add node 41 to have Xref's killed/rebuilt
 .Q:'$D(^ABMDCLM(DUZ(2),ABMP("CDFN"),I))
 .S J=0,L=0
 .F  S J=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),I,"C",J)) Q:'J  D
 ..S K=0
 ..F  S K=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),I,"C",J,K)) Q:'K  D
 ...Q:$D(ABM("PRIO",K))
 ...S ABM("PRIO",K)=""
 ...S L=L+1
 ...S $P(^ABMDCLM(DUZ(2),ABMP("CDFN"),I,K,0),"^",2)=L
 ...I $P(^ABMDCLM(DUZ(2),ABMP("CDFN"),I,K,0),"^",3)="I" D
 ....Q:$P(^ABMDCLM(DUZ(2),ABMP("CDFN"),0),"^",8)=K
 ....S $P(^ABMDCLM(DUZ(2),ABMP("CDFN"),I,K,0),"^",3)="P"
 ....Q
 .K ^ABMDCLM(DUZ(2),ABMP("CDFN"),I,"B")
 .K ^ABMDCLM(DUZ(2),ABMP("CDFN"),I,"C")
 .S DA(1)=ABMP("CDFN")
 .S DIK="^ABMDCLM(DUZ(2),DA(1),I,"
 .D IXALL^DIK
 W !!,"Cross referencing new claim # ",ABMP("CDFN"),!
 S DIK="^ABMDCLM(DUZ(2),"
 S DA=ABMP("CDFN")
 D IX1^DIK
 I $D(ABMDCLM(21))=10 D
 .S ABMIEN=0
 .F  S ABMIEN=$O(ABMDCLM(21,ABMIEN)) Q:+ABMIEN=0  D
 ..Q:$P($G(ABMDCLM(21,ABMIEN,0)),U,3)=""
 ..K DIE,DA,DR,DIC,DIR,X,Y
 ..S DA(1)=ABMP("CDFN")
 ..S DA=ABMIEN
 ..S DIE="^ABMDCLM(DUZ(2),"_DA(1)_",21,"
 ..S DR=".03////"_$P(ABMDCLM(21,ABMIEN,0),U,3)
 ..D ^DIE
 I $D(ABMDCLM(23))=10 D
 .S ABMIEN=0
 .F  S ABMIEN=$O(ABMDCLM(23,ABMIEN)) Q:+ABMIEN=0  D
 ..Q:$P($G(ABMDCLM(23,ABMIEN,0)),U,2)=""
 ..K DIE,DA,DR,DIC,DIR,X,Y
 ..S DA(1)=ABMP("CDFN")
 ..S DA=ABMIEN
 ..S DIE="^ABMDCLM(DUZ(2),"_DA(1)_",23,"
 ..S DR=".02////"_$P(ABMDCLM(23,ABMIEN,0),U,2)
 ..D ^DIE
 I $D(ABMDCLM(27))=10 D
 .S ABMIEN=0
 .F  S ABMIEN=$O(ABMDCLM(27,ABMIEN)) Q:+ABMIEN=0  D
 ..Q:$P($G(ABMDCLM(27,ABMIEN,0)),U,2)=""
 ..K DIE,DA,DR,DIC,DIR,X,Y
 ..S DA(1)=ABMP("CDFN")
 ..S DA=ABMIEN
 ..S DIE="^ABMDCLM(DUZ(2),"_DA(1)_",27,"
 ..S DR=".02////"_$P(ABMDCLM(27,ABMIEN,0),U,2)
 ..D ^DIE
 I $D(ABMDCLM(33))=10 D
 .S ABMIEN=0
 .F  S ABMIEN=$O(ABMDCLM(33,ABMIEN)) Q:+ABMIEN=0  D
 ..Q:$P($G(ABMDCLM(33,ABMIEN,0)),U,2)=""
 ..K DIE,DA,DR,DIC,DIR,X,Y
 ..S DA(1)=ABMP("CDFN")
 ..S DA=ABMIEN
 ..S DIE="^ABMDCLM(DUZ(2),"_DA(1)_",33,"
 ..S DR=".02////"_$P(ABMDCLM(33,ABMIEN,0),U,2)
 ..D ^DIE
 I $D(ABMDCLM(35))=10 D
 .S ABMIEN=0
 .F  S ABMIEN=$O(ABMDCLM(35,ABMIEN)) Q:+ABMIEN=0  D
 ..Q:$P($G(ABMDCLM(35,ABMIEN,0)),U,2)=""
 ..K DIE,DA,DR,DIC,DIR,X,Y
 ..S DA(1)=ABMP("CDFN")
 ..S DA=ABMIEN
 ..S DIE="^ABMDCLM(DUZ(2),"_DA(1)_",35,"
 ..S DR=".02////"_$P(ABMDCLM(35,ABMIEN,0),U,2)
 ..D ^DIE
 I $D(ABMDCLM(37))=10 D
 .S ABMIEN=0
 .F  S ABMIEN=$O(ABMDCLM(37,ABMIEN)) Q:+ABMIEN=0  D
 ..Q:$P($G(ABMDCLM(37,ABMIEN,0)),U,2)=""
 ..K DIE,DA,DR,DIC,DIR,X,Y
 ..S DA(1)=ABMP("CDFN")
 ..S DA=ABMIEN
 ..S DIE="^ABMDCLM(DUZ(2),"_DA(1)_",37,"
 ..S DR=".02////"_$P(ABMDCLM(37,ABMIEN,0),U,2)
 ..D ^DIE
 I $D(ABMDCLM(39))=10 D
 .S ABMIEN=0
 .F  S ABMIEN=$O(ABMDCLM(39,ABMIEN)) Q:+ABMIEN=0  D
 ..I $P($G(ABMDCLM(39,ABMIEN,0)),U,3)'="" D
 ...K DIE,DA,DR,DIC,DIR,X,Y
 ...S DA(1)=ABMP("CDFN")
 ...S DA=ABMIEN
 ...S DIE="^ABMDCLM(DUZ(2),"_DA(1)_",39,"
 ...S DR=".03////"_$P(ABMDCLM(39,ABMIEN,0),U,3)
 ...D ^DIE
 ..I $P($G(ABMDCLM(39,ABMIEN,0)),U,2)'="" D
 ...K DIE,DA,DR,DIC,DIR,X,Y
 ...S DA(1)=ABMP("CDFN")
 ...S DA=ABMIEN
 ...S DIE="^ABMDCLM(DUZ(2),"_DA(1)_",39,"
 ...S DR=".02////"_$P(ABMDCLM(39,ABMIEN,0),U,2)
 ...D ^DIE
 I $D(ABMDCLM(43))=10 D
 .S ABMIEN=0
 .F  S ABMIEN=$O(ABMDCLM(43,ABMIEN)) Q:+ABMIEN=0  D
 ..Q:$P($G(ABMDCLM(43,ABMIEN,0)),U,2)=""
 ..K DIE,DA,DR,DIC,DIR,X,Y
 ..S DA(1)=ABMP("CDFN")
 ..S DA=ABMIEN
 ..S DIE="^ABMDCLM(DUZ(2),"_DA(1)_",43,"
 ..S DR=".02////"_$P(ABMDCLM(43,ABMIEN,0),U,2)
 ..D ^DIE
 I $D(ABMDCLM(47))=10 D
 .S ABMIEN=0
 .F  S ABMIEN=$O(ABMDCLM(47,ABMIEN)) Q:+ABMIEN=0  D
 ..Q:$P($G(ABMDCLM(47,ABMIEN,0)),U,2)=""
 ..K DIE,DA,DR,DIC,DIR,X,Y
 ..S DA(1)=ABMP("CDFN")
 ..S DA=ABMIEN
 ..S DIE="^ABMDCLM(DUZ(2),"_DA(1)_",47,"
 ..S DR=".02////"_$P(ABMDCLM(47,ABMIEN,0),U,2)
 ..D ^DIE
 K ABMDCLM,ABMPRV,ABMMED,ABMDXTST
 ;
CLM ;go to claim editor
 S DIR("A")="Proceed to Claim Editor"
 S DIR(0)="Y"
 S DIR("B")="N"
 D ^DIR
 K DIR
 I Y=1 S ABMPP("CLM")="" D EXT^ABMDE
 ;
DEL ;delete the claims merged from
 S DIR("A")="Delete claims merged from"
 S DIR(0)="Y"
 S DIR("B")="N"
 D ^DIR
 K DIR
 I Y=1 D
 .S DIK="^ABMDCLM(DUZ(2),"
 .S ABMCLMI=0
 .F  S ABMCLMI=$O(ABMDL("CLM",ABMCLMI)) Q:'ABMCLMI  D
 ..K DA,DIC,DIE,DR
 ..D ADDBENTR^ABMUCUTL("CCLM",ABMDL("CLM",ABMCLMI))  ;add claim to UFMS Cash. Session
 ..S DA=ABMDL("CLM",ABMCLMI)
 ..D ^DIK
 ..W !,"Claim # ",DA,$S($D(^ABMDCLM(DUZ(2),DA)):" NOT",1:"")," deleted."
 W !
 K ABM
 Q
MULT ;merge multiples into array by subfile to be stored on "master" claim when all are merged
 I $G(ABM(ABMMULT))="" S ABM(ABMMULT)=1
 S ABMIEN=0
 M ABMDCLM(ABMMULT,0)=^ABMDCLM(DUZ(2),ABMDL("CLM",I),ABMMULT,0)
 F  S ABMIEN=$O(^ABMDCLM(DUZ(2),ABMDL("CLM",I),ABMMULT,ABMIEN)) Q:+ABMIEN=0  D
 .M ABMDCLM(ABMMULT,ABM(ABMMULT))=^ABMDCLM(DUZ(2),ABMDL("CLM",I),ABMMULT,ABMIEN)
 .S ABM(ABMMULT)=$G(ABM(ABMMULT))+1
 Q
