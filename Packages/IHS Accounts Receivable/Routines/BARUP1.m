BARUP1 ; IHS/SD/LSL - 3P UPLOAD CONTINUED DEC 5,1996 ; 
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**1,19,21,23**;OCT 26, 2005
 ;
 ; IHS/ASDS/LSL - 9/11/01 - Version 1.5 Patch 2 - Modified to
 ;     accomodate Pharmacy POS.  Passes RX through to Other Bill
 ;     Identifier field.
 ;
 ; IHS/SD/LSL - 11/27/02 - V1.7 - QAA-1200-130051
 ;     Modified to insert quit logic if error in creating a new
 ;     transaction.  Also inserted documentation.
 ;
 ; IHS/SD/LSL - 06/09/03 - V1.7 Patch 1
 ;      If uploading bill (not created through 3P Claim Approval),
 ;      create BILL NEW transaction with 3P Approval Date and populate
 ;      Message and Text fields of transaction.
 ;
 ; IHS/SD/LSL - 08/21/03 - V1.7 Patch 2 - IM11348
 ;      Allow for checking of existing manually entered bill.  Avoid
 ;      duplicate bills in AR.
 ;
 ; IHS/SD/LSL - 09/10/03 - V1.7 Patch 3 - IM11459
 ;      Resolve creation of multiple bills in AR when print or reprint
 ;      from 3P.
 ;      
 ; IHS/SD/RTL - 04/28/05 - V1.8 Patch 1 - IM17271
 ;      Dupilcate bills
 ;
 ; ********************************************************************
 ;
 ; Global changes for indirection global - ABMA to @BAR3PUP@
 ;
 ;** Upload from 3P BILL file to A/R BILL/IHS file
 ; ---- continuation from ^BARUP
 ;
 ;** This routine is intended to be called from the 3p billing module
 ;   at the time an item is created in the 3P BILL file.
 ;
 ;** Calling this routine at the entry point TPB^BARUP(ABMA ARRAY)
 ;   will create an entry in the A/R BILL/IHS file.
 ;
 ; *********************************************************************
 ;IHS/SD/SDR 10/10/13 HEAT135708
 Q
UPLOAD ; EP
 ; Create a new in A/R Bill File based on 3P data
 I '$D(BAR3PUP) D S3PUP
 D LK2              ; See if bill already exists for this parent in A/R
 I +BARBLDA>0 D
 . D UPDATE
 . I BARXX,$G(^TMP("BAR",$J,"BARUPCHK",$J)) D  Q  ; Already uploaded
 . . S BARACT=$$CMP^BARUPCHK(BARBLDA)
 . . S ^TMP($J,"BARXX")=BARXX
 . D BILLOAD
 I +BARBLDA<1 D ADD  ; Bill not found, try adding it
 I +BARBLDA<1 D NOT   ; Could not find/add bill in A/R
 Q
 ; *********************************************************************
 ;
S3PUP ;set BAR3PUP variable
 S BAR3PUP="^TMP($J,""ABMPASS"")"
 Q
 ; *********************************************************************
 ;
