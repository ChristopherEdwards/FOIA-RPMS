BILETVW2 ;IHS/CMI/MWR - VIEW/EDIT FORM LETTERS; MAY 10, 2010
 ;;8.5;IMMUNIZATION;;SEP 01,2011
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  EDIT SECTIONS OF FORM LETTERS.
 ;
 ;
 ;----------
EDITSEC(BINODE) ;EP
 ;---> Edit Section of Form Letter.
 ;---> Parameters:
 ;     1 - BINODE (req) WP Node in BI LETTER entry to edit.
 ;
 ;---> Variables:
 ;     1 - BIIEN  (req) IEN of the BI LETTER entry being edited
 ;                      (selected in ^BILETVW).
 ;
 ;---> Steps:
 ;            1) This entry point is called by the Protocols:
 ;               BI LETTER EDIT TOP/MIDDLE/BOTTOM, actions on the
 ;               List Manager menu protocol: BI MENU LETTER FORM.
 ;
 ;            2) This code calls ^DIWE to allow the user to edit
 ;               those sections of the Form Letter in WP mode.
 ;
 Q:$$LETCHECK($G(BIIEN))
 ;
 ;---> If BINODE not supplied, set Error Code and quit.
 I '$G(BINODE) D ERRCD^BIUTL2(611,,1) D RESET^BILETVW Q
 D:'$D(^BILET(BIIEN,BINODE,0))
 .S ^BILET(BIIEN,BINODE,0)="^^1^1^"_DT,^(1,0)="     Place text here."
 ;
 N DIC S DIC="^BILET("_BIIEN_","_BINODE_","
 D EN^DIWE
 ;
 D RESET^BILETVW
 Q
 ;
 ;
 ;----------
HISTORY ;EP
 ;---> Add/Remove Immunization History to/from a Form Letter.
 ;---> Variables:
 ;     1 - BIIEN  (req) IEN of the BI LETTER entry being edited.
 ;
 ;---> Steps:
 ;            1) This entry point is called by the Protocol:
 ;               BI LETTER HISTORY, an action on the Listmanager
 ;               menu protocol: BI MENU LETTER FORM.
 ;
 Q:$$LETCHECK($G(BIIEN))
 ;
 D FULL^VALM1
 D TITLE^BIUTL5("INCLUDE IMM HISTORY IN LETTER")
 N DIR,DIRUT
 W !!!,"   Include patient's Immunization History in this Form Letter?"
 W ! D HELP1
 S DIR(0)="YOA",DIR("A")="   Enter Yes or No: "
 S DIR("B")=$S(+$P(^BILET(BIIEN,0),U,2):"Yes",1:"No")
 D ^DIR
 I $D(DIRUT) D RESET^BILETVW Q
 ;
 I 'Y S $P(^BILET(BIIEN,0),U,2)=0 D RESET^BILETVW Q
 ;
 K DIR,DIRUT
 W !!!,"   List the Immunization History by Date or by Vaccine,"
 W " with or without",!,"   Lot Numbers?"
 D HELP2
 S DIR(0)="SOM^1:Date;2:Date w/Lot#;3:Vaccine;4:Vaccine w/Lot#"
 S DIR("A")="   Enter a number"
 S DIR("B")=+$P(^BILET(BIIEN,0),U,2) S:DIR("B")=0 DIR("B")=1
 D ^DIR
 I $D(DIRUT) D RESET^BILETVW Q
 S $P(^BILET(BIIEN,0),U,2)=+Y
 K DIR,DIRUT
 ;
 ;---> Next section not used, but preserved in case they want to be
 ;---> able to exclude invalid doses from letter for particular letters.
 ;N DIR,DIRUT
 ;W !!!,"   Include Invalid Doses in this Form Letter?"
 ;W ! D HELP6
 ;S DIR(0)="YOA",DIR("A")="   Enter Yes or No: "
 ;S DIR("B")=$S(+$P(^BILET(BIIEN,0),U,5):"No",1:"Yes")
 ;D ^DIR
 ;I $D(DIRUT) D RESET^BILETVW Q
 ;S $P(^BILET(BIIEN,0),U,5)=+Y
 ;
 D RESET^BILETVW
 Q
 ;
 ;
 ;----------
HELP1 ;EP
 ;;Enter YES to have the patient's Immunization History appear between
 ;;the top and middle sections of the Form Letter.  Enter NO to exclude
 ;;the Immunization History from this Form Letter.
 D HELPTX("HELP1",5)
 Q
 ;
 ;
 ;----------
