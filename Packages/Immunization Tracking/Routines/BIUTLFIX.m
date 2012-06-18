BIUTLFIX ;IHS/CMI/MWR - UTIL: FIX STUFF.; MAY 10, 2010
 ;;8.5;IMMUNIZATION;;SEP 01,2011
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  UTILITY: FIXES: LISTMAN HIDDEN MENUS.
 ;;  PATCH 1: UPDATE VACCINE TABLE: ADD "INFLUENZA, 1203" CVX=123
 ;
 ;
 ;----------
LISTMENU ;EP
 ;---> Fix/update Listmanager hidden menus.
 ;---> This will go through all of the BI PROTOCOLS and update
 ;---> any hidden menus.
 ;
 D ^XBKVAR
 D LISTQUIT
 N N S N="BI"
 F  S N=$O(^ORD(101,"B",N)) Q:N=""  Q:N]"BIZZZ"  D
 .Q:N'["HIDDEN"
 .N BIIEN S BIIEN=$O(^ORD(101,"B",N,0))
 .D:BIIEN FIX(BIIEN)
 Q
 ;
 ;
 ;----------
FIX(BIIEN) ;EP
 Q:'BIIEN  Q:'$D(^ORD(101,+BIIEN,0))
 S XQORM=+BIIEN_";ORD(101,"
 D XREF^XQORM
 Q
 ;
 ;
 ;----------
LISTQUIT ;EP
 ;---> Set Quit synonym to "Q" on VALM HIDDEN ACTIONS Protocol.
 ;---> Get IEN of VALM HIDDEN ACTIONS Protocol.
 N BIN S BIN=$O(^ORD(101,"B","VALM HIDDEN ACTIONS",0))
 Q:'BIN
 Q:$P(^ORD(101,BIN,0),U)'="VALM HIDDEN ACTIONS"
 ;
 ;---> Find "VALM QUIT" Item.
 N N S N=0
 F  S N=$O(^ORD(101,BIN,10,N)) Q:'N  D
 .N X,Y
 .S X=$P(^ORD(101,BIN,10,N,0),U)
 .S Y=$P($G(^ORD(101,X,0)),U)
 .Q:Y'="VALM QUIT"
 .S $P(^ORD(101,BIN,10,N,0),U,2)="Q"
 D FIX(BIN)
 Q
 ;
 ;
 ;----------
ONE ;EP
 ;---> Individual Hidden Menu lookup.
 W !!,"Select the Protocol you wish to fix.",!
 D DIC^BIFMAN(101,"QEMA",.Y)
 Q:Y<0
 D FIX(+Y)
 Q
 ;
 ;
 ;----------
BADPATS ;EP
 ;---> Look for BI PATIENTS with no data in ^BIP(BIDFN,0) node.
 ;
 S N=0
 F  S N=$O(^BIP(N)) Q:'N  D
 .W:'$P(^BIP(N,0),"^") !,N,": ",^(0)
 Q
 ;
 ;
 ;----------
ACTIVE ;EP
 ;---> Fix patients whose "Date Inactive" was erroneously converted.
 ;---> 1=Active, 0=Inactive.
 ;
 N BITOTN,BITOTY
 S N=0
 S BITOTN=0,BITOTY=0
 F  S N=$O(^BIP(N)) Q:'N  D
 .I $P(^BIP(N,0),"^",8)=0 S $P(^(0),U,8)=DT S BITOTN=BITOTN+1 Q
 .I $P(^BIP(N,0),"^",8)=1 S $P(^(0),U,8)="" S BITOTY=BITOTY+1
 W !,"NO : ",BITOTN
 W !,"YES: ",BITOTY
 Q
 ;
 ;
 ;----------
