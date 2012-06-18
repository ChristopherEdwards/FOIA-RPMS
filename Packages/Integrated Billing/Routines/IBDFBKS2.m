IBDFBKS2 ;ALB/CJM/AAS - ENCOUNTER FORM - create form spec for scanning (Broker Version) ; 6-JUN-95 [ 11/13/96  5:25 PM ]
 ;;3.0;AUTOMATED INFO COLLECTION SYS;;APR 24, 1997
 ;
HANDPRNT(IEN,NAME,PAGE,ROW,COL,WIDTH,LINES,READTYPE,PAPKEY,PI) ;
 ;there must be a package interface to handle the data
 Q:('PI)
 Q:($P($G(^IBE(357.6,PI,0)),"^",6)'=1)
 ;
 N X1,X2,Y1,Y2,W,PICTURE,TYPEDATA,NODE0,LENGTH,LINENUM,PKDICT,CONF,L,SUBPICS,FORMAT
 S TYPEDATA="ALPHA",PICTURE=""
 ; -- get info associated with DHCP Data Element
 ;    (and not stored with form definition)
 ; -- 9/28/95 moved file 359.1, pieces 0;3, 0;4, 0;8, 0;9 to
 ;    to 10;1, 10;2, 10;3, 10;4 respectively
 ;
 I PAPKEY D
 .S NODE0=$G(^IBE(359.1,PAPKEY,0)),NODE10=$G(^(10))
 .S TYPEDATA=$P(NODE10,"^",1)
 .S TYPEDATA=$S(TYPEDATA="a":"ALPHA",TYPEDATA="i":"INT",TYPEDATA="f":"FLOAT",TYPEDATA="t":"TIME",TYPEDATA="d":"DATE",1:"ALPHA")
 .S PICTURE=$P(NODE10,"^",2)
 .S FORMAT=$P(NODE0,"^",5)
 .S LENGTH=$P(NODE0,"^",2)
 .S CONF=$P(NODE0,"^",7)
 .S PKDICT=$P(NODE10,"^",3)
 .S SUBPICS=$P(NODE10,"^",4)
 ;
 ;find top left-hand corner
 S X1=((COL*COLWIDTH)+XOFFSET)*CONVERT,X1=$FN(X1,"",0)
 S Y1=((ROW*ROWHT)+YOFFSET+YHANDOS)*CONVERT,Y1=$FN(Y1,"",0)
 ;
 ;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!1
 ;ALSO MUST DO THIS IF TYPE = 1!!!!!!!!!!!!!!!!! BUT SCALE IT
 I READTYPE=3 D
 .;define some marksense fields - if any marked it means there is print!
 .S FIELD=FIELD+1
 .D BLDARY^IBDFBKS("FIELD ' "_FIELD)
 .D BLDARY^IBDFBKS("  NAME = """_NAME_"?"";")
 .D BLDARY^IBDFBKS("  ELEMTYPE = RECT;")
 .D BLDARY^IBDFBKS("  METRIC = 40 40 0 0 0 0 1 0 1;")
 .D BLDARY^IBDFBKS("  TYPEDATA = INT;")
 .D BLDARY^IBDFBKS("  LENGTH = ",LENGTH,";")
 .D BLDARY^IBDFBKS("  POINTS =")
 .F L=1:1:LINES F W=1:1:WIDTH D
 ..S X2=X1+((((W-1)*172.7645)+30)*CONVERT),X2=$FN(X2,"",0)
 ..S Y2=Y1+(((L*180)-39)*CONVERT),Y2=$FN(Y2,"",0)
 ..S IBDFSA(IBLC)=IBDFSA(IBLC)_" "_Y2+1_" "_X2+1
 .S IBDFSA(IBLC)=IBDFSA(IBLC)_";"
 .D BLDARY^IBDFBKS("  PAGE = ",PAGE,";")
 .D BLDARY^IBDFBKS("  CONFIDENCE = "" 0"";")
 .D BLDARY^IBDFBKS("  END = {if (FIELDSTATUS != FIELD_BLANK){")
 .D BLDARY^IBDFBKS("    hasprint=1;")
 .D BLDARY^IBDFBKS("    FIELDSTATUS=FIELD_BAD;")
 .D BLDARY^IBDFBKS("  }")
 .D BLDARY^IBDFBKS("  else {")
 .D BLDARY^IBDFBKS("    hasprint=0;")
 .D BLDARY^IBDFBKS("    NEXTFIELD=NEXTFIELD+1;")
 .D BLDARY^IBDFBKS("  }};")
 .D BLDARY^IBDFBKS("  EXFORMAT = ""NOEXPORT"";")
 .D BLDARY^IBDFBKS("  HIDDEN = ""1"";")
 ;
 ;field is narrative that needs to be broken into single lines
 I (LINES>1)&(READTYPE=2) D  Q
 .F LINENUM=1:1:LINES S:LINENUM>1 Y1=$FN(Y1+(2*ROWHT*CONVERT),"",0) D
 ..S X2=X1+(172.7654*WIDTH*CONVERT),X2=$FN(X2,"",0)
 ..S Y2=Y1+(180*CONVERT),Y2=$FN(Y2,"",0)
 ..D PRINTEND^IBDFBKS3
 ..D PKFIELD(X1+2,Y1+2,X2-2,Y2-2,2,PICTURE,0,CONF,PKDICT,WIDTH,TYPEDATA,NAME,2)
 ..;for handprint fields,must prefix data exported with field info - for bubbles the XMAP has the field info
 ..S @FIELDS@(PAGE,FIELD)="H:"_IEN_":",@FIELDS@(PAGE,FIELD,"DATATYPE")=TYPEDATA S:LINENUM=1 @FIELDS@(PAGE,FIELD,"START")=1 S:LINENUM=LINES @FIELDS@(PAGE,FIELD,"END")=1 S @FIELDS@(PAGE,FIELD,"MULT")=1
 ;
 ;field needs to be broken into subfields due to the print format
 I (READTYPE=2)&(FORMAT'="") D  Q
 .N SUBFIELD,I1,I2,PREFIX,SX1,SX2,SPICTURE,LEN,FOUNDEND
 .S PREFIX=$P(FORMAT,"_"),I1=$L(PREFIX)+1
 .S Y2=Y1+(180*CONVERT),Y2=$FN(Y2,"",0)
 .F  Q:(I1>WIDTH)  D
 ..S I2=I1
 ..S FOUNDEND=0 F  D  Q:FOUNDEND
 ...I $E(FORMAT,I2+1)="_" S I2=I2+1
 ...E  S FOUNDEND=1 Q
 ..;so at this point I1=beginning of the subfield, I2=the end
 ..S SX1=$FN(X1+(172.7654*(I1-1)*CONVERT),"",0)
 ..S SX2=$FN(X1+(172.7654*(I2)*CONVERT),"",0)
 ..S SPICTURE=$E(SUBPICS,I1,I2)
 ..S LEN=(I2-I1)+1
 ..D PRINTEND^IBDFBKS3
 ..D PKFIELD(SX1+2,Y1+2,SX2-2,Y2-2,2,SPICTURE,1,0,"",LEN,"ALPHA",NAME_" Char:"_I1_" to "_I2)
 ..S SUBFIELD(FIELD)=""
 ..S (I1,I2)=I2+1
 ..S FOUNDEND=0 F  D  Q:FOUNDEND
 ...I $E(FORMAT,I2+1)="_" S FOUNDEND=1 Q
 ...I I2>WIDTH S FOUNDEND=1 Q
 ...S I2=I2+1 Q
 ..I $E(FORMAT,I1,I2)'="" S SUBFIELD(FIELD)=$E(FORMAT,I1,I2)
 ..S I1=I2+1
 .
 .;now create a field to concatenate the subfields together
 .S X2=X1+(172.7654*WIDTH*CONVERT),X2=$FN(X2,"",0)
 .S Y2=Y1+(180*CONVERT),Y2=$FN(Y2,"",0)
 .D PKFIELD(X1,Y1,X2,Y2,1,PICTURE,0,CONF,PKDICT,WIDTH,TYPEDATA,NAME,1)
 .D
 ..D BLDARY^IBDFBKS("BEGIN = {ALPHA sfstr;")
 ..D BLDARY^IBDFBKS("ALPHA str;")
 ..D BLDARY^IBDFBKS("INT sfconf;")
 ..D BLDARY^IBDFBKS("INT conf;")
 ..D BLDARY^IBDFBKS("INT found;")
 ..D BLDARY^IBDFBKS("INT ret;")
 ..D BLDARY^IBDFBKS("found=0;")
 ..D BLDARY^IBDFBKS("conf=10;")
 ..I PREFIX'="" D BLDARY^IBDFBKS("    str=\"""_PREFIX_"\"";")
 ..N SUB S SUB=0 F  S SUB=$O(SUBFIELD(SUB)) Q:'SUB  D
 ...D BLDARY^IBDFBKS("  sfstr=STRIP(GETAVALUE("_SUB_"));")
 ...D BLDARY^IBDFBKS("str=STRCAT(str,sfstr);")
 ...D BLDARY^IBDFBKS("if (sfstr!=\""\"") found=1;")
 ...I SUBFIELD(SUB)'="" D BLDARY^IBDFBKS("str=STRCAT(sfstr,\"""_SUBFIELD(SUB)_"\"");")
 ...D BLDARY^IBDFBKS("sfconf=GETCONF("_SUB_");")
 ...D BLDARY^IBDFBKS("if (sfconf<conf) conf=sfconf;")
 ..D BLDARY^IBDFBKS("if (found) ret=SETTEXT("_FIELD_",str,ITOA(conf-1),FIELD_OK);")
 ..D BLDARY^IBDFBKS("if (found == 0) ret=SETTEXT("_FIELD_",\""\"",ITOA(conf-1),FIELD_BLANK);")
 ..D BLDARY^IBDFBKS("if (ret) SETTEXT("_FIELD_",str,\""1\"",FIELD_BAD);")
 ..D BLDARY^IBDFBKS("};")
 .;
 .;for handprint fields,must prefix data exported with field info - for bubbles the XMAP has the field info
 .S @FIELDS@(PAGE,FIELD)="H:"_IEN_":",@FIELDS@(PAGE,FIELD,"DATATYPE")=TYPEDATA
 ;
 ;following are handprint fields that don't need to be broken into subfields
 ;
 I READTYPE=1 D  ;not printed in ICR format
 .D CNVRTHT^IBDF2D1(LINES,.LINES)
 .S X2=X1+(103.65924*WIDTH*CONVERT),X2=$FN(X2,"",0)
 .S Y2=Y1+(ROWHT*LINES*CONVERT),Y2=$FN(Y2,"",0)
 ;
 I READTYPE'=1 D  ;printed in ICR format
 .S X2=X1+(172.7654*WIDTH*CONVERT),X2=$FN(X2,"",0)
 .S Y2=Y1+(180*LINES*CONVERT),Y2=$FN(Y2,"",0)
 ;
 D PRINTEND^IBDFBKS3
 D:READTYPE=2 PKFIELD(X1+2,Y1+2,X2-2,Y2-2,READTYPE,PICTURE,0,CONF,PKDICT,WIDTH,TYPEDATA,NAME,2)
 ;
 D:READTYPE'=2 PKFIELD(X1,Y1,X2,Y2,READTYPE,PICTURE,0,"","",LENGTH,TYPEDATA,NAME)
 S @FIELDS@(PAGE,FIELD)="H:"_IEN_":",@FIELDS@(PAGE,FIELD,"DATATYPE")=TYPEDATA
 D ENDSTUFF
 Q
 ;
ENDSTUFF ;** END STUFF **
 ;S L=$S(TYPEDATA="ALPHA":$L(PICTURE),1:0)
 ;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! PUT BACK?
 ;I L D
 ;.D ADDTOEND^IBDFBKS3("  "_TYPEDATA_" val;")
 ;.D ADDTOEND^IBDFBKS3("  INT len;")
 I READTYPE'=2 D  ;test the results of the marksense fields that were laid on top of the operator fill field
 .D ADDTOEND^IBDFBKS3("  if ((hasprint)&&(FIELDACCEPTED==0)){")
 .D ADDTOEND^IBDFBKS3("    FIELDSTATUS=FIELD_BAD;")
 .D ADDTOEND^IBDFBKS3("  }")
 ;
 ;!!!!!!!!!! PUT BACK?
 ;I L D
 ;.D ADDTOEND^IBDFBKS3("  val=GETVALUE(FIELDNAME);")
 ;.D ADDTOEND^IBDFBKS3("  val=STRIP(val);")
 ;.D ADDTOEND^IBDFBKS3("  len=STRLEN(val);")
 ;.D ADDTOEND^IBDFBKS3("  if ((FIELDSTATUS==FIELD_OK)&&(len<"_L_")){")
 ;.D ADDTOEND^IBDFBKS3("    FIELDSTATUS=FIELD_BAD;")
 ;.D ADDTOEND^IBDFBKS3("    SHOW(""Value too short!"");")
 ;.D ADDTOEND^IBDFBKS3("}")
 Q
 ;
PKFIELD(X1,Y1,X2,Y2,READTYPE,PICTURE,HIDDEN,CONF,PKDICT,LENGTH,TYPEDATA,NAME,ENDPGM) ;
 ; -- now for the handprint field
 S FIELD=FIELD+1
 D BLDARY^IBDFBKS("FIELD ' "_FIELD)
 D BLDARY^IBDFBKS("  NAME = """_NAME_""";")
 ;
 I READTYPE=2 D
 .D BLDARY^IBDFBKS("  ELEMTYPE = ELEM_OT;")
 .D BLDARY^IBDFBKS("  METRIC = 2;")
 ;
 E  D
 .D BLDARY^IBDFBKS("  ELEMTYPE = ELEM_OT;")
 .D BLDARY^IBDFBKS("  METRIC = 1;")
 ;
 D BLDARY^IBDFBKS("  DATATYPE ="_TYPEDATA_";")
 D BLDARY^IBDFBKS("  LENGTH = "_LENGTH_";")
 D BLDARY^IBDFBKS("  POINTS = "_Y1_" "_X1_" "_Y2_" "_X2_";")
 D BLDARY^IBDFBKS("  PAGE = "_PAGE_";")
 I CONF'="" D BLDARY^IBDFBKS("  CONFIDENCE = """_CONF_""";")
 I HIDDEN D BLDARY^IBDFBKS(" HIDDEN = ""1"";")
 I $G(ENDPGM) D HPSKIP
 ;
 ;** IMAGE PROCESSING **
 I READTYPE=2 D
 .D BLDARY^IBDFBKS(" ImageProcessing = {")
 .D BLDARY^IBDFBKS("   IMAGEPROCE = 1")
 .D BLDARY^IBDFBKS("   DESKEW = 0")
 .D BLDARY^IBDFBKS("   DESHADE = 0")
 .D BLDARY^IBDFBKS("   REMOVE _NOISE = 0")
 .D BLDARY^IBDFBKS("   SMOOTH = 1")
 .D BLDARY^IBDFBKS("   PROC_MIN_VERT_LINE_LEN=70")
 .D BLDARY^IBDFBKS("   PROC_MIN_HORZ_LINE_LEN=70")
 .D BLDARY^IBDFBKS("   FATTYPE = 0")
 .D BLDARY^IBDFBKS("   FATTEN = 0};")
 .D BLDARY^IBDFBKS("   Recognition = {FIXED_WIDTH=1")
 .D BLDARY^IBDFBKS("   OT_RECOGTYPE=HP")
 .D BLDARY^IBDFBKS("   };")
 ;
 ;** begin program **
 I $G(ENDPGM)=2 D
 .D BLDARY^IBDFBKS("BEGIN = {ALPHA str;")
 .D BLDARY^IBDFBKS("INT conf;")
 .D BLDARY^IBDFBKS("INT ret;")
 .D BLDARY^IBDFBKS("  conf = GETCONF("_FIELD_");")
 .D BLDARY^IBDFBKS("  if (GETSTATUS("_FIELD_") == FIELD_BLANK) {")
 .D BLDARY^IBDFBKS("     ret=SETTEXT("_FIELD_",\""\"",ITOA(conf-1),FIELD_BLANK); }")
 .D BLDARY^IBDFBKS("if (ret) FIELDSTATUS = FIELD_ERROR;")
 .D BLDARY^IBDFBKS("};")
 .;
 I PKDICT'="" D BLDARY^IBDFBKS("  DICTIONARY = """_PKDICT_""";")
 I PICTURE'="",TYPEDATA="ALPHA" D BLDARY^IBDFBKS("  PICTURE = """_PICTURE_""";")
 Q
HPSKIP ; If hand print field blank, skip it
 D ADDTOEND^IBDFBKS3("   if ((GETSTATUS(FIELDNAME) != FIELD_BLANK) && (FIELDACCEPTED == 0)) {")
 D ADDTOEND^IBDFBKS3("     FIELDSTATUS = FIELD_BAD;}")
 Q
 ;
