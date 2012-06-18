ACHSDN ; IHS/ITSC/PMF - DENIAL DATA ENTRY (1/2) ;
 ;;3.1;CONTRACT HEALTH MGMT SYSTEM;**10,11,12,13,18**;JUN 11,2001
 ;3.1*10 4.21.03 IHS/ITSC/FCJ TEST FOR RCIS IF LINK IS ON WILL NOW SET
 ;       DEFAULT VARS AND CLOSE REF ONCE DENIAL IS COMPLETE
 ;3.1*11 8.24.03 IHS/ITSC/FCJ TEST FOR RCIS VERSION
 ;3.1*12 1.4.04 IHS/ITSC/JVK TEST FOR PAWNEE BEN PKG
 ;3.1*13 12.1.06 IHS/OIT/FCJ COULD NOT ^ OUT OF DATA ENTRY
 ;3.1*18 4/1/2010;IHS/CNI/ABK;Change every occurrance of Deferred to Unmet Need
 ;
SITE ;
 ;ACHS*3.1*13 12.1.06 IHS/OIT/FCJ S ACHSERR VAR USED WHEN EXITING DATA ENTRY
 ;S ACHDREG=""
 S ACHDREG="",ACHSERR=""
 D SETCK^ACHSDF1             ;SETUP SITE PARAMETERS
 ;                           REMOVE INCOMPLETE DENIALS
 I $D(ACHS("NOTSET")) D END Q
 ;
START ;EP --- Set the pseudo number of a Denial and begin entering data.
 I '$D(^ACHSDEN(DUZ(2),0)) S ^ACHSDEN(DUZ(2),0)=DUZ(2),DIK="^ACHSDEN(",DA=DUZ(2),DIK(1)=".01" D EN^DIK K DIK,DA
 ;
 I '($D(^ACHSDEN(DUZ(2),"D",0))#10) S ^ACHSDEN(DUZ(2),"D",0)=$$ZEROTH^ACHS(9002071,1)
 ;
 K DIC
 S DIC="^ACHSDEN("_DUZ(2)_",""D"",",DA(1)=DUZ(2)
 S DIC(0)="L"
 S X="#"_$P($H,",",1)_"#"_$P($H,",",2)
 D ^DIC K DIC
 I +Y<1 D END Q
 S ACHSA=+Y
 ;
 ;FORCE ENTER 'DATE DENIAL ISSUED' AND 'ISSUED BY'
 I '$$DIE("2////"_DT_";3////"_DUZ) D END Q
 ;
PAT ; ---  Select the patient for this Denial.
 G P2:ACHDREG="N"
 G P1:ACHDREG="Y"
 ;
 ;ACHS*3.1*10 4.21.04 IHS/ITSC/FCJ REMOVED EXTRA ?
 ;S Y=$$DIR^ACHS("Y","Is the patient REGISTERED IN THIS COMPUTER? ","YES","","",2) ;ACHS*3.1*10 4.21.04
 S Y=$$DIR^ACHS("Y","Is the patient REGISTERED IN THIS COMPUTER","YES","","",2)  ;ACHS*3.1*10 4.21.04
 I $D(DTOUT)!$D(DUOUT) D END Q
 G P1:Y
 G P2
 ;
P1 ; ---  Patient is registered.
 ;ACHS*3.1*10 4.21.03 IHS/ITSC/FCJ TEST FOR RCIS
 ;ACHS*3.1*11 8.24.03 IHS/ITSC/FCJ ADD TEST FOR RCIS VERSION
 I $$LINK^ACHSBMC,$$VCHK^ACHSBMC>2 S ACHSREF="" D GETREF^ACHSBMC(.ACHSREF) G:$D(DFN) P1A ;ACHS*3.1*10 4.21.03
 G:$D(DUOUT) PAT
 S DFN=$$DN^ACHS(0,7)                ;GET 'REGISTERED PATIENT' PTR
 I DFN,'$D(^DPT(DFN,0)) S DFN=""     ;
 S AUPNX=0
 I DFN="" D PTLK^ACHS G:'$G(DFN) PAT  ;THIS GIVES US PROBLEMS SOMETIMES
 ;
 ;ITSC/SET/JVK ACHS**TESTING**
 ;S Y=$$DIR^ACHS("Y","Is this the correct patient REGISTERED IN THIS COMPUTER? ","YES","","",2) ;ACHS***
 ;I 'Y D KILL Q
 ;
 I $D(DUOUT)!'$D(DFN)!$D(DTOUT) D KILL Q
 ;