HELP2 ;EP
 ;;Enter 1 to list the Immunization History in the letter by DATE,
 ;;enter 2 to list the History by DATE with LOT NUMBERS,
 ;;enter 3 to list the History by VACCINE, or
 ;;enter 4 to list the History by VACCINE with LOT NUMBERS.
 D HELPTX("HELP2",5)
 Q
 ;
 ;
 ;----------
HELP6 ;EP
 ;;Enter YES if you would like to have doses that are considered Invalid
 ;;(and their reasons) appear in the list of immunizations on this letter.
 ;;Enter NO to prevent any Invalid Doses from appearing in this letter.
 D HELPTX("HELP6",5)
 Q
 ;
 ;
 ;----------
FORECAST ;EP
 ;---> Add/Remove Immunization Forecast to/from a Form Letter.
 ;---> Variables:
 ;     1 - BIIEN  (req) IEN of the BI LETTER entry being edited.
 ;
 ;---> Steps:
 ;            1) This entry point is called by the Protocol:
 ;               BI LETTER FORECAST, an action on the Listmanager
 ;               menu protocol: BI MENU LETTER FORM.
 ;
 Q:$$LETCHECK($G(BIIEN))
 ;
 N DIR,DIRUT
 W !!!!,"   Include patient's Forecast in this Form Letter?"
 S DIR(0)="YO",DIR("A")="   Enter Yes or No" D HELP3
 D ^DIR
 S:'$D(DIRUT) $P(^BILET(BIIEN,0),U,3)=+Y
 D RESET^BILETVW
 Q
 ;
 ;
 ;----------
HELP3 ;EP
 ;;Enter YES to have the patient's Immunization Forecast appear between
 ;;the middle and bottom sections of the Form Letter.
 D HELPTX("HELP3",5)
 Q
 ;
 ;
 ;----------
DATELOC ;EP
 ;---> Add/Remove Date/Location to/from a Form Letter.
 ;---> Variables:
 ;     1 - BIIEN  (req) IEN of the BI LETTER entry being edited.
 ;
 ;---> Steps:
 ;            1) This entry point is called by the Protocol:
 ;               BI LETTER DATE/LOCATION, an action on the Listmanager
 ;               menu protocol: BI MENU LETTER FORM.
 ;
 Q:$$LETCHECK($G(BIIEN))
 ;
 N DIR,DIRUT
 W !!!!,"   Include Date/Location for appointment in this Form Letter?"
 S DIR(0)="YO",DIR("A")="   Enter Yes or No" D HELP4
 D ^DIR
 S:'$D(DIRUT) $P(^BILET(BIIEN,0),U,4)=+Y
 D RESET^BILETVW
 Q
 ;
 ;
 ;----------
HELP4 ;EP
 ;;Enter YES to have the Date and Location for an appointment appear
 ;;between the bottom and closing sections of the Form Letter.
 D HELPTX("HELP4",5)
 Q
 ;
 ;
 ;----------
PRINTSAM ;EP
 ;---> Print a sample of a Form Letter.
 ;---> Variables:
 ;     1 - BIIEN  (req) IEN of the BI LETTER entry being edited.
 ;
 ;---> Steps:
 ;            1) This entry point is called by the Protocol:
 ;               BI LETTER PRINT SAMPLE, an action on the Listmanager
 ;               menu protocol: BI MENU LETTER FORM.
 ;
 Q:$$LETCHECK($G(BIIEN))
 ;
 ;---> Print sample letters for individual patient.
 D
 .D FULL^VALM1 S BIPOP=0 N BIDFN
 .D TITLE^BIUTL5("PRINT SAMPLE LETTER")
 .D PATLKUP^BIUTL8(.BIDFN)
 .Q:BIDFN<1
 .D ASKDLOC^BILETPR(BIIEN,.BIDLOC,.BIPOP) Q:BIPOP
 .D DEVICE^BILETPR Q:BIPOP
 .D PRINT^BILETPR(BIDFN,BIIEN,$G(BIDLOC),ION)
 .D ^%ZISC
 ;
 D RESET^BILETVW
 Q
 ;
 ;
 ;----------
LETCHECK(BIIEN) ;EP
 ;---> If BIIEN not supplied, set Error Code and quit.
 I '$G(BIIEN) D ERRCD^BIUTL2(609,,1) Q 1
 I '$D(^BILET(BIIEN,0)) D ERRCD^BIUTL2(610,,1) Q 1
 Q 0
 ;
 ;
 ;----------
