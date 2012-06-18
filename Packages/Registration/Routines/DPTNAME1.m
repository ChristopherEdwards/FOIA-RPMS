DPTNAME1 ;BPOIFO/KEITH - NAME STANDARDIZATION ; 12 Aug 2002@20:20
 ;;5.3;Registration;**244**;Aug 13, 1993
 ;
NCEVAL(DGC,DGX) ;Evaluate name component entry values
 ;Input: DGC=name component (e.g. FAMILY, GIVEN, etc.)
 ;       DGX=input value for name
 ;
 Q:DGX="@"
 N DGM,DGL,DGI
 I DGX=""!($E(DGX)=U) Q
 D CVALID(DGC,DGX,.DGM)
 M DIR("?")=DGM("HELP") S DGI=$O(DIR("?",""),-1) I DGI D
 .S DIR("?")=DIR("?",DGI) K DIR("?",DGI)
 .Q
 I "???"[DGX Q
 I DGM("RESULT")="" D  Q
 .S DGI="" F  S DGI=$O(DGM("ERROR",DGI)) Q:DGI=""  D
 ..I DGM("ERROR",DGI)["''" S $P(DGM("ERROR",DGI),"'",2)=DGX
 ..W:DGI=1 ! W !,DGM("ERROR",DGI)
 ..Q
 .K DGX
 .Q
 I DGM("RESULT")'=DGX W "   (",DGM("RESULT"),")"
 S DGX=DGM("RESULT")
 Q
 ;
FAMILY ;Family name help text
 S DGM("LENGTH")="1-35"
 D HTEXT("family (last) name.",DGM("LENGTH"))
 S DGM("HELP",4)="Input values less than 3 characters in length must be all alpha characters."
 Q
 ;
GIVEN ;Given name help text
 S DGM("LENGTH")="1-25"
 D HTEXT("given (first) name.",DGM("LENGTH"))
 Q
 ;
MIDDLE ;Middle name help text
 S DGM("LENGTH")="1-25"
 D HTEXT("middle name.",DGM("LENGTH"))
 S DGM("HELP",4)="Middle names of 'NMI' and 'NMN' are prohibited."
 Q
 ;
PREFIX ;Name prefix help text
 S DGM("LENGTH")="1-10"
 D HTEXT("name prefix, such as MR or MS.",DGM("LENGTH"))
 Q
 ;
SUFFIX ;Name suffix help text
 S DGM("LENGTH")="1-10"
 D HTEXT("suffix(es), such as JR, SR, II, or II.",DGM("LENGTH"))
 Q
 ;
DEGREE ;Name degree help text
 S DGM("LENGTH")="1-10"
 D HTEXT("academic degree, such as BS, BA, MD, or PHD.",DGM("LENGTH"))
 Q
 ;
HTEXT(DGF,DGL) ;Generic help text
 ;Input: DGF=field name
 ;       DGL=field length
 S DGM("HELP",1)="Answer with this persons "_DGF
 S DGM("HELP",2)="The response must be "_DGL_" characters in length and may only contain"
 S DGM("HELP",3)="uppercase alpha characters, spaces, hyphens and apostrophes."
 Q
 ;
CVALID(DGC,DGX,DGM) ;Name component validation
 ; Input: DGC=name component (e.g. FAMILY, GIVEN, etc.)
 ;        DGX=input value to validate
 ;        DGM=array to return results and errors (pass by reference)
 ;
 ;Output: DGM array in the format:
 ;       DGM("ERROR",n)=error text (if any) 
 ;       DGM("HELP",n)=help text          
 ;       DGM("LENGTH")=field length in length (e.g. 3-30) 
 ;       DGM("RESULT")=transformed name value (null if invalid entry)
 ; 
 N DGL,DGF,DGI,DGR,DGMSG
 S DGF="FAMILY^GIVEN^MIDDLE^PREFIX^SUFFIX^DEGREE"
 S DGF=$P(DGF,DGC),DGF=$L(DGF,U)
 D @DGC  ;Set up length and help text 
 S DGL=+$P(DGM("LENGTH"),"-")_U_+$P(DGM("LENGTH"),"-",2)
 ;Transform suffixes
 I DGC="SUFFIX" S DGX=$$CLEANC^XLFNAME(DGX)
 ;Clean/format input value 
 S DGX=$$FORMAT^DPTNAME(DGX,$P(DGL,U),$P(DGL,U,2),,3,,1,1)
 ;Validate against file 20 
 D CHK^DIE(20,DGF,"E",DGX,.DGR,"DGMSG")
 I $D(DGMSG("DIERR","E",701)) D
 .S DGI=$O(DGMSG("DIERR","E",701,""))
 .M DGM("ERROR")=DGMSG("DIERR",DGI,"TEXT")
 .Q
 S DGM("RESULT")=$S(DGR=U:"",1:DGR)
 Q
 ;
JUMP(DGI) ;Evaluate request to jump fields
 N DGX,DGY S DGX=$P($E(X,2,99)," ")
 I (U_DGCOM)'[(U_DGX) D  Q
 .W !,"While editing name components, only jumping to other components is allowed!",$C(7)
 .Q
 I (U_DGCOM_U)[(U_DGX_U) S DGI=$O(DGC(DGX,0)) Q
 S DGI=$O(DGC($O(DGC(DGX)),0))
 S DGY=$P(DGCOM,U,DGI)_$P(DGCX,U,DGI) W $P(DGY,DGX,2)
 Q
 ;
NOTES() ;Produce value for the file #20 NOTES ABOUT NAME field
 ;Output: string representing when, who and how editing occurred
 ;
 N DGWHEN,DGWHO,DGHOW
 S DGWHEN=$$FMTE^XLFDT($$NOW^XLFDT())
 S DGWHO=$S($G(DUZ)>0:$$GET1^DIQ(200,DUZ_",",.01),1:"Unknown")
 S DGWHO=DGWHO_" ("_$G(DUZ)_")"
 S DGHOW=$P($G(XQY0),U)
 Q "Edited: "_DGWHEN_" By: "_DGWHO_" With: "_DGHOW
 ;
COMP(DGX,DGDNC) ;Use existing name array
 ;Input: DGX=name array (pass by reference)
 ;     DGDNC='do not componentize' flag (pass by reference)
 ;
 N DGY,DGI,DGZ
 Q:$D(DGX)<10  Q:DGDNC=0
 S DGDNC=1,DGY="FAMILY^GIVEN^MIDDLE^PREFIX^SUFFIX^DEGREE"
 F DGI=1:1:6 S DGZ=$P(DGY,U,DGI) S:'$D(DGX(DGZ)) DGX(DGZ)=""
 Q
 ;
F1(DGX,DGCOMA)  ;Transform text value
 ;Input: DGX=text value to transform (pass by reference)
 ;    DGCOMA=comma indicator
 ;Output: 1 if changed, 0 otherwise
 ;
 N DGI,DGII,DGC,DGY,DGZ,DGOLDX S DGOLDX=DGX
 ;Transform accent grave to apostrophe
 S DGX=$TR(DGX,"`","'")
 ;Transform single characters
 F DGI=1:1:$L(DGX) S DGC=$E(DGX,DGI) D:$$FC1(.DGC,DGCOMA)
 .S DGX=$E(DGX,0,DGI-1)_DGC_$E(DGX,DGI+1,999)
 .Q
 ;Transform double character combinations
 S DGY="  ^--^,,^''^,-^,'^ ,^-,^',^ -^ '^- ^' ^-'^'-"
 S DGZ=" ^-^,^'^,^,^,^,^,^ ^ ^ ^ ^-^-"
 F DGI=1:1 S DGC=$P(DGY,U,DGI) Q:DGC=""  D
 .Q:DGX'[DGC
 .F DGII=1:1:$L(DGX,DGC)-1 D
 ..S DGX=$P(DGX,DGC,0,DGII)_$P(DGZ,U,DGI)_$P(DGX,DGC,DGII+1,999)
 ..Q
 .Q
 ;Remove NMI and NMN
 F DGY="NMI","NMN" I DGX[DGY,DGCOMA=3 D
 .S DGC=$F(DGX,DGY)
 .I " ,"[$E(DGX,(DGC-4))," ,"[$E(DGX,DGC) D
 ..S DGX=$E(DGX,0,(DGC-4))_$E(DGX,(DGC),999)
 ..F DGY="  ",",," I DGX[DGY D
 ...S DGC=$F(DGX,DGY) S DGX=$E(DGX,0,(DGC-3))_$E(DGX,(DGC-1),999) Q
 ..F DGZ=" ","," F DGC=1,$L(DGX) D
 ...I $E(DGX,DGC)=DGZ S DGX=$E(DGX,0,(DGC-1))_$E(DGX,(DGC+1),999) Q
 ..Q
 .Q
 ;Clean up numerics
 I DGX?.E1N.E D
 .S DGY="1ST^2ND^3RD^4TH^5TH^6TH^7TH^8TH^9TH"
 .F DGI=1:1:$L(DGX) S DGC=$E(DGX,DGI) D:DGC?1N
 ..I DGC," ,"[$E(DGX,DGI-1),$E(DGX,DGI,DGI+2)=$P(DGY,U,DGC)," ,"[$E(DGX,DGI+3) Q
 ..I DGC=1," ,"[$E(DGX,DGI-1),$E(DGX,DGI,DGI+3)="10TH"," ,"[$E(DGX,DGI+4) S DGI=DGI+1 Q
 ..S DGX=$E(DGX,0,DGI-1)_$E(DGX,DGI+1,999)
 ..Q
 .Q
 ;Check for dangling apostrophes
 I DGX["'" F DGI=1:1:$L(DGX) S DGC=$E(DGX,DGI) D:DGC?1"'"
 .I $E(DGX,(DGI-1))?1U,$E(DGX,(DGI+1))?1U Q
 .S DGX=$E(DGX,0,(DGI-1))_$E(DGX,(DGI+1),99),DGI=1
 .Q
 ;Remove parenthetical text from name value
 N DGCH S DGOLDX(2)=DGX,DGCH=1 F  Q:'DGCH  D
 .S DGCH=0,DGOLDX(1)=DGX,DGY="()[]{}" D
 ..F DGI=1,3,5 S DGC(1)=$E(DGY,DGI),DGC(2)=$E(DGY,DGI+1) D
 ...S DGZ(1)=$$CLAST(DGX,DGC(1)) Q:'DGZ(1)  S DGZ(2)=$F(DGX,DGC(2),DGZ(1))
 ...I DGZ(2)>DGZ(1) S DGX=$E(DGX,0,(DGZ(1)-2))_$E(DGX,DGZ(2),999)
 ...S DGCH=(DGX'=DGOLDX(1)) Q
 ..Q
 .Q
 S:DGX'=DGOLDX(2) DGAUDIT(2)=""
 F DGI=1:1:6 S DGC=$E(DGY,DGI) D
 .F  Q:DGX'[DGC  S DGX=$P(DGX,DGC)_$P(DGX,DGC,2,999)
 .Q
 ;Insure value begins and ends with an alpha character
 F  Q:'$L(DGX)!($E(DGX,1)?1A)  S DGX=$E(DGX,2,999)
 F  Q:'$L(DGX)!($E(DGX,$L(DGX))?1A)  Q:($L(DGX,",")=2)&($E(DGX,$L(DGX))=",")  S DGX=$E(DGX,1,($L(DGX)-1))
 Q DGX'=DGOLDX
 ;
CLAST(DGX,DGC) ;Find last instance of character
 N DGY,DGZ
 S DGZ=$F(DGX,DGC) Q:'DGZ DGZ
 F  S DGY=$F(DGX,DGC,DGZ) Q:'DGY  S DGZ=DGY
 Q DGZ
 ;
FC1(DGC,DGCOMA) ;Transform single character
 ;Input: DGC=character to transform (pass by reference)
 ;    DGCOMA=comma indicator
 ;Output: 1 if value is changed, 0 otherwise
 ;
 S DGC=$E(DGC) Q:'$L(DGC) 0
 ;See if comma stays
 I DGCOMA'=3,DGC?1"," Q 0
 ;Retain uppercase, numeric, hyphen, apostrophe and space
 Q:DGC?1U!(DGC?1N)!(DGC?1"-")!(DGC?1"'")!(DGC?1" ") 0
 ;Retain parenthesis, bracket and brace characters
 Q:DGC?1"("!(DGC?1")")!(DGC?1"[")!(DGC?1"]")!(DGC?1"{")!(DGC?1"}") 0
 ;Transform lowercase to uppercase
 I DGC?1L S DGC=$C($A(DGC)-32) Q 1
 ;Set all other characters to space
 S DGC=" " Q 1
