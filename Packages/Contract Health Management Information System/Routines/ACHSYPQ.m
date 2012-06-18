ACHSYPQ ; IHS/ITSC/PMF - SET DOCUMENTS INTO PRINT QUE ;   [ 03/07/2002  10:45 AM ]
 ;;3.1;CONTRACT HEALTH MGMT SYSTEM;**3,19**;JUN 11, 2001
 ;ACHS*3.1*3  change method of getting transaction method
 ;            also, start at the right document
 ;
 ; This utility sets document IENs into the "PQ" x-ref, which is used
 ; for batch printing of documents.
 ;
 ; Kernel variables must be defined.
 ;
 ; You will be asked for the beginning internal entry number.
 ;
 ; The entire file can be x-ref'd using FM x-ref utility, CHS FACILITY
 ; file, DOCUMENT sub-file, TRANSACTION sub-file, TRANSACTION TYPE
 ; field, "PQ" x-ref.
 ;
 ;THIS HAS BEEN RESTRUCTURED AND RE-WRITTEN AS THE ORIGINAL WAS NOT
 ;WORKING
 ;
 ;ACHS*3.1*19 CHANGED THE PROMPT TO REQUEST FY AND DOCUMENT NUMBER AND ENDING DOCUMENT NUMBER
 ;
 S U="^"
 I '$G(DUZ) W !,"DUZ UNDEFINED OR 0." Q
 I '$G(DUZ(2)) W !,"DUZ(2) UNDEFINED OR 0." Q
 D HOME^%ZIS,DT^DICRW
 W @IOF
 W !,"This option will reset PO's to be printed.  You will need to enter the FY "
 W !,"and starting and ending PO number.  Use the print document option to print PO's.",!
START ;
FY ;ENTER FY FOR START OF DOCUMENT RESET
 S ACHSSFY=ACHSCFY-10
 S DIR(0)="N^"_ACHSSFY_":"_ACHSCFY,DIR("A")="Enter the 4 digit FY for starting document"
 S DIR("B")=ACHSCFY
 D ^DIR K DIR
 G:$D(DIRUT) EXT
 G:Y<1 START
 S ACHSEFY=Y
DOC ;ENTER STARTING DOCUMENT NUMBER
 S DIR(0)="N^1:"_$P(^ACHS(9,DUZ(2),"FY",ACHSEFY,"C"),U),DIR("A")="Enter the starting document number"
 D ^DIR K DIR
 G:$D(DIRUT) EXT
 G:Y<1 START
 S ACHSDOCS=Y
EDOC ;ENTER ENDING DOCUMENT NUMBER
 S DIR(0)="N^"_ACHSDOCS_":"_$P(^ACHS(9,DUZ(2),"FY",ACHSEFY,"C"),U),DIR("A")="Enter the ending document number"
 D ^DIR K DIR
 G:$D(DIRUT) EXT
 G:Y<1 START
 S ACHSDOCE=Y
 ;S Y=$$DIR^XBDIR("NO^1:"_$P($G(^ACHSF(DUZ(2),"D",0)),U,3),"ENTER BEGINNING IEN")
 ;Q:$D(DUOUT)!$D(DTOUT)
 ;Q:'Y
 W !
 N C,D,N,P,S,O,T
 ;
 ;S DOCUMENT=0  ;  ACHS*3.1*3
 ;S DOCUMENT=Y-1
BEIN ;FIND BEG EIN
 S DOCUMENT=0
 S ACHSDOC=1_$E(ACHSEFY,4)_"00000"+ACHSDOCS
 S DOCUMENT=$O(^ACHSF(DUZ(2),"D","B",ACHSDOC,DOCUMENT))
 S DOCUMENT=DOCUMENT-1
EEIN ;FIND END EIN
 S LASTEIN=0
 S ACHSDOC=1_$E(ACHSEFY,4)_"00000"+ACHSDOCE
 S LASTEIN=$O(^ACHSF(DUZ(2),"D","B",ACHSDOC,LASTEIN))
 ;
 S O(6)=$P($G(^ACHSF(DUZ(2),2)),U,6)="Y"  ;PRINT CANCEL DOCUMENTS
 S O(7)=$P($G(^ACHSF(DUZ(2),2)),U,7)="Y"  ;PRINT SUPPLEMENTAL DOCUMENTS
 W !
 S DX=$X,DY=$Y,C=0
 ;S LASTIEN=$P($G(^ACHSF(DUZ(2),"D",0)),U,4) ;GET LAST ENTRY # USED
GO ;
 F  S DOCUMENT=$O(^ACHSF(DUZ(2),"D",DOCUMENT)) Q:(DOCUMENT'?1N.N)!(DOCUMENT>LASTEIN)  D
 .;
 .Q:$P(^ACHSF(DUZ(2),"D",DOCUMENT,0),U,27)'=ACHSEFY
 .S TYPESERV=$P($G(^ACHSF(DUZ(2),"D",DOCUMENT,0)),U,4)
 .Q:TYPESERV=""
 .W "."
 .;
 .;S TRANSNUM=$P($G(^ACHSF(DUZ(2),"D",DOCUMENT,"T",0)),U,3)  ;GET LAST TRANSACTION NUMBER USED  ;  ACHS*3.1*3
 .S TRANSNUM=$O(^ACHSF(DUZ(2),"D",DOCUMENT,"T",""),-1) I 'TRANSNUM Q
 .;
 .S TRANTYPE=$P($G(^ACHSF(DUZ(2),"D",DOCUMENT,"T",TRANSNUM,0)),U,2)
 .Q:TRANTYPE'="I"&(TRANTYPE'="C")&(TRANTYPE'="S")
 .Q:TRANTYPE="C"&('O(6))
 .Q:TRANTYPE="S"&('O(7))
 .S ^ACHSF("PQ",DUZ(2),TYPESERV,DOCUMENT,TRANSNUM)=""
 Q
EXT ;
 K ACHSDOCS,ACHSDOCE,ACHSEFY,DOCUMENT,TRANSNUM,TYPESERV,LASTEIN
 ;