P1A ;
 ;ITSC/SET/JVK ACHS*3.1*12 ADD FOR IHS/OKCAO/POC PAWNEE BEN PKG
 ;I '$D(^AUPNPAT(DFN,41,DUZ(2))) D  I ('%)!$D(DUOUT)!$D(DTOUT) D END Q
 I (+$P($G(^AUTTLOC(DUZ(2),0)),U,10)'=505613)&('$D(^AUPNPAT(DFN,41,DUZ(2)))) D  I ('%)!$D(DUOUT)!$D(DTOUT) D END Q
 . W !!,*7,*7,$$R("*",13)," THIS PATIENT HAS NO CHART AT THIS FACILITY.",$$R("*",12)
 . W !,$$R("*",13)," THEY ARE REGISTERED AT :"
 . S J=0
 . F  S J=$O(^AUPNPAT(DFN,41,J)) Q:+J=0  W !?10,$P($G(^DIC(4,J,0)),U),?35,$P($G(^AUPNPAT(DFN,41,J,0)),U,2)
 . W !,$$R("*",13),!,$$R("*",13)," YOU MUST ENTER THEIR CHART NUMBER FOR THIS FACILITY ",$$R("*",9),!!,"CONTINUE? ",!
 .S %=$$DIR^ACHS("Y","Do you want to enter their Chart Number for this facility","NO","","",2)
 . I %,'$$DIE(15) S %=0    ;'CHART # (OTHER FACILITY)'
 ;
 ;
 I '$$DIE("6///Y;7////"_DFN) D END Q   ;FORCE ENTRY 'PATIENT REGISTERED'
 ;                                    'REGISTERED PATIENT'  ?????
 ;
 ;IF THERE IS MISSING INFO IN 'PATIENT NAME' 'MAILING ADDRESS- STREET 'MAILING ADDRESS-CITY' 'MAILING ADDRESS- STATE' OR 'MAILING ADDRESS-ZIP' QUIT
 I $D(^ACHSDEN(DUZ(2),"D",ACHSA,10)),'$$DIE("10///@;11///@;12///@;13///@;14///@") D END Q
 ;
 ;GET NAME AND ADDRESS INFO FROM PATIENT FILE (REGISTERED PATIENT)
 S X=$G(^DPT(DFN,.11))
 S Y=$P($G(^DPT(DFN,0)),U)
 W !!,$P(Y,",",2)_" "_$P(Y,",",1),!,$P(X,U),!,$P(X,U,4)
 I $P(X,U,5),$D(^DIC(5,$P(X,U,5),0)) W " ",$P($G(^DIC(5,$P(X,U,5),0)),U,2)
 W " ",$P(X,U,6)
 G P3
 ;
P2 ; ---  Patient is not registered.
 I '$$DIE("10:15",2) D END Q       ;EDIT PATIENT INFO NON-REGISTERED
 I $D(^ACHSDEN(DUZ(2),"D",ACHSA,10)),$P($G(^ACHSDEN(DUZ(2),"D",ACHSA,10)),U)]"",'$$DIE("6///N;7///@") D END Q
 ;
 ;
P3 ;
 I $L($$DN^ACHS(0,7))!$L($$DN^ACHS(10,1)) G DEFER  ;IF 'REGISTERED PATIENT
 ;                                                OR 'PATIENT NAME' OKAY
 W !!,*7,"No valid patient has yet been entered - try again.",!!
 G PAT
 ;
DEFER ;
 W !!
 S DIE="^ACHSDEN("_DUZ(2)_",""D"","
 ;IHS/CNI/abk 7/16/10 ACHS*3.1*18
 ;S DR="400//NOT A DEFERRED SERVICE"
 S DR="400//NOT AN UNMET NEED"
 S DA=ACHSA
 D ^DIE               ;DEFERRED SERVICES TYPE
 ;ACHS*3.1*13 12.1.06 IHS/OIT/FCJ EXIT TO PAT LINE
 ;Q:$D(Y)
 G:$D(Y) PAT
 ;
