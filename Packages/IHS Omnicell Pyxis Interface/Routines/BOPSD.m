BOPSD ;ILC/IHS/ALG/CIA/PLS - ILC Starter Dose Query ;19-Sep-2006 22:08;SM;
 ;;1.0;AUTOMATED DISPENSING INTERFACE;**1**;Jul 26, 2005
 ;
 Q:'PSGP  Q:'PSGORD
 N BOPJ,BOPDFN,BOPWHO,BOPI,BOPMID,BOPORDN,BOPDD0,BOPMED,BOPK,BOPN
 N DA,DR,DIE,STA
 S BOPDFN=PSGP,BOPORDN=+PSGORD
 S BOPWHO=$$INTFACE^BOPTU(1) S BOPWHO=$S(BOPWHO="O":"Omnicell",1:"Pyxis")
 F BOPI=0:0 S BOPI=$O(^PS(55,BOPDFN,5,BOPORDN,1,BOPI)) Q:'BOPI  D
 .S BOPDD0=$G(^PS(55,BOPDFN,5,BOPORDN,1,BOPI,0)) Q:'BOPDD0
 .Q:$P(BOPDD0,U,3)  ; Check for inactive date
 .S STA=$P(^PS(55,BOPDFN,5,BOPORDN,0),U,9)
 .Q:STA'="A"&(STA'="R")&(STA'="RE")
 .S BOPMID=+$P(BOPDD0,U) Q:'$D(^PSDRUG(BOPMID,0))
 .Q:'$D(^BOP(90355.2,"AT",BOPDFN,BOPMID))  ;No entries for medication or already linked
ASK .S BOPK=0
 .W !!,"The following items were removed from a "_$G(BOPWHO)_" Medstation."
 .W !,?5,"BOPED DRUG",?46,"QUANTITY",?61,"DATE/TIME",!
 .K BOPMED
 .F BOPJ=0:0 S BOPJ=$O(^BOP(90355.2,"AT",BOPDFN,BOPMID,BOPJ)) Q:BOPJ<1  D
 ..Q:'$D(^BOP(90355.2,BOPJ,0))
 ..S BOPK=BOPK+1,BOPMED(BOPK)=BOPJ
 ..W !,BOPK,?5,$P(^PSDRUG(BOPMID,0),U)
 ..W ?50,$P(^BOP(90355.2,BOPJ,0),U,5)
 ..W ?56,$$FMTE^XLFDT($P($G(^BOP(90355.2,BOPJ,0)),U,3),"2Z"),!  ;S Y=$P(^BOP(90355.2,BOPJ,0),U,3) X ^DD("DD") W ?56,Y,!
 .Q:'BOPK  ; No entries to link
 .S DIR("A")="If any of the above is a pre-exchange dose for this order, select its number."
 .S DIR(0)="N" D ^DIR K DIR Q:$D(DIRUT)
 .S BOPN=+Y I '$D(BOPMED(BOPN)) W $C(7) G ASK
 .D UPXTRA(BOPDFN,BOPORDN,BOPI,BOPMED(BOPN))
 .S DA=BOPMED(BOPN)
 .S DIE="^BOP(90355.2,",DR=".04///"_BOPORDN_";.07///@"_";.08///R"
 .D ^DIE
 Q
 ;
 ; Update Extra Units field
UPXTRA(DFN,UORDN,MSEQN,RECDRGI) ;
 N DA,DIE,DR
 S DA=MSEQN,DA(1)=UORDN,DA(2)=DFN
 S DIE="^PS(55,"_DFN_",5,"_UORDN_",1,"
 S DR=".11///"_$P(^BOP(90355.2,RECDRGI,0),U,5)
 S:$P($G(^PS(55,DFN,5,UORDN,1,MSEQN,0)),"^",11) $P(^(0),"^",11)=""
 D ^DIE
 Q
 ; Return linked unit dose order number
 ; Input:
 ;         DFN - Patient
 ;         MEDIEN - Drug IEN
 ; Output: Order Number (e.g. 30-1478) or null ("")
GETLINK(DFN,MEDIEN) ; EP
 N RES,DA,NODE
 S RES=""
 S DA=0 F  S DA=$O(^BOP(90355.2,"C",DFN,DA)) Q:'DA  D  Q:RES
 .S NODE=^BOP(90355.2,DA,0)
 .Q:+NODE'=MEDIEN  ; compare medication
 .Q:'$P(NODE,U,4)  ; lacks an order number
 .Q:'$$ISACTIVE(DFN,+$P(NODE,U,4),MEDIEN)
 .S RES=$P(NODE,U,4)  ; return order number
 Q RES
 ; Return true if unit dose order med is active
 ; Input: DFN - Patient
 ;        ORDNUM - Unit Dose order number
 ;        MEDIEN - Drug IEN
 ; Output: Boolean
ISACTIVE(DFN,ORDNUM,MEDIEN) ; EP
 N LP,SEQN,NODE,STA
 S (SEQN,LP)=0 F  S LP=$O(^PS(55,DFN,5,ORDNUM,1,"B",MEDIEN,LP)) Q:'LP  D
 .S NODE=^PS(55,DFN,5,ORDNUM,1,LP,0)
 .Q:$P(NODE,U,3)   ; med is inactive
 .S STA=$P(^PS(55,DFN,5,ORDNUM,0),U,9)
 .I STA="A"!(STA="R")!(STA="RE") D  ;Active, Renewed and Reinstated
 ..S SEQN=LP
 Q ''SEQN
 ; Find entries matching patient and med and not matched to inpatient order
FINDITMS(DFN,MEDIEN,ARY) ;EP
 N LP,DA
 K ARY
 S DA=0 F  S DA=$O(^BOP(90355.2,"C",DFN,DA)) Q:'DA  D
 .S NODE=^BOP(90355.2,DA,0)
 .Q:+NODE'=MEDIEN  ; compare medication
 .Q:$P(NODE,U,4)   ; can't have order number
 .S ARY(DA)=NODE
 Q
 ; Combine similiar entries into first entry matching patient and med.
COMBINE(DA,ARY) ;EP
 Q:'DA
 N IEN,QTY
 S QTY=$P(^BOP(90355.2,DA,0),U,5)
 S IEN=DA F  S IEN=$O(ARY(IEN)) Q:'IEN  D
 .S QTY=QTY+$P(ARY(IEN),U,5)
 .D DELITM(IEN)
 D UPDITM(DA,QTY)
 Q
 ; Delete combined entry
DELITM(DA) ;EP
 N DIK
 S DIK="^BOP(90355.2,"
 D ^DIK
 Q
 ; Update Qty value of entry
UPDITM(DA,QTY) ;EP
 N ERR
 S FDA(90355.2,DA_",",.05)=QTY
 D FILE^DIE("K","FDA","ERR")
 Q
