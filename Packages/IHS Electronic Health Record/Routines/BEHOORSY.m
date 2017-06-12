BEHOORSY ; IHS/MSC/MGH Sign or Symptom ;27-Oct-2015 10:28;PLS
 ;;1.1;BEH COMPONENTS;**011006,011007,011008**;Sep 18, 2007;Build 1
 ;
 ;
GETDIAG ; EP
 ; User MUST enter a diagnosis.  No exceptions.
 N DIR,SNOMED,IN,OUT,ITEM,DA,SNO,XSAVE,LINE,LINEVAR,NUM,ICDCODE
 N SNOMED,SNOMEDSC,VARS,VARSDESC,WHICHONE
 ;S Y=0
 ;F  Q:Y  D
 ;. W !!
 ;. D ^XBFMK
 ;. S DIR(0)="F"
 ;. S DIR("A")="Enter Clinical Indication (Free Text)"
 ;. D ^DIR
 ;. I $L(X)<1!(+$G(DIRUT))!(X["^") S Y=9999999 Q
 S XSAVE=X
 K OUT  S OUT="VARS",IN=$G(X)_"^F",$P(IN,"^",6)=100,$P(IN,"^",8)=1,$P(IN,"^",11)=1
 S SNO=$$SEARCH^BSTSAPI(OUT,IN)
 I SNO<1 W !!,?9,"No entries found in the IHS STANDARD TERMINOLOGY database."
 I SNO>0&(SNO'=9999999) D
 .S SNOMED=$$LISTMSEL()
 .S Y=$P(SNOMED,U,1)
 .S X=$P(SNOMED,U,1)
 Q
POST(Y) ;   Set the dialogs
 N SNO
 S SNO=$$DESC^BSTSAPI(Y)
 S ORDIALOG($$PTR("CLININD"),1)=$P(SNO,U,2)
 S ORDIALOG($$PTR("SNMDCNPTID"),1)=$P(SNO,U,1)
 S ORDIALOG($$PTR("CLININD2"),1)=$P($P(SNO,U,3),";")
 Q
CHKDEL(Y) ;EP Check for deletion
 I +Y=0 S ORDIALOG($$PTR("SNMDCNPTID"),1)=""
 Q
 ;
PTR(X) ; -- Ptr to prompt OR GTX X
 Q +$O(^ORD(101.41,"AB","OR GTX "_X,0))
 ;
LISTMSEL() ; EP - LIST Manager to SELect entry
 K SNOMED
 S WHICHONE=0
 D EN^BEHOORSM(1)
 Q $G(SNOMED(WHICHONE))
QUIT ; EP -
 ;
 D CLEAR^VALM1
 K SNOMED,DA
 Q
CHK() ;EP -See what its doing
 I $G(ORDIALOG($$PTR("CLININD"),1))="" D
 .S ORDIALOG($$PTR("SNMDCNPTID"),1)=""
 Q
ID() ;Set CLININD2
 N CLIN,ID
 S CLIND=$$PTR("CLININD2")
 S ID=$G(ORDIALOG(CLIND,1))
 Q ID
QUICK ;Report to find quick orders with clinical indications that are not converted to SNOMED
 N ZTRTN
 W @IOF
 W !,"Unconverted Quick Order to SNOMED clinical indication report",!!
 S ZTRTN="OUT^BEHOORSY"
 D DEVICE
 Q
DEVICE ; Device handling
 ; Call with: ZTRTN
 N %ZIS
 S %ZIS="Q" D ^%ZIS Q:POP
 G:$D(IO("Q")) QUE
NOQUE ; Call report directly
 D @ZTRTN
 Q
QUE ; Queue output
 N %,ZTDTH,ZTIO,ZTSAVE,ZTSK
 Q:'$D(ZTRTN)
 K IO("Q") S ZTSAVE("BGORPT")=""
 S:'$D(ZTDESC) ZTDESC="Unconverted Clinical Indication to SNOMED report" S ZTIO=ION
 D ^%ZTLOAD W !,$S($D(ZTSK):"Request Queued!",1:"Request Cancelled!")
 K ZTSK,ZTDESC,ZTDTH,ZTIO,ZTRTN,ZTSAVE
 D HOME^%ZIS
 Q
OUT ;Run the report
 N I,J,NAME,TYPE,ITEM,CVALUE,SVALUE,CLININD,SNOMED,NAME
 D HDR
 S (CLININD,SNOMED)=""
 S CLININD=$O(^ORD(101.41,"B","OR GTX CLININD",""))
 S SNOMED=$O(^ORD(101.41,"B","OR GTX SNMDCNPTID",""))
 S I=0 F  S I=$O(^ORD(101.41,I)) Q:'+I  D
 .S TYPE=$P($G(^ORD(101.41,I,0)),U,4)
 .Q:TYPE'="Q"
 .S (CVALUE,SVALUE)=""
 .S J=0 F  S J=$O(^ORD(101.41,I,6,J)) Q:'+J  D
 ..S ITEM=$P($G(^ORD(101.41,I,6,J,0)),U,2)
 ..I ITEM=CLININD D
 ...S CVALUE=$G(^ORD(101.41,I,6,J,1))
 ..I ITEM=SNOMED D
 ...S SVALUE=$G(^ORD(101.41,I,6,J,1))
 .I CVALUE'=""&(SVALUE="") D
 ..S NAME=$P($G(^ORD(101.41,I,0)),U,1)
 ..W !,NAME,?40,CVALUE
 Q
HDR(TYP) ;PRINT HEADER
 N LIN,DTYP
 I IOST["C-" W @IOF
 W !,"Unconverted Clinical Indication to SNOMED report",!
 W !,"Order Dialog",?40,"Clinical Indication"
 W ! F LIN=1:1:72 W "-"
 W !
 Q
