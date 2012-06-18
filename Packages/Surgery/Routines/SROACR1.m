SROACR1 ;BIR/MAM - OPERATIVE DATA ; [ 09/19/00  9:39 AM ]
 ;;3.0; Surgery ;**38,71,93,95,99**;24 Jun 93
 S SRA(206)=$G(^SRF(SRTN,206))
 S SRA(207)=$G(^SRF(SRTN,207)) I $P(SRA(207),"^",27)="" K DA,DIE,DR S DA=SRTN,DIE=130,DR="469////NS" D ^DIE K DA,DIE,DR S SRA(207)=$G(^SRF(SRTN,207))
 S SRAO(1)=$P(SRA(207),"^")_"^365",SRAO(2)=$P(SRA(207),"^",2)_"^366",SRAO(3)=$P(SRA(207),"^",24)_"^464",SRAO(4)=$P(SRA(207),"^",25)_"^465",SRAO(5)=$P(SRA(207),"^",20)_"^416"
 S NYUK=$P(SRA(207),"^",3) D YN S SRAO(6)=SHEMP_"^367"
 S NYUK=$P(SRA(207),"^",4) D YN S SRAO(7)=SHEMP_"^368"
 S NYUK=$P(SRA(207),"^",5) D YN S SRAO(8)=SHEMP_"^369",NYUK=$P(SRA(207),"^",6) D YN S SRAO(9)=SHEMP_"^370",NYUK=$P(SRA(207),"^",7) D YN S SRAO(10)=SHEMP_"^371"
 S NYUK=$P(SRA(207),"^",8) D YN S SRAO(11)=SHEMP_"^372",NYUK=$P(SRA(207),"^",9) D YN S SRAO(14)=SHEMP_"^373"
 S NYUK=$P(SRA(207),"^",10) D YN S SRAO(15)=SHEMP_"^374"
 S NYUK=$P(SRA(207),"^",11) D YN S SRAO(16)=SHEMP_"^375"
 S NYUK=$P(SRA(207),"^",12) D YN S SRAO("16A")=SHEMP_"^376",NYUK=$P(SRA(207),"^",13) D YN S SRAO("16B")=SHEMP_"^380"
 S NYUK=$P(SRA(207),"^",14) D YN S SRAO("16C")=SHEMP_"^377",NYUK=$P(SRA(207),"^",15) D YN S SRAO("16D")=SHEMP_"^381",NYUK=$P(SRA(207),"^",16) D YN S SRAO("16E")=SHEMP_"^378"
 S NYUK=$P(SRA(207),"^",17) D YN S SRAO("16F")=SHEMP_"^382",NYUK=$P(SRA(207),"^",18) D YN S SRAO("16G")=SHEMP_"^379",NYUK=$P(SRA(207),"^",19) D YN S SRAO("16H")=SHEMP_"^383"
 S X=$P($G(^SRF(SRTN,207.1)),"^"),SRAO("16H1")=X_"^383.1"
 S SRAO(12)=$P(SRA(206),"^",36)_"^450",SRAO(13)=$P(SRA(206),"^",37)_"^451",NYUK=$P(SRA(207),"^",22) D YN S SRAO(17)=SHEMP_"^441",NYUK=$P(SRA(207),"^",23) D YN S SRAO(18)=SHEMP_"^439"
 S Y=$P(SRA(207),"^",26),C=$P(^DD(130,468,0),"^",2) D:Y'="" Y^DIQ S SRAO(19)=$E(Y,1,21)_"^468"
 S Y=$P(SRA(207),"^",27),C=$P(^DD(130,469,0),"^",2) D:Y'="" Y^DIQ S SRAO(20)=$E(Y,1,11)_"^469"
 S SRPAGE="PAGE: 1" D HDR^SROAUTL
 W "CABG Distal Anastomoses",?40,"14. Cardiac Transplant:",?74,$P(SRAO(14),"^")
 W !," 1. Number with Vein:",?35,$P(SRAO(1),"^"),?40,"15. Electrophysiologic Procedure:",?74,$P(SRAO(15),"^")
 W !," 2. Number with IMA:",?35,$P(SRAO(2),"^"),?40,"16. Misc. Cardiac Procedures:",?74,$P(SRAO(16),"^")
 W !," 3. Number with Radial Artery:",?35,$P(SRAO(3),"^"),?44,"A. ASD Repair:",?74,$P(SRAO("16A"),"^")
 W !," 4. Number with Other Artery:",?35,$P(SRAO(4),"^"),?44,"B. VSD Repair:",?74,$P(SRAO("16B"),"^")
 W !," 5. Number with Other Conduit:",?35,$P(SRAO(5),"^"),?44,"C. Myxoma Resection:",?74,$P(SRAO("16C"),"^")
 W !,?44,"D. Foreign Body Removal:",?74,$P(SRAO("16D"),"^")
 W !," 6. Aortic Valve Replacement:",?35,$P(SRAO(6),"^"),?44,"E. Myectomy for IHSS:",?74,$P(SRAO("16E"),"^")
 W !," 7. Mitral Valve Replacement:",?35,$P(SRAO(7),"^"),?44,"F. Pericardiectomy:",?74,$P(SRAO("16F"),"^")
 W !," 8. Tricuspid Valve Replacement:",?35,$P(SRAO(8),"^"),?44,"G. Other Tumor Resection:",?74,$P(SRAO("16G"),"^")
 W !," 9. Valve Repair:",?35,$P(SRAO(9),"^"),?44,"H. Other Procedure(s):",?74,$P(SRAO("16H"),"^") W:$P(SRAO("16H1"),"^")'=""!($P(SRAO("16H"),"^")["Y") " *"
 W !,"10. LV Aneurysmectomy:",?35,$P(SRAO(10),"^"),?40,"17. Minimally Invasive Procedure: ",?74,$P(SRAO(17),"^")
 W !,"11. Great Vessel Repair (Req CPB):",?35,$P(SRAO(11),"^"),?40,"18. Batista Procedure:",?74,$P(SRAO(18),"^")
 W !,"12. Total Ischemic Time:",?27,$P(SRAO(12),"^")_$S($P(SRAO(12),"^")'="":" minutes",1:""),?40,"19. Incision Type:",?59,$J($P(SRAO(19),"^"),21)
 W !,"13. Total CPB Time:",?27,$P(SRAO(13),"^")_$S($P(SRAO(13),"^")'="":" minutes",1:""),?40,"20. Convert Off Pump to CPB:",?69,$P(SRAO(20),"^"),!
 D CHCK
 I $P(SRAO("16H1"),"^")'=""!($P(SRAO("16H"),"^")["Y")  S SRQ=0 W IORVON_"* Other Procedures List: " S X=$P(SRAO("16H1"),"^") W:$L(X)<56 X,! I $L(X)>55 S Z=$L(X) D
 .I X'[" " W ?25,X Q
 .S I=0,LINE=1 F  S SRL=$S(LINE=1:55,1:80) D  Q:SRQ
 ..I $E(X,1,SRL)'[" " W X,! S SRQ=1 Q
 ..S J=SRL-I,Y=$E(X,J),I=I+1 I Y=" " W $E(X,1,J-1),! S X=$E(X,J+1,Z),Z=$L(X),I=0,LINE=LINE+1 I Z<SRL W X,! S SRQ=1 Q
 W IORVOFF
 F MOE=1:1:80 W "-"
 Q
CHCK ; compare ischemic time to CPB time
 I '$D(IORVON) S X="IORVON;IORVOFF" D ENDR^%ZISS
 N SRISCH,SRCPB S SRISCH=$P(SRAO(12),"^"),SRCPB=$P(SRAO(13),"^")
 I SRISCH,SRCPB,SRISCH>SRCPB W IORVON_"  ***  NOTE: Ischemic Time is greater than CPB Time!!  Please check.  ***"_IORVOFF,!
 Q
YN ; store answer
 S SHEMP=$S(NYUK="NS":"NS",NYUK="N":"NO",NYUK="Y":"YES",1:"")
 Q
MISC ; miscellaneous
 K DIR S X=$P(SRAO(14),"^") I X'="" S DIR("B")=X
 S DIR(0)="130,375",DIR("A")="Miscellaneous Cardiac Procedures" D ^DIR K DIR I $D(DUOUT) S SRSOUT=1 Q
 I X="@" D SURE Q:SRSOUT  G:'SRYN MISC S (SRAX,X)="",$P(^SRF(SRTN,207),"^",11)="" D NOMIS Q
 S:X="N" X="NO" S:X="Y" X="YES"
 S SRAX=$S(X="NS":"NS",1:$E(X)),$P(^SRF(SRTN,207),"^",11)=SRAX I X["N" D NOMIS Q
 I SRAX="Y" D MIS
 Q
NOMIS ; no miscellaneous
 F I=12:1:19 S $P(^SRF(SRTN,207),"^",I)=SRAX
 D NOTH
 Q
MIS ; enter miscellaneous
 K DR,DIE,DA S DIE=130,DA=SRTN,DR="[SRISK-MISC]" W ! D ^DIE K DR S SRACLR=0 D NOTH
 Q
NOTH I $P($G(^SRF(SRTN,207)),"^",19)'="Y" K ^SRF(SRTN,207.1)
 Q
SURE W ! K DIR S DIR("A")="   Sure you want to delete all Misc. Cardiac Procedures information ? ",DIR("B")="NO",DIR(0)="YA" D ^DIR W ! K DIR S SRYN=Y I $D(DTOUT)!$D(DUOUT) S SRSOUT=1
 Q
