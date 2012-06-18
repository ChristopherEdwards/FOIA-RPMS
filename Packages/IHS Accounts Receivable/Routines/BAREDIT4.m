BAREDIT4 ; IHS/SD/LSL - CREATE AN ENTRY IN A/R EDI TRANSPORT FILE (4) ; 
 ;;1.8;IHS ACCOUNTS RECEIVABLE;;OCT 26, 2005
 ;
 ; IHS/SD/LSL - 08/14/2002 - V1.7 Patch 4
 ;     For HIPAA compliance.  Make 835 v4010 entry in A/R EDI
 ;     TRANSPORT FILE.  This routine defines the Sub - elements
 ;     or composite elements.
 ;
 ; ********************************************************************
 Q
 ; ********************************************************************
SUBELM ; EP
 ; Create Sub-element Multiple w/in Element Multiple w/in Segment
 ; Multiple in A/R EDI TRANSPORT
 S BARSECNT=0
 F  D SUBELM2  Q:BARSUBE="END"
 Q
 ; ********************************************************************
SUBELM2 ;
 ; Loop Sub-elements
 S BARSECNT=BARSECNT+1
 S BARSUBE=$P($T(@BARELID+BARSECNT),BARDELIM,2,10)
 Q:BARSUBE="END"
 D SUBELM3
 Q
 ; ********************************************************************
SUBELM3 ;
 ; Create Segment multiple entry in A/R EDI TRANSPORT File
 K DA,DIC,X,Y
 S DA(3)=BAREDITR
 S DA(2)=BARSEGDA
 S DA(1)=BARELDA
 S DIC="^BAREDI(""1T"","_DA(3)_",10,"_DA(2)_",10,"_DA(1)_",10,"
 S DIC(0)="LZ"
 S DIC("P")=$P(^DD(90056.0102,10,0),U,2)
 S X=$P(BARSUBE,BARDELIM)
 S DIC("DR")=".02///^S X=$P(BARSUBE,BARDELIM,2)"
 S DIC("DR")=DIC("DR")_";.03///^S X=$P(BARSUBE,BARDELIM,3)"
 S:$P(BARSUBE,BARDELIM,4)]"" DIC("DR")=DIC("DR")_";.04///^S X=$P(BARSUBE,BARDELIM,4)"
 S:$P(BARSUBE,BARDELIM,5)]"" DIC("DR")=DIC("DR")_";.05///^S X=$P(BARSUBE,BARDELIM,5)"
 S:$P(BARSUBE,BARDELIM,6)]"" DIC("DR")=DIC("DR")_";.06///^S X=$P(BARSUBE,BARDELIM,6)"
 S:$P(BARSUBE,BARDELIM,8)]"" DIC("DR")=DIC("DR")_";.08///^S X=$P(BARSUBE,BARDELIM,8)"
 S:$P(BARSUBE,BARDELIM,9)]"" DIC("DR")=DIC("DR")_";.09///^S X=$P(BARSUBE,BARDELIM,9)"
 K DD,DO
 D FILE^DICN
 Q:+Y<0
 S BARSEDA=+Y
 Q
 ; ********************************************************************
 ; The following is a table of sub-elements per Segment_element.  For
 ; example, if segment SVC element SVC01 is composite, the sub-element
 ; definitions can be found under linetag 231 (seg cnt 23_elem cnt 1)
 ; ********************************************************************
 ;;SUBELEM;;DESC;;SEQ;;DATA TYPE;;MIN;;MAX;;PATH;;PST ELEM;;EDI TBL PTR
 ; ********************************************************************
SVC01 ;;
 ;;SVC01-1;;Product/Service ID Qualifier;;1;;ID;;2;;2;;;;;;31
 ;;SVC01-2;;Product/Service ID;;2;;AN;;1;;48
 ;;SVC01-3;;Procedure Modifier;;3;;AN;;2;;2
 ;;SVC01-4;;Procedure Modifier;;4;;AN;;2;;2
 ;;SVC01-5;;Procedure Modifier;;5;;AN;;2;;2
 ;;SVC01-6;;Procedure Modifier;;6;;AN;;2;;2
 ;;SVC01-7;;Description;;7;;AN;;1;;80
 ;;END
SVC06 ;;
 ;;SVC06-1;;Product/Service ID Qualifier;;1;;ID;;2;;2;;;;;;31
 ;;SVC06-2;;Product/Service ID;;2;;AN;;1;;48
 ;;SVC06-3;;Procedure Modifier;;3;;AN;;2;;2
 ;;SVC06-4;;Procedure Modifier;;4;;AN;;2;;2
 ;;SVC06-5;;Procedure Modifier;;5;;AN;;2;;2
 ;;SVC06-6;;Procedure Modifier;;6;;AN;;2;;2
 ;;SVC06-7;;Description;;7;;AN;;1;;80
 ;;END
PLB03 ;;
 ;;PLB03-1;;Adjustment Reason Code;;1;;ID;;2;;2;;;;;;32
 ;;PLB03-2;;Provider Adjustment Modifier;;2;;AN;;1;;30
 ;;END
PLB05 ;;
 ;;PLB05-1;;Adjustment Reason Code;;1;;ID;;2;;2;;;;;;32
 ;;PLB05-2;;Provider Adjustment Modifier;;2;;AN;;1;;30
 ;;END
PLB07 ;;
 ;;PLB07-1;;Adjustment Reason Code;;1;;ID;;2;;2;;;;;;32
 ;;PLB07-2;;Provider Adjustment Modifier;;2;;AN;;1;;30
 ;;END
PLB09 ;;
 ;;PLB09-1;;Adjustment Reason Code;;1;;ID;;2;;2;;;;;;32
 ;;PLB09-2;;Provider Adjustment Modifier;;2;;AN;;1;;30
 ;;END
PLB11 ;;
 ;;PLB11-1;;Adjustment Reason Code;;1;;ID;;2;;2;;;;;;32
 ;;PLB11-2;;Provider Adjustment Modifier;;2;;AN;;1;;30
 ;;END
PLB13 ;;
 ;;PLB13-1;;Adjustment Reason Code;;1;;ID;;2;;2;;;;;;32
 ;;PLB13-2;;Provider Adjustment Modifier;;2;;AN;;1;;30
 ;;END
