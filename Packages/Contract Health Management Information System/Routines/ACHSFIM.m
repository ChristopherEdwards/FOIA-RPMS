ACHSFIM ;IHS/ITSC/JVK -AUTHORIZATION MESSAGE TO FI;
 ;;3.1;CONTRACT HEALTH MGMT SYSTEM;**6,13**;JUN 11, 2001
 ;;ACHS*3.1*6 7/1/03 ADD THE ABLITY TO SEND APPROVAL AUTHORIZATION
 ;;ACHS*3.1*13 6.6.2007 OIT/DIRM/FCJ Multiple fixes: exiting option, multiple looping, error on blanket, selecting special local type doc
 ;
EN ;EP - From Option to send approval message to FI
 ;
 I '$D(ACHSCFY)!($G(ACHSFC)="") D ^ACHSVAR
 ;
 K DR,D0,D1,D2,ACHSDIEN
 ;
 D ^ACHSUD              ;SELECT DOCUMENT AND DISPLAY
 I '$D(ACHSDIEN) D K Q
 S %=$$DOC^ACHS(0,12) ;TEST FOR OPEN DOCUMENT
 I %'=0 W !,"Must be an open document." D K G EN
 K DIR
 ;ACHS*3.1*13 6.6.2007 OIT/DIRM/FCJ ADDED NXT 2 LINES
 S %=$$DOC^ACHS(0,3) ;TEST FOR SPECIAL LOCAL DOCUMENT
 I %=2 W !!,"Cannot send a special local document." D K K DIR G EN
 D DISPLAY
ASK ;
 S %=$$DIR^ACHS("Y","Do you want to send a EPO approval message to the FI","YES","By entering yes you may send approval for sterilization procedures,etc","","")
 I Y<1 D K Q
 D SET
 ;ACHS*3.1*13 6.6.2007 OIT/DIRM/FCJ  ADD NXT 4 LINES AND "SET" SUB
 ;G ASK
 S %=$$DIR^ACHS("Y","Do you want to send another EPO approval message to the FI","YES","By entering yes you may send approval for sterilization procedures,etc","","")
 I Y=1 D SET
 W !!,"Approval Message will be sent with next export to the FI ONLY if PO has not been exported",!
 D RTRN^ACHS D K Q
 ;
SET ;SET MESSAGE IN DOCUMENT
 S %=$$DIE^ACHS(102,.01)
 D DISPLAY
 Q
 ;
DISPLAY ;
 W @IOF
 W !
 W ?5,"DOCUMENT: ",$$DOC^ACHS(0,14)_"-"_$$DOC^ACHS(0,1)
 ;W ?40,"PATIENT NAME: ",$P(^DPT($$DOC^ACHS(0,22),0),U),!
 W:$$DOC^ACHS(0,3)'=1 ?40,"PATIENT NAME: ",$P(^DPT($$DOC^ACHS(0,22),0),U)
 S ACHSDOS=$$DOC^ACHS(3,1)
 S Y=ACHSDOS D DD^%DT S ACHSDOS=Y
 W !?5,"DATE OF SERVICE: ",ACHSDOS
 Q:'$D(^ACHSF(DUZ(2),"D",ACHSDIEN,102))  ;ACHS*3.1*13 6.6.2007 OIT/DIRM/FCJ
 W ?40,"APRROVAL MESSAGE(S) TO FI: ",!
 S J=0
 F I=1:1:2  S J=$O(^ACHSF(DUZ(2),"D",ACHSDIEN,102,J)) Q:J'?1N.N  D
 . S ACHSVAL(I)=$P(^ACHSF(DUZ(2),"D",ACHSDIEN,102,J,0),U)
 . W ?49,I_". "_$S(ACHSVAL(I)="S":"Sterilization",ACHSVAL(I)="D":"In Support of Direct Care",ACHSVAL(I)="":""),!
 Q
K ;
 K ACHSDIEN,ACHSDOS,ACHSVAL,D0,D1,I,J
 Q
 ;