BUILD ;EP
 ;---> STEPS TO ADD NEW VACCINE TO VACCINE TABLE/IMMUNIZATION FILE:
 ;
 ;---> 1) Use Fileman to add new vaccine to the BI IMMUNIZATION TABLE
 ;--->    HL7/CVX STANDARD File #9002084.94.
 ;
 ;---> 2) Execute line listed below to update ^BITN routine.
 ;--->         (At programmer prompt, D BUILD^BIUTLFIX ZR  X BIX0.)
 ;
 ;---> 3) Load BITN2 into an editor and trim the entire BITN routine
 ;--->         that gets tacked onto the end of BITN2 during compilation.
 ;
 ;---> 4) Restandardize the Vaccine Table D RESTAND^BIRESTD().
 ;--->                        (Or under Manager Menu do MGR-->RES.)
 ;
 ;---> Build routine ^BITN.
 ;---> Not called by any option or User action.  Used by package
 ;---> programmer to create routine BITN, which in turn is used
 ;---> to build ^BITN global during installation.
 ;---> To use: At programmer prompt, D BUILD^BIUTLFIX ZR  X BIX0.
 ;
 D SETVARS^BIUTL5
 K BIXDT S BIXDT=$$TXDT^BIUTL5(DT)
 S BIX0="N I F I=1:1 Q:'$D(@(""BIX""_I))  X @(""BIX""_I)"
 ;
 ;---> build first routine for nodes <200.
 S BIX1="ZI ""BITN ;IHS/CMI/MWR - BUILD ^BITN GLOBAL."""
 S BIX2="ZI "" ;;8.5;IMMUNIZATION;;""_BIXDT"
 S BIX3="ZI "" ;;* MICHAEL REMILLARD, DDS"
 S BIX3=BIX3_" * CIMARRON MEDICAL INFORMATICS, FOR IHS *"""
 S BIX4="ZI "" ;;  UTILITY: BUILD STANDARD ^BITN GLOBAL."""
 S BIX5="ZI "" ;"","" ;"","" ;----------"",""START ;EP"""
 S BIX6="ZI "" D KGBL^BIUTL8(""""^BITN"""")"""
 S BIX7="ZI "" S ^BITN(0)=""""BI IMMUNIZATION TABLE HL7 STANDARD"
 S BIX7=BIX7_"^9002084.94I"""""""
 ;
 S BIX8="ZI "" N I,X,Y,Z"""
 S BIX9="ZI "" F I=1:2 S X=$T(@""""TABLE""""+I) Q:X'["""";;""""  D"""
 S BIX10="ZI "" .S Y=$P(X,"""";;"""",2),Z=$P(X,"""";;"""",3)"""
 S BIX11="ZI "" .S ^BITN(Y,0)=Z""  ZI "" .S X=$T(@""""TABLE""""+(I+1))"
 S BIX11=BIX11_",Z=$P(X,"""";;"""",3),^BITN(Y,1)=Z"","" ;"""
 ;
 ;---> Next node for future inserts.
 S BIX12=""
 ;
 S BIX13="ZI "" F I=1:2 S X=$T(@""""TABLE""""+I^BITN2) Q:X'["""";;""""  D"""
 S BIX14="ZI "" .S Y=$P(X,"""";;"""",2),Z=$P(X,"""";;"""",3)"""
 S BIX15="ZI "" .S ^BITN(Y,0)=Z""  ZI "" .S X=$T(@""""TABLE""""+(I+1)^BITN2)"
 S BIX15=BIX15_",Z=$P(X,"""";;"""",3),^BITN(Y,1)=Z"","" ;"""
 ;
 S BIX16="ZI "" N DIK S DIK=""""^BITN("""" D IXALL^DIK"""
 S BIX17="ZI "" Q"","" ;"","" ;"","" ;----------"",""TABLE ; EP"""
 S BIX18="N N S N=0 F  S N=$O(^BITN(N)) Q:'N  Q:(N>199)  "
 ;S BIX18="N N S N=0 F  S N=$O(^AUTTIMM(N)) Q:'N  "
 S BIX18=BIX18_"ZI "" ;;""_N_"";;""_^BITN(N,0)"
 S BIX18=BIX18_" ZI "" ;;""_N_""a;;""_^BITN(N,1)"
 S BIX19="ZS BITN ZR  "
 ;
 ;---> Now build second routine for nodes >199.
 S BIX20="ZI ""BITN2 ;IHS/CMI/MWR - BUILD ^BITN GLOBAL SECOND HALF."""
 S BIX21="ZI "" ;;8.5;IMMUNIZATION;;""_BIXDT"
 S BIX22="ZI "" ;;* MICHAEL REMILLARD, DDS"
 S BIX22=BIX22_" * CIMARRON MEDICAL INFORMATICS, FOR IHS *"""
 S BIX23="ZI "" ;;  UTILITY: BUILD STANDARD ^BITN GLOBAL."""
 S BIX24="ZI "" ;"","" ;"","" ;----------"",""TABLE ; EP"""
 S BIX25="N N S N=199 F  S N=$O(^BITN(N)) Q:'N  "
 S BIX25=BIX25_"ZI "" ;;""_N_"";;""_^BITN(N,0)"
 S BIX25=BIX25_" ZI "" ;;""_N_""a;;""_^BITN(N,1)"
 S BIX26="ZI "" Q"""
 S BIX27="ZS BITN2"
 S BIX28="W !,""DONE.  Load and trim BITN2"""
 Q
 ;
 ;
 ;----------
