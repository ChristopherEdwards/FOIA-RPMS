AUMP1012 ;IHS/HQ/ABK - AUM PRE INSTALL [ 10/11/2010 12:25 PM ]
 ;;11.0;TABLE MAINTENANCE;**5**;Oct 15,2010
 ;
 ; This is the pre-init for AUM 10.1. It sets all existing education
 ; topics to inactive as long as they are not diagnosis codes with
 ; valid ICD9 cross references.
 ;
 ;
START ;inactivate all codes that are not local codes
 N AUMX,AUMCODE,AUMICD,AUMB
 D ^XBFMK
 S DIE="^AUTTEDT("
 S DR=".03///1"
 S DA=0
 F   S DA=$O(^AUTTEDT(DA)) Q:'DA  S AUMX=$G(^AUTTEDT(DA,0)) D
  .Q:$P(AUMX,U,3)=1
  .S AUMCODE=$P(AUMX,U,6),AUMICD=$P(AUMX,U,4)
  .; 1st quit if EIN to ^ICD9 is valid (piece 4)
  .I AUMICD'="",AUMICD?1N.N Q:$D(^ICD9(AUMICD))
  .; 2nd quit if ICD code to ^ICD9("AB" is valid (piece 6)
  .I AUMCODE'="" Q:$D(^ICD9("AB",AUMCODE))
  .; 3rd quit if "ICD" (Quoted) code to ^ICD9("AB" is valid (piece 6)
  .S AUMB="^ICD9("_""""_"AB"_""""_","_""""_AUMCODE_""""_")"
  .Q:$D(@AUMB)
  .S AUMCODE=$P(AUMX,U,2),AUMCODE=$P(AUMCODE,"-",1)
  .; 4th quit if ICD code to ^ICD9("AB" is valid (piece 1 (-) of piece 2)
  .I AUMCODE'="" Q:$D(^ICD9("AB",AUMCODE))
  .S AUMB="^ICD9("_""""_"AB"_""""_","_""""_AUMCODE_""""_")"
  .; 5th quit if "ICD" (Quoted) code to ^ICD9("AB" is valid (piece 1 (-) of piece 2)
  .Q:$D(@AUMB)
  .; Must be something other than an ICD code - inactivate it
  .D ^DIE
  .I '(DA#100) W "."
  .Q
 ;
 Q
INACT ; Inactivate only one code
 N AUMX,AUMCODE,AUMICD,AUMB
 D ^XBFMK
 S DIE="^AUTTEDT("
 S DR=".03///1"
 S DA=0
 ;F S DA=$O(^AUTTEDT(DA)) Q:'DA S AUMX=$G(^AUTTEDT(DA,0)) D
 S AUMCNAM=$P(AUMXS,U,2),AUMMNE=$P(AUMXS,U,3)
 S DA=$O(^AUTTEDT("B",AUMCNAM,"")),DA2=$O(^AUTTEDT("C",AUMMNE,""))
 S AUMX=$G(^AUTTEDT(DA,0))
 Q:$P(AUMX,U,3)=1
 S AUMCODE=$P(AUMX,U,6),AUMICD=$P(AUMX,U,4)
 ; 1st quit if EIN to ^ICD9 is valid (piece 4)
 I AUMICD'="",AUMICD?1N.N Q:$D(^ICD9(AUMICD))
 ; 2nd quit if ICD code to ^ICD9("AB" is valid (piece 6)
 I AUMCODE'="" Q:$D(^ICD9("AB",AUMCODE))
 ; 3rd quit if "ICD" (Quoted) code to ^ICD9("AB" is valid (piece 6)
 S AUMB="^ICD9("_""""_"AB"_""""_","_""""_AUMCODE_""""_")"
 Q:$D(@AUMB)
 S AUMCODE=$P(AUMX,U,2),AUMCODE=$P(AUMCODE,"-",1)
 ; 4th quit if ICD code to ^ICD9("AB" is valid (piece 1 (-) of piece 2)
 I AUMCODE'="" Q:$D(^ICD9("AB",AUMCODE))
 S AUMB="^ICD9("_""""_"AB"_""""_","_""""_AUMCODE_""""_")"
 ; 5th quit if "ICD" (Quoted) code to ^ICD9("AB" is valid (piece 1 (-) of piece 2)
 Q:$D(@AUMB)
 ; Must be something other than an ICD code - inactivate it
 D ^DIE
 S TOTINACT=TOTINACT+1
 I '(DA#100) W "."
 Q