DOS ; ---  Enter Date of Service of Denial.
 ;ACHS*3.1*10 4.21.03 IHS/ITSC/FCJ TEST FOR RCIS CHG PASS OF 4 TO DR VAR
 ;ACHS*3.1*13 12.1.06 IHS/OIT/FCJ ALSO CHG G PAT TO G DEFER
 ;I '$$DIE(4,2) D END Q      ;IF NO 'DATE OF MEDICAL SERVICE' QUIT
 S DR=4,Y=$P(^ACHSDEN(DUZ(2),"D",ACHSA,0),U,4)
 I Y="",$G(ACHSREF) D
 .S Y=$S(ACHSREF(1106)'="":ACHSREF(1106),1:ACHSREF(1105))
 I Y X ^DD("DD") S DR="4//"_Y
 I '$$DIE(DR,2) D END Q      ;IF NO 'DATE OF MEDICAL SERVICE' QUIT
 I $D(Y) K ACHSREF,Y S $P(^ACHSDEN(DUZ(2),"D",ACHSA,0),U,4)="" G DEFER
 ;ACHS*3.1*10 4.21.03 IHS/ITSC/FCJ END OF CHANGES
 ;
 ; CHECK IF DATE IS IN ACCEPTABLE RANGE OF 10 YEARS
 S X1=X,X2=DT
 D ^%DTC
 I $TR(X,"-","")>3650 D  G DOS
 . W !!,*7,"DATE OF MEDICAL SERVICE must be within 10 years of today!",!
 . D RTRN^ACHS
 I $$DN^ACHS(0,4)="" W !!,*7,"A DATE OF MEDICAL SERVICE must be entered - try again." W ! D RTRN^ACHS G DOS
DOR ; ---  Enter Date Request Received.
 I '$$DIE(5,2) D END Q
 G DOS:$D(Y)
 ;I $$DN^ACHS(0,5)="" W !!,*7,"A DATE REQUEST RECEIVED must be entered - try again." W ! D RTRN^ACHS G DOR ;ACHS*3.1*13 12.1.06 IHS/OIT/FCJ RMVD RTRN
 I $$DN^ACHS(0,5)="" W !!,*7,"A DATE REQUEST RECEIVED must be entered - try again." W ! G DOR ;ACHS*3.1*13 12.1.06 IHS/OIT/FCJ RMVD RTRN
 ;
 ;ADD CHS WORKGROUP REQUEST FOR PROMPT TO "SEND THE LETTER TO WHOM"
 ;DEFAULT=PATIENT
 ;ASK IF THERE IS AN ALTERNATE RECIPIENT
ALTREC ;
 ;change next line.  the denial record number is in var ACHSA,
 ;not in A("DA").  1/5/01  PMF
 ;W !! S DR=9,DIE="^ACHSDEN("_DUZ(2)_",""D"",",DA=A("DA") D ^DIE
 W !!
 S DR="9//YES"
 S DIE="^ACHSDEN("_DUZ(2)_",""D"","
 S DA=ACHSA
 D ^DIE
 ;
 G DOR:$D(Y)
 ;
 ;it looks like wanted to set DA, but screwed it up.  also, we
 ;want to take this action if they said N, not Y.   1/5/01  pmf
 ;I X="Y" W !! S DR=9.5,DIE="^ACHSDEN("_DUZ(2)_",""D"",",DA("DA") D ^DIE G ALTREC:$D(Y)
 I X="N" W !! S DR=9.5,DIE="^ACHSDEN("_DUZ(2)_",""D"",",DA=ACHSA D ^DIE G ALTREC:$D(Y)
 ;
 D ^ACHSDN1                     ;SECOND PART OF DENIAL ENTRY
 G:$D(DTOUT)!$D(DUOUT) PAT
 ;ACHS*3.1*13 12.1.06 IHS/OIT/FCJ COULD NOT GET OUT OF LOOP EXT TO PREV CALL
 I ACHSERR S ACHSERR="" G ALTREC
 D ^ACHSDNDP                    ;DISPLAY DENIAL DATA
 D NUMBER                      ;CALCULATE AND SSIGN DENAIL #
END ;
 K A,ACHD,DFN,DTOUT,DUOUT,DIC,DIE,DR,DLAYGO,DA,DIK,ACHDREG
 ;ACHS*3.1*10 4.21.03 IHS/ITSC/FCJ ADDED LN
 K ACHSREF,ACHSERR,ACHSDES,ACHSEDOS,ACHSESDO,ACHSHRN,ACHSPROV,ACHSRMPC,ACHSTYP,ACHDPAT,ACHS,ACHSA,C,Y,Y1,INS  ;ACHS*3.1*10 4.21.03 IHS/ITSC/FCJ ADDED LN
 Q
 ;
KILL ; ---  User stopped before all data entered.  Delete pseudo.
 S DA(1)=DUZ(2),DA=ACHSA,DIK="^ACHSDEN("_DUZ(2)_",""D"","
 D ^DIK
 W !!,*7,"This denial has been deleted.",!!!
 D RTRN^ACHS
 D END
 Q
 ;
NUMBER ; ---  Calculate and assign the Denial Number.
 N ACHDDOS,ACHDFY,ACHDMSG,ACHDNUM,ACHDQTR,ACHDSEQ
 ;
 S ACHDDOS=$$DN^ACHS(0,4)
 S ACHDFY=$$GETFY(ACHDDOS)
 S ACHDQTR=+$E($P($$FY^ACHS(ACHDFY),U),4,5)
 S Y=0
 F X=ACHDQTR:1 S:X=13 X=1 S Y=Y+1 I X=+$E(ACHDDOS,4,5) Q
 S ACHDQTR=$S(Y<4:1,Y<7:2,Y<10:3,1:4)
 I '$$LOCK^ACHS("^ACHSDENR(DUZ(2),4)","+") Q
 S ACHDFY=$S(ACHDFY>50:"19",1:"20")_ACHDFY
 I '$D(^ACHSDENR(DUZ(2),4,ACHDFY,0)) S DIE="^ACHSDENR(",DR="4///"_ACHDFY,DA=DUZ(2),DR(2,9002072.02)=".01///"_ACHDFY D ^DIE
 S ACHDMSG=0
SEQ ;
 S (ACHDSEQ,$P(^ACHSDENR(DUZ(2),4,ACHDFY,0),U,2))=$P($G(^ACHSDENR(DUZ(2),4,ACHDFY,0)),U,2)+1
 S ACHDNUM=$E(ACHDFY,3,4)_ACHDQTR_"-"_ACHD("AREA")_ACHD("FAC")_"-"_ACHDSEQ
 ;
 I $D(^ACHSDEN(DUZ(2),"D","B",ACHDNUM)) S ACHDMSG=ACHDMSG+1 W:ACHDMSG<2 !!,"*** one moment, please ***",!! G SEQ
 I '$$LOCK^ACHS("^ACHSDENR(DUZ(2),4)","-") Q
 ;
 I '$$DIE(".01///"_ACHDNUM_";2////"_DT_";3////"_DUZ) Q
 W @IOF,!!,"This denial has been posted.  The DENIAL NUMBER is: ",ACHDNUM,!!!!
 ;ACHS*3.1*10 4.21.04 IHS/ITSC/FCJ ADDED NXT LINE TO CLOSE REF
 I $G(ACHSREF) D STAT^ACHSBMC("D") ;ACHS*3.1*10 4.21.04
 D RTRN^ACHS
 Q
 ;
R(C,N) ;
 Q $$REPEAT^XLFSTR(C,N)
 ;
DIE(DR,Z) ;EP - Edit Denial fields.  ACHSA must be the IEN of the Denial.
 I $G(Z) F %=1:1:Z W !
 S DA=ACHSA
 S DA(1)=DUZ(2)
 S DIE="^ACHSDEN("_DUZ(2)_",""D"","
 I '$$LOCK^ACHS("^ACHSDEN(DUZ(2),""D"",ACHSA)","+") S DUOUT="" Q 0
 D ^DIE
 I '$$LOCK^ACHS("^ACHSDEN(DUZ(2),""D"",ACHSA)","-") S DUOUT="" Q 0
 Q 1
 ;
GETFY(X) ;EP - Given date X, return last 2 digits of FY in which it falls.
 N W,Y,Z
 ;
 S Y=$E(DT,1,3)+1700-10
 S Y=$E(Y,3,4)
 ; Fiscal spending authorities are only good for 7 years, that's why
 ; the lookback of only 10 years.
 ;
 ; Check 20 FYs until the date (X) is bracketed in the FY begin and
 ; end dates, returned from FY^ACHS().
 F Z=Y:1:Y+21 S:Z>99 Z=0 S:Z<10 Z="0"_Z S W=$$FY^ACHS(Z) I '(X<$P(W,U)),'(X>$P(W,U,2)) Q
 ;
 I Z=(Y+21) Q -1
 Q Z
 ;
