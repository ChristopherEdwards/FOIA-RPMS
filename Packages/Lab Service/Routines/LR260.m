LR260 ;VA/DALOI/RLM-PATCH 260 POST-INIT ROUTINE ;1/1/98
 ;;5.2;LAB SERVICE;**1030**;NOV 01, 1997
 ;;5.2;LAB SERVICE;**260**;Sep 27, 1994;Build 2
 K ERROR,FDA,DIERR
 D VAL^DIE(69.51,"+1,",.01,,"VA-HEP C RISK ASSESSMENT",.LRANS)
 S FDA(42,69.51,"+1,",.01)=LRANS
 I $D(^LAB(69.51,"B",LRANS)) W !,"VA-HEP C RISK ASSESSMENT entry exists in 69.51 and will not be duplicated."
 I '$D(^LAB(69.51,"B",LRANS)) D UPDATE^DIE("","FDA(42)","","ERROR")
 I $D(ERROR) W !,"VA-HEP C RISK ASSESSMENT not added to file 69.51.",!,"Please log a NOIS call and request assistance."
 ;
 K ERROR,FDA,DIERR
 D VAL^DIE(69.51,"+1,",.01,,"VA-NATIONAL EPI LAB EXTRACT",.LRANS)
 S FDA(42,69.51,"+1,",.01)=LRANS
 I $D(^LAB(69.51,"B",LRANS)) W !,"VA-NATIONAL EPI LAB EXTRACT entry exists in 69.51 and will not be duplicated."
 I '$D(^LAB(69.51,"B",LRANS)) D UPDATE^DIE("","FDA(42)","","ERROR")
 I $D(ERROR) W !,"VA-NATIONAL EPI LAB EXTRACT not added to file 69.51.",!,"Please log a NOIS call and request assistance."
 ;
 K ERROR,FDA,DIERR
 D VAL^DIE(69.51,"+1,",.01,,"VA-NATIONAL EPI RX EXTRACT",.LRANS)
 S FDA(42,69.51,"+1,",.01)=LRANS
 I $D(^LAB(69.51,"B",LRANS)) W !,"VA-NATIONAL EPI RX EXTRACT entry exists in 69.51 and will not be duplicated."
 I '$D(^LAB(69.51,"B",LRANS)) D UPDATE^DIE("","FDA(42)","","ERROR")
 I $D(ERROR) W !,"VA-NATIONAL VA-NATIONAL EPI RX EXTRACT not added to file 69.51.",!,"Please log a NOIS call and request assistance."
 ;
 K ERROR,FDA,DIERR
 D VAL^DIE(69.5,"+1,",12,,"LREPI",.LRANS)
 S FDA(42,69.5,"+1,",12)=LRANS ;Protocol
 S FDA(42,69.5,"+1,",.01)="HEPATITIS C ANTIBODY NEG" ;Name
 S FDA(42,69.5,"+1,",.05)=15 ;Sequence Number
 S FDA(42,69.5,"+1,",1)=0 ;Active (0=yes)
 S FDA(42,69.5,"+1,",10.5)=15 ;Lag Days
 S FDA(42,69.5,"+1,",10)="M" ;Cycle
 S FDA(42,69.5,"+1,",13)=1 ;Follow PTF
 I $D(^LAB(69.5,"B","HEPATITIS C ANTIBODY NEG")) W !,"HEPATITIS C ANTIBODY NEG entry exists in 69.5 and will not be duplicated."
 I '$D(^LAB(69.5,"B","HEPATITIS C ANTIBODY NEG")) D UPDATE^DIE("","FDA(42)","","ERROR")
 I $D(ERROR) W !,"HEPATITIS C ANTIBODY NEG not added to file 69.5.",!,"Please log a NOIS call and request assistance."
 ;
 K ERROR,FDA,DIERR
 D VAL^DIE(69.5,"+1,",12,,"LREPI",.LRANS)
 S FDA(42,69.5,"+1,",12)=LRANS ;Protocol
 S FDA(42,69.5,"+1,",.01)="HEPATITIS A ANTIBODY POS" ;Name
 S FDA(42,69.5,"+1,",.05)=16 ;Sequence Number
 S FDA(42,69.5,"+1,",1)=0 ;Active (0=yes)
 S FDA(42,69.5,"+1,",10.5)=15 ;Lag Days
 S FDA(42,69.5,"+1,",10)="M" ;Cycle
 S FDA(42,69.5,"+1,",13)=1 ;Follow PTF
 I $D(^LAB(69.5,"B","HEPATITIS A ANTIBODY POS")) W !,"HEPATITIS A ANTIBODY POS entry exists in 69.5 and will not be duplicated."
 I '$D(^LAB(69.5,"B","HEPATITIS A ANTIBODY POS")) D UPDATE^DIE("","FDA(42)","","ERROR")
 I $D(ERROR) W !,"HEPATITIS A ANTIBODY POS not added to file 69.5.",!,"Please log a NOIS call and request assistance."
 ;
 K ERROR,FDA,DIERR
 D VAL^DIE(69.5,"+1,",12,,"LREPI",.LRANS)
 S FDA(42,69.5,"+1,",12)=LRANS ;Protocol
 S FDA(42,69.5,"+1,",.01)="HEPATITIS B POS" ;Name
 S FDA(42,69.5,"+1,",.05)=17 ;Sequence Number
 S FDA(42,69.5,"+1,",1)=0 ;Active (0=yes)
 S FDA(42,69.5,"+1,",10.5)=15 ;Lag Days
 S FDA(42,69.5,"+1,",10)="M" ;Cycle
 S FDA(42,69.5,"+1,",13)=1 ;Follow PTF
 I $D(^LAB(69.5,"B","HEPATITIS B POS")) W !,"HEPATITIS B ANTIBODY POS entry exists in 69.51 and will not be duplicated."
 I '$D(^LAB(69.5,"B","HEPATITIS B POS")) D UPDATE^DIE("","FDA(42)","","ERROR")
 I $D(ERROR) W !,"HEPATITIS B POS not added to file 69.5.",!,"Please log a NOIS call and request assistance."
 K FDA,ERROR,DIERR ;
 ;I $$FIND1^DIC(3.812,","_$$FIND1^DIC(3.8,,"XM","EPI")_",","M","XXX@Q-EPI",,,"ERROR") W !,"XXX@Q-EPI.MED.VA.GOV already exists in the EPI mailgroup and will not be duplicated."
 ;I '$$FIND1^DIC(3.812,","_$$FIND1^DIC(3.8,,"XM","EPI")_",","M","XXX@Q-EPI",,,"ERROR") D
 ; . D FIND^DIC(3.8,,,"O","EPI",1,,,,"RESULT","ERROR")
 ; . S LRMG=RESULT("DILIST",2,1) D
 ; . . S FDA(42,3.812,"+2,"_LRMG_",",.01)="XXX@Q-EPI.MED.VA.GOV"
 ; . . D UPDATE^DIE("","FDA(42)","","ERROR")
 ;I $D(ERROR) W !,"XXX@Q-EPI.MED.VA.GOV not added to EPI MailGroup.",!,"Please log a NOIS call and request assistance."
 K FDA,ERROR,DIERR
 S LRIEN=$O(^LAB(69.5,"B","NCH PAP SMEAR",""))
 I LRIEN S $P(^LAB(69.5,LRIEN,0),"^",2)=1
 S LRIEN=$O(^LAB(69.5,"B","NCH CHOLESTEROL",""))
 I LRIEN S $P(^LAB(69.5,LRIEN,0),"^",2)=1
 K DIERR,ERROR,FDA,LRANS,LRIEN,LRMG,RESULT
ZEOR ;LR260