LK2 ;
 ; Try to find the 3PB bill under this parent in A/R
 N BARTMP
 S BARBLDA=-1
 S BARSNM=$P(@BAR3PUP@("BLNM"),"-",1)
 S BARNNM=+BARSNM_" "
 ;F  S BARNNM=$O(^BARBL(DUZ(2),"B",BARNNM)) Q:((+$P(BARNNM,"-")'=+BARSNM)!(BARBLDA>0))  D
 F  S BARNNM=$O(^BARBL(DUZ(2),"B",BARNNM)) Q:(($E(BARNNM,1,$L(+BARSNM))'=(+BARSNM))!(BARBLDA>0))  D    ;IM17271
 . I $P(BARNNM,"-")'=BARSNM Q
 . S BARTMP=0
 . F  S BARTMP=$O(^BARBL(DUZ(2),"B",BARNNM,BARTMP)) Q:('+BARTMP!(BARBLDA>0))  D
 . . Q:$P($G(^BARBL(DUZ(2),BARTMP,0)),U,17)'=@BAR3PUP@("BLDA")  ;3P IEN (DA)
 . . Q:$P($G(^BARBL(DUZ(2),BARTMP,1)),U)'=@BAR3PUP@("PTNM")     ;PATIENT DFN
 . . S BARBLDA=BARTMP
 Q
 ; *********************************************************************
ADD ;
 ; Create entry in A/R Bill file
 S DIC="^BARBL(DUZ(2),"
 S DIC(0)="LX"
 S X=@BAR3PUP@("BLNM")
 S DLAYGO=90050
 K DD,DO
 D FILE^DICN
 K DLAYGO
 I +Y<1 Q
 S BARBLDA=+Y
 ; Tell 3P where A/R put the bill
 S ^TMP($J,"ABMPASS","ARLOC")=DUZ(2)_","_BARBLDA
 D BILLOAD                  ;Add items from 3P to AR
 D SETTX                    ; Create BILL NEW transaction
 Q
 ; *********************************************************************
 ;
NOT ;
 ; Write message
 Q:$D(ZTQUEUED)
 U IO(0)
 W !,@BAR3PUP@("BLNM"),?10,"BILL NOT FOUND NOR ADDED ???"
 U IO
 Q
 ; *********************************************************************
 ;
UPDATE ;EP
 ; Update .01 field of A/R Bill
 K DR
 S DIE="^BARBL(DUZ(2),"
 S DA=BARBLDA
 I @BAR3PUP@("BLNM")'=$P(^BARBL(DUZ(2),DA,0),U) D
 . S DR=".01///"_@BAR3PUP@("BLNM")
 .D ^DIE
 S BARXX=$$GET1^DIQ(90050.01,BARBLDA,13) ;check if previously loaded
 Q
 ; *********************************************************************
 ;
BILLOAD ;EP - called by barupchk
 ; add/reload item from 3P to A/R everytime
 I '$D(BARXX) D
 .I '$D(^TMP($J,"BARXX")) Q
 .I $D(^TMP($J,"BARXX")) D
 . . S BARXX=^TMP($J,"BARXX")
 . . K ^TMP($J,"BARXX")
 I '$D(BAR3PUP) D S3PUP
 I $G(BARXX) D ITMRLOAD Q  ; Previously loaded
 D BILLOAD2  ; Add top level A/R Bill data
 D SETITM
 D SETCOLL  ;IHS/SD/AR 1.8*19 07182010
 Q
 ; *********************************************************************
 ;
ITMRLOAD  ;
 ; Bill previously loaded into A/R, delete old items and create new ones
 D DELITM  ; Delete Items
 D SETITM  ; Create Items
 ; -------------------------------
 ;
 ; Update 3P IEN, 3P DUZ(2), and export date on A/R Bill
 K DA,DIC,DIE,X,Y,DR
 S DA=BARBLDA
 S DIE="^BARBL(DUZ(2),"
 I $L(@BAR3PUP@("BLDA")) D
 . S DR="17////^S X=@BAR3PUP@(""BLDA"")"
 . S DR=DR_";22////^S X=BARDUZ2"
 . I $L(@BAR3PUP@("DTBILL")) S DR=DR_";19////^S X=@BAR3PUP@(""DTBILL"")"
 . S DIE=$$DIC^XBDIQ1(90050.01)
 . D ^DIE
 ; -------------------------------
 ;
 ; Write message
 Q:$E(IOST)'="C"
 Q:IOT'["TRM"
 Q:$D(ZTQUEUED)
 W !,@BAR3PUP@("BLNM")
 W " Previously loaded .. deleting existing A/R Bill items",!
 W !,@BAR3PUP@("BLNM")," Now adding 3P Bill items to A/R Bill",!
 Q
 ; *********************************************************************
 ;
BILLOAD2  ;
 ; Populate top level A/R Bill data
 S @BAR3PUP@("BLAMT")=@BAR3PUP@("BLAMT")*100+.5\1/100
 S @BAR3PUP@("CURTOT")=@BAR3PUP@("BLAMT")-$G(@BAR3PUP@("CREDIT"))
 Q:'$D(BARPAR)
 S DIE="^BARBL(DUZ(2),"
 S DA=BARBLDA
 S DIDEL=90050
 ; -------------------------------
DR01  ;
 ; Populate 1st half zero node
 S DR=""
 S DR=DR_"3////^S X=BARACEIN"
 S DR=DR_";4////^S X=BARBLTYP"
 S DR=DR_";8////^S X=BARPAR"
 S DR=DR_";10////^S X=BARSERV"
 S DR=DR_";11////3PU"
 S DR=DR_";13////^S X=$G(@BAR3PUP@(""BLAMT""))"
 S DR=DR_";15////^S X=$G(@BAR3PUP@(""CURTOT""))"
 S DR=DR_";1001////^S X=$G(@BAR3PUP@(""LICN""))"  ;IHS/SD/TPF BAR*1.8*21 5010 SPECS PAGE 16
 D ^DIE
 ; -------------------------------
DR02  ;
 ; Popolate 2nd half zero node
 S DR=""
 S DR=DR_"16////^S X=BARSTAT"
 S DR=DR_";17///^S X=$G(@BAR3PUP@(""BLDA""))"
 S DR=DR_";18////^S X=@BAR3PUP@(""DTAP"")"
 ;S DR=DR_";18////^S X=@BAR3PUP@(""DTAP"");Q"
 S DR=DR_";19////^S X=@BAR3PUP@(""DTBILL"")"
 S DR=DR_";20///^S X=@BAR3PUP@(""CREDIT"")"
 S DR=DR_";22////^S X=BARDUZ2"
 D ^DIE
 ; -------------------------------
DR11  ;
 ; Populate 1st half one node
 S DR=""
 S DR=DR_"101////^S X=$G(@BAR3PUP@(""PTNM""))"
 S DR=DR_";102////^S X=$G(@BAR3PUP@(""DOSB""))"
 S DR=DR_";103////^S X=$G(@BAR3PUP@(""DOSE""))"
 S DR=DR_";105////^S X=BARSSN"
 S DR=DR_";106////^S X=BARPTYP"
 S DR=DR_";107////^S X=BARHRN"
 D ^DIE
 ; -------------------------------
DR12  ;
 ; Populate 2nd half one node
 S DR=""
 S DR=DR_"108////^S X=BARSAT"
 S DR=DR_";112////^S X=$G(@BAR3PUP@(""CLNC""))"
 S DR=DR_";113////^S X=BARPRV"
 S DR=DR_";114////^S X=$G(@BAR3PUP@(""VSTP""))"
 S DR=DR_";115////^S X=BARPBEN"
 D ^DIE
 ; -------------------------------
DR278  ;
 ; Popolate two, seven, and eight nodes
 S DR=""
 S DR=DR_"205////^S X=BARTMP1(205)"
 S DR=DR_";206////^S X=BARTMP1(206)"
 S DR=DR_";207////^S X=BARTMP1(207)"
 S DR=DR_";702///^S X=@BAR3PUP@(""POLN"")"
 S DR=DR_";701///^S X=@BAR3PUP@(""POLH"")"
 I $G(@BAR3PUP@("OTHIDENT")) S DR=DR_";801////^S X=@BAR3PUP@(""OTHIDENT"")"
 D ^DIE
 K DIDEL
 Q
 ; ********************************************************************
 ;
SETITM  ;EP
 ; Create ITEM multiple for A/R Bill
 N BARCNT,DR,DA,DIC,J,I
 I '$D(BAR3PUP) D S3PUP
 S DA(1)=BARBLDA
 S DIC="^BARBL(DUZ(2),"_DA(1)_",3,"
 S DIC(0)="LX"
 S DIC("P")=$P(^DD(90050.01,301,0),U,2)
 S DIC("DR")=""
 ;F I=1:1 S J=$T(TXT+I) Q:J=""  S $P(DIC("DR"),";",I)=$P(J,"~",2)
 ;IHS/SD/TPF FIX ERROR IN CODE WHEN MSGTXT WAS ADDED IN PATCH 19
 ;ALSO ADDED ;;END TO END OF TXT TAG BAR*1.8*21
 F I=1:1 S J=$T(TXT+I) Q:J[("END")  S $P(DIC("DR"),";",I)=$P(J,"~",2)
 S BARCNT=0
 F  S BARCNT=$O(@BAR3PUP@(BARCNT)) Q:'+BARCNT  D
 .S X=$G(@BAR3PUP@(BARCNT,"ITNM"))
 .I '$L(X),$G(@BAR3PUP@(BARCNT,"BLSRV"))="REVENUE CODE" S (X,@BAR3PUP@(BARCNT,"ITNM"))="REVENUE CODE"
 .Q:'$L(X)
 .S X=""""_X_""""
 .S @BAR3PUP@(BARCNT,"DOS")=$S(@BAR3PUP@(BARCNT,"DOS"):@BAR3PUP@(BARCNT,"DOS"),1:@BAR3PUP@("DOSB"))
 .S Y=$G(@BAR3PUP@(BARCNT,"BLSRV"))
 .S BARBLSRV=89            ; Default
 .S:Y="PHARMARCY" BARBLSRV=83
 .S:Y="ROOM & BOARD" BARBLSRV=84
 .S:Y="REVENUE CODE" BARBLSRV=84
 .S:Y="MED/SURG PROCEDURE" BARBLSRV=82
 .S:Y="MEDICAL PROCEDURES" BARBLSRV=85
 .S:Y="DENTAL" BARBLSRV=86
 .S:Y="RADIOLOGY" BARBLSRV=87
 .S:Y="LABORATORY" BARBLSRV=91
 .S:Y="ANESTHESIA" BARBLSRV=88
 .K DD,DO
 .D FILE^DICN
 .K BARBLSRV
 K DLAYGO
 Q
 ; ********************************************************************
SETCOLL  ;EP
 ; Create COLLECTION STATUS multiple for A/R Bill
 N DR,DA,DIC,J,I
 S DA(1)=BARBLDA
 S DIC="^BARBL(DUZ(2),"_DA(1)_",9,"
 S DIC(0)="LX"
 S DIC("P")=$P(^DD(90050.01,901,0),U,2)
 S DIC("DR")=""
 S X=$G(@BAR3PUP@("DTAP"))_U_$G(@BAR3PUP@("BLAMT"))_U_"INITIAL BILL"_U_"0"
 K DD,DO
 D FILE^DICN
 K DLAYGO
 Q
 ; ********************************************************************
DELITM  ;EP - For the reload of an A/R Bill from the 3P Bill,
 ;deleting all existing items 
 N DIK,DA
 S DA(1)=BARBLDA
 S DA=0
 S DIK=$$DIC^XBDIQ1(90050.01)
 S DIK=DIK_DA(1)_",3,"
 F  S DA=$O(^BARBL(DUZ(2),DA(1),"3",DA)) Q:'+DA  D ^DIK
 Q
 ; ********************************************************************
 ;
SETTX   ;** create transaction
 K DR
 N DIC
 S BARTT=$O(^BARTBL("B","BILL NEW",""))
 I '+BARTT D NOTX(BARBLDA,"BILL NEW")
 I +BARTT D
 . S DR="3////^S X=@BAR3PUP@(""BLAMT"")"
 . D NEWTX
 I @BAR3PUP@("CREDIT") D
 . S BARTT=$O(^BARTBL("B","3P CREDIT",""))
 . I '+BARTT D NOTX(BARBLDA,"3P CREDIT")
 . I +BARTT D
 . . S DR="2////^S X=$G(@BAR3PUP@(""CREDIT""))"
 . . D NEWTX
 Q
 ; *********************************************************************
 ;
NEWTX  ;
 ; Create A/R transaction
 S BARTRIEN=$$NEW^BARTR()
 ;I BARTRIEN<1 D NOTX(BARBLDA,BARTT) Q  ;IHS/SD/SDR 10/10/13 HEAT135708
 I BARTRIEN<1 D NOTX(BARBLDA,"") Q  ;IHS/SD/SDR 10/10/13 HEAT135708
 S DIE="^BARTR(DUZ(2),"
 S DA=BARTRIEN
 S DR=DR_";4////^S X=BARBLDA"
 S DR=DR_";5////^S X=@BAR3PUP@(""PTNM"")"
 S DR=DR_";6////^S X=BARACEIN"
 S DR=DR_";8////^S X=BARPAR"
 S DR=DR_";10////^S X=BARSERV"
 S DR=DR_";11////^S X=BARSAT"
 S DR=DR_";12////^S X=$P(BARTRIEN,""."")"
 S DR=DR_";101////^S X=BARTT"
 I $P($G(BAROPT)," ")="Upload" D
 . S DR=DR_";7////^S X=1"
 . S DR=DR_";1001///^S X=BAROPT_"" ""_DT"
 S DIDEL=90050
 D ^DIE
 K DIDEL
 D TR^BARTDO(BARTRIEN)                    ; Update other files
 Q
 ; *********************************************************************
 ;
NOTX(X,BARTYP)  ;
 ; Couldn't create transaction.
 N XVAL
 I BARTYP="" S BARTYP="<UNK MSG>" ; P.OTT
 S XVAL=$$GET1^DIQ(900501.01,X,.01)
 W *7,$$CJ^XLFSTR("Could not create a "_BARTYP_" transaction.",IOM)
 W $$CJ^XLFSTR("Please contact IT support.",IOM)
 Q
 ; ********************************************************************
 ;
 ; This is a new section to build the DIC("DR") string
 ;BAR/SD/TPF BAR*1.8*21 ADDED LICN FOR 5010 SPEC PAGE 16
TXT  ;
 ;;~2////^S X=$G(@BAR3PUP@(BARCNT,"DOS"))
 ;;~3////^S X=$G(@BAR3PUP@(BARCNT,"ITCODE"))
 ;;~4////^S X=$G(@BAR3PUP@(BARCNT,"OTIT"))
 ;;~5////^S X=$G(@BAR3PUP@(BARCNT,"OTUC"))
 ;;~6////^S X=$G(BARBLSRV)
 ;;~7////^S X=$G(@BAR3PUP@(BARCNT,"ITQT"))
 ;;~8////^S X=$G(@BAR3PUP@(BARCNT,"ITUI"))
 ;;~9////^S X=$G(@BAR3PUP@(BARCNT,"ITUC"))
 ;;~11////^S X=$G(BARCNT)
 ;;~12////^S X=$G(@BAR3PUP@(BARCNT,"LICN"))
 ;;~Q;10////^S X=$G(@BAR3PUP@(BARCNT,"ITTOT"))
 ;;END
 ;IHS/SD/AR BAR*1.8*19 06.17.2010
MSGTX  ;
 ; Create A/R message transaction
 N BARSCODE,BARGCN,BARSAT,BARCKEX,BARDATE
 S BARGCN=$G(@BAR3PUP@(74,BARMIEN,"GCN"))
 S BARSAT=$G(@BAR3PUP@("VSLC"))
 S BARSCODE=$G(@BAR3PUP@(74,BARMIEN,"STAT"))
 S BARUSER=$G(@BAR3PUP@(74,BARMIEN,"USR"))
 S BARDATE=$G(@BAR3PUP@(74,BARMIEN,"DT"))
 S BARRSN=$S($D(@BAR3PUP@(74,BARMIEN,"RSN")):@BAR3PUP@(74,BARMIEN,"RSN"),1:"NO MESSAGE")
 D CKEXIST
 Q:$G(BARCKEX)=1
 D STATCODE
 S BARTRIEN=$$NEW^BARTR()
 I BARTRIEN<1 D NOTX(BARBLDA,BARTT) Q
 S DIE="^BARTR(DUZ(2),"
 S DA=BARTRIEN
 S DR=DR_";7////^S X=1"
 S DR=DR_";4////^S X=BARBLDA"
 S DR=DR_";10////^S X=""BUSINESS OFFICE"""
 S DR=DR_";11////^S X=BARSAT"
 S DR=DR_";12////^S X=$P(BARTRIEN,""."")"
 S DR=DR_";13////^S X=BARUSER"
 S DR=DR_";16////^S X=""PRIMARY"""
 S Y=BARTRIEN X ^DD("DD")
 K ^TMP($J,"WP")
 S ^TMP($J,"WP",1)=BARSCODE_" ON "_BARDATE_", GCN: "_BARGCN
 S ^TMP($J,"WP",2)="REASON: "_BARRSN
 S DIDEL=90050
 D ^DIE
 K DIDEL
 D WP^DIE(90050.03,BARTRIEN_",",1001,"","^TMP($J,""WP"")")
 K ^TMP($J,"WP")
 D TR^BARTDO(BARTRIEN)                    ; Update other files
 Q
 ; *********************************************************************
 ;
STATCODE  ;
 ; TRANSLATE STATUS CODE TO VALUE
 S:BARSCODE="O" BARSCODE="ORIGINAL"
 S:BARSCODE="S" BARSCODE="RESENT"
 S:BARSCODE="F" BARSCODE="REFILE"
 S:BARSCODE="C" BARSCODE="RECREATED"
 Q
RSTATCOD  ;
 ; TRANSLATE STATUS CODE TO VALUE
 S:BARSCODE="ORIGINAL" BARSCODE="O"
 S:BARSCODE="RESENT" BARSCODE="S"
 S:BARSCODE="REFILE" BARSCODE="F"
 S:BARSCODE="RECREATED" BARSCODE="C"
 Q
CKEXIST  ;
 ; LOOK FOR EXISTING ENTRIES
 N BARWP,BARWP2
 S BARWP="",BARCKEX=0,BARTRIEN=0,BARWP2=""
 F  S BARTRIEN=$O(^BARTR(DUZ(2),"AM4",BARBLDA,BARTRIEN)) Q:('+BARTRIEN)!(BARCKEX)  D
 . S BARWP=$$GET1^DIQ(90050.03,BARTRIEN,1001,,"BARWP")
 . S:$D(BARWP(1))&($G(BARWP(1))["GCN") BARWP2=$P(BARWP(1)," ",5)
 . S:$D(BARWP2)&(BARWP2?1.N)&(BARWP2=BARGCN) BARCKEX=1
 Q