ADDNEW(BIIEN) ;EP
 ;---> Copy the Generic Sample Letter to this new Form Letter.
 ;---> Parameters:
 ;     1 - BIIEN (req) IEN of Form Letter.
 ;               (ret) BIIEN="" if Sample Form Letter not chosen.
 ;
 I '$G(BIIEN) D ERRCD^BIUTL2(609,,1) Q
 ;
 D TITLE^BIUTL5("ADD A NEW FORM LETTER"),TEXT1
 N BIACT,BISIEN,DIR
 S DIR("A")="     Enter 1, 2, or 3: ",DIR("B")=1
 S DIR(0)="SAM^1:Standard Due Letter;2:Official Immunization Record"
 S DIR(0)=DIR(0)_";3:Standard Due Letter, Forecast First"
 D ^DIR K DIR
 ;---> If user backed out, delete new letter and quit.
 I ($D(DIRUT)!(Y=-1)) D  Q
 .N DA,DIK S DA=BIIEN,DIK="^BILET(" D ^DIK S BIIEN=""
 .W !!?5,"New Form Letter not added."  D DIRZ^BIUTL3()
 ;
 S BISIEN=+Y
 N I
 F I=1:1:4 D
 .Q:'$D(^BILETS(BISIEN,I,0))
 .S ^BILET(BIIEN,I,0)=^BILETS(BISIEN,I,0)
 .N N S N=0
 .F  S N=$O(^BILETS(BISIEN,I,N)) Q:'N  D
 ..S ^BILET(BIIEN,I,N,0)=^BILETS(BISIEN,I,N,0)
 ;
 F I=2,3,4,6 S $P(^BILET(BIIEN,0),U,I)=$P(^BILETS(BISIEN,0),U,I)
 Q
 ;
 ;
 ;----------
TEXT1 ;EP
 ;;You have chosen to add a new Form Letter.
 ;;
 ;;In order to save you time, this program will load a Sample Form
 ;;Letter, which you may then edit to suit the purpose of your new
 ;;Form Letter.
 ;;
 ;;There are two Sample Form Letters to choose from:
 ;;
 ;;   1) Standard Due Letter
 ;;   2) Official Immunization Record
 ;;   3) Standard Due Letter--Forecast First
 ;;
 ;;Please enter 1 to select the Standard Due Letter, 2 to select
 ;;the Official Immunization Record, or 3 to select the Standard Due
 ;;Letter with the Forecast listed first and the History following.
 ;;
 ;
 D PRINTX("TEXT1")
 Q
 ;
 ;
 ;----------
DELETLET ;EP
 ;---> Delete a Form Letter.
 ;---> Variables:
 ;     1 - BIIEN  (req) IEN of the BI LETTER entry being deleted.
 ;
 ;---> Steps:
 ;            1) This entry point is called by the Protocol:
 ;               BI LETTER DELETE, an action on the Listmanager
 ;               menu protocol: BI MENU LETTER FORM.
 ;
 Q:$$LETCHECK($G(BIIEN))
 ;
 N DIR,DIRUT
 W !!!!,"   Are you sure you want to DELETE this entire Form Letter?"
 S DIR(0)="YO",DIR("A")="   Enter Yes or No",DIR("B")="NO" D HELP5
 D ^DIR
 I $D(DIRUT)!('Y) D RESET^BILETVW Q
 ;
 ;---> Delete Form Letter.
 N DA,DIK S DA=BIIEN,DIK="^BILET(" D ^DIK
 ;
 ;---> If a Site Parameter points to this entry, delete it.
 N N S N=0
 F  S N=$O(^BISITE(N)) Q:'N  D
 .S:$P(^BISITE(N,0),U,4)=BIIEN $P(^BISITE(N,0),U,4)=""
 .S:$P(^BISITE(N,0),U,13)=BIIEN $P(^BISITE(N,0),U,13)=""
 ;
 S VALMQUIT="" Q
 Q
 ;
 ;
 ;----------
HELP5 ;EP
 ;;If you enter YES, this Form Letter will be deleted and no longer
 ;;available for editing or sending to patients."
 D HELPTX("HELP5",5)
 Q
 ;
 ;
 ;----------
HELPTX(BILINL,BITAB) ;
 N I,T,X S T="" S:'$D(BITAB) BITAB=5 F I=1:1:BITAB S T=T_" "
 F I=1:1 S X=$T(@BILINL+I) Q:X'[";;"  S DIR("?",I)=T_$P(X,";;",2)
 S DIR("?")=DIR("?",I-1) K DIR("?",I-1)
 Q
 ;
 ;
 ;----------
PRINTX(BILINL,BITAB) ;EP
 Q:$G(BILINL)=""
 N I,T,X S T="" S:'$D(BITAB) BITAB=5 F I=1:1:BITAB S T=T_" "
 F I=1:1 S X=$T(@BILINL+I) Q:X'[";;"  W !,T,$P(X,";;",2)
 Q
