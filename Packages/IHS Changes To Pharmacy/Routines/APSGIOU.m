APSGIOU ;IHS/ITSC/ENM - STUFF IOU IN DRUG FILE [ 01/14/2002  10:42 AM ]
 ;;3.2;INPATIENT MEDICATIONS;**3**;12/28/01
 D CREATE
 D EXREF
 W !,".......Done!",!
 Q
CREATE ;Create Application Package Use settings for each local drug
 S IFN=0
 W !,"One Moment Please!  I need to create 'Application Package Use' settings for all of your local drugs.....",!
 H 4
 F  S IFN=$O(^PSDRUG(IFN)) Q:'IFN  D P1
 W !,"Done!",!
 Q
P1 ;
 S APSID=$G(^PSDRUG(IFN,"I")) ;INACTIVE DRUG CHECK
 Q:+APSID
 S $P(^PSDRUG(IFN,2),"^",3)="IOU",^PSDRUG("IU","IOU",IFN)=""
 Q
EXREF ;
 ;NEXT LINE WILL REINDEX THE 'IU and AIU' XREF's ON FLD 63 IN FILE 50
 W !,"Re-indexing the 'IU', 'AIUI', 'AIUO' and 'AIUU' cross-references",!,"in your Drug File...",!
 K ^PSDRUG("IU"),^PSDRUG("AIUI"),^PSDRUG("AIUO"),^PSDRUG("AIUU")
 S DIK="^PSDRUG(",DIK(1)="63^IU^AIU" D ENALL^DIK K DIK
 W !,?20,"Re-Indexing Done!",!
 Q
LIST ;LIST LOCAL DRUGS WITH IOU IN 'IU' XREF
 S IFN=0,CT=1
 F  S IFN=$O(^PSDRUG("IU","OI",IFN))  Q:'IFN  S DNAME=$P(^PSDRUG(IFN,0),"^",1) D CK
 Q
CK S ND=$G(^PSDRUG(IFN,"ND"))
 I ND]"" S NDFIRN=+$P(^("ND"),"^",1),NDNAM=$P(^PSNDF(NDFIRN,0),"^")
 I ND]"" W !,CT,?5,IFN,?15,NDNAM S CT=CT+1
 Q
