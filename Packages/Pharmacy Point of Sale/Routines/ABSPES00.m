ABSPES00 ; IHS/FCS/DRS - JWS 03:02 PM 12 Jun 1995 ;  [ 09/12/2002  10:03 AM ]
 ;;1.0;PHARMACY POINT OF SALE;**3**;JUN 21, 2001
 ;----------------------------------------------------------------------
 ;----------------------------------------------------------------------
 ;Claims Submission File (9002313.02) - Billing Item Search
 ;
 ;Parameters:  ROOT     -
 ;             MAX      -
 ;             GROOT    - Global root of resulting list (eg: "^LIST($J")
 ;
 ;Returns:     Fmatted list
 ;----------------------------------------------------------------------
 Q
EN1(ROOT,MAX,GROOT) ;EP - from ABSPECZ2
 ;
 ;Search 'Patient Name' cross-reference
 D BITEM1(ROOT,"C",MAX,GROOT)
 Q:$G(@(GROOT_",0)"))>0
 ;
 ;Search 'Billing Item PCN #' cross-reference
 D BITEM1(ROOT,"D",MAX,GROOT)
 Q:$G(@(GROOT_",0)"))>0
 ;
 ;Search 'Billing Item VCN #' cross-reference
 D BITEM1(ROOT,"E",MAX,GROOT)
 Q
 ;----------------------------------------------------------------------
 ;Build list of Billing Item records
BITEM1(ROOT,XREF,MAX,GROOT) ;
 N ROOTL,NEXT,DA,COUNT,PCN,VCN,PAT,BAL,DATA,BITEMIEN,NCLAIMS
 ;
 Q:$G(ROOT)=""
 Q:$G(XREF)=""
 Q:$G(MAX)=""
 Q:$G(GROOT)=""
 S ROOTL=$L(ROOT)
 Q:ROOTL<2
 ;
 K @(GROOT_")")
 S COUNT=0
 S NEXT=$S(XREF="E"&'($E(ROOT,$L(ROOT))?1A):ROOT_" ",1:ROOT)
 S:$DATA(^ABSPC(XREF,NEXT)) NEXT=$O(^ABSPC(XREF,NEXT),-1)
 F  D  Q:$E(NEXT,1,ROOTL)'=ROOT!(COUNT=MAX)
 .S NEXT=$O(^ABSPC(XREF,NEXT))
 .Q:$E(NEXT,1,ROOTL)'=ROOT
 .S DA=""
 .F  D  Q:'+DA
 ..S DA=$O(^ABSPC(XREF,NEXT,DA))
 ..Q:'+DA
 ..Q:'$DATA(^ABSPC(DA,0))
 ..S BITEMIEN=$P($G(^ABSPC(DA,0)),U,3)
 ..Q:'+BITEMIEN
 ..Q:$DATA(@(GROOT_",""B"",BITEMIEN)"))
 ..S @(GROOT_",""B"",BITEMIEN)")=""
 ..S COUNT=COUNT+1
 ..S @(GROOT_",COUNT,""I"")")=BITEMIEN
 ..S DATA=$G(^ABSPC(DA,1))
 ..S PAT=$$LJBF^ABSPOSU9($P(DATA,U,1),30)
 ..S PCN=$$LJBF^ABSPOSU9($P(DATA,U,2),12)
 ..S VCN=$$LJBF^ABSPOSU9($P(DATA,U,3),10)
 ..S NCLAIMS=$$RJBF^ABSPOSU9($$NCLAIMS(BITEMIEN),7)
 ..S @(GROOT_",COUNT,""E"")")=PAT_"  "_PCN_"  "_VCN_"  "_NCLAIMS
 S @(GROOT_",""Column Headers"")")="2|Patient Name:30,PCN #:12,VCN #:10,# Claims:7"
 S @(GROOT_",0)")=COUNT
 Q
 ;---------------------------------------------------------------------
 ;Returns the number of electronic claims for a billing item record
NCLAIMS(BITEMIEN) ;
 N COUNT,NEXT
 Q:BITEMIEN="" 0
 S (NEXT,COUNT)=0
 F  D  Q:'+NEXT
 .S NEXT=$O(^ABSPC("AC",BITEMIEN,NEXT))
 .Q:'+NEXT
 .S COUNT=COUNT+1
 Q COUNT
