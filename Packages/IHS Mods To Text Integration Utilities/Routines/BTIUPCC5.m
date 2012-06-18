BTIUPCC5 ; IHS/CIA/MGH - IHS PCC PERSONAL HEALTH OBJECTS ;25-Jun-2010 09:03;MGH
 ;;1.0;TEXT INTEGRATION UTILITIES;**1005,1006**;NOV 04, 2004
 ;This routine creates objects for the personal health
 ;data entered
 ;Patch 1006 changed the data in the V asthma lookup
 ;==============================================================
INFANT(DFN,TARGET) ;EP
 ; Infant feeding data
 N DATA,ARRAY,FNUM,CNT,RESULT,DATE,ENTRY
 S FNUM=9000010.44,CNT=0,ENTRY=""
 D VFGET^BGOUTL2(.ARRAY,DFN,FNUM,".03;.01;1201")
 F  S ENTRY=$O(@ARRAY@(ENTRY)) Q:+ENTRY'>0  D
 .S CNT=CNT+1
 .S DATA=$G(@ARRAY@(ENTRY))
 .S RESULT=$P($P(DATA,U,4),"|",1)
 .S DATE=$P($P(DATA,U,5),"|",1)
 .I DATE="" S DATE=$P($P(DATA,U,3),"|",1)
 .S @TARGET@(CNT,0)=RESULT_" "_DATE
 I CNT=0 S @TARGET@(1,0)="No infant feeding data on file"
 Q "~@"_$NA(@TARGET)
FUNC(DFN,TARGET) ;EP
 ;Functional assessment
 N DATA,ARRAY,FNUM,CNT,RESULT,DATE,ENTRY
 S FNUM=9000010.35,CNT=0,ENTRY=""
 D VFGET^BGOUTL2(.ARRAY,DFN,FNUM,".03;.04;.05;.06;.07;.08;.09;.11;.12;.13;.14;.15;.16;.17;.18")
 F  S ENTRY=$O(@ARRAY@(ENTRY)) Q:+ENTRY'>0  D
 .S CNT=CNT+1
 .S DATA=$G(@ARRAY@(ENTRY))
 .S DATE=$P($P(DATA,U,3),"|",1)
 .S @TARGET@(CNT,0)="Assessment Date:"_DATE
 .S CNT=CNT+1
 .S @TARGET@(CNT,0)=" Status Change: "_$P($P(DATA,U,16),"|",1)_" Caregiver: "_$P($P(DATA,U,17),"|",1)
 .S CNT=CNT+1
 .S @TARGET@(CNT,0)=" Toileting:  "_$P($P(DATA,U,4),"|",1)_" Finances:     "_$P($P(DATA,U,5),"|",1)
 .S CNT=CNT+1
 .S @TARGET@(CNT,0)=" Bathing:    "_$P($P(DATA,U,5),"|",1)_" Cooking:     "_$P($P(DATA,U,7),"|",1)
 .S CNT=CNT+1
 .S @TARGET@(CNT,0)=" Dressing:   "_$P($P(DATA,U,5),"|",1)_" Shopping:    "_$P($P(DATA,U,5),"|",1)
 .S CNT=CNT+1
 .S @TARGET@(CNT,0)=" Transfers:  "_$P($P(DATA,U,7),"|",1)_" Housework:   "_$P($P(DATA,U,5),"|",1)
 .S CNT=CNT+1
 .S @TARGET@(CNT,0)=" Continence: "_$P($P(DATA,U,8),"|",1)_" Medications: "_$P($P(DATA,U,5),"|",1)
 I CNT=0 S @TARGET@(1,0)="No functional assessment on file"
 Q "~@"_$NA(@TARGET)
BMEA(DFN,TARGET) ;EP
 ;Birth Measurement data
 N DATA,ARRAY,FNUM,CNT,RESULT,DATE,ENTRY,I
 S FNUM=9000024,CNT=0,ENTRY=""
 S DATA=""
 D GET^BGOBMSR(.DATA,DFN)
 I DATA="" S @TARGET@(1,0)="No birth measurement data" Q "~@"_$NA(@TARGET)
 F I=1:1:14 I $P(DATA,U,I)="" S $P(DATA,U,I)="Unknown"
 S CNT=CNT+1
 S @TARGET@(CNT,0)="Birth Weight: "_$P(DATA,U,1)_" lbs "_$P(DATA,U,2)_" oz "_$P(DATA,U,4)_" grams"
 S CNT=CNT+1
 ;S @TARGET@(CNT,0)="Apgar:  "_$P(DATA,U,5)_" 1 MIN "_$P(DATA,U,6)_" 5 MIN"
 ;S CNT=CNT+1
 ;S @TARGET@(CNT,0)="Gestational Age: "_$P(DATA,U,7)_" Del Type: "_$P(DATA,U,8)
 ;S CNT=CNT+1
 ;S @TARGET@(CNT,0)="Complications: "_$P(DATA,U,9)_" Birth Order: "_$P(DATA,U,10)
 ;S CNT=CNT+1
 S @TARGET@(CNT,0)="Formula Started: "_$P(DATA,U,11)_"     Solids Started: "_$P(DATA,U,13)
 S CNT=CNT+1
 S @TARGET@(CNT,0)="Breast Stopped: "_$P(DATA,U,12)
 S CNT=CNT+1
 S @TARGET@(CNT,0)="Mother: "_$P($P(DATA,U,14),"|",1)
 S CNT=CNT+1
 Q "~@"_$NA(@TARGET)
