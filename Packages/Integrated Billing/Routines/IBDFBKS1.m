IBDFBKS1 ;ALB/CJM/AAS - ENCOUNTER FORM - create form spec for scanning (Broker Version CONTINUATION) ; 6-JUN-95
 ;;3.0;AUTOMATED INFO COLLECTION SYS;;APR 24, 1997
 ;
 ;
FORM ;;
 ;;'Paper Keyboard FormSpec
 ;;'VERSION = 2.53
 ;;'AICS Version 3.0
 ;;INT hasprint;
 ;;INT check;
 ;;INT pfid;
 ;;INT page;
 ;;INT saveunrf;
 ;;ALPHA narrative;
 ;;
 ;;FORM
NAME ;;  NAME = "ENCOUNTER FORM 71";
 ;;  AREA =  0 0 2810 2150;
 ;;  PAGESIZE = " 2810 2150";
 ;;  ANCHOR1 = NONE;
 ;;  ANCHOR2 = NONE;
 ;;  POINTS = 0 0 0 0;
 ;;  CONFIDENCE = " 9";
 ;;  DATEFORMAT = "6";
 ;;  TIMEFORMAT = "5";
 ;;  EXFORMAT = "STRIP";
 ;;  FS = ",";
 ;;  Recognition = "hasprint=0;";
 ;;  QUOTABLE = "\\n";
 ;;  ImageProcessing = {
 ;;     IMAGEPROC=1
 ;;     AUTO_ALIGN=0
 ;;     ALIGN_TEXT=0
 ;;     ALIGN_ORIENT=0
 ;;     DESKEW=0
 ;;     DESHADE=0
 ;;     SMOOTH=0
 ;;     REMOVE_BORDER=1
 ;;     REMOVE_NOISE=0
 ;;     PROC_MIN_VERT_LINE_LEN=0
 ;;     PROC_MIN_HORZ_LINE_LEN=0
 ;;     FATTYPE=0
 ;;     FATTEN=0};
 ;;FIELD ' 1
 ;;  NAME = "ANCHOR 3";
 ;;  ELEMTYPE = CROSSHAIR;
 ;;  METRIC = 3 2 20 50 0 0 90 100;
 ;;  DATATYPE =INT;
 ;;  LENGTH = 1;
 ;;  POINTS = 65 2056;
 ;;  PAGE = 0;
 ;;  ANCHOR = "1";
 ;;  HIDDEN = "1";
 ;;  REQUIRED = "1";
 ;;FIELD ' 2
 ;;  NAME = "ANCHOR 6";
 ;;  ELEMTYPE = CROSSHAIR;
 ;;  METRIC = 3 4 20 50 0 0 90 100;
 ;;  DATATYPE =INT;
 ;;  LENGTH = 1;
 ;;  POINTS = 2729 2056;
 ;;  PAGE = 0;
 ;;  ANCHOR = "1";
 ;;  HIDDEN = "1";
 ;;  REQUIRED = "1";
 ;;FIELD ' 3
 ;;  NAME = "ANCHOR 1";
 ;;  ELEMTYPE = CROSSHAIR;
 ;;  METRIC = 3 1 20 50 0 0 90 100;
 ;;  DATATYPE =INT;
 ;;  LENGTH = 1;
 ;;  POINTS = 65 65;
 ;;  PAGE = 0;
 ;;  ANCHOR = "1";
 ;;  HIDDEN = "1";
 ;;  REQUIRED = "1";
 ;;FIELD ' 4
 ;;  NAME = "ANCHOR 4";
 ;;  ELEMTYPE = CROSSHAIR;
 ;;  METRIC = 3 3 20 50 0 0 90 80;
 ;;  DATATYPE =INT;
 ;;  LENGTH = 1;
 ;;  POINTS = 2729 65;
 ;;  PAGE = 0;
 ;;  ANCHOR = "1";
 ;;  HIDDEN = "1";
 ;;  REQUIRED = "1";
 ;;FIELD ' 5
 ;;NAME = "SCANPAGE?";
 ;;ELEMTYPE = RECT;
 ;;METRIC = 30 30 0 0 0 0 90 0 1;
 ;;DATATYPE =INT;
 ;;LENGTH = 1;
 ;;POINTS = 2710 1273;
 ;;PAGE = 0;
 ;; HIDDEN = "1";
 ;;EXFORMAT="NOEXPORT";
 ;;MAP = "PAGE HAS NO DATA,PAGE HAS DATA";
 ;;XMAP = "0,1";
 ;;FIELD ' 6
 ;;  NAME = "FORM ID CHECK";
 ;;  ELEMTYPE = ELEM_OCR;
 ;;  DATATYPE =INT;
 ;;  LENGTH = 3;
 ;;  POINTS = 60 1422 120 1530;
 ;;  PAGE = 0;
 ;;  CONFIDENCE = " 10";
 ;;  CHARFORMAT = "NOSPACES";
 ;;  END = {
 ;;  check=GETIVALUE(FIELDNAME);};
 ;;  HIDDEN = "1";
 ;;  REQUIRED = "1";
 ;;FIELD ' 7
 ;;  NAME = "FORM ID";
 ;;  ELEMTYPE = ELEM_OCR;
 ;;  DATATYPE =INT;
 ;;  LENGTH = 9;
 ;;  POINTS = 60 652 120 910;
 ;;  PAGE = 0;
 ;;  CONFIDENCE = " 10";
 ;;  CHARFORMAT = "NOSPACES";
 ;;  END = {
 ;;  INT checksum;
 ;;  INT div;
 ;;
 ;;  pfid=GETIVALUE(FIELDNAME);
 ;;  checksum=3*pfid;
 ;;  div=checksum/997;
 ;;  checksum=checksum-(div*997);
 ;;  if ((checksum!=check)&&(FIELDACCEPTED!=1)) {
 ;;  FIELDSTATUS=FIELD_BAD;
 ;;  }
 ;;};
 ;;FIELD ' 8
 ;;  NAME = "PAGE CHECK";
 ;;  ELEMTYPE = ELEM_OCR;
 ;;  DATATYPE =INT;
 ;;  LENGTH = 3;
 ;;  POINTS = 60 1600 120 1700;
 ;;  PAGE = 0;
 ;;  CHARFORMAT = "NOSPACES";
 ;;  END = {
 ;;  check=GETIVALUE(FIELDNAME);};
 ;;  HIDDEN = "1";
 ;;  REQUIRED = "1";
 ;;FIELD ' 9
 ;;  NAME = "PAGE";
 ;;  ELEMTYPE = ELEM_OCR;
 ;;  DATATYPE =INT;
 ;;  LENGTH = 1;
 ;;  POINTS = 60 1858 120 1934;
 ;;  PAGE = 0;
 ;;  CHARFORMAT = "NOSPACES";
 ;;  END = {INT  checksum;
 ;;  INT div;
 ;;  ALPHA next;
 ;;
 ;;  page=GETIVALUE(FIELDNAME);
 ;;  next=STRCAT("TOP OF PAGE ",ITOA(page));
 ;;  checksum=3*page;
 ;;  div=checksum/997;
 ;;  checksum=checksum-(div*997);
 ;;
 ;;  if ((checksum!=check)&&(FIELDACCEPTED!=1)) {
 ;;  FIELDSTATUS=FIELD_BAD;
 ;;  }
PGCK ;;  else if ((page!=1)&&(page!=2)){
 ;;  FIELDSTATUS=FIELD_BAD;
 ;;  }
 ;;  else if (page>1) {NEXTFIELD=GETNUM(next); }
 ;;};
