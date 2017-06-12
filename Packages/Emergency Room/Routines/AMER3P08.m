AMER3P08 ;GDIT/HS/BEE - AMER v3.0 Patch 8 ENV Check/PST Check ; 07 Oct 2013  11:33 AM
 ;;3.0;ER VISIT SYSTEM;**8**;MAR 03, 2009;Build 23
 ;
 ;Check for AMER*3.0*7
 I '$$INSTALLD("AMER*3.0*7") D FIX(2)
 ;
 Q
 ;
PST ;Post installation front end
 ;
 ;Need to loop through old PRESENTING COMPLAINT (#8) field and move results to new
 ;PRESENTING COMPLAINT field (#23)
 ;
 NEW AMERADM,X1,X2,X,II,QA3IEN
 ;
 ;Switch ER INPUT MAP QA3 entry to save in field 23 instead of field 8
 S QA3IEN=$O(^AMER(2.3,"B","QA3",""))
 I QA3IEN]"" D
 . NEW AMERUPD,ERROR
 . S AMERUPD(9009082.3,QA3IEN_",",.04)=23
 . D FILE^DIE("","AMERUPD","ERROR")
 ;
 ;Move Presenting Complaint data from field 8 to field 23
 ;
 ;Reset Monitoring Global
 K ^XTMP("AMERP8LOG")
 ;
 ;Get later date
 S X1=DT,X2=60 D C^%DTC
 ;
 ;Set up Monitoring Global
 S ^XTMP("AMERP8LOG",0)=X_U_DT_U_"Log of entries moved from old PC to new PC"
 ;
 S (II,AMERADM)=0 F  S AMERADM=$O(^AMERADM(AMERADM)) Q:'AMERADM  D
 . NEW OLDPC,NEWPC,AMERUPD,ERROR
 . ;
 . ;Retrieve new presenting complaint value (already converted)
 . S NEWPC=$$GET1^DIQ(9009081,AMERADM_",",23,"I") Q:NEWPC]""
 . ;
 . ;Retrieve old presenting complaint value
 . S OLDPC=$$GET1^DIQ(9009081,AMERADM_",",8,"I") Q:OLDPC=""
 . ;
 . ;Save to new
 . S AMERUPD(9009081,AMERADM_",",23)=OLDPC
 . D FILE^DIE("","AMERUPD","ERROR")
 . S II=II+1,^XTMP("AMERP8LOG",9009081,II)=AMERADM_U_OLDPC
 ;
 Q
 ;
INSTALLD(AMERSTAL) ;EP - Determine if patch AMERSTAL was installed, where
 ; AMERSTAL is the name of the INSTALL.  E.g "AMER*3.0*7"
 ;
 NEW AMERY,INST
 ;
 S AMERY=$O(^XPD(9.7,"B",AMERSTAL,""))
 S INST=$S(AMERY>0:1,1:0)
 D IMES(AMERSTAL,INST)
 Q INST
 ;
IMES(AMERSTAL,Y) ;Display message to screen
 D MES^XPDUTL($$CJ^XLFSTR("Patch """_AMERSTAL_""" is"_$S(Y<1:" *NOT*",1:"")_" installed.",IOM))
 Q
 ;
FIX(X) ;
 KILL DIFQ
 I X=3 S XPDQUIT=2 Q
 S XPDQUIT=X
 W *7,!,$$CJ^XLFSTR("This patch must be installed prior to the installation of AMER*3.0*7",IOM)
 Q
