ABSPOSZ ; IHS/FCS/DRS - Upgrades ;       
 ;;1.0;PHARMACY POINT OF SALE;;JUN 21, 2001
 Q
 ; Upgrades for files are in ABSPOSZA.  Only needed at a couple of
 ; places, so run them manually, separately.
 ;
PRE ; Pre-installation procedure, pointed to by .KID file
 ; If you have renamed any 9002313.92 entries,  ;  look up the existing ones at this site and rename them.
 ;  Otherwise, resolving of pointers will fail, won't it?
 Q
POST ; Post-installation procedure, pointed to by .KID file
 I $$HASILCAR D BILLMENU
 I DUZ(2)=1665 D ANMC
 D INIT58
 D T1ADDR
 K ^ABSP(9002313.99,"ABSPOSM1") ; node erroneously set in earlier ver.
 Q
 ;
T1ADDR ; the "ENVOY DIRECT VIA T1 LINE" dialout - make sure it has the
 ; latest and correct address and port information
 N T1 S T1=$$T1 I 'T1 D  Q
 . W !,"There is no dial out named ",$$T1NAME,!
 N X S X=$G(^ABSP(9002313.55,T1,"SERVER"))
 ;
 ; T1VALUES points directly inside Envoy.
 ; CLOVERLF is that special new project, the address we ultimately
 ; do want to send to.   Pick the CLOVERLF value starting some date,
 ; which is when I'm guessing they will be done testing and ready to
 ; do production business.
 ; Some sites may still need to manually edit the values if my guess
 ; is far off the actual completion date of Cloverleaf.
 ; Cloverleaf may assign specific ports to specific sites,
 ; so don't change the port number if the correct IP address is already
 ; in place.
 ;
 ; ABSP*1.0T7*7 - Cloverleaf effective date is uncertain.
 ; For now, always install the Envoy IP address and port
 ;N Y S Y=$P($S(DT<3010701:$T(T1VALUES),1:$T(CLOVERLF)),";",2) ;
 N Y S Y=$P($T(T1VALUES),";",2) ; ABSP*1.0T7*7
 I X=Y Q  ; already has correct values
 W !!,"Updating your settings for the ",$$T1NAME," dial out...",! H 2
 I $P(X,U)'=$P(Y,U) D
 . W "Changing the IP address from ",$P(X,U)," to ",$P(Y,U),! H 2
 . S $P(X,U)=$P(Y,U)
 . W "Changing the TCP port from ",$P(X,U,2)," to ",$P(Y,U,2),! H 2
 . S $P(X,U,2)=$P(Y,U,2)
 E  I $P(X,U,2)="" D
 . W "Setting the TCP port to ",$P(Y,U,2),! H 2
 . S $P(X,U,2)=$P(Y,U,2)
 S ^ABSP(9002313.55,T1,"SERVER")=X
 W !,"Settings for ",$$T1NAME," have been updated.",! H 2
 W !
 W "If you customized any dial outs to also point to the T1 address",!
 W "and port, you will need to update those manually using the",! H 1
 W "MGR/SET/DIAL menu to set up the dial outs.",! H 2
 Q
T1VALUES ;199.244.222.6^6802
CLOVERLF ;161.223.90.56^5006
T1() Q $O(^ABSP(9002313.55,"B",$$T1NAME,0))
T1NAME() Q "ENVOY DIRECT VIA T1 LINE"
ANMC ; Special for ANMC
 ; Rename the receipt protocol
 ; Lookup the ABSP P1 RECEIPT protocol
 ; and change its ITEM TEXT (#1) to "Print DUR data"
 W !,"Renaming the ABSP P1 RECEIPT protocol's ITEM TEXT...",!
 N PRO S PRO=$$FIND1^DIC(101,,,"ABSP P1 RECEIPT")
 I 'PRO W "Could not find it!",! Q
 S PRO=PRO_","
 N FDA,MSG S FDA(101,PRO,1)="Print DUR data"
 D FILE^DIE(,"FDA","MSG")
 I $D(MSG) W "Error in FILE^DIE: ",! D ZWRITE^ABSPOS("MSG") Q
 W "Done",!
 ;
 ; File 101, Subfile 101.01, Field .01 
 ; Lookup which one points to ABSP P1 RECEIPT
 ; and change its Mnemonic (#2) to "DUR"
 ;
 W "Finding the menu in ABSP PROTOCOL 1...",!
 N PRO1
 S PRO=$$FIND1^DIC(101,,,"ABSP PROTOCOL 1") ; top-level protocol
 I 'PRO W "Could not find it!",! Q
 S PRO=PRO_","
 W "Finding the ABSP P1 RECEIPT among the ITEMs therein...",!
 S PRO1=$$FIND1^DIC(101.01,","_PRO,,"ABSP P1 RECEIPT")
 I 'PRO1 W "Could not find it!",! Q
 K FDA,MSG S FDA(101.01,PRO1_","_PRO,2)="DUR"
 D FILE^DIE(,"FDA","MSG")
 I $D(MSG) W "Error in FILE^DIE: ",! D ZWRITE^ABSPOS("MSG") Q
 W "Done",!
 Q
HASILCAR() ; does the site have ILC A/R installed and active?
 ; This is for use only by installation procedure!
 ; Look at the most recently created bill.  See if it was in the
 ; past week or so.
 N PCN S PCN=$P($G(^ABSBITMS(9002302,0)),U,3)
 I 'PCN Q 0
 N X1,X2,X,%Y S X2=$P($G(^ABSBITMS(9002302,PCN,4)),U) ; date created
 I 'X2 Q 0 ; impossible
 S X1=DT D ^%DTC
 Q X<9
BILLMENU ; If so, then on the main menu ABSPMENU,
 ; change the ITEM named ABSP BILLING MENU
 ; to ABSP BILLING MENU FOR ILC A/R
 W !,"ILC A/R detected!",!
 W !,"As a result, we now make a change to the correct billing menu.",!
 N MAINMENU S MAINMENU=$$FIND1^DIC(19,,"X","ABSPMENU")
 I 'MAINMENU W !!?10,"Couldn't find ABSPMENU in file 19??",! Q
 N BILLMENU
 S BILLMENU=$$FIND1^DIC(19.01,","_MAINMENU_",","X","ABSP BILLING MENU")
 I 'BILLMENU W !!?10,"Couldn't find ABSP BILLING MENU in ABSPMENU??",! Q
 N FDA,MSG S FDA(19.01,BILLMENU_","_MAINMENU_",",.01)="ABSP BILLING MENU FOR ILC A/R"
 D FILE^DIE("E","FDA","MSG")
 I $D(MSG) D
 . W !!?10,"Failed to change the BILLING MENU item",!
 . D ZWRITE^ABSPOS("FDA","MSG")
 Q
INIT58 ; Make sure there's an entry in file 9002313.58
 I $P(^ABSPECX("S",0),U,3) Q  ; already is one
 N FDA,MSG
 S FDA(9002313.58,"+1,",.01)=1
 D UPDATE^DIE(,"FDA",,"MSG")
 Q
