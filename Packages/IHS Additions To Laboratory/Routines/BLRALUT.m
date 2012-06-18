BLRALUT ;DAOU/ALA-Lab Audit Utility [ 11/18/2002  1:38 PM ]
 ;;5.2;LR;**1013,1015**;NOV 18, 2002
 ;
 ;**Program Description**
 ;  This contains utilities for Lab Audit
 ;
ULK ;EP
 ;  User Lookup
 K ^TMP($J,"BLRAU"),^TMP($J,"BLRAUSC")
 S BLRAU="",BLCT=0,BLRACTN=0
 F  S BLRAU=$O(^BLRALAB(9009027,"C",BLRAU)) Q:'BLRAU  D
 . S BLRAUN=$$GET1^DIQ(200,BLRAU,.01,"E")
 . Q:$D(^TMP($J,"BLRAU",BLRAUN))
 . S BLCT=BLCT+1
 . S ^TMP($J,"BLRAU",BLRAUN)=""
 . S ^TMP($J,"BLRAUSC",BLCT)=BLRAUN_U_BLRAU
 ;
 S BLRAU="",QFL=0,BLRACT=""
 F  S BLRACT=$O(^TMP($J,"BLRAUSC",BLRACT)) Q:BLRACT=""  D  Q:QFL
 . S BLRACTN=BLRACT
 . W !,?10,BLRACT_"  "_$P($G(^TMP($J,"BLRAUSC",BLRACT)),U,1)
 . I BLRACT#10=0 S QFL=0 D PRET Q:QFL
 ;
CHS S DIR(0)="L^1:"_BLRACTN D ^DIR
 K DIR
 I $G(BLRANS)=U Q
 ;
 S BLRAVAL=Y
 Q
 ;-------------------------------------------------------------
PRET W !,"Press <RETURN> to see more OR '^' to exit: "
 R BLRANS:DTIME
 I BLRANS=U S QFL=1
 Q
 ;
MEN ;EP
 ;  Menu Lookup
 ;
 K ^TMP($J,"BLRAU"),^TMP($J,"BLRAUSC")
 N BLRAMTXT
 S BLRAU="",BLCT=0,BLRACTN=0,BLRAMTXT=""
 F  S BLRAU=$O(^BLRALAB(9009027,"D",BLRAU)) Q:'BLRAU  D
 . I BLRAU=-1 Q  ;Safety check if "D" not created correctly -ejn
 . S BLRAUN=$$GET1^DIQ(19,BLRAU,.01,"E")
 . S BLRAMTXT=$$GET1^DIQ(19,BLRAU,1,"E")
 . Q:$D(^TMP($J,"BLRAU",BLRAUN))
 . S BLCT=BLCT+1
 . S ^TMP($J,"BLRAU",BLRAUN)=""
 . S ^TMP($J,"BLRAUSC",BLCT)=BLRAUN_U_BLRAU_U_BLRAMTXT
 ;
 S BLRAU="",QFL=0,BLRACT=""
 F  S BLRACT=$O(^TMP($J,"BLRAUSC",BLRACT)) Q:BLRACT=""  D  Q:QFL
 . S BLRACTN=BLRACT
 . W !,?10,BLRACT_"  "_$P($G(^TMP($J,"BLRAUSC",BLRACT)),U,3)
 . I BLRACT#10=0 S QFL=0 D PRET Q:QFL
 ;
 D CHS
 Q
