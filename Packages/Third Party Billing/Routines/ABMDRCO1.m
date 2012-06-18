ABMDRCO1 ; IHS/ASDST/DMJ - PRINT CO VIST REPORT (CALC) ;
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;Original;TMD;
 ;
INIT ;EP - initialize variables
 S ABMD("CO")=$O(^AUTTBEN("C","03",0)),ABMD("DEP")=$O(^AUTTBEN("C","04",0))
 S ABMD("RET")=$O(^AUTTBEN("C","30",0)),ABMD("RTD")=$O(^AUTTBEN("C","31",0))
 I ABMD("CO")="" W !!,"CODE 03 NOT IN BENEFICIARY FILE"
 I ABMD("DEP")="" W !!,"CODE 04 NOT IN BENEFICIARY FILE"
 I ABMD("RET")="" W !!,"CODE 30 NOT IN BENEFICIARY FILE"
 I ABMD("RTD")="" W !!,"CODE 31 NOT IN BENEFICIARY FILE"
 S ABMD("DEN")=$O(^DIC(40.7,"C",56,0)) ;dental clinic stop code
 S ABMD("RBDT")=(9999999-ABMD("BDT"))_.2400
 Q
 ;
MAIN ;
 I ABMD("CO")]"" S ABMD("II")=ABMD("CO") D CALC
 I ABMD("DEP")]"" S ABMD("II")=ABMD("DEP") D CALC
 I ABMD("RET")]"" S ABMD("II")=ABMD("RET") D CALC
 I ABMD("RTD")]"" S ABMD("II")=ABMD("RTD") D CALC
 Q
 ;
CALC ;find patients and their visits
 S ABMD("DFN")=0
PAT ;must have hrcn at your facility
 S ABMD("DFN")=$O(^AUPNPAT("AD",ABMD("II"),ABMD("DFN"))) Q:ABMD("DFN")=""
 G PAT:'$D(^AUPNPAT(ABMD("DFN"),41,DUZ(2))) S ABMD("HRCN")=$P(^(DUZ(2),0),"^",2)
 G PAT:'$D(^DPT(ABMD("DFN"),0)) S ABMD("NAME")=$P(^(0),"^")
 ;
 S ABMD("REDT")=9999999-ABMD("EDT")-.0001
VST S ABMD("REDT")=$O(^AUPNVSIT("AA",ABMD("DFN"),ABMD("REDT"))) G PAT:ABMD("REDT")="",PAT:ABMD("REDT")>ABMD("RBDT") S ABMD("VDFN")=0
VST1 S ABMD("VDFN")=$O(^AUPNVSIT("AA",ABMD("DFN"),ABMD("REDT"),ABMD("VDFN"))) G VST:ABMD("VDFN")=""
 G VST1:'$D(^AUPNVSIT(ABMD("VDFN"),0)) S ABMD("STR")=^(0)
 G VST1:$P(ABMD("STR"),"^",11)'="" ;screen out deleted visits
 G VST1:$P(ABMD("STR"),"^",6)'=DUZ(2) ;screen out visits at other facilities
 ;
 S ABMD("VDT")=$P(ABMD("STR"),"^"),X=$P(ABMD("STR"),"^",7)
 I (X'="A")&(X'="H")&(X'="S") G VST1
 ;set dental visits
 I $P(ABMD("STR"),"^",8)=ABMD("DEN"),$D(ABMD("TDEN")) S ^TMP("ABMDRCO",ABMD("$J"),"D",ABMD("II"),ABMD("NAME"),ABMD("DFN"),ABMD("VDT"),ABMD("VDFN"))=ABMD("HRCN") G VST1
 ;set outpt node
 I X'="H",$D(ABMD("TOP")) S ^TMP("ABMDRCO",ABMD("$J"),"O",ABMD("II"),ABMD("NAME"),ABMD("DFN"),ABMD("VDT"),ABMD("VDFN"))=ABMD("HRCN") G VST1
 ;set inpt node
 G VST1:'$D(ABMD("TIP")) S ABMD("IDFN")=$O(^AUPNVINP("AD",ABMD("VDFN"),0)) G VST1:ABMD("IDFN")=""
 S ABMD("DSCH")=+^AUPNVINP(ABMD("IDFN"),0)
 S ^TMP("ABMDRCO",ABMD("$J"),"I",ABMD("II"),ABMD("NAME"),ABMD("DFN"),ABMD("VDT"),ABMD("VDFN"))=ABMD("HRCN")_"^"_ABMD("DSCH") G VST1
 Q
