BDGP1001 ;NEW PROGRAM [ 01/06/2005  11:38 AM ]
 ;;5.3;PIMS;**1001**;APR 26, 2002
 ;
POST ; 
 W !,"** CHECKING ENVIRONMENT **",!!
 NEW VER,X
 S VER=$$VERSION^XPDUTL("PIMS")
 I VER'=5.3 D
 . W !,"You must first install PIMS 5.3"
 . I VER["t"!(VER["T") W !,"Your site may have a 'T' version loaded"
 . S XPDQUIT=2
 E  D
 .D UPDTVER   ;Updates the two DPT version nodes
 .D BSDXREF   ;Ensures that the xref AIHSDAM is/was created
 .D ADDPROT   ;Ensures that ALL 14 protocols are included
 Q
 ;
BSDXREF ;Assures that the AIHSDAM xref is/was created in ^SC (file#44)
 ; Some inpatient sites may not have had this xref created during
 ; the initial install of PIMS 5.3
 D AIHSDAM^BSDPOST  ;no check performed in BSDPOST prior to running
 Q
UPDTVER ;Update the appropriate 'version' nodes for DPT.
 ;Using 'DPT' & the "C" Xref (PREFIX) should give you more than one
 ; entry, thus the reason for the $O. The two entries are:
 ; REGISTRATION^DG^ADT   and   PATIENT FILE^DPT^FILE 2
 I $G(VER)]"" D
 .S BDGN=0
 .F  S BDGN=$O(^DIC(9.4,"C","DPT",BDGN)) Q:'BDGN  D
 ..S ^DIC(9.4,BDGN,"VERSION")=VER  ;update current version field
 ..;
 ..; now add version multiple
 ..I '$O(^DIC(9.4,BDGN,22,"B",5.3,0)) D
 ...S DIC="^DIC(9.4,"_BDGN_",22,",DIC(0)="L",X=5.3
 ...S DIC("P")=$P(^DD(9.4,22,0),U,2)
 ...S DIC("DR")="2///"_DT_";3///`"_DUZ,DA(1)=BDGN
 ...D ^DIC
 Q
 ; 
ADDPROT ;This sub-rtn was MOSTLY copied from the original code. The change
 ;  that was made was in the 'F BDGI=1:1:14' it was 1:1:13.
 NEW IEN,ITEM,BDGE
 S BDGE=$O(^ORD(101,"B","BDGPM MOVEMENT EVENTS",0)) I 'BDGE Q
 ;
 F BDGI=1:1:14 S ITEM=$P($T(PROT+BDGI),";;",2) D
 . I $D(^ORD(101,"B",ITEM)) D         ;if protocol exists
 .. S IEN=$O(^ORD(101,"B",ITEM,0)) Q:'IEN
 .. Q:$D(^ORD(101,BDGE,10,"B",IEN))   ;already added to event driver
 .. ;
 .. ; go ahead and add it
 .. S DIC="^ORD(101,"_BDGE_",10,",DIC(0)="L",DLAYGO=101.01
 .. S DA(1)=BDGE,DIC("P")="101.01PA",X=IEN
 .. S DIC("DR")="3///"_$P($T(PROT+BDGI),";;",3)
 .. K DD,DO D FILE^DICN
 K X S X=$$REPEAT^XLFSTR(" ",20)_"Done." D MES^XPDUTL(.X)
 Q
PROT ;; Protocols to add to event driver
 ;;ORU PATIENT MOVMT;;101;;
 ;;ORU AUTOLIST;;105;;
 ;;PSJ OR PAT ADT;;120;;
 ;;GMRADGPM MARK CHART;;210;;
 ;;AQAL ADT EVENT;;150;;
 ;;FHWMAS;;160;;
 ;;SR IHS EVENT-ADMIT;;170;;
 ;;MAGD DHCP-PACS ADT EVENTS;;180;;
 ;;VEFSP PYXIS;;140;;
 ;;AMCO ADT EVENT;;130;;
 ;;BHL ADMIT A PATIENT;;5;;
 ;;BHL TRANSFER A PATIENT;;6;;
 ;;BHL DISCHARGE A PATIENT;;7;;
 ;;BHL PYXIS ADT;;141;;