QUIT ;;
 ;;
 ;;
TOPOFPG ;;
NUMBER1 ;;FIELD ' 49
FLDNAME ;;  NAME = "TOP OF PAGE 2";
 ;;  ELEMTYPE = RECT;
 ;;  METRIC = 2 2 0 0 0 0 0 0 0;
 ;;  DATATYPE =INT;
 ;;  LENGTH = 1;
 ;;  POINTS = 100 2040;
PAGE1 ;;  PAGE = 1;
 ;;  HIDDEN="1";
 ;;  EXFORMAT="NOEXPORT";
QUIT1 ;;
 ;;
BOTTOM ;;
NUMBER2 ;;FIELD ' 49
NAME2 ;;  NAME = "BOTTOM OF PAGE";
 ;;  ELEMTYPE = RECT;
 ;;  METRIC = 2 2 0 0 0 0 0 0 0;
 ;;  DATATYPE =INT;
 ;;  LENGTH = 1;
 ;;  POINTS = 100 2040;
PAGE2 ;;  PAGE = 1;
 ;;  HIDDEN="1";
 ;;END = {INT result;
 ;;INT ddechan;
 ;;INT loop;
 ;;ALPHA Data;
 ;;ALPHA str;
 ;;ALPHA  RS;
 ;;ALPHA Save;
 ;;ALPHA New;
 ;;ALPHA Add;
 ;;ALPHA End;
 ;;
 ;;New=\"$$NEW$$("\;
 ;;Add=\"$$ADD$$("\;
 ;;End=\"$$END$$("\;
 ;;RS=STRCAT(",",ITOC(13));
 ;;
 ;;if (BATCH&&(saveunrf>0)){
SAVE ;;  Save = \"SAVEFORM("\;
 ;;  ddechan = DDEINIT(\"IBDSCAN\",\"DdeServerConv\");
 ;;    if (ddechan==0) {
 ;;       DIALOG(\"\", \"OK\", \"\",\"Unable to Open Channel to AICS to Export Data!\");
 ;;       CHAIN(\"AICSMSTR.FS\",1);
 ;;       }
 ;;  else {
 ;;    result = DDEEXEC(ddechan,Save);
 ;;    if (result==0) {
 ;;       DIALOG(\"\", \"OK\", \"\", \"Warning: Saving of Unrecognized form in AICS has Failed!\");}
 ;;     else {
 ;;          DDEPOKE(ddechan,\"DdeServerItem\",\"Operator Verification Needed\");}
 ;;    DDETERM(ddechan);
 ;;    }
 ;;  CHAIN(\"AICSMSTR.FS\",1);}
 ;;
 ;;    ddechan=DDEINIT(\"IBDSCAN\",\"DdeServerConv\");
 ;;    if (ddechan==0) {
 ;;       DIALOG(\"\", \"OK\", \"\",\"Unable to Open Channel to AICS to Export Data!\");
 ;;       CHAIN(\"AICSMSTR.FS\",1);
 ;;       }
 ;;  else {
EXPORT ;;      \'if (STRFIND(Data,RS,STRLEN(Data) - 1) > 0) {;;      \'    Data = SUBSTR(Data,1,STRLEN(Data) - 1); }
 ;;       result=DDEPOKE(ddechan,\"DdeServerItem\",End);
 ;;
 ;;  DDETERM(ddechan);
 ;;  }
 ;;CHAIN(\"AICSMSTR.FS\",1);
 ;;};
 ;;EXFORMAT="NOEXPORT";
QUIT2 ;;
