ABMER31A ; IHS/ASDST/DMJ - UB92 EMC RECORD 31 (Third Party Payor Address) ;
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;Original;DMJ;
 ;
DIQ1 ; EP
 ; Pull Policy Holder data via DIQ1
 S ABME("EMP")=""
 Q:'$G(ABME("PH"))
 Q:$D(ABM(9000003.1,ABME("PH"),ABME("FLD")))
 N I
 S DIQ="ABM("
 S DIQ(0)="EI"
 S DIC="^AUPN3PPH("
 S DA=ABME("PH")
 S DR=".02;.04;.08;.09;.11;.12;.13;.15;.16"
 S ABME("EMP")=ABM(9000003.1,ABME("PH"),.16,"I")
 D EN^DIQ1
 K DIQ
 Q
 ;
DIQ2 ; EP
 ; Employer information from EMPLOYER file (FILE#9999999.75)
 S ABME("EMP")=ABM(9000003.1,+ABME("PH"),.16,"I")
 Q:'$G(ABME("EMP"))
 Q:$D(ABM(9999999.75,ABME("EMP"),ABME("FLD")))
 N I
 S DIQ="ABM("
 S DIQ(0)="EI"
 S DIC="^AUTNEMPL("
 S DA=ABME("EMP")
 S DR=".02;.03;.04;.05"
 D EN^DIQ1
 K DIQ
 Q
 ;
DIQ3 ; EP
 ; Employer information from file 9000001 
 S DA=$P(^AUPNPAT(ABMP("PDFN"),0),"^",19)
 Q:'DA
 Q:$D(ABM(9999999.75,DA,ABME("FLD")))
 N I
 S DIQ="ABM("
 S DIQ(0)="EI"
 S DIC="^AUTNEMPL("
 S DR=".01:.05"
 D EN^DIQ1
 K DIQ
 Q
 ;
DIQ4 ; EP
 ; Address information from file 2
 Q:$D(ABM(2,ABME("PPP"),ABME("FLD")))
 N I
 S DIQ="ABM("
 S DIQ(0)="EI"
 S DIC="^DPT("
 S DA=ABME("PPP")
 S DR=".111:.116"
 D EN^DIQ1
 K DIQ
 Q