CHGPTR(BICHG) ;EP
 ;---> Change all records with one vaccine pointer to a different one.
 ;---> Parameters:
 ;     1 - BICHG   (opt) IF BICHG=1 then change entries from 214 to 235.
 ;
 D SETVARS^BIUTL5
 D KGBL^BIUTL8("^MIKE") S ^MIKE(0)=^AUPNVIMM(0)
 N BICOUNT,BIECOUNT,BIN S BIN=0,BICOUNT=0,BIECOUNT=0
 F  S BIN=$O(^AUPNVIMM(BIN)) Q:'BIN  D
 .N BIERR S BIERR=0
 .Q:($P(^AUPNVIMM(BIN,0),U)'=214)
 .S BICOUNT=BICOUNT+1
 .Q:('$G(BICHG))
 .S ^MIKE(BIN,0)=^AUPNVIMM(BIN,0)
 .;
 .;---> Change .01 pointer to VAccine Table.
 .N BIFLD S BIFLD(.01)=235
 .D FDIE^BIFMAN(9000010.11,BIN,.BIFLD,.BIERR)
 .I BIERR=1 S BIECOUNT=BIECOUNT+1,^MIKE("ERR",N)=""  Q
 ;
 W !!,"COUNT: ",BICOUNT
 W !,"ERRORS: ",BIECOUNT
 Q
 ;
 ;
 ;----------
CURCOM ;EP
 ;---> Utility to update Patients' Curren Community pointer, piece 17,
 ;---> based on text of Community in piece 18 of ^AUPNPAT(DFN,11).
 ;
 N DFN,TOTAL
 S DFN=0,TOTAL=0,U="^"
 F  S DFN=$O(^AUPNPAT(DFN)) Q:'DFN  D
 .N X,Y
 .Q:'$D(^AUPNPAT(DFN,11))
 .;
 .;---> Quit if piece 17 is already set.
 .Q:$P(^AUPNPAT(DFN,11),U,17)
 .;
 .;---> First try to get Current Community pointer from the last
 .;---> "Community of Residence" Subfield of "Previous Community"
 .;---> (Field .03 of the last/latest 51 subnode).
 .N CC,N S CC="",N=0
 .F  S N=$O(^AUPNPAT(DFN,51,N)) Q:'N  D
 ..S CC=$P($G(^AUPNPAT(DFN,51,N,0)),U,3)
 .;
 .;---> If the last Previous Community is a good pointer, use it & quit.
 .I CC I $D(^AUTTCOM(CC,0)) D  Q
 ..;---> Set the "CURRENT RESIDENCE PTR" Field #1117.
 ..S $P(^AUPNPAT(DFN,11),U,17)=CC
 ..;---> Set the "CURRENT COMMUNITY" Field #1118 (text).
 ..S $P(^AUPNPAT(DFN,11),U,18)=$P(^AUTTCOM(CC,0),U)
 ..S TOTAL=TOTAL+1
 .;
 .;---> If Previous Comm failed, get text of Community from piece 18.
 .S X=$P(^AUPNPAT(DFN,11),U,18)
 .Q:X=""
 .;
 .;---> If text of piece 18 exists in Community file, get IEN and
 .;---> set patient's piece 17=IEN in Community File.
 .D:$D(^AUTTCOM("B",X))
 ..S Y=$O(^AUTTCOM("B",X,0))
 ..;---> Quit if there are other instances of this name.
 ..Q:$O(AUTTCOM("B",X,Y))
 ..;---> Quit if the pointer is bad.
 ..Q:'$D(^AUTTCOM(+Y,0))
 ..S $P(^AUPNPAT(DFN,11),U,17)=Y
 ..S TOTAL=TOTAL+1
 ;
 W !!?5,"Total changed: ",TOTAL,!?5,"Done.",!
 Q
 ;
 ;
 ;----------
BADINACT ; EP
 ;---> Correct any bad Inactive Dates, that were 1 or 0 from earLier
 ;---> version.
 D ^XBKVAR
 N M,N,P
 S M=0,P=0
 S N=0
 F  S N=$O(^BIP(N)) Q:'N  D
 .I $P(^BIP(N,0),"^",8)=1 S $P(^(0),U,8)=2990507 S M=M+1 Q
 .I $P(^BIP(N,0),"^",8)=0 S $P(^(0),U,8)="" S P=P+1 Q
 ;
 W !,"BAD DATES: ",M
 W !,"ZERO ACTIVE: ",P
 Q
 ;
 ;
 ;----------
LOTNUM ;EP
 ;---> Inactivate all Lot Numbers.
 D ^XBKVAR
 N N S N=0
 F  S N=$O(^AUTTIML(N)) Q:'N  D
 .Q:'$D(^AUTTIML(N,0))
 .;---> Do not Inactivate if Exp Date is later than Today.
 .Q:($P(^AUTTIML(N,0),"^",9)>$G(DT))
 .;---> Inactivate this Lot Number.
 .S $P(^AUTTIML(N,0),"^",3)=1
 W !!,"All Lot Numbers have been Inactivated.",!
 Q