REF(DFN,TARGET,NUM) ;EP
 ;Refusals
 N REFIEN,CNT,TYPE
 S REFIEN="",CNT=0,ARRAY=""
 F  S REFIEN=$O(^AUPNPREF("AC",DFN,REFIEN)) Q:REFIEN=""  D
 .S ARRAY=$$REFGET1^BGOUTL2(REFIEN)
 .S CNT=CNT+1
 .S @TARGET@(CNT,0)=$P(ARRAY,U,6)_" "_$P(ARRAY,U,9)_" "_$P(ARRAY,U,4)_" "_$P(ARRAY,U,11)
 I CNT=0 S @TARGET@(1,0)="No refusals found on file"
 Q "~@"_$NA(@TARGET)
ASTHMA(DFN,TARGET) ;EP
 ;Asthma Data
 N DATA,ARRAY,FNUM,CNT,RESULT,DATE,ENTRY
 S FNUM=9000010.41,CNT=0,ENTRY=""
 D VFGET^BGOUTL2(.ARRAY,DFN,FNUM,".03;.14;.08;.09;.11;")
 F  S ENTRY=$O(@ARRAY@(ENTRY)) Q:+ENTRY'>0  D
 .S CNT=CNT+1
 .S DATA=$G(@ARRAY@(ENTRY))
 .S DATE=$P($P(DATA,U,3),"|",1)
 .S @TARGET@(CNT,0)="Assessment Date: "_DATE
 .S CNT=CNT+1
 .S @TARGET@(CNT,0)=" Asthma Control: "_$P($P(DATA,U,4),"|",1)
 .S CNT=CNT+1
 .;S @TARGET@(CNT,0)=" FEV 1: "_$P($P(DATA,U,5),"|",1)_" FEV 25-75: "_$P($P(DATA,U,6),"|",1)
 .;S CNT=CNT+1
 .;S @TARGET@(CNT,0)=" Particulate Matter: "_$P($P(DATA,U,10),"|",1)_" Dust Mites: "_$P($P(DATA,U,11),"|",1)
 .;S CNT=CNT+1
 .;S @TARGET@(CNT,0)=" Asthma Management Plan: "_$P($P(DATA,U,11),"|",1)
 I CNT=0 S @TARGET@(1,0)="No asthma data on file"
 Q "~@"_$NA(@TARGET)
PAIN(DFN,TARGET) ;EP
 ;Pain Contract
 N DATA,ARRAY,FNUM,CNT,TYPE,DATE,ENTRY,PROVIDER
 S FNUM=9000010.39,CNT=0,ENTRY=""
 D VFGET^BGOUTL2(.ARRAY,DFN,FNUM,".03;.01;.04;.05")
 F  S ENTRY=$O(@ARRAY@(ENTRY)) Q:+ENTRY'>0  D
 .S CNT=CNT+1
 .S DATA=$G(@ARRAY@(ENTRY))
 .S TYPE=$P($P(DATA,U,4),"|",1)
 .S DATE=$P($P(DATA,U,5),"|",1)
 .S PROVIDER=$P($P(DATA,U,6),"|",1)
 .S @TARGET@(CNT,0)="Contract Type: "_TYPE
 .S CNT=CNT+1
 .S @TARGET@(CNT,0)="Date Initiated: "_DATE_" Provider: "_PROVIDER
 I CNT=0 S @TARGET@(1,0)="No pain contract on file"
 Q "~@"_$NA(@TARGET)
ER(DFN,TARGET) ;EP
 ;ER data
 N DATA,ARRAY,FNUM,CNT,RESULT,DATE,ENTRY,X,DEPART,TRANS
 S FNUM=9000010.29,CNT=0,ENTRY=""
 D VFGET^BGOUTL2(.ARRAY,DFN,FNUM,".03;.04;.05;.06;.07;.08;.09;.11;.12;.13;.15;.16")
 F  S ENTRY=$O(@ARRAY@(ENTRY)) Q:+ENTRY'>0  D
 .S CNT=CNT+1
 .S DATA=$G(@ARRAY@(ENTRY))
 .S DATE=$P($P(DATA,U,3),"|",1)
 .S @TARGET@(CNT,0)="ER Date: "_DATE
 .S CNT=CNT+1
 .S X=$P($P(DATA,U,5),"|",2)
 .S @TARGET@(CNT,0)=" Urgency: "_$P($P(DATA,U,4),"|",1)
 .S CNT=CNT+1
 .I X="O" S @TARGET@(CNT,0)=" Means of arrival: "_$P($P(DATA,U,6),"|",1)
 .I X'="O" S @TARGET@(CNT,0)=" Means of arrival: "_$P($P(DATA,U,5),"|",1)
 .S CNT=CNT+1
 .S @TARGET@(CNT,0)=" Entered ER by: "_$P($P(DATA,U,7),"|",1)
 .S CNT=CNT+1
 .S @TARGET@(CNT,0)=" Informant: "_$P($P(DATA,U,8),"|",1)_" Notified: "_$P($P(DATA,U,9),"|",1)
 .S CNT=CNT+1
 .S X=$P($P(DATA,U,10),"|",2)
 .I X'="O" S @TARGET@(CNT,0)=" Disposition of Care: "_$P($P(DATA,U,10),"|",1)
 .I X="O" S @TARGET@(CNT,0)=" Disposition Of Care: "_$P($P(DATA,U,11),"|",1)
 .S CNT=CNT+1
 .S TRANS=""
 .S DEPART=" Departure Date/Time: "_$P($P(DATA,U,12),"|",1)
 .I $P($P(DATA,U,14),"|",1)'="" S TRANS=" Transferred to: "_$P($P(DATA,U,14),"|",1)
 .S @TARGET@(CNT,0)=DEPART_TRANS
 .S CNT=CNT+1
 .S @TARGET@(CNT,0)=" Condition at Departure: "_$P($P(DATA,U,13),"|",1)
 I CNT=0 S @TARGET@(1,0)="No ER visits on file"
 Q "~@"_$NA(@TARGET)
